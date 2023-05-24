import 'package:es/Viewer/LoginPage.dart';
import 'package:es/Viewer/MainMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EvaluateLogin extends StatelessWidget {
  const EvaluateLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MainMenu();
            } else {
              return LoginPage();
            }
          }),
    );
  }
}
