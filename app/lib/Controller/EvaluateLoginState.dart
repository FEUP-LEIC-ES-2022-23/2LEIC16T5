import 'package:es/Viewer/LoginPage.dart';
import 'package:es/Viewer/MainMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'LoginScreenController.dart';
import '../Viewer/settings.dart';

//import 'package:firebase_core/firebase_core.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

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
