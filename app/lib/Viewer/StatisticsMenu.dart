import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database/RemoteDBHelper.dart';

class StatiscticsMenu extends StatefulWidget {
  const StatiscticsMenu(
      {super.key, required this.title, required this.currency});
  final String currency;
  final String title;

  @override
  State<StatiscticsMenu> createState() => StatiscticsMenuState();
}

class StatiscticsMenuState extends State<StatiscticsMenu> {
  bool totalLimitEdited = false;

  RemoteDBHelper remoteDBHelper =
      RemoteDBHelper(userInstance: FirebaseAuth.instance);
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
          child: Text("ola!"),
        ));
  }
}
