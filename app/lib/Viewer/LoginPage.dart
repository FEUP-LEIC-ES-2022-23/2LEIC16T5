import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:quickalert/quickalert.dart';
import '../Controller/LoginScreenController.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'Elements/InputElements.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  loginScreenController loginController = loginScreenController();
  InputElements inputElements = InputElements();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String errorMessage = '';
  void showErrorAlert() {
    QuickAlert.show(
        context: context,
        text: "Login failed, please check your credentials again",
        type: QuickAlertType.error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key("Login"),
      backgroundColor: const Color.fromARGB(255, 12, 18, 50),
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
                  width: 250,
                ),
                const Text(
                  'Welcome to Fortuneko!',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                const SizedBox(height: 30),
                inputElements.inputBox('Email', usernameController,
                    loginController.validateEmail, false),
                const SizedBox(height: 10),
                inputElements.inputBox('Password', passwordController,
                    loginController.validatePassword, true),
                const SizedBox(height: 60),
                inputElements.signInButtonWide(
                    'Sign in',
                    _key,
                    loginController,
                    usernameController,
                    passwordController,
                    context,
                    loginController.signIn),
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Become a member of FortuFamily! ',
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  _signUpState().build(context))),
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                            color: Colors.blue[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline),
                      ),
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

class _signUpState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confimPasswordController = TextEditingController();
  loginScreenController loginController = loginScreenController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  InputElements inputElement = InputElements();

  ValueNotifier<double> ProgressValue = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 18, 50),
      body: Form(
          key: _key,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/Luckycat1.png',
                      fit: BoxFit.contain,
                      width: 250,
                    ),
                    const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'Please provide us with the following info to become a member!',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 15),
                    inputElement.inputBox('Email', usernameController,
                        loginController.validateEmail, false),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        inputElement.inputBox2(
                            'Password',
                            passwordController,
                            loginController.validatePassword,
                            true,
                            ProgressValue),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Align(
                            child: SimpleCircularProgressBar(
                              valueNotifier: ProgressValue,
                              size: 20,
                              backStrokeWidth: 6,
                              progressStrokeWidth: 6,
                              animationDuration: 1,
                              progressColors: [
                                Colors.red,
                                Colors.orange,
                                Colors.yellow,
                                Colors.green
                              ],
                            ),
                            alignment: Alignment.topRight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    inputElement.inputBox(
                        'Confirm password',
                        confimPasswordController,
                        loginController.validatePassword,
                        true),
                    const SizedBox(height: 30),
                    inputElement.signUpButtonWide(
                        'Sign up',
                        _key,
                        loginController,
                        usernameController,
                        passwordController,
                        confimPasswordController,
                        context,
                        loginController.signUp),
                  ]),
            ),
          )),
    );
  }
}
