import 'package:es/Model/IncomeModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    IncomeModel object = IncomeModel(
      transactionID: '0',
      userID: '1',
      categoryID: '2',
      name: 'Expense',
      total: 200,
      date: DateTime(2020, 10, 1),
      notes: 'some notes',
      categoryColor: 111111,
      );
  Map<String, dynamic> json = {
    'transactionID' : '0',
    'userID': '1',
    'categoryID': '2',
    'name': 'Expense',
    'total': 200,
    'date': DateTime(2020, 10, 1).millisecondsSinceEpoch,
    'notes': 'some notes',
    'categoryColor': 111111,
  };

  group('Income model tests', () {
    test('Deserialize from JSON', () {
      IncomeModel temp = IncomeModel.fromMap(json);
      expect(temp.transactionID, json['transactionID']);
      expect(temp.userID, json['userID']);
      expect(temp.categoryID, json['categoryID']);
      expect(temp.name, json['name']);
      expect(temp.total, json['total']);
      expect(temp.date.millisecondsSinceEpoch, json['date']);
      expect(temp.notes, json['notes']);
      expect(temp.categoryColor, json['categoryColor']);
    });

    test('Serialize to JSON', () {
      Map<String, dynamic> serializedMap = object.toMap();
      expect(serializedMap['transactionID'], json['transactionID']);
      expect(serializedMap['userID'], json['userID']);
      expect(serializedMap['categoryID'], json['categoryID']);
      expect(serializedMap['name'], json['name']);
      expect(serializedMap['total'], json['total']);
      expect(serializedMap['date'], json['date']);
      expect(serializedMap['notes'], json['notes']);
      expect(serializedMap['categoryColor'], json['categoryColor']);
    });
  });
}
