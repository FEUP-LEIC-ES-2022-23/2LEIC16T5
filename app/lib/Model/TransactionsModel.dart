import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TransactionModel {
  String? transactionID;
  String? userID;
  int expense;
  String name;
  num total;
  DateTime date;
  String? notes;
  GeoPoint? location;

  TransactionModel(
      {this.transactionID,
      required this.userID,
      required this.expense,
      required this.name,
      required this.total,
      required this.date,
      this.notes,
      this.location});

  factory TransactionModel.fromMap(Map<String, dynamic> json) =>
      TransactionModel(
        transactionID: json['transactionID'],
        userID: json['userID'],
        expense: json['expense'],
        name: json['name'],
        total: json['total'],
        date: DateTime.fromMillisecondsSinceEpoch(json['date']),
        notes: json['notes'],
        location: json['location']
      );

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'expense': expense,
      'name': name,
      'total': total,
      'date': date.millisecondsSinceEpoch,
      'notes': notes,
      'location': location
    };
  }
}
