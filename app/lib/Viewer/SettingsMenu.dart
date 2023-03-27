import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../Controller/PopUpController.dart';
import 'package:es/Viewer/MainMenu.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key, required this.title});
  final String title;
  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  List listItems = ["€", "\$", "£"];
  String valCurrency = "€";
  bool valMode = true;
  bool valNotifications = true;
  changeCurrency(String newCurrency) {
    setState(() {
      valCurrency = newCurrency;
    });
  }

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
        backgroundColor: Color.fromRGBO(20, 25, 46, 1.0),
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(widget.title,
              style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic)),
          centerTitle: true,
          leading: IconButton(
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
                onPressed: () {},
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
              buildDropDownBox(
                  "Currency", listItems, valCurrency, changeCurrency),
              buildSwitch("Mode", valMode, changeMode),
              buildSwitch(
                  "Notifications", valNotifications, changeNotifications),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: Image.asset('assets/img/Luckycat1.png'),
              ),
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  onPressed: () {ButtonActions().resetData(context);},
                  child: const Text(
                    "RESET DATA",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Padding buildDropDownBox(
      String title, List listItems, String value, Function changeValue) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style:
                    const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
            Transform.scale(
              scale: 1.3,
              child: DropdownButton(
                underline: SizedBox(),
                borderRadius: BorderRadius.circular(12),
                value: value,
                iconEnabledColor: Colors.white,
                onChanged: (newValue) {
                  setState(() {
                    changeValue(newValue);
                  });
                },
                items: listItems.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: valueItem == value? Text(valueItem, style: TextStyle(fontSize: 20, color: Colors.white),) : Text(valueItem, style: TextStyle(fontSize: 20, color: Colors.black),),
                  );
                }).toList(),
              ),
            )
          ],
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
