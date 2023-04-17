import 'package:es/Controller/SavingsMenuController.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:es/Model/SavingsModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:quickalert/quickalert.dart';

class SavingsMenu extends StatefulWidget {
  const SavingsMenu({Key? key}) : super(key: key);

  @override
  State<SavingsMenu> createState() => _SavingsMenu();
}

class _SavingsMenu extends State<SavingsMenu> {
  List<String?> listitems = ['1'];

  String? selectedVal = 'Ola';

  RemoteDBHelper remoteDBHelper =
      RemoteDBHelper(userInstance: FirebaseAuth.instance);

  SavingsMenuController savingsMenuController = SavingsMenuController();

  Stream<SavingsModel> savings =
      RemoteDBHelper(userInstance: FirebaseAuth.instance).readSaving('1');
  bool initState_ = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 18, 50),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  //TESTE
                  onPressed: () => {
                    savingsMenuController.newSavings(context),
                  },
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => {
                    remoteDBHelper.deleteSaving(selectedVal),
                    setInitState(remoteDBHelper.readSavings(), setState),
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 30,
                ),

                //Builds DropdownMenu
                buildDropdownList(remoteDBHelper),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            buildBody(context, savings),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownList(RemoteDBHelper db) {
    if (initState_) {
      setInitState(remoteDBHelper.readSavings(), setState);
    }

    return StreamBuilder<List<SavingsModel>>(
        stream: db.readSavings(),
        builder:
            (BuildContext context, AsyncSnapshot<List<SavingsModel>> snapshot) {
          List<String?> temp = [];
          if (!snapshot.hasData) {
            return DropdownButton(
                dropdownColor: Colors.black,
                iconEnabledColor: Colors.white,
                value: '',
                items: const [],
                onChanged: (val) {});
          }
          snapshot.data!.forEach((element) {
            temp.add(element.name);
          });
          listitems = temp;

          return snapshot.hasData
              ? DropdownButton(
                  dropdownColor: Colors.black,
                  iconEnabledColor: Colors.white,
                  value: selectedVal,
                  items: listitems
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e!,
                            style: TextStyle(color: Colors.white),
                          )))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedVal = val as String;
                      savings = remoteDBHelper.readSaving(val);
                      initState_ = false;
                    });
                  })
              : DropdownButton(
                  dropdownColor: Colors.black,
                  iconEnabledColor: Colors.white,
                  value: '',
                  items: const [],
                  onChanged: (val) {});
        });
  }

  Widget buildBody(BuildContext context, Stream<SavingsModel> savings) {
    return StreamBuilder<SavingsModel>(
        stream: savings,
        builder: (BuildContext context, AsyncSnapshot<SavingsModel> snapshot) {
          if (!snapshot.hasData) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  const SizedBox(
                    height: 90,
                  ),
                  CircularProgressIndicator(
                    color: Colors.yellow,
                  )
                ]);
          }
          double percent = snapshot.data!.value!.toDouble() /
              snapshot.data!.total!.toDouble();
          return snapshot.hasData
              ? Stack(alignment: AlignmentDirectional.center, children: [
                  CircularPercentIndicator(
                    animation: true,
                    animationDuration: 600,
                    radius: 140.0,
                    lineWidth: 13.0,
                    percent: percent,
                    progressColor: Colors.yellow,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  Image.asset(
                    'assets/img/Luckycat1.png',
                    width: 250,
                  ),
                ])
              : const Center(
                  child: Text("Nothing to show",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                );
        });
  }

  void setInitState(Stream<List<SavingsModel>> stream, Function? callback) {
    stream.listen((event) {
      List<String?> temp = [];
      event.forEach((element) {
        temp.add(element.name);
      });
      callback!(() {
        if (temp.isNotEmpty) {
          selectedVal = temp.first;
          listitems = temp;
          savings = remoteDBHelper.readSaving(selectedVal);
        } else {
          selectedVal = '';
          listitems = [''];
        }
      });
    });
  }
}
