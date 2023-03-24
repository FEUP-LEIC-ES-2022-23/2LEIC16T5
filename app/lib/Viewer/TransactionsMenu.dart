import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ButtonActions.dart';
import 'package:es/model/transaction.dart' as t_model;
import 'package:es/database/LocalDBHelper.dart';

class TransactionsMenu extends StatefulWidget {
  const TransactionsMenu({Key? key}) : super(key: key);

  @override
  State<TransactionsMenu> createState() => _TransactionsMenuState();
}

class _TransactionsMenuState extends State<TransactionsMenu> {
  @override
  Widget build(BuildContext context) {
    NumberFormat euro = NumberFormat.currency(locale: 'pt_PT', name: "€");
    final nameController = TextEditingController();
    final totalController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Transactions'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Stack(
          children: [
            FutureBuilder<List<t_model.Transaction>>(
                future: LocalDBHelper.instance.getTransactions(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<t_model.Transaction>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text('Loading...'));
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.map((transac) {
                      return Center(
                        child: ListTile(
                          title: Text(transac.name),
                          trailing: Text(euro.format(transac.total)),
                        ),
                      );
                    }).toList(),
                  );
                }),

            /*ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  leading: const Icon(Icons.wallet),
                  title: Text(_textcontrollerAMOUNT.text),
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
            ),*/
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: FloatingActionButton(
                      onPressed: () {}, child: const Icon(Icons.filter_alt)),
                )),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: FloatingActionButton(
                      onPressed: () {
                        ButtonActions().newTransaction(context);
                      },
                      child: const Icon(Icons.add)),
                ))
          ],
        ));
  }
}
