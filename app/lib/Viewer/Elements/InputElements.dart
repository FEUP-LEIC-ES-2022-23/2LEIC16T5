import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quickalert/quickalert.dart';
import '../../Controller/LoginScreenController.dart';

class InputElements {
  Widget signInButtonWide(
      String text,
      GlobalKey<FormState> _key,
      LoginScreenController loginController,
      TextEditingController usernameController,
      TextEditingController passwordController,
      BuildContext context,
      f) {
    return Padding(
        key: Key(text),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: GestureDetector(
          onTap: () {
            if (_key.currentState!.validate()) {
              f(usernameController, passwordController, context);
              loginController.toMainMenu(context);
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
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(text,
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ));
  }

  Widget signUpButtonWide(
      String text,
      GlobalKey<FormState> _key,
      LoginScreenController loginController,
      TextEditingController usernameController,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController,
      BuildContext context,
      f) {
    bool error;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: GestureDetector(
          onTap: () {
            error = false;
            if (_key.currentState!.validate()) {
              if (passwordController.text != confirmPasswordController.text) {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: 'Passwords do not match!');
              } else {
                f(usernameController, passwordController, context);
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
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(text,
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ));
  }

  Widget inputBox(String? text, TextEditingController textController, validator,
      bool obscure) {
    return Padding(
      key: (text == null)? null : Key(text),
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
    RegExp number = RegExp(r'(?=.*\d)');
    RegExp lowercase = RegExp(r'(?=.*[a-z])');
    RegExp upper = RegExp(r'(?=.*[A-Z])');
    RegExp symbols = RegExp(r'(?=.*?[!@#\$&*~_])');
    if (password.contains(number) &&
            !password.contains(lowercase) &&
            !password.contains(upper) &&
            !password.contains(symbols) ||
        !password.contains(number) &&
            password.contains(lowercase) &&
            !password.contains(upper) &&
            !password.contains(symbols) ||
        !password.contains(number) &&
            !password.contains(lowercase) &&
            password.contains(upper) &&
            !password.contains(symbols) ||
        !password.contains(number) &&
            !password.contains(lowercase) &&
            !password.contains(upper) &&
            password.contains(symbols)) {
      return 25;
    } else if (password.contains(number) &&
            password.contains(lowercase) &&
            !password.contains(upper) &&
            !password.contains(symbols) ||
        !password.contains(number) &&
            password.contains(lowercase) &&
            password.contains(upper) &&
            !password.contains(symbols) ||
        !password.contains(number) &&
            !password.contains(lowercase) &&
            password.contains(upper) &&
            password.contains(symbols) ||
        password.contains(number) &&
            !password.contains(lowercase) &&
            !password.contains(upper) &&
            password.contains(symbols))
      return 50;
    else if (password.contains(number) &&
            password.contains(lowercase) &&
            password.contains(upper) &&
            !password.contains(symbols) ||
        !password.contains(number) &&
            password.contains(lowercase) &&
            password.contains(upper) &&
            password.contains(symbols) ||
        password.contains(number) &&
            !password.contains(lowercase) &&
            password.contains(upper) &&
            password.contains(symbols) ||
        password.contains(number) &&
            password.contains(lowercase) &&
            !password.contains(upper) &&
            password.contains(symbols))
      return 75;
    else if (password.contains(number) &&
        password.contains(lowercase) &&
        password.contains(upper) &&
        password.contains(symbols)) return 100;
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
