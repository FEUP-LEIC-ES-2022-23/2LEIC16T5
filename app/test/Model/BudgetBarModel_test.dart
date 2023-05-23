import 'package:es/Model/BudgetBarModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  BudgetBarModel testModel = BudgetBarModel(
      categoryName: 'testCat',
      categoryID: '1',
      userID: 'fu',
      limit: 50,
      value: 10,
      color: 0);
  Map<String, dynamic> testJson = {
    'categoryName': 'testCat',
    'categoryID': '1',
    'userID': 'fu',
    'limit': 50,
    'value': 10,
    'color': 0
  };
  group('BudgetBarModel tests', () {
    test('Serialize to JSON', () {
      Map<String, dynamic> test = testModel.toMap();
      expect(test['categoryName'], testModel.categoryName);
      expect(test['categoryID'], testModel.categoryID);
      expect(test['userID'], testModel.userID);
      expect(test['limit'], testModel.limit);
      expect(test['value'], testModel.value);
      expect(test['color'], testModel.color);
    });
    test('Deserialize from JSON', () {
      BudgetBarModel test = BudgetBarModel.fromMap(testJson);
      expect(test.categoryName, testJson['categoryName']);
      expect(test.categoryID, testJson['categoryID']);
      expect(test.userID, testJson['userID']);
      expect(test.limit, testJson['limit']);
      expect(test.color, testJson['color']);
    });
    test('Deserialize with from JSON with value parameter', () {
      BudgetBarModel test = BudgetBarModel.fromMapWithValue(testJson);
      expect(test.categoryName, testJson['categoryName']);
      expect(test.categoryID, testJson['categoryID']);
      expect(test.userID, testJson['userID']);
      expect(test.limit, testJson['limit']);
      expect(test.value, testJson['value']);
      expect(test.color, testJson['color']);
    });
  });
}
