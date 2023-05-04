import 'package:flutter/foundation.dart';

class BudgetBarModel {
  String? categoryName;
  String categoryID;
  String userID;
  double? limit;
  double? value;
  int? color;
  DateTime? triggerDate;
  int? x;
  double? y;
  bool? onLimit;
  bool? overLimit;
  BudgetBarModel(
      {this.categoryName,
      required this.categoryID,
      required this.userID,
      this.limit,
      this.value,
      this.color,
      this.triggerDate});

  factory BudgetBarModel.fromMap(Map<String, dynamic> json) => BudgetBarModel(
        categoryName: json['categoryName'],
        categoryID: json['categoryID'],
        userID: json['userID'],
        limit: json['limit'].toDouble(),
        value: json['value'].toDouble(),
        color: json['color'].toInt(),
        triggerDate: DateTime.fromMillisecondsSinceEpoch(json['triggerDate']),
      );

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'categoryID': categoryID,
      'userID': userID,
      'limit': limit,
      'value': value,
      'color': color,
      'triggerDate':triggerDate!.millisecondsSinceEpoch
    };
  }
}
