import 'transaction.dart';

class TransactionRepository {
  static List<Transaction> transactions = [
    Transaction(
        name: 'Spotify',
        total: 5,
        date: DateTime(2022, 12, 31, 23, 59, 59),
        notes: 'cancel next month',
        repeat: DateTime(2022, 12, 31, 23, 59, 59)),
    Transaction(
        name: 'Groceries',
        total: 34.33,
        date: DateTime(2022, 7, 20, 23, 11, 11),
        notes: 'notes',
        repeat: DateTime(2022, 12, 31, 23, 59, 59)),
    Transaction(
        name: 'Lunch',
        total: 10,
        date: DateTime(2022, 11, 15, 20, 30, 45),
        notes: 'Burguer',
        repeat: DateTime(2022, 12, 31, 23, 59, 59)),
    Transaction(
        name: 'Cinema',
        total: 6.35,
        date: DateTime(2022, 3, 4, 12, 0, 0),
        notes: 'Movie: 65',
        repeat: DateTime(2022, 12, 31, 23, 59, 59)),
    Transaction(
        name: 'Andante',
        total: 30,
        date: DateTime(2022, 9, 1, 6, 15, 30),
        notes: 'notes',
        repeat: DateTime(2022, 12, 31, 23, 59, 59)),
  ];
}
