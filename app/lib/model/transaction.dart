class Transaction {
  String name;
  double total;
  DateTime date;
  String notes;
  DateTime repeat;

  Transaction(
      {required this.name,
      required this.total,
      required this.date,
      required this.notes,
      required this.repeat});
}
