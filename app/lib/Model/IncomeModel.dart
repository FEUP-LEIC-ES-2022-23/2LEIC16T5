import 'TransactionsModel.dart';

class IncomeModel extends TransactionModel {
  IncomeModel({
    String? transactionID,
    String? userID,
    String? categoryID,
    required String name,
    required num total,
    required DateTime date,
    String? notes,
    int? categoryColor
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

  factory IncomeModel.fromMap(Map<String, dynamic> json) {
    return IncomeModel(
      transactionID: json['transactionID'],
      userID: json['userID'],
      categoryID: json['categoryID'],
      name: json['name'],
      total: json['total'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      notes: json['notes'],
      categoryColor: json['categoryColor'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap();
  }
}