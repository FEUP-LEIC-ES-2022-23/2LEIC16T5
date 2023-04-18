import 'package:firebase_core/firebase_core.dart';
import 'package:es/Controller/NewTransactionController.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:es/Model/TransactionsModel.dart' as t_model;
import 'package:flutter/material.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockRemoteDBHelper extends Mock implements RemoteDBHelper {
  MockRemoteDBHelper(this.firebaseAuth);
  final FirebaseAuth firebaseAuth;
}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockRemoteDBHelper mockRemoteDBHelper;
  late NewTransactionController controller;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    mockFirebaseAuth = MockFirebaseAuth();
    mockRemoteDBHelper = MockRemoteDBHelper(mockFirebaseAuth);
    controller = NewTransactionController(mockRemoteDBHelper);
    
  });

  group('enterTransaction', () {
    /*when(mockFirebaseAuth.currentUser!.uid).thenAnswer((realInvocation) {
      return 'UserID';
    });*/
    test(
        'adds an expense to the remote database and clears the text controllers',
        () {
      final textControllerName = TextEditingController();
      final textControllerTotal = TextEditingController();
      final textControllerDate = TextEditingController();
      final textControllerNotes = TextEditingController();

      textControllerName.text = 'Test transaction';
      textControllerTotal.text = '50';
      textControllerDate.text = '2022-01-01';
      textControllerNotes.text = 'Test notes';
      controller.isIncome = false;

      final expectedTransaction = t_model.TransactionModel(
        userID: mockFirebaseAuth.currentUser!.uid,
        name: 'Test transaction',
        expense: 1,
        total: 50,
        date: DateTime(2022, 1, 1),
        notes: 'Test notes',
      );

      NewTransactionController.textcontrollerNAME = textControllerName;
      NewTransactionController.textcontrollerTOTAL = textControllerTotal;
      NewTransactionController.textcontrollerDATE = textControllerDate;
      NewTransactionController.textcontrollerNOTES = textControllerNotes;

      controller.enterTransaction();

      verify(mockRemoteDBHelper.addTransaction(expectedTransaction));
      expect(textControllerName.text, '');
      expect(textControllerTotal.text, '');
      expect(textControllerDate.text, '');
      expect(textControllerNotes.text, '');
    });
  });
}
