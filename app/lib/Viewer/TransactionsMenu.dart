import 'package:flutter/material.dart';
import '../model/transactions_repository.dart';
import 'package:intl/intl.dart';
import 'ButtonActions.dart';

class TransactionsMenu extends StatefulWidget {
  const TransactionsMenu({Key? key}) : super(key: key);

  @override
  State<TransactionsMenu> createState() => _TransactionsMenuState();
}

  class _TransactionsMenuState extends State<TransactionsMenu> {
  @override
  Widget build(BuildContext context) {
    final transactions = TransactionRepository.transactions;
    NumberFormat euro = NumberFormat.currency(locale: 'pt_PT', name: "€");

    return Scaffold(
        appBar: AppBar(
          title: const Text('Transactions'),
          centerTitle: true,
        ),
        body:
        Stack(
          children: [
            ListView.separated(
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
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding( padding: EdgeInsets.all(10),
                  child: FloatingActionButton(
                      onPressed: () {}, child: const Icon(Icons.filter_alt)),
                )
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding( padding: EdgeInsets.all(10),
                  child: FloatingActionButton(
                      onPressed: () {ButtonActions().newTransaction(context);}, child: const Icon(Icons.add)),
                )
            )
          ],
        )
    );
  }
}
