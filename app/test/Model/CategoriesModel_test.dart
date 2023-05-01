import 'package:es/Model/CategoryModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CategoryModel object = CategoryModel(
    categoryID: '123',
    userID: '456',
    name: 'test category',
    color: 1125415
  );
  Map<String, dynamic> json = {
    'categoryID' : '123',
    'userID' : '456',
    'name' : 'test category',
    'color' : 1125415
  };

  group('User model tests', () {
    test('Deserialize from JSON', () {
      CategoryModel temp = CategoryModel.fromMap(json);
      expect(temp.categoryID, json['categoryID']);
      expect(temp.userID, json['userID']);
      expect(temp.name, json['name']);
      expect(temp.color, json['color']);
    });

    test('Serialize to JSON', () {
      Map<String, dynamic> tmp = object.toMap();
      expect(tmp['categoryID'], json['categoryID']);
      expect(tmp['userID'], json['userID']);
      expect(tmp['name'], json['name']);
      expect(tmp['color'], json['color']);
    });
  });
}
