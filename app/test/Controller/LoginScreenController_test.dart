import 'package:es/Controller/LoginScreenController.dart';
import 'package:es/testenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();
  final googleSignIn = MockGoogleSignIn();
  final signinAccount = await googleSignIn.signIn();
  final googleAuth = await signinAccount?.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  loginScreenController loginController = loginScreenController();
  MockBuildContext context = MockBuildContext();
  TextEditingController email = TextEditingController(text: "test@test.com");
  TextEditingController password = TextEditingController(text: "password");

  group('Login tests', () {

    /*
    test('Register Account', () {
      expect(loginController.signUp(email, password, context), completes);
    });

    test('SignIn Account', () {
      expect(loginController.signIn(email, password, context), completes);
    });

    test('SignOut Account', () {
      expect(loginController.signOut(), completes);
    });
*/
    test('Validate empty password', () {
      String pass = "";
      String? result = loginController.validatePassword(pass);
      expect(result, 'Password is empty!');
    });

    test('Validate null password', () {
      String? pass;
      String? result = loginController.validatePassword(pass);
      expect(result, 'Password is empty!');
    });

    test('Validate password', () {
      String pass = password.text;
      String? result = loginController.validatePassword(pass);
      expect(result, null);
    });

    test('Validate empty email', () {
      String mail = "";
      String? result = loginController.validateEmail(mail);
      expect(result, 'Email address is required!');
    });

    test('Validate null email', () {
      String? mail;
      String? result = loginController.validateEmail(mail);
      expect(result, 'Email address is required!');
    });

    test('Validate bad email', () {
      String mail = "foo";
      String? result = loginController.validateEmail(mail);
      expect(result, 'Invalid email address format!');
    });

    test('Validate good email', () {
      String mail = email.text;
      String? result = loginController.validateEmail(mail);
      expect(result, null);
    });
  });
}
