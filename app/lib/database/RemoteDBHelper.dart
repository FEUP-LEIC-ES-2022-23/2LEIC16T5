import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RemoteDBHelper {
  Future createUser(FirebaseAuth? user) async {
    UserModel userModel = UserModel(uid: user!.currentUser!.uid);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userModel.uid)
        .set(userModel.toMap());
  }
}
