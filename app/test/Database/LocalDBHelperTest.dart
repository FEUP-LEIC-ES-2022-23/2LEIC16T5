import 'package:es/database/LocalDBHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  LocalDBHelper localDb = LocalDBHelper.instance;

  test('Db is empty', (){
    Future<bool> future = LocalDBHelper.instance.isLocalDBEmpty();
    future.then((val){
      expect(val, true);
    });
  });

  test('Add Transaction', (){

  });

  test('Get Transactions', (){

  });

  test('Remove Transaction', (){

  });

  test('Delete Local DB', (){

  });
}