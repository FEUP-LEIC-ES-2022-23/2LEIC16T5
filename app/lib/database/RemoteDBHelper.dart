import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Model/TransactionsModel.dart';
import 'package:es/Model/SavingsModel.dart';
import 'package:es/Model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:es/Controller/MapMenuController.dart';
import 'package:es/Model/BudgetBarModel.dart';

import '../Model/CategoryModel.dart';

class RemoteDBHelper {
  FirebaseAuth userInstance;
  FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;
  RemoteDBHelper({required this.userInstance});
  Future createUser() async {
    UserModel userModel = UserModel(uid: userInstance!.currentUser!.uid);
    await firebaseInstance
        .collection('Users')
        .doc(userModel.uid)
        .set(userModel.toMap());
  }

  //Section for Transactions
  Future<String?> addTransaction(TransactionModel transaction) async {
    UserModel user = UserModel(uid: userInstance!.currentUser!.uid);
    await firebaseInstance
        .collection('Transactions')
        .add(transaction.toMap())
        .then((value) {
      transaction.transactionID = value.id;
    });
    await firebaseInstance
        .collection('Transactions')
        .doc(transaction.transactionID)
        .update({
      'transactionID': transaction.transactionID,
      'userID': userInstance.currentUser!.uid,
      'categoryID': 'tDi5HgBjmuCK9tmvXhdHw',
      'expense': transaction.expense,
      'name': transaction.name,
      'total': transaction.total,
      'date': transaction.date.millisecondsSinceEpoch,
      'notes': transaction.notes,
      'location': transaction.location
    });
    return transaction.transactionID;
  }

  Future removeTransaction(TransactionModel transaction) async {
    await firebaseInstance
        .collection('Transactions')
        .doc(transaction.transactionID)
        .delete();
  }

  Stream<List<TransactionModel>> readTransactions() {
    User? usr = FirebaseAuth.instance.currentUser;
    var transactions = firebaseInstance
        .collection('Transactions')
        .where('userID', isEqualTo: usr!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data()))
            .toList());

    transactions.listen((list) {
      list.forEach((transaction) {
        if (transaction.transactionID != null && transaction.location != null) {
          MapMenuController().addMarker(transaction);
        }
      });
    });
    return transactions;
  }

  Future<bool> hasTransactions() async {
    User? usr = FirebaseAuth.instance.currentUser;
    var transactions = firebaseInstance
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

  //Section for Category
  Future addCategory(CategoryModel category) async {
    UserModel user = UserModel(uid: userInstance!.currentUser!.uid);
    /*await firebaseInstance
        .collection('Categories')
        .add(category.toMap())
        .then((value) {
      category.categoryID = value.id;
    });
    await firebaseInstance
        .collection('Categories')
        .doc(category.categoryID)
        .update({
      'categoryID': category.categoryID,
      'userID': userInstance.currentUser!.uid,
      'name': category.name,
      'color': category.color,
    });*/

    /* falta adicionar atualizar as transacoes e os budgetBars smp q category é atualizada*/
    await firebaseInstance
        .collection('Categories')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .where('name', isEqualTo: category.name)
        .get()
        .then((value) async {
      if (value.docs.length < 1) {
        await firebaseInstance
            .collection('Categories')
            .add(category.toMap())
            .then((doc) {
          category.categoryID = doc.id;
        });
        await firebaseInstance
            .collection('Categories')
            .doc(category.categoryID)
            .update({
          'categoryID': category.categoryID,
          'userID': userInstance.currentUser!.uid,
          'name': category.name,
          'color': category.color,
        });
      } else {
        String categoryID_ = value.docs.first.id;
        //update Category
        await firebaseInstance
            .collection('Categories')
            .doc(categoryID_)
            .update(category.toMap());
        // update transactions
        /*await firebaseInstance
            .collection('Transactions')
            .where('userID', isEqualTo: user.uid)
            .where('categoryID', isEqualTo: categoryID_)
            .get()
            .then((transactions) {
          transactions.docs.forEach((transaction) {
            transaction.reference.update({'categoryID': categoryID_});
          });
        });*/
        //update budgetBars
        await firebaseInstance
            .collection('BudgetBars')
            .where('userID', isEqualTo: user.uid)
            .where('categoryID', isEqualTo: categoryID_)
            .get()
            .then((budgetBar) {
          budgetBar.docs.first.reference
              .update({'color': category.color, 'categoryName': category.name});
        });
      }
    });
  }

  Future removeCategory(CategoryModel category) async {
    UserModel user = UserModel(uid: userInstance.currentUser!.uid);
    await firebaseInstance
        .collection('Categories')
        .doc(category.categoryID)
        .delete();
  }

  Future<bool> hasCategories() async {
    User? usr = FirebaseAuth.instance.currentUser;
    var categories = firebaseInstance
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

  Stream<List<CategoryModel>> readCategories() {
    User? usr = FirebaseAuth.instance.currentUser;
    return firebaseInstance
        .collection('Categories')
        .where('userID', isEqualTo: usr!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromMap(doc.data()))
            .toList());
  }

//Section for Savings
  Stream<List<SavingsModel>> readSaving(String? name) {
    return firebaseInstance
        .collection('Savings')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .where('name', isEqualTo: name)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SavingsModel.fromMap(doc.data()))
            .toList());
  }

  Stream<List<SavingsModel>> readSavings() {
    User? usr = FirebaseAuth.instance.currentUser;
    return firebaseInstance
        .collection('Savings')
        .where('userID', isEqualTo: usr!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SavingsModel.fromMap(doc.data()))
            .toList());
  }

  Future updateSavingValue(
      String? name, double currVal, double valToUpdate, bool ifAdd) async {
    await firebaseInstance
        .collection('Savings')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .where('name', isEqualTo: name)
        .limit(1)
        .get()
        .then((item) {
      item.docs.first.reference.update(
          {"value": ifAdd ? currVal + valToUpdate : currVal - valToUpdate});
    });
  }

  Future addSaving(SavingsModel saving) async {
    User? usr = FirebaseAuth.instance.currentUser;
    saving.userID = usr!.uid;
    await firebaseInstance
        .collection('Savings')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .where('name', isEqualTo: saving.name)
        .get()
        .then((value) async {
      if (value.docs.length < 1) {
        await firebaseInstance.collection('Savings').add(saving.toMap());
      } else {
        await firebaseInstance
            .collection('Savings')
            .doc(value.docs.first.reference.id)
            .update(saving.toMap());
      }
    });
  }

  Future deleteSaving(String? name) async {
    await firebaseInstance
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

//Section for Budgeting
  Future addEmptyBudgetBar(CategoryModel category) async {
    UserModel user = UserModel(uid: userInstance.currentUser!.uid);
    BudgetBarModel budgetBarModel;
    await firebaseInstance
        .collection('Categories')
        .where('userID', isEqualTo: category.userID)
        .where('name', isEqualTo: category.name)
        .get()
        .then((docsQuery) async {
      if (docsQuery.docs.length == 1) {
        Map<String, dynamic> categoryQueryData = docsQuery.docs.first.data();

        budgetBarModel = BudgetBarModel(
            categoryName: categoryQueryData['name'],
            categoryID: categoryQueryData['categoryID'],
            userID: user.uid!,
            limit: 0,
            value: 0,
            color: categoryQueryData['color']);
        await firebaseInstance
            .collection(('BudgetBars'))
            .doc(categoryQueryData['categoryID'])
            .set(budgetBarModel.toMap());
      }
    });
  }

  Future updateBudgetBarOnNewTransaction(String transactionID) async {
    UserModel user = UserModel(uid: userInstance.currentUser!.uid);

    await firebaseInstance
        .collection('Transactions')
        .doc(transactionID)
        .get()
        .then((doc) async {
      num val = doc.data()!['total'];
      String categoryID_ = doc.data()!['categoryID'];
      await firebaseInstance
          .collection('Categories')
          .doc(categoryID_)
          .get()
          .then((categoryDoc) async {
        int color_ = categoryDoc.data()!['color'];

        await firebaseInstance
            .collection('BudgetBars')
            .where('categoryName', isEqualTo: categoryDoc.data()!['name'])
            .get()
            .then((budgetBar) async {
          if (budgetBar.docs.length == 1) {
            double budgetBarVal = budgetBar.docs.first.data()['value'];
            double limit = budgetBar.docs.first.data()['limit'];

            BudgetBarModel temp = BudgetBarModel(
                categoryName: categoryDoc.data()!['name'],
                categoryID: categoryID_,
                userID: user.uid!,
                limit: limit,
                value: val.toDouble() + budgetBarVal,
                color: color_);
            await firebaseInstance
                .collection('BudgetBars')
                .doc(budgetBar.docs.first.id)
                .set(temp.toMap());
          }
        });
      });
    });
  }

  Future updateBudgetBarLimit(String? categoryName, double? limit) async {
    await firebaseInstance
        .collection('BudgetBars')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .where('categoryName', isEqualTo: categoryName)
        .get()
        .then((budgetBarDocs) {
      if (budgetBarDocs.docs.length == 1) {
        budgetBarDocs.docs.first.reference.update({'limit': limit});
      }
    });
  }

  Stream<List<BudgetBarModel>> readBudgetBars() {
    return firebaseInstance
        .collection('BudgetBars')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BudgetBarModel.fromMap(doc.data()))
            .toList());
  }

  Future removeBudgetBar(String? categoryName) async {
    await firebaseInstance
        .collection('BudgetBars')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .where('categoryName', isEqualTo: categoryName)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

  Future userResetData() async {
    await firebaseInstance
        .collection('Transactions')
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      for (DocumentSnapshot ds in doc.docs) {
        ds.reference.delete();
      }
    });
    firebaseInstance
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
