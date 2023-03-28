class Transaction {
  int? idTransaction;
  int expense;
  String name;
  num total;
  DateTime date;
  String? notes;

  Transaction({
    this.idTransaction,
    required this.expense,
    required this.name,
    required this.total,
    required this.date,
    this.notes});

  factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
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
