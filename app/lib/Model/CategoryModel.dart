import 'package:flutter/material.dart';

class CategoryModel {
  String? categoryID;
  String? userID;
  String name;
  int color;

  CategoryModel({
    this.categoryID,
    required this.userID,
    required this.name,
    required this.color,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
        categoryID: json['categoryID'],
        userID: json['userID'],
        name: json['name'],
        color: json['color'],
      );
  }

  Map<String, dynamic> toMap() {
    print(color.toString());
    return {
      'categoryID' : categoryID,
      'userID': userID,
      'name': name,
      'color': color,
    };
  }
}
