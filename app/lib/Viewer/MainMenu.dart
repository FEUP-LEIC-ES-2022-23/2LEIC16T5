//import 'package:es/Viewer/ChartsMenu.dart';
import 'package:es/Viewer/SavingsMenu.dart';
import 'package:es/Viewer/SettingsMenu.dart';
import 'package:flutter/material.dart';
import 'CategoriesMenu.dart';
import 'TransactionsMenu.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Text('FORTUNEKO',
                  style: TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/img/Luckycat1.png',
                width: 250,
              ),
              ElevatedButton(
                  key: const Key("Transactions"),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 35)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const TransactionsMenu(title: 'Transactions')),
                    );
                  },
                  child: const Text('Transactions',
                      style: TextStyle(fontSize: 20))),
              ElevatedButton(
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
                          builder: (context) =>
                              const SavingsMenu(title: 'Savings')),
                    );
                  },
                  child: const Text('Savings', style: TextStyle(fontSize: 20))),

             /* ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 35)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ChartsMenu(title: 'Charts')),
                    );
                  },
                  child: const Text('Charts', style: TextStyle(fontSize: 20))),
              ElevatedButton(
                onPressed: () {},
                child: Text('Goal', style: TextStyle(fontSize: 20)),
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(250, 35)),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Statistics', style: TextStyle(fontSize: 20)),
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(250, 35)),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('National', style: TextStyle(fontSize: 20)),
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(250, 35)),
              ),*/
            ],
          ),
        ));
  }
}
