import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Controller/BudgetMenuController.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../Model/BudgetBarModel.dart';
import '../Model/TransactionsModel.dart';
import 'Elements/BarGraph.dart';

class BudgetMenu extends StatefulWidget {
  const BudgetMenu({super.key, required this.title});
  final String title;

  @override
  State<BudgetMenu> createState() => BudgetMenuState();
}

class BudgetMenuState extends State<BudgetMenu> {
  bool totalLimitEdited = false;

  RemoteDBHelper remoteDBHelper = RemoteDBHelper(
      userInstance: FirebaseAuth.instance,
      firebaseInstance: FirebaseFirestore.instance);
  BudgetMenuController budgetMenuController = BudgetMenuController();

  getTransactions(transacs) {
    if (mounted) {
      setState(() {
        transactions = transacs;
      });
    }
  }

  List<TransactionModel> transactions = [];
  Timer timer = Timer(const Duration(seconds: 10), () {});
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
          buildBody(remoteDBHelper),
        ]),
      ),
    );
  }

  Widget buildBody(RemoteDBHelper db) {
    budgetMenuController.getTransactions(remoteDBHelper, getTransactions);

    return StreamBuilder<List<BudgetBarModel>>(
        stream: db.readBudgetBars(),
        builder: (BuildContext context,
            AsyncSnapshot<List<BudgetBarModel>> snapshot) {
          // bool hasOverflowed = false;

          if (!snapshot.hasData && timer.isActive) {
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
                        "Trying to load...",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  )
                ]);
          }
          if (snapshot.hasData && snapshot.data!.isEmpty || !snapshot.hasData) {
            return const Center(
                heightFactor: 25,
                child: Text("Nothing to show",
                    style: TextStyle(fontSize: 20, color: Colors.white)));
          } else {
            List<BudgetBarModel> barData = [];
            int xCoord = 0;
            double maxY = 0;
            double percentage = 0;
            double currBudgetValSum = 0;
            double totalBudgetVal = 0;

            for (var budgetBar in snapshot.data!) {
              double categoryValSum = 0;

              for (TransactionModel transac in transactions) {
                if (transac.categoryID == budgetBar.categoryID) {
                  categoryValSum += transac.total;
                }
              }
              budgetBar.x = xCoord;
              xCoord++;
              budgetBar.y = categoryValSum;
              BudgetMenuController().checkLimit(budgetBar, 0.05);
              barData.add(budgetBar);
              currBudgetValSum += categoryValSum;
              totalBudgetVal += budgetBar.limit!;
              if (budgetBar.limit! > maxY) {
                maxY = budgetBar.limit!;
              }
              if (budgetBar.limit! < currBudgetValSum) {
                maxY = currBudgetValSum;
              }
            }
            if (totalBudgetVal > 0) {
              percentage = totalBudgetVal > currBudgetValSum
                  ? currBudgetValSum / totalBudgetVal
                  : 1;
            } else {
              percentage = 0;
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: IconButton(
                        onPressed: () {
                          if (mounted) {
                            BudgetMenuController().EditBudgetMenu(context);
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
                  Image.asset(
                    'assets/img/Luckycat1.png',
                    width: 160,
                  ),
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    const SizedBox(
                      height: 125,
                    ),
                    Text(
                      '${(percentage * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                                color: Colors.red,
                                offset: Offset.zero,
                                blurRadius: 16)
                          ]),
                    )
                  ]),
                ]),
              ],
            );
          }
        });
  }
}
