import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Database/LocalDBHelper.dart';
import 'package:es/Viewer/NationalMenu.dart';
import 'package:es/Viewer/BugetMenu.dart';
import 'package:es/Viewer/SavingsMenu.dart';
import 'package:es/Viewer/SettingsMenu.dart';
import 'package:es/Database/RemoteDBHelper.dart';
import 'package:es/Viewer/SwipableCharts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'CategoriesMenu.dart';
import 'TransactionsMenu.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/foundation.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  RemoteDBHelper remoteDBHelper = RemoteDBHelper(
      userInstance: FirebaseAuth.instance,
      firebaseInstance: FirebaseFirestore.instance);
  LocalDBHelper localStorage = LocalDBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: const Key("Main"),
        backgroundColor: const Color.fromARGB(255, 12, 18, 50),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 25,
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    key: const Key("Settings"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SettingsMenu(title: 'Settings')));
                    },
                    child: const Icon(Icons.settings),
                  )),
              const SizedBox(height: 20),
              Image.asset(
                'assets/img/Fortuneko.png',
                width: 350,
                alignment: Alignment.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/img/Luckycat1.png',
                width: 250,
                alignment: Alignment.center,
              ),
              ElevatedButton(
                  key: const Key("Transactions"),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 35)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionsMenu(
                                title: 'Transactions',
                                currency: localStorage.getCurrentCurrency(),
                              )),
                    );
                  },
                  child: const Text('Transactions',
                      style: TextStyle(fontSize: 20))),
              ElevatedButton(
                  key: const Key("Categories"),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 35)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const CategoriesMenu(title: 'Categories')),
                    );
                  },
                  child:
                      const Text('Categories', style: TextStyle(fontSize: 20))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 35)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SwipableCharts(
                                title: 'Statistics',
                                currency: localStorage.getCurrentCurrency(),
                              )),
                    );
                  },
                  child:
                      const Text('Statistics', style: TextStyle(fontSize: 20))),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BudgetMenu(
                              title: 'Budget',
                              currency: localStorage.getCurrentCurrency(),
                            )),
                  );
                },
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(250, 35)),
                child: const Text('Budget', style: TextStyle(fontSize: 20)),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 35)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SavingsMenu(
                                title: 'Savings',
                                currency: localStorage.getCurrentCurrency(),
                              )),
                    );
                  },
                  child: const Text('Savings', style: TextStyle(fontSize: 20))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 35)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NationalMenu(
                                title: 'National Comparison',
                                currency: localStorage.getCurrentCurrency(),
                              )),
                    );
                  },
                  child: const Text('National Comparison',
                      style: TextStyle(fontSize: 20)))
            ],
          ),
        ));
  }
}
