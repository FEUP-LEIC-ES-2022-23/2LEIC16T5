import 'dart:async';

import 'package:es/Controller/BudgetMenuController.dart';
import 'package:es/Model/BudgetBarModel.dart';
import 'package:es/Model/TransactionsModel.dart';
import 'package:es/Database/RemoteDBHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'BudgetMenuController_test.mocks.dart';

class BudgetMenuControllerFake extends Fake implements BudgetMenuController {
  @override
  checkLimit(BudgetBarModel model, double threshold) {
    if (threshold <= 1) {
      if (model.y! >=
          model.limit!.toDouble() - model.limit!.toDouble() * threshold) {
        model.onLimit = true;
      } else {
        model.onLimit = false;
      }
      if (model.y! >= model.limit!.toDouble())
        model.overLimit = true;
      else
        model.overLimit = false;
    } else {
      /*if (model.y! >=
          model.limit!.toDouble() - model.limit!.toDouble() * 1) {
        model.onLimit = true;
      } else {
        model.onLimit = false;
      }
      if (model.y! >= model.limit!.toDouble())
        model.overLimit = true;
      else
        model.overLimit = false;*/
      throw 'Threshold bigger than 1';
    }
  }

  @override
  void getTransactions(RemoteDBHelper db, Function? callback) {
    dynamic transacs = db.readTransactions();
    transacs.listen((transacs) {
      List<TransactionModel> transactions = [];
      for (TransactionModel transac in transacs) {
        if (transac.date.month == DateTime.now().month &&
            transac.date.year == DateTime.now().year) {
          transactions.add(transac);
        }
      }
      callback!(transactions);
    });
  }

  @override
  void loadBudgetBars(
      RemoteDBHelper db, BuildContext context, Function? callback) async {
    Stream<List<BudgetBarModel>> stream = db.readBudgetBars();
    stream.listen((budgetBars) {
      if (context.mounted) {
        callback!(() {
          listitems = [];
          for (var budgetBar in budgetBars) {
            listitems.add(budgetBar.categoryName!);
          }
          selectedVal = listitems.first;
        });
      }
    });
  }
}

@GenerateNiceMocks([
  MockSpec<BudgetMenuController>(),
  MockSpec<BudgetBarModel>(),
  MockSpec<Stream<List<TransactionModel>>>(
      as: Symbol('MockStreamTransactionModel')),
  MockSpec<Stream<List<BudgetBarModel>>>(as: Symbol('MockStreamBudgetBars')),
  MockSpec<RemoteDBHelper>(),
  MockSpec<TransactionModel>(),
  MockSpec<BuildContext>()
])
Future<void> main() async {
  late MockBudgetMenuController mock;
  late MockBudgetBarModel barMock;
  late BudgetMenuController concreteBudgetMenuController;
  late MockRemoteDBHelper dbMock;
  late MockStreamTransactionModel streamTransactionMock;
  late MockTransactionModel transactionModelMock;
  late MockStreamBudgetBars budgetBarsStreamMock;
  late MockBuildContext buildContextMock;

  setUpAll(() {
    mock = MockBudgetMenuController();
    barMock = MockBudgetBarModel();
    concreteBudgetMenuController = BudgetMenuControllerFake();
    dbMock = MockRemoteDBHelper();
    transactionModelMock = MockTransactionModel();
    streamTransactionMock = MockStreamTransactionModel();
    budgetBarsStreamMock = MockStreamBudgetBars();
    buildContextMock = MockBuildContext();
  });
  tearDown(() {});

  group('Testing for checkLimit', () {
    test('checkLimit value test 1', () {
      BudgetBarModel bar = BudgetBarModel(categoryID: '0', userID: '1');
      bar.y = 10.0;
      bar.limit = 11.0;
      dynamic threshold = 0.1;
      concreteBudgetMenuController.checkLimit(bar, threshold);
      expect(bar.onLimit, isTrue);

      when(barMock.y).thenReturn(10);
      when(barMock.limit).thenReturn(11);
      expect(barMock.y, 10);
      expect(barMock.limit, 11);
      concreteBudgetMenuController.checkLimit(barMock, 1);
      verify(barMock.y).called(greaterThan(1));
      verify(barMock.limit).called(greaterThan(2));

      reset(barMock);
    });
    test('checkLimit value test 2', () {
      BudgetBarModel bar = BudgetBarModel(categoryID: '0', userID: '1');
      dynamic threshold = 0.0;
      bar.y = 10.0;
      bar.limit = 11.0;
      concreteBudgetMenuController.checkLimit(bar, threshold);
      expect(bar.onLimit, isFalse);
    });
    test('checkLimit value test 3', () {
      BudgetBarModel bar = BudgetBarModel(categoryID: '0', userID: '1');
      dynamic threshold = 0.0;
      bar.y = 11.0;
      bar.limit = 10.0;
      concreteBudgetMenuController.checkLimit(bar, threshold);
      expect(bar.overLimit, isTrue);
    });
    test('checkLimit value test 4', () {
      BudgetBarModel bar = BudgetBarModel(categoryID: '0', userID: '1');
      dynamic threshold = 0.0;
      bar.y = 10.0;
      bar.limit = 11.0;
      concreteBudgetMenuController.checkLimit(bar, threshold);
      expect(bar.overLimit, isFalse);
    });
    test('checkLimit behavior test 1', () {
      when(barMock.y).thenReturn(10);
      when(barMock.limit).thenReturn(11);
      expect(barMock.y, 10);
      expect(barMock.limit, 11);
      concreteBudgetMenuController.checkLimit(barMock, 1);
      verify(barMock.y).called(greaterThan(1));
      verify(barMock.limit).called(greaterThan(2));

      reset(barMock);
    });
  });

  group('testing getTransactions', () {
    test('getTransactions behaviour test', () {
      when(dbMock.readTransactions()).thenAnswer((realInvocation) {
        return streamTransactionMock;
      });
      concreteBudgetMenuController.getTransactions(dbMock, (transactions) {});

      verify(dbMock.readTransactions()).called(1);
      verify(streamTransactionMock.listen(
        any,
        onError: anyNamed('onError'),
        onDone: anyNamed('onDone'),
        cancelOnError: anyNamed('cancelOnError'),
      )).called(1);
      reset(dbMock);
      reset(streamTransactionMock);

      /* when(transactionModelMock.date).thenReturn(DateTime.now());

      when(dbMock.readTransactions()).thenAnswer((realInvocation) {
        List<MockTransactionModel> transacs = [transactionModelMock];
        StreamController<List<MockTransactionModel>> controller =
            StreamController();
        controller.add(transacs);
        return controller.stream;
      });
      concreteBudgetMenuController.getTransactions(dbMock, (transactions) {});
      verify(transactionModelMock.date).called(greaterThanOrEqualTo(2));*/
    });
  });
  group('testing _loadBudgetBar', () {
    test('_loadBudgetBars behaviour test', () {
      when(dbMock.readBudgetBars()).thenAnswer((realInvocation) {
        return budgetBarsStreamMock;
      });
      concreteBudgetMenuController.loadBudgetBars(
          dbMock, buildContextMock, () {});
      when(buildContextMock.mounted).thenReturn(true);
      verify(dbMock.readBudgetBars()).called(1);
      //verify(buildContextMock.mounted).called(1);
      verify(budgetBarsStreamMock.listen(
        any,
        onError: anyNamed('onError'),
        onDone: anyNamed('onDone'),
        cancelOnError: anyNamed('cancelOnError'),
      )).called(1);
    });
  });
}
