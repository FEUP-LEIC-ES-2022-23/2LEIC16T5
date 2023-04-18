import 'package:cloud_firestore/cloud_firestore.dart';

class SavingsModel {
  String? userID;
  String? name;
  num? value;
  num? total;
  String? notes;

  SavingsModel(
      {required this.userID,
      required this.name,
      required this.value,
      required this.total,
      this.notes});

  factory SavingsModel.fromMap(Map<String, dynamic>? json) => SavingsModel(
        userID: json!['userID'],
        name: json['name'],
        value: json['value'],
        total: json['total'],
        notes: json['notes'],
      );
  factory SavingsModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return SavingsModel(
        userID: data!["userID"],
        name: data["name"],
        value: data["value"],
        total: data["total"]);
  }
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'value': value,
      'total': total,
      'notes': notes,
    };
  }
}
