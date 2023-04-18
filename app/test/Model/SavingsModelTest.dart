import 'package:es/Model/SavingsModel.dart';
import 'package:flutter_test/flutter_test.dart';

SavingsModel object = SavingsModel(userID: '1', name: 'Joe', value: 100, total: 200);
Map<String, dynamic> json = {
  'userID' : '1',
  'name' : 'Joe',
  'value' : 100,
  'total' : 200,
};
void main() {
  test('Deserialize from JSON', () {
    SavingsModel temp = SavingsModel.fromMap(json);
    expect(temp.userID, json['userID']);
    expect(temp.name, json['name']);
    expect(temp.value, json['value']);
    expect(temp.total, json['total']);
  });

  test('Serialize to JSON', () {
    Map<String, dynamic> serializedMap = object.toMap();
    expect(serializedMap['userID'], json['userID']);
    expect(serializedMap['value'], json['value']);
    expect(serializedMap['name'], json['name']);
    expect(serializedMap['total'], json['total']);
  });
}