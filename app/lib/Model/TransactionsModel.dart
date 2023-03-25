class Transaction {
  int? id_transaction;
  int expense;
  String name;
  num total;
  //DateTime? date;
  String? notes;

  Transaction({
    this.id_transaction,
    required this.expense,
    required this.name,
    required this.total,
    //this.date,
    this.notes});

  factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
        id_transaction: json['id_transaction'],
        expense: json['expense'],
        name: json['name'],
        total: json['total'],
        //date: json['date'],
        notes: json['notes'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id_transaction': id_transaction,
      'expense': expense,
      'name': name,
      'total': total,
      //'date': date,
      'notes': notes,
    };
  }
}
