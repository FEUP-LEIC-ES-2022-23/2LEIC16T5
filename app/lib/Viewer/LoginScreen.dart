import 'package:es/Viewer/MainMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 210, 212, 230),
      body: SafeArea(
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
                      child: TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainMenu()));
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
                        child: const Center(
                          child: Text('Sign in',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                    )),
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Become a member of FortuFamily! ',
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
                const SizedBox(
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
