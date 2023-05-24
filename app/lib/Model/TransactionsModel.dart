import 'ExpenseModel.dart';
import 'IncomeModel.dart';

abstract class TransactionModel {
  String? transactionID;
  String? userID;
  String? categoryID;
  String name;
  num total;
  DateTime date;
  String? notes;
  int? categoryColor;

  TransactionModel({
    this.transactionID,
    required this.userID,
    this.categoryID,
    required this.name,
    required this.total,
    required this.date,
    this.notes,
    this.categoryColor,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> json) {
    if (json.containsKey('location')) {
      return ExpenseModel.fromMap(json);
    } else {
      return IncomeModel.fromMap(json);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionID': transactionID,
      'userID': userID,
      'categoryID': categoryID,
      'name': name,
      'total': total,
      'date': date.millisecondsSinceEpoch,
      'notes': notes,
      'categoryColor': categoryColor,
    };
  }
}
