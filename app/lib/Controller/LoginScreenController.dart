import 'package:es/Viewer/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:es/Viewer/MainMenu.dart';
import 'package:flutter/rendering.dart';
import 'package:quickalert/quickalert.dart';

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
              return const MainMenu();
            } else {
              return const LoginPage();
            }
          }),
    );
  }

  toMainMenu(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => loginScreenController()),
        (route) => false);
  }

  Future signIn(TextEditingController email, TextEditingController password,
      BuildContext context) async {
    try {
      await FirebaseAuth.instance!.signInWithEmailAndPassword(
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

      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Your account was created successfully!');
    } on FirebaseAuthException catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, text: e.message!);
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  toLogInScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => loginScreenController()),
        (route) => false);
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
