import 'package:es/Controller/SavingsMenuController.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:es/Model/SavingsModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:quickalert/quickalert.dart';

class SavingsMenu extends StatefulWidget {
  const SavingsMenu({super.key, required this.title});
  final String title;

  @override
  State<SavingsMenu> createState() => _SavingsMenu();
}

class _SavingsMenu extends State<SavingsMenu> {
  List<String?> listitems = ['1'];

  String? selectedVal = 'Ola';
  double multiplier = 0;
  double currSliderVal = 0;
  RemoteDBHelper remoteDBHelper =
      RemoteDBHelper(userInstance: FirebaseAuth.instance);

  SavingsMenuController savingsMenuController = SavingsMenuController();

  Stream<List<SavingsModel>> savings =
      RemoteDBHelper(userInstance: FirebaseAuth.instance).readSaving('1');
  bool initState_ = true;

  @override
  Widget build(BuildContext context) {
    if (initState_) {
      setInitState(remoteDBHelper.readSavings(), setState);
    }
    return Scaffold(
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
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  //TESTE
                  onPressed: () => {
                    if (this.mounted)
                      {
                        savingsMenuController.newSavings(context),
                        setState(() {
                          initState_ = false;
                        }),
                      },
                  },
                  iconSize: 40,
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                )
              ],
            ),
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 90),
                  child: IconButton(
                    onPressed: () => {
                      setInitState(remoteDBHelper.readSavings(), setState),
                      if (selectedVal != "")
                        {
                          remoteDBHelper.deleteSaving(selectedVal),
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              text: "Successfully deleted saving!"),
                        }
                      else
                        {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              text: "There are no more items to delete!"),
                        },
                    },
                    iconSize: 40,
                    icon: const Icon(Icons.delete_rounded),
                    color: Colors.red,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 30,
                    ),

                    //Builds DropdownMenu
                    buildDropdownList(remoteDBHelper),
                  ],
                ),
              ],
            ),

            const SizedBox(
              height: 60,
            ),
            //Builds body according to the database
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
                  dropdownColor: const Color.fromRGBO(255, 113, 64, 10),
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
                    if (this.mounted) {
                      setState(() {
                        selectedVal = val as String;
                        savings = remoteDBHelper.readSaving(val);
                        initState_ = false;
                      });
                    }
                  })
              : DropdownButton(
                  dropdownColor: Colors.black,
                  iconEnabledColor: Colors.white,
                  value: '',
                  items: const [],
                  onChanged: (val) {});
        });
  }

  Widget buildBody(BuildContext context, Stream<List<SavingsModel>> savings) {
    if (initState_) {
      setInitState(remoteDBHelper.readSavings(), setState);
    }
    return StreamBuilder<List<SavingsModel>>(
        stream: savings,
        builder:
            (BuildContext context, AsyncSnapshot<List<SavingsModel>> snapshot) {
          // bool hasOverflowed = false;

          if (!snapshot.hasData) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  const CircularProgressIndicator(
                    color: Color.fromRGBO(226, 177, 60, 10),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Loading...",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  )
                ]);
          }
          if (snapshot.data!.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                SizedBox(height: 150),
                Text("Nothing to show",
                    style: TextStyle(fontSize: 20, color: Colors.white))
              ],
            );
          } else {
            double percent = snapshot.data!.first.value!.toDouble() /
                snapshot.data!.first.total!.toDouble();
            double overflow = 0;

            if (percent > 1) {
              // overflow = snapshot.data!.value!.toDouble() -
              //     snapshot.data!.total!.toDouble();
              //  hasOverflowed = true;
              percent = 1.0;
            }
            return Column(children: [
              /*savingsMenuController.checkSavingOverflow(
                      context, hasOverflowed, overflow),*/
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  CircularPercentIndicator(
                    animation: true,
                    animationDuration: 600,
                    radius: 180.0,
                    lineWidth: 13.0,
                    percent: percent,
                    progressColor: const Color.fromRGBO(226, 177, 60, 10),
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Colors.white,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Image.asset(
                        'assets/img/Luckycat1.png',
                        width: 250,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(75),
                              child: IconButton(
                                  onPressed: () {
                                    savingsMenuController.changeSavingValue(
                                      context,
                                      snapshot.data!.first.value!.toDouble(),
                                      multiplier,
                                      selectedVal!,
                                      true,
                                    );
                                  },
                                  iconSize: 50,
                                  color: Colors.white,
                                  icon: const Icon(Icons.add_circle_outline)),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.all(75),
                              child: IconButton(
                                  onPressed: () {
                                    savingsMenuController.changeSavingValue(
                                      context,
                                      snapshot.data!.first.value!.toDouble(),
                                      multiplier,
                                      selectedVal!,
                                      false,
                                    );
                                  },
                                  iconSize: 50,
                                  color: Colors.white,
                                  icon:
                                      const Icon(Icons.remove_circle_outline)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.data!.first.value!.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 28,
                          color: Color.fromRGBO(226, 177, 60, 10))),
                  const Icon(Icons.euro,
                      size: 30, color: Color.fromRGBO(226, 177, 60, 10)),
                  const Text("/",
                      style: TextStyle(
                          fontSize: 28,
                          color: Color.fromRGBO(226, 177, 60, 10))),
                  Text(snapshot.data!.first.total.toString(),
                      style: const TextStyle(
                          fontSize: 28,
                          color: Color.fromRGBO(226, 177, 60, 10))),
                  const Icon(Icons.euro,
                      size: 30, color: Color.fromRGBO(226, 177, 60, 10)),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (snapshot.data!.first.targetDate == null)
                        ? ""
                        : "Target Date:  " +
                            DateFormat('dd-MM-yyyy')
                                .format(snapshot.data!.first.targetDate!),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              )
            ]);
          }
        });
  }

  void refreshState(Stream<List<SavingsModel>> stream, Function? callback,
      String? selectedVal_) {
    stream.listen((event) {
      List<String?> temp = [];
      event.forEach((element) {
        temp.add(element.name);
      });
      if (this.mounted) {
        callback!(() {
          if (event.isNotEmpty) {
            selectedVal = selectedVal_;
            listitems = temp;
            savings = remoteDBHelper.readSaving(selectedVal);
          } else {
            selectedVal = '';
            listitems = [''];
          }
        });
      }
    });
  }

  void setInitState(Stream<List<SavingsModel>> stream, Function? callback) {
    stream.listen((event) {
      List<String?> temp = [];
      event.forEach((element) {
        temp.add(element.name);
      });
      if (this.mounted) {
        callback!(() {
          if (event.isNotEmpty) {
            selectedVal = temp.first;
            listitems = temp;
            savings = remoteDBHelper.readSaving(selectedVal);
          } else {
            selectedVal = '';
            listitems = [''];
          }
        });
      }
    });
  }
}
