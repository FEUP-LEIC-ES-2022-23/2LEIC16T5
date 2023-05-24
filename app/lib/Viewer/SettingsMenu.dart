import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Controller/LoginScreenController.dart';
import 'package:es/Viewer/SettingsPopUpViewer.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key, required this.title});
  final String title;

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}



class _SettingsMenuState extends State<SettingsMenu> {
  RemoteDBHelper remoteDBHelper = RemoteDBHelper(userInstance: FirebaseAuth.instance,firebaseInstance: FirebaseFirestore.instance);

  LoginScreenController loginController = LoginScreenController();

  List listItems = ["€", "\$", "£", "₣", "¥", "₽", "₹"];

  bool valMode = true;
  bool valNotifications = true;

  changeMode(bool newMode) {
    setState(() {
      valMode = newMode;
    });
  }

  changeNotifications(bool newMode) {
    setState(() {
      valNotifications = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: const Key("Settings"),
        backgroundColor: const Color.fromARGB(255, 12, 18, 50),
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(widget.title,
              style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic)),
          centerTitle: true,
          leading: IconButton(
            key: const Key("Home"),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);}
            },
            icon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              key: const Key("Logout"),
                onPressed: () {
                  SettingsPopUpViewer().sureLogout(context, loginController);
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const SizedBox(height: 40),

              StreamBuilder(
                stream: remoteDBHelper.getCurrency(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData) {
                    return const LinearProgressIndicator();
                  }
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Currency",
                              style:
                              TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                          Transform.scale(
                            scale: 1.3,
                            child: DropdownButton(
                              key: const Key('DropDown'),
                              underline: const SizedBox(),
                              borderRadius: BorderRadius.circular(12),
                              value: snapshot.data,
                              dropdownColor: Colors.lightBlue,
                              iconEnabledColor: Colors.white,
                              onChanged: (newValue) {
                                setState(() {
                                  remoteDBHelper.changeCurrency(newValue);
                                });
                              },
                              items: listItems.map((dynamic valueItem) {
                                return DropdownMenuItem(
                                  key: Key(valueItem),
                                  value: valueItem,
                                  child: valueItem == snapshot.data? Text(valueItem, style: const TextStyle(fontSize: 20, color: Colors.white),) : Text(valueItem, style: const TextStyle(fontSize: 20, color: Colors.black),),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ));
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 200,
                child: Image.asset('assets/img/Luckycat1.png'),
              ),
              Center(
                child: OutlinedButton(
                  key: const Key("Reset Data"),
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  onPressed: () {SettingsPopUpViewer().resetData(context);},
                  child: const Text(
                    "Reset Data",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Padding buildSwitch(String title, bool value, Function onOff) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,

                style:
                const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
            Transform.scale(
              scale: 1,
              child: CupertinoSwitch(
                activeColor: Colors.lightBlue,
                trackColor: Colors.grey,
                value: value,
                onChanged: (bool newValue) {
                  onOff(newValue);
                },
              ),
            )
          ],
        ));
  }
}
