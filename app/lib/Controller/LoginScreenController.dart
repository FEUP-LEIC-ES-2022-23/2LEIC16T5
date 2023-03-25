import 'package:es/Viewer/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:es/Viewer/MainMenu.dart';
import 'package:flutter/rendering.dart';
import 'package:quickalert/quickalert.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class loginScreenController extends StatelessWidget {
  bool rememberMeChecked = false;
  loginScreenController({Key? key}) : super(key: key);
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

  toMainMenu(BuildContext context) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MainMenu()), (route) => false);
  }

  Future signIn(TextEditingController email, TextEditingController password,
      BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
    } on FirebaseAuthException catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, text: e.message!);
    }
  }

  Future signUp(TextEditingController email, TextEditingController password,
      BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
    } on FirebaseAuthException catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, text: e.message!);
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  toLogInScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email adress is required!';
    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email)) return 'Invalid email adress format!';

    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Password is empty!';
    return null;
  }
}
