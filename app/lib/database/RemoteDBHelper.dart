import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Model/TransactionsModel.dart';
import 'package:es/Model/SavingsModel.dart';
import 'package:es/Model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:es/Controller/MapMenuController.dart';

import '../Model/CategoryModel.dart';

class RemoteDBHelper {
  FirebaseAuth userInstance;
  RemoteDBHelper({required this.userInstance});
  Future createUser() async {
    UserModel userModel = UserModel(uid: userInstance!.currentUser!.uid);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userModel.uid)
        .set(userModel.toMap());
  }

  Future addTransaction(TransactionModel transaction) async {
    UserModel user = UserModel(uid: userInstance!.currentUser!.uid);
    await FirebaseFirestore.instance
        .collection('Transactions')
        .add(transaction.toMap())
        .then((value) {
      transaction.transactionID = value.id;
    });
    await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(transaction.transactionID)
        .update({
      'transactionID': transaction.transactionID,
      'userID': userInstance.currentUser!.uid,
      'categoryID': transaction.categoryID,
      'expense': transaction.expense,
      'name': transaction.name,
      'total': transaction.total,
      'date': transaction.date.millisecondsSinceEpoch,
      'notes': transaction.notes,
      'location' : transaction.location
    });
  }

  Future addCategory(CategoryModel category) async {
    UserModel user = UserModel(uid: userInstance!.currentUser!.uid);
    await FirebaseFirestore.instance
        .collection('Categories')
        .add(category.toMap())
        .then((value) {
      category.categoryID = value.id;
    });
    await FirebaseFirestore.instance
        .collection('Categories')
        .doc(category.categoryID)
        .update({
      'categoryID': category.categoryID,
      'userID': userInstance.currentUser!.uid,
      'name': category.name,
      'color': category.color,
    });
  }

  Future removeTransaction(TransactionModel transaction) async {
    await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(transaction.transactionID)
        .delete();
  }

  Future removeCategory(CategoryModel category) async {
    UserModel user = UserModel(uid: userInstance.currentUser!.uid);
    await FirebaseFirestore.instance
        .collection('Categories')
        .doc(category.categoryID)
        .delete();
  }

  Stream<List<TransactionModel>> readTransactions() {
    User? usr = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('Transactions')
        .where('userID', isEqualTo: usr!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TransactionModel.fromMap(doc.data()))
        .toList());
  }

  Stream<List<CategoryModel>> readCategories() {
    User? usr= FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('Categories')
        .where('userID',isEqualTo: usr!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromMap(doc.data()))
            .toList());
  }

  Future<bool> hasTransactions() async {
    User? usr = FirebaseAuth.instance.currentUser;
    var transactions = FirebaseFirestore.instance
        .collection('Transactions')
        .where('userID', isEqualTo: usr!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TransactionModel.fromMap(doc.data()))
        .toList());
    try {
      var firstTransaction = await transactions.first;
      return firstTransaction.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hasCategories() async {
    User? usr = FirebaseAuth.instance.currentUser;
    var categories = FirebaseFirestore.instance
        .collection('Categories')
        .where('userID', isEqualTo: usr!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CategoryModel.fromMap(doc.data()))
        .toList());
    try {
      var firstCategory = await categories.first;
      return firstCategory.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Stream<SavingsModel> readSaving(String? name) {
    return FirebaseFirestore.instance
        .collection('Savings')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .where('name', isEqualTo: name)
        .snapshots()
        .map((snapshot) => SavingsModel.fromMap(snapshot.docs.first.data()));
  }

  Stream<List<SavingsModel>> readSavings() {
    User? usr = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('Savings')
        .where('userID', isEqualTo: usr!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SavingsModel.fromMap(doc.data()))
            .toList());
  }

  Future addSavings(SavingsModel saving) async {
    User? usr = FirebaseAuth.instance.currentUser;
    saving.userID = usr!.uid;
    await FirebaseFirestore.instance
        .collection('Savings')
        .doc(saving.name)
        .set(saving.toMap());
  }

  Future deleteSaving(String? name) async {
    FirebaseFirestore.instance
        .collection('Savings')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .where('name', isEqualTo: name)
        .get()
        .then((doc) {
      for (DocumentSnapshot ds in doc.docs) {
        ds.reference.delete();
      }
    });
  }

  Future userResetData() async {
    FirebaseFirestore.instance
        .collection('Transactions')
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      for (DocumentSnapshot ds in doc.docs) {
        ds.reference.delete();
      }
    });
    FirebaseFirestore.instance
        .collection('Categories')
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      for (DocumentSnapshot ds in doc.docs) {
        ds.reference.delete();
      }
    });
  }
}
