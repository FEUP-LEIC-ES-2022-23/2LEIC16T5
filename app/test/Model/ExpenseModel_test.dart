import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Model/ExpenseModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    ExpenseModel object = ExpenseModel(
      transactionID: '0',
      userID: '1',
      categoryID: '2',
      name: 'Expense',
      total: 200,
      date: DateTime(2020, 10, 1),
      notes: 'some notes',
      location: const GeoPoint(0, 0),
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
    'location': const GeoPoint(0, 0),
    'categoryColor': 111111,
  };

  group('Expense model tests', () {
    test('Deserialize from JSON', () {
      ExpenseModel temp = ExpenseModel.fromMap(json);
      expect(temp.transactionID, json['transactionID']);
      expect(temp.userID, json['userID']);
      expect(temp.categoryID, json['categoryID']);
      expect(temp.name, json['name']);
      expect(temp.total, json['total']);
      expect(temp.date.millisecondsSinceEpoch, json['date']);
      expect(temp.notes, json['notes']);
      expect(temp.location, json['location']);
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
      expect(serializedMap['location'], json['location']);
      expect(serializedMap['categoryColor'], json['categoryColor']);
    });
  });
}
