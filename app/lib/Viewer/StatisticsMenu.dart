import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/BudgetBarModel.dart';
import '../Database/RemoteDBHelper.dart';
import 'Elements/PieChart.dart';

class StatiscticsMenu extends StatefulWidget {
  const StatiscticsMenu({
    super.key,
    required this.title,
    required this.currency,
    required this.swipped,
  });
  final String currency;
  final String title;
  final bool swipped;

  @override
  State<StatiscticsMenu> createState() => StatiscticsMenuState();
}

class StatiscticsMenuState extends State<StatiscticsMenu> {
  bool totalLimitEdited = false;

  RemoteDBHelper remoteDBHelper = RemoteDBHelper(
      userInstance: FirebaseAuth.instance,
      firebaseInstance: FirebaseFirestore.instance);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildPieChart(remoteDBHelper, context),
        const SizedBox(
          height: 40,
        ),
        widget.swipped
            ? const SizedBox.shrink()
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                Text(
                  'Swipe Right',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                Icon(
                  Icons.swipe_right,
                  size: 40,
                  color: Colors.white,
                )
              ]),
      ],
    );
  }

  Widget buildPieChart(RemoteDBHelper db, BuildContext context) {
    return StreamBuilder<List<BudgetBarModel>>(
        stream: db.readBudgetBarsWithValue(),
        builder: (BuildContext context,
            AsyncSnapshot<List<BudgetBarModel>> snapshot) {
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
                        "Trying to load...",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  )
                ]);
          }
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                
                   Text("Nothing to show",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                
              ],
            );
          } else {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Image.asset(
                  'assets/img/Luckycat1.png',
                  width: 230,
                ),
                MyPieChart(
                  barsData: snapshot.data!,
                  graphHeight: 300,
                  spaceBetweenSections: 0,
                  strokeWidth: 25,
                  fontSize: 16,
                  size: 130,
                ),
              ],
            );
          }
        });
    // bool hasOverflowed = false;
  }
}
