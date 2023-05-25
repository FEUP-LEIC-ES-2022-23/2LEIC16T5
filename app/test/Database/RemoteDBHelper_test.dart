import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Controller/BudgetMenuController.dart';
import 'package:es/Model/BudgetBarModel.dart';
import 'package:es/Model/ExpenseModel.dart';
import 'package:es/Database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../Controller/BudgetMenuController_test.mocks.dart';
import 'RemoteDBHelper_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseFirestore>(),
  MockSpec<CollectionReference<Map<String, dynamic>>>(as: #CollectionMock),
  MockSpec<DocumentReference<Map<String, dynamic>>>(as: #DocMock),
  MockSpec<Future<DocumentReference<Map<String, dynamic>>>>(as: #FutureDocMock),
  MockSpec<FirebaseAuth>(),
  MockSpec<ExpenseModel>(as: #ExpenseMock),
  MockSpec<User>(),
  MockSpec<Query<Map<String, dynamic>>>(as: #QueryMock),
  MockSpec<Stream<QuerySnapshot<Map<String, dynamic>>>>(
      as: #StreamQuerySnapshotMock)
])
Future<void> main() async {
  late MockFirebaseFirestore firebaseFirestoreMock;
  late CollectionMock collectionMock;
  late DocMock docMock;
  late FutureDocMock futureDocMock;
  late MockFirebaseAuth firebaseAuthMock;
  late RemoteDBHelper concreteDB;
  late MockUser userMock;
  late TransactionMock transactionMock;
  late QueryMock queryMock;
  late Map<String, dynamic> stubData;
  late ExpenseModel stubTransaction;
  late StreamQuerySnapshotMock snapshotMock;

  

  setUpAll(() {
    firebaseFirestoreMock = MockFirebaseFirestore();
    collectionMock = CollectionMock();
    docMock = DocMock();
    futureDocMock = FutureDocMock();
    firebaseAuthMock = MockFirebaseAuth();
    concreteDB = RemoteDBHelper(
        userInstance: firebaseAuthMock,
        firebaseInstance: firebaseFirestoreMock);
    userMock = MockUser();
    transactionMock = TransactionMock();
    queryMock = QueryMock();
    snapshotMock = StreamQuerySnapshotMock();
  });
  tearDown(() {
    reset(firebaseAuthMock);
    reset(firebaseFirestoreMock);
    reset(collectionMock);
    reset(docMock);
    reset(transactionMock);
  });


  group('addTransaction test', () {
    setUp(() {
      when(firebaseFirestoreMock.collection(any)).thenReturn(collectionMock);
      when(firebaseAuthMock.currentUser).thenReturn(userMock);
      when(collectionMock.doc(any)).thenReturn(docMock);
      when(collectionMock.add(any)).thenAnswer((realInvocation) async {
        return docMock;
      });

      when(docMock.id).thenReturn('1');

      when(userMock.uid).thenReturn('test');
      when(transactionMock.date).thenReturn(DateTime.now());

      stubTransaction = ExpenseModel(
          transactionID: '0',
          userID: '0',
          categoryID: '0',
          name: 'test',
          total: 0,
          date: DateTime.now());
    });
    test('value testing add transaction', () async {
      await concreteDB.addTransaction(stubTransaction);
      expect(stubTransaction.transactionID, '1');
    });
  });
  group('removeTransaction test', () {
    setUp(() {
      when(firebaseFirestoreMock.collection(any)).thenReturn(collectionMock);
      when(firebaseAuthMock.currentUser).thenReturn(userMock);
      when(collectionMock.doc(any)).thenReturn(docMock);
      when(userMock.uid).thenReturn('test');
    });
    test('removeTransaction behaviour testing', () async {
      await concreteDB.removeTransaction(transactionMock);
      verify(firebaseFirestoreMock.collection(any)).called(1);
      verify(collectionMock.doc()).called(1);
      verify(docMock.delete()).called(1);
    });
  });
}
