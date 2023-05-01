import 'package:es/Controller/BudgetMenuController.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../Model/BudgetBarModel.dart';
import 'BarGraph.dart';

class BudgetMenu extends StatefulWidget {
  const BudgetMenu({super.key, required this.title});
  final String title;

  @override
  State<BudgetMenu> createState() => BudgetMenuState();
}

class BudgetMenuState extends State<BudgetMenu> {
  double totalBudgetVal = 0;
  bool totalLimitEdited = false;
  callback(totalLimitValue) {
    if (mounted) {
      setState(() {
        totalBudgetVal = totalLimitValue;
      });
    }
  }

  RemoteDBHelper remoteDBHelper =
      RemoteDBHelper(userInstance: FirebaseAuth.instance);
  BudgetMenuController budgetMenuController = BudgetMenuController();
  @override
  Widget build(BuildContext context) {
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
          icon: const Icon(Icons.home, color: Colors.white, size: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: IconButton(
                  onPressed: () {
                    if (mounted) {
                      BudgetMenuController(callback: callback)
                          .EditBudgetMenu(context);
                      setState(() {
                        totalLimitEdited = true;
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          if (mounted) buildBody(remoteDBHelper, setState, context),
        ]),
      ),
    );
  }

  Widget buildBody(RemoteDBHelper db, Function callBack, BuildContext context) {
    return StreamBuilder<List<BudgetBarModel>>(
        stream: db.readBudgetBars(),
        builder: (BuildContext context,
            AsyncSnapshot<List<BudgetBarModel>> snapshot) {
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
            List<BudgetBarModel> barData = [];
            int xCoord = 0;
            double maxY = 0;
            double percentage = 0;
            double currBudgetValSum = 0;

            snapshot.data!.forEach(
              (budgetBar) {
                if (budgetBar.limit! > maxY) {
                  maxY = budgetBar.limit!;
                }
                budgetBar.x = xCoord;
                xCoord++;
                budgetBar.y = budgetBar.value;
                budgetMenuController.checkLimit(budgetBar, 0.05);
                barData.add(budgetBar);
                currBudgetValSum += budgetBar.value!;
                if (!totalLimitEdited) {
                  totalBudgetVal += budgetBar.limit!;
                }
              },
            );

            percentage = totalBudgetVal > currBudgetValSum
                ? currBudgetValSum / totalBudgetVal
                : 1;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyBarGraph(
                  barsData: barData,
                  graphMaxY: maxY,
                  barWidth: 40,
                  spaceBetweenBars: 10,
                  graphContainerHeight: 320,
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(alignment: AlignmentDirectional.center, children: [
                  Image.asset(
                    'assets/img/Luckycat1.png',
                    width: 180,
                  ),
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    const SizedBox(
                      height: 120,
                    ),
                    Text(
                      (percentage * 100).toStringAsFixed(0) + '%',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                color: Colors.red,
                                offset: Offset.zero,
                                blurRadius: 15)
                          ]),
                    )
                  ]),
                  CircularPercentIndicator(
                    animation: true,
                    animationDuration: 600,
                    radius: 80.0,
                    lineWidth: 6.0,
                    percent: percentage,
                    progressColor: Colors.red,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Colors.black,
                  ),
                ]),
              ],
            );
          }
        });
  }
}
