import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/BudgetBarModel.dart';
import '../database/RemoteDBHelper.dart';
import 'Elements/PieChart.dart';

class StatiscticsMenu extends StatefulWidget {
  const StatiscticsMenu({
    super.key,
    required this.title,
    required this.currency,
  });
  final String currency;
  final String title;

  @override
  State<StatiscticsMenu> createState() => StatiscticsMenuState();
}

class StatiscticsMenuState extends State<StatiscticsMenu> {
  bool totalLimitEdited = false;

  RemoteDBHelper remoteDBHelper =
      RemoteDBHelper(userInstance: FirebaseAuth.instance,firebaseInstance: FirebaseFirestore.instance);
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
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
            ),
            buildPieChart(remoteDBHelper, context),
          ],
        )));
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
              children: const [
                SizedBox(height: 150),
                Center(
                    child: Text("Nothing to show",
                        style: TextStyle(fontSize: 20, color: Colors.white)))
              ],
            );
          } else {
            //aqui para editar algumas propriedades do grafico em geral, passando os valores.
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
                  strokeWidth: 35,
                  fontSize: 16,
                  size: 125,
                ),
              ],
            );
          }
        });
    // bool hasOverflowed = false;
  }
}
