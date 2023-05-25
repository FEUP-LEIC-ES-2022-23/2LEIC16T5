import 'package:cloud_firestore/cloud_firestore.dart';
import 'TransactionsModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExpenseModel extends TransactionModel {
  GeoPoint? location;

  ExpenseModel({
    String? transactionID,
    String? userID,
    String? categoryID,
    required String name,
    required num total,
    required DateTime date,
    String? notes,
    this.location,
    int? categoryColor,
  }) : super(
          transactionID: transactionID,
          userID: userID,
          categoryID: categoryID,
          name: name,
          total: total,
          date: date,
          notes: notes,
          categoryColor: categoryColor,
        );

  factory ExpenseModel.fromMap(Map<String, dynamic> json) {
    return ExpenseModel(
      transactionID: json['transactionID'],
      userID: json['userID'],
      categoryID: json['categoryID'],
      name: json['name'],
      total: json['total'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      notes: json['notes'],
      location: json['location'],
      categoryColor: json['categoryColor'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['location'] = location;
    return map;
  }
}
