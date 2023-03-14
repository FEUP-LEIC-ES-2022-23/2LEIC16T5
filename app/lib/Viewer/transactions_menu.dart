import 'package:flutter/material.dart';
import '../model/transactions_repository.dart';
import 'package:intl/intl.dart';

class TransactionMenu extends StatelessWidget {
  const TransactionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = TransactionRepository.transactions;
    NumberFormat euro = NumberFormat.currency(locale: 'pt_PT', name: "€");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            leading: const Icon(Icons.wallet),
            title: Text(transactions[index].name),
            trailing: Text(euro.format(transactions[index].total)),
          );
        },
        padding: const EdgeInsets.all(20),
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: Colors.grey,
            thickness: 1.0,
            height: 1.0,
          );
        },
        itemCount: transactions.length,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: const Icon(Icons.filter_alt)),
    );
  }
} 
