class TransactionModel {
  int? idTransaction;
  int expense;
  String name;
  num total;
  DateTime date;
  String? notes;

  TransactionModel(
      {this.idTransaction,
      required this.expense,
      required this.name,
      required this.total,
      required this.date,
      this.notes});

  factory TransactionModel.fromMap(Map<String, dynamic> json) =>
      TransactionModel(
        idTransaction: json['idTransaction'],
        expense: json['expense'],
        name: json['name'],
        total: json['total'],
        date: DateTime.fromMillisecondsSinceEpoch(json['date']),
        notes: json['notes'],
      );

  Map<String, dynamic> toMap() {
    return {
      'idTransaction': idTransaction,
      'expense': expense,
      'name': name,
      'total': total,
      'date': date.millisecondsSinceEpoch,
      'notes': notes,
    };
  }
}
