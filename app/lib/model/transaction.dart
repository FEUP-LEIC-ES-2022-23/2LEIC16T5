class Transaction {
  int? id_transaction;
  String name;
  num total;
  //DateTime? date;
  String? notes;

  Transaction(
      {this.id_transaction,
      required this.name,
      required this.total,
      //this.date,
      this.notes});

  factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
        id_transaction: json['id_transaction'],
        name: json['name'],
        total: json['total'],
        //date: json['date'],
        notes: json['notes'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id_transaction': id_transaction,
      'name': name,
      'total': total,
      //'date': date,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return 'Transaction{id_transaction: $id_transaction, name: $name, total: $total}';
  }
}
