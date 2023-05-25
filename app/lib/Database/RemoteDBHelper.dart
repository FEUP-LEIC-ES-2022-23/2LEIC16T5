import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Model/SettingModel.dart';
import 'package:es/Model/TransactionsModel.dart';
import 'package:es/Model/ExpenseModel.dart';
import 'package:es/Model/IncomeModel.dart';
import 'package:es/Model/SavingsModel.dart';
import 'package:es/Model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:es/Controller/MapMenuController.dart';
import 'package:es/Model/BudgetBarModel.dart';
import 'package:es/Model/CategoryModel.dart';

class RemoteDBHelper {
  FirebaseAuth userInstance;
  FirebaseFirestore firebaseInstance;
  RemoteDBHelper({required this.userInstance, required this.firebaseInstance});

  Future createUser() async {
    UserModel userModel = UserModel(uid: userInstance.currentUser!.uid);
    await firebaseInstance
        .collection('Users')
        .doc(userModel.uid)
        .set(userModel.toMap());
    CategoryModel defaultCategory = CategoryModel(
      userID: userModel.uid,
      name: 'Default',
      color: 0xFF808080,
    );
    await addCategory(defaultCategory);
    await addEmptyBudgetBar(defaultCategory);
  }

  //Section for Transactions
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    UserModel user = UserModel(uid: userInstance!.currentUser!.uid);
    DocumentReference transactionRef = await firebaseInstance
        .collection('Transactions')
        .add(transaction.toMap());

    transaction.transactionID = transactionRef.id;

    await firebaseInstance
        .collection('Transactions')
        .doc(transaction.transactionID)
        .update(transaction.toMap());

    return transaction;
  }

  Future<void> removeTransaction(TransactionModel transaction) async {
    await firebaseInstance
        .collection('Transactions')
        .doc(transaction.transactionID)
        .delete();
  }

  Future removeCategory(CategoryModel category) async {
    UserModel user = UserModel(uid: userInstance.currentUser!.uid);

    var defaultCategory = await getCategoryByName("Default");

    await FirebaseFirestore.instance
        .collection('Transactions')
        .where('userID', isEqualTo: user.uid)
        .where('categoryID', isEqualTo: category.categoryID)
        .get()
        .then((value) async {
      List<Future<void>> updateTasks = [];

      value.docs.forEach((doc) {

        var transactionRef =
        FirebaseFirestore.instance.collection('Transactions').doc(doc.id);

        updateTasks.add(transactionRef.update({
          'categoryID': defaultCategory.categoryID,
          'categoryName': defaultCategory.name,
          'color': defaultCategory.color,
          'categoryColor': defaultCategory.color,
        }));
      });

      await Future.wait(updateTasks);

      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(category.categoryID)
          .delete();
    });
  }


  Stream<List<TransactionModel>> readTransactions() {
    User? usr = FirebaseAuth.instance.currentUser;
    var transactions = firebaseInstance
        .collection('Transactions')
        .where('userID', isEqualTo: usr!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              if (data.containsKey('location')) {
                return ExpenseModel.fromMap(data);
              } else {
                return IncomeModel.fromMap(data);
              }
            }).toList()..sort((a, b) => b.date!.compareTo(a.date!)));

    transactions.listen((list) {
      list.forEach((transaction) {
        if (transaction.transactionID != null &&
            transaction is ExpenseModel &&
            transaction.location != null) {
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
    UserModel user = UserModel(uid: userInstance.currentUser!.uid);

    await firebaseInstance
        .collection('Categories')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .where('name', isEqualTo: category.name)
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
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
        category.categoryID = categoryID_;
        //update Category
        await firebaseInstance
            .collection('Categories')
            .doc(categoryID_)
            .update(category.toMap());
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

  Future<bool> hasCategories() async {
    User? usr = FirebaseAuth.instance.currentUser;
    var categories = firebaseInstance
        .collection('Categories')
        .where('userID', isEqualTo: usr!.uid)
        .where('name', isNotEqualTo: "Default")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromMap(doc.data()))
            .toList());

    try {
      var empty = await categories.isEmpty;
      return !empty;
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

  Future<CategoryModel> getCategoryById(String catID) async {
    User? usr = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Categories')
        .where('userID', isEqualTo: usr!.uid)
        .where('categoryID', isEqualTo: catID)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;
      final categoryMap = docSnapshot.data();
      return CategoryModel.fromMap(categoryMap);
    } else {
      throw Exception('Category not found');
    }
  }

  Future<CategoryModel> getCategoryByName(String name) async {
    User? usr = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Categories')
        .where('userID', isEqualTo: usr!.uid)
        .where('name', isEqualTo: name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;
      final categoryMap = docSnapshot.data();
      return CategoryModel.fromMap(categoryMap);
    } else {
      throw Exception('Category not found');
    }
  }

  Future<Stream<List<TransactionModel>>> getTransactionsByCategory(
      String catName) async {
    User? usr = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Categories')
        .where('userID', isEqualTo: usr!.uid)
        .where('name', isEqualTo: catName)
        .get();

    var categoryId = '';

    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;
      final categoryMap = docSnapshot.data();
      categoryId = CategoryModel.fromMap(categoryMap).categoryID!;
    }

    var transactions = FirebaseFirestore.instance
        .collection('Transactions')
        .where('userID', isEqualTo: usr.uid)
        .where('categoryID', isEqualTo: categoryId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data()))
            .toList());
    return transactions;
  }

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
      if (value.docs.isEmpty) {
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

  Future updateBudgetBarValOnChangedTransaction(
      String transactionID, bool isAdd) async {
    UserModel user = UserModel(uid: userInstance.currentUser!.uid);

    await firebaseInstance
        .collection('Transactions')
        .doc(transactionID)
        .get()
        .then((doc) async {
      num val = doc.data()!['total'];

      String categoryID_ = doc.data()!['categoryID'];

      await firebaseInstance
          .collection('BudgetBars')
          .where('userID', isEqualTo: user.uid)
          .where('categoryID', isEqualTo: categoryID_)
          .get()
          .then((budgetBar) {
        if (budgetBar.docs.length == 1) {
          double totalVal = budgetBar.docs.first.data()['value'].toDouble();
          budgetBar.docs.first.reference.update({
            'value':
                isAdd ? totalVal + val.toDouble() : totalVal - val.toDouble()
          });
        }
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

  Stream<List<BudgetBarModel>> readBudgetBarsWithValue() {
    return firebaseInstance
        .collection('BudgetBars')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BudgetBarModel.fromMapWithValue(doc.data()))
            .toList());
  }

  Future removeBudgetBar(String? categoryName) async {
    await firebaseInstance
        .collection('BudgetBars')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .where('categoryName', isEqualTo: categoryName)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
    });
  }

  Future userResetData() async {
    await firebaseInstance
        .collection('Transactions')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .get()
        .then((doc) {
      for (DocumentSnapshot ds in doc.docs) {
        ds.reference.delete();
      }
    });
    firebaseInstance
        .collection('Categories')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .get()
        .then((doc) {
      for (DocumentSnapshot ds in doc.docs) {
        if (ds.get('name') != "Default") {
          ds.reference.delete();
        }
      }
    });
    firebaseInstance
        .collection('Settings')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .get()
        .then((doc) {
      for (DocumentSnapshot ds in doc.docs) {
        ds.reference.delete();
      }
    });
    firebaseInstance
        .collection('BudgetBars')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .get()
        .then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    });
    firebaseInstance
        .collection('Savings')
        .where('userID', isEqualTo: userInstance.currentUser!.uid)
        .get()
        .then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    });
  }

  Stream<String> getCurrency() {
    User? usr = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('Settings')
        .where('userID', isEqualTo: usr!.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final settings = SettingsModel.fromMap(doc.data());
        return settings.currency;
      } else {
        return '€';
      }
    });
  }

  Future<void> changeCurrency(Object? newCurrency) async {
    final userId = userInstance.currentUser!.uid;
    final settingsQuery = FirebaseFirestore.instance
        .collection('Settings')
        .where('userId', isEqualTo: userId);
    final settingsQueryResult = await settingsQuery.get();

    if (settingsQueryResult.docs.isNotEmpty) {
      // Update existing settings document
      final settingsDocRef = settingsQueryResult.docs.first.reference;
      await settingsDocRef.update({"currency": newCurrency.toString()});
    } else {
      // Create new settings document
      final newSettings =
          SettingsModel(userID: userId, currency: newCurrency.toString());
      await FirebaseFirestore.instance
          .collection('Settings')
          .doc(userId)
          .set(newSettings.toMap());
    }
  }
}
