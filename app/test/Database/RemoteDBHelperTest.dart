import 'package:es/Model/TransactionsModel.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:es/testenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

bool USE_FIRESTORE_EMULATOR = true;

Future<void> main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();
  final googleSignIn = MockGoogleSignIn();
  final signinAccount = await googleSignIn.signIn();
  final googleAuth = await signinAccount?.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  // Sign in.
  final mockUser = MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
  );
  final auth = MockFirebaseAuth(mockUser: mockUser);
  final result = await auth.signInWithCredential(credential);
  final user = await result.user;
  RemoteDBHelper db = RemoteDBHelper(userInstance: auth);
  test('test',() async{
    Stream<List<TransactionModel>> transactions = db.readTransactions();
    transactions.forEach((element) {
      print(element.first.name);
    });
  });
}