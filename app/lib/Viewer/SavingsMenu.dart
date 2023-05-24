import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Controller/SavingsMenuController.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:es/Model/SavingsModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:quickalert/quickalert.dart';

class SavingsMenu extends StatefulWidget {
  const SavingsMenu({super.key, required this.title, required this.currency});
  final String title;
  final String currency;

  @override
  State<SavingsMenu> createState() => _SavingsMenu();
}

class _SavingsMenu extends State<SavingsMenu> {
  List<String?> listitems = ['1'];

  String? selectedVal = '1';
  double multiplier = 0;
  double currSliderVal = 0;
  RemoteDBHelper remoteDBHelper = RemoteDBHelper(
      userInstance: FirebaseAuth.instance,
      firebaseInstance: FirebaseFirestore.instance);

  SavingsMenuController savingsMenuController = SavingsMenuController(
      remoteDBHelper: RemoteDBHelper(
          userInstance: FirebaseAuth.instance,
          firebaseInstance: FirebaseFirestore.instance),
      userInstance: FirebaseAuth.instance);

  Stream<List<SavingsModel>> savings = RemoteDBHelper(
          userInstance: FirebaseAuth.instance,
          firebaseInstance: FirebaseFirestore.instance)
      .readSaving('1');
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    IconButton(
                      //TESTE
                      onPressed: () => {
                        if (mounted)
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
                )
              ],
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 90),
                  child: IconButton(
                    onPressed: () async => {
                      setInitState(remoteDBHelper.readSavings(), setState),
                      if (selectedVal != "")
                        {
                          await remoteDBHelper.deleteSaving(selectedVal),
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
              height:25,
            ),
            //Builds body according to the database
            buildBody(context, savings),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownList(RemoteDBHelper db) {
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
              ? DropdownButtonHideUnderline(
                  child: DropdownButton(
                      dropdownColor: const Color.fromRGBO(255, 113, 64, 10),
                      iconEnabledColor: Colors.white,
                      value: selectedVal,
                      items: listitems
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e!,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 23),
                              )))
                          .toList(),
                      onChanged: (val) {
                        if (mounted) {
                          setState(() {
                            selectedVal = val as String;
                            savings = remoteDBHelper.readSaving(val);
                            initState_ = false;
                          });
                        }
                      }))
              : DropdownButtonHideUnderline(
                  child: DropdownButton(
                      dropdownColor: Colors.black,
                      iconEnabledColor: Colors.white,
                      value: '',
                      items: const [],
                      onChanged: (val) {}));
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
                    color: Colors.blue,
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
                    progressColor: Colors.blue,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Colors.white,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/img/Luckycat1.png',
                            width: 230,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      '${snapshot.data!.first.value!
                                          .toStringAsFixed(2)} ${widget.currency}',
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                      )),
                                  const Text("/",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,


                                      )),
                                  Text('${snapshot.data!.first.total} ${widget.currency}',
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,

                                      )),
                                ],
                              ),
                            ],
                          )
                        ],
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
                                        snapshot.data!.first.total!.toDouble());
                                  },
                                  iconSize: 50,
                                  color: Colors.white,
                                  icon: const Icon(Icons.add_circle_outline)),
                            ),
                          ),
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
                                        false,
                                        snapshot.data!.first.total!.toDouble());
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
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (snapshot.data!.first.targetDate != null)
                    [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 280,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(
                                  width: 30, color: Colors.transparent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Row(children: [
                            const Icon(Icons.warning, size: 30,color: Colors.black),
                            const SizedBox(width: 10),
                            Text(
                              (snapshot.data!.first.targetDate == null)
                                  ? ""
                                  : "Target Date:  " +
                                      DateFormat('dd-MM-yyyy').format(
                                          snapshot.data!.first.targetDate!),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ]),
                        ],
                      ),
                    ].first,
                ],
              ),
              const SizedBox(
                height: 25,
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
      if (mounted) {
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
      for (SavingsModel element in event) {
        temp.add(element.name);
      }
      if (mounted) {
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
