import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TransactionModel {
  String? transactionID;
  String? userID;
  String? categoryID;
  int expense;
  String name;
  num total;
  DateTime date;
  String? notes;
  GeoPoint? location;
  int? categoryColor;

  TransactionModel(
      {this.transactionID,
      required this.userID,
      required this.categoryID,
      required this.expense,
      required this.name,
      required this.total,
      required this.date,
      this.notes,
      this.location,
      this.categoryColor});

  factory TransactionModel.fromMap(Map<String, dynamic> json) =>
      TransactionModel(
        transactionID: json['transactionID'],
        userID: json['userID'],
        categoryID: json['categoryID'],
        expense: json['expense'],
        name: json['name'],
        total: json['total'],
        date: DateTime.fromMillisecondsSinceEpoch(json['date']),
        notes: json['notes'],
        location: json['location'],
        categoryColor: json['categoryColor'],
      );

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'categoryID': categoryID,
      'expense': expense,
      'name': name,
      'total': total,
      'date': date.millisecondsSinceEpoch,
      'notes': notes,
      'location': location,
      'categoryColor':categoryColor,
    };
  }
}
