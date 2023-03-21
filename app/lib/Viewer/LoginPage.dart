import 'package:es/Viewer/MainMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import '../Controller/LoginScreenController.dart';
import 'settings.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  void showErrorAlert() {
    QuickAlert.show(
        context: context,
        text: "Login failed, please check your credentials again",
        type: QuickAlertType.error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 210, 212, 230),
      body: Form(
        key: _key,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/img/Luckycat1.png',
                  fit: BoxFit.contain,
                  width: 150,
                  height: 150,
                ),
                Text(
                  'Welcome to Fortuneko!',
                  style: GoogleFonts.shadowsIntoLight(fontSize: 30),
                ),
                //SizedBox(height:30),

                Padding(
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
                        controller: usernameController,
                        validator: loginScreenController().validateEmail,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Padding(
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
                        controller: passwordController,
                        obscureText: true,
                        validator: loginScreenController().validatePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 60),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: () {
                        if (_key.currentState!.validate()) {
                          loginScreenController()
                              .signIn(usernameController, passwordController);
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
                          child: Text('Sign in',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                    )),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Become a member of FortuFamily! ',
                        style: TextStyle(fontSize: 15)),
                    Text(
                      'Register Now',
                      style: TextStyle(
                          color: Colors.blue[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                SizedBox(
                  height: 45,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
