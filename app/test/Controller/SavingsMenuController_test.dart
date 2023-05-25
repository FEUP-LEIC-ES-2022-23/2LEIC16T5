import 'dart:async';

import 'package:es/Controller/BudgetMenuController.dart';
import 'package:es/Controller/SavingsMenuController.dart';
import 'package:es/Model/BudgetBarModel.dart';
import 'package:es/Model/TransactionsModel.dart';
import 'package:es/Database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'BudgetMenuController_test.mocks.dart';

class FakeSavingsMenuController extends Fake implements SavingsMenuController {

 
  
  @override
  Future updateSavingValue(BuildContext context, String? name_, double currVal,
      double valueToAdd, bool ifAdd) async {
    if ((!ifAdd && currVal - valueToAdd >= 0) || (ifAdd)) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Item updated successfully!");
      await remoteDBHelper.updateSavingValue(name_, currVal, valueToAdd, ifAdd);
    } else {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Value to update leads to a negative saving!");
    }
  }
}

@GenerateNiceMocks([MockSpec<RemoteDBHelper>(), MockSpec<BuildContext>()])
void main() {
  late MockRemoteDBHelper dbMock;
  late FakeSavingsMenuController concreteSavingsController;
  late MockBuildContext buildContextMock;
  setUpAll(() {
    dbMock = MockRemoteDBHelper();
    buildContextMock = MockBuildContext();
    
  });

  group('updateSavingValue test', () {
    test('behaviour test', () {
      
    });
  });
}
