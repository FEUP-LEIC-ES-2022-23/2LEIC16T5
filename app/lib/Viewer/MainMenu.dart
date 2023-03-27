import 'package:es/Viewer/SettingsMenu.dart';
import 'package:flutter/material.dart';
import 'TransactionsMenu.dart';
import 'package:google_fonts/google_fonts.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 12, 18, 50),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 25,
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SettingsMenu(title: 'Settings')));
                    },
                    child: Icon(Icons.settings),
                  )),
              Text('Main Menu',
                  style: TextStyle(fontSize: 60, color: Colors.white)),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/img/Luckycat1.png',
                width: 250,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 35)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionsMenu(title: 'Transactions')),
                    );
                  },
                  child: Text('Transactions', style: TextStyle(fontSize: 20))),
              ElevatedButton(
                onPressed: () {},
                child: Text('Budget', style: TextStyle(fontSize: 20)),
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(250, 35)),
              ),
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
              ),
            ],
          ),
        ));
  }
}
