import 'dart:math';

import 'package:es/Viewer/LoginPage.dart';
import 'package:es/Viewer/MainMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import '../Controller/LoginScreenController.dart';
import 'settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class InputElements {
  Widget signInButtonWide(
      String text,
      GlobalKey<FormState> _key,
      loginScreenController loginController,
      TextEditingController usernameController,
      TextEditingController passwordController,
      BuildContext context,
      f) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: GestureDetector(
          onTap: () {
            if (_key.currentState!.validate()) {
              f(usernameController, passwordController, context);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              //color: Color.fromARGB(255, 4, 48, 194),
              color: Colors.blue,
              border: Border.all(
                  //color: Color.fromARGB(255, 4, 48, 194)),
                  color: Colors.blue),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(12),
            child: Center(
              child: Text(text,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ));
  }

  Widget signUpButtonWide(
      String text,
      GlobalKey<FormState> _key,
      loginScreenController loginController,
      TextEditingController usernameController,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController,
      BuildContext context,
      f) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: GestureDetector(
          onTap: () {
            if (_key.currentState!.validate()) {
              if (passwordController.text != confirmPasswordController.text) {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: 'Passwords do not match!');
              } else {
                f(usernameController, passwordController, context);
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: 'Your account was created!');
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              //color: Color.fromARGB(255, 4, 48, 194),
              color: Colors.blue,
              border: Border.all(
                  //color: Color.fromARGB(255, 4, 48, 194)),
                  color: Colors.blue),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(12),
            child: Center(
              child: Text(text,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ));
  }

  Widget inputBox(String? text, TextEditingController textController, validator,
      bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 23),
          child: TextFormField(
            obscureText: obscure,
            controller: textController,
            validator: validator,
            decoration: InputDecoration(
              labelText: text,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  double? CheckPasswordStrength(String password) {
    RegExp Number = RegExp(r'(?=.*\d)');
    RegExp Lowercase = RegExp(r'(?=.*[a-z])');
    RegExp Upper = RegExp(r'(?=.*[A-Z])');
    RegExp simbols = RegExp(r'(?=.*?[!@#\$&*~_])');
    if (password.contains(Number) &&
            !password.contains(Lowercase) &&
            !password.contains(Upper) &&
            !password.contains(simbols) ||
        !password.contains(Number) &&
            password.contains(Lowercase) &&
            !password.contains(Upper) &&
            !password.contains(simbols) ||
        !password.contains(Number) &&
            !password.contains(Lowercase) &&
            password.contains(Upper) &&
            !password.contains(simbols) ||
        !password.contains(Number) &&
            !password.contains(Lowercase) &&
            !password.contains(Upper) &&
            password.contains(simbols)) {
      return 25;
    } else if (password.contains(Number) &&
            password.contains(Lowercase) &&
            !password.contains(Upper) &&
            !password.contains(simbols) ||
        !password.contains(Number) &&
            password.contains(Lowercase) &&
            password.contains(Upper) &&
            !password.contains(simbols) ||
        !password.contains(Number) &&
            !password.contains(Lowercase) &&
            password.contains(Upper) &&
            password.contains(simbols) ||
        password.contains(Number) &&
            !password.contains(Lowercase) &&
            !password.contains(Upper) &&
            password.contains(simbols))
      return 50;
    else if (password.contains(Number) &&
            password.contains(Lowercase) &&
            password.contains(Upper) &&
            !password.contains(simbols) ||
        !password.contains(Number) &&
            password.contains(Lowercase) &&
            password.contains(Upper) &&
            password.contains(simbols) ||
        password.contains(Number) &&
            !password.contains(Lowercase) &&
            password.contains(Upper) &&
            password.contains(simbols) ||
        password.contains(Number) &&
            password.contains(Lowercase) &&
            !password.contains(Upper) &&
            password.contains(simbols))
      return 75;
    else if (password.contains(Number) &&
        password.contains(Lowercase) &&
        password.contains(Upper) &&
        password.contains(simbols)) return 100;
    return 0;
  }

  Widget inputBox2(
    String? text,
    TextEditingController textController,
    validator,
    bool obscure,
    notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 23),
          child: TextFormField(
            onChanged: (value) {
              notifier.value = CheckPasswordStrength(value);
            },
            obscureText: obscure,
            controller: textController,
            validator: validator,
            decoration: InputDecoration(
              labelText: text,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
