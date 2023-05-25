import 'package:es/Controller/LoginScreenController.dart';
import 'package:es/Controller/EvaluateLoginState.dart';
import 'package:es/LocalStorage/LocalStorage.dart';
import 'package:flutter/material.dart';
import 'Viewer/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreenController(),
    );
  }
}
