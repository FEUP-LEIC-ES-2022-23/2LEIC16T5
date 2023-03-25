import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Controller/PopUpController.dart';
import 'package:es/model/TransactionsModel.dart' as t_model;
import 'package:es/database/LocalDBHelper.dart';

class TransactionsMenu extends StatefulWidget {
  const TransactionsMenu({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TransactionsMenu> createState() => _TransactionsMenuState();
}

class _TransactionsMenuState extends State<TransactionsMenu> {
  @override
  Widget build(BuildContext context) {
    NumberFormat euro = NumberFormat.currency(locale: 'pt_PT', name: "€");

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title,
              style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic)),
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
                    return const Center(child: Text('Loading...', style: TextStyle(fontSize: 20)));
                  }
                  return snapshot.data!.isEmpty
                    ? const Center( child: Text("Nothing to show", style: TextStyle(fontSize: 20),),)
                      : ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.map((transac) {
                      return Center(
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.black26))),
                          child: ListTile(
                            horizontalTitleGap: 0.5,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                            leading: (transac.expense == 1)? const Icon(Icons.money_off) : const Icon(Icons.wallet),
                            title: Text(transac.name, style: const TextStyle(fontSize: 20),),
                            trailing: (transac.expense == 1)? Text("- ${euro.format(transac.total)}", style: const TextStyle(fontSize: 20)) : Text("+ ${euro.format(transac.total)}", style: const TextStyle(fontSize: 20)),
                            onLongPress: () {
                              setState(() {
                                LocalDBHelper.instance.removeTransaction(transac.id_transaction!);
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                      heroTag: "Reload",
                      onPressed: () {setState(() {});},
                      child: const Icon(Icons.refresh)),
                )),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                      heroTag: "Add",
                      onPressed: () {
                        ButtonActions().newTransaction(context);
                      },
                      child: const Icon(Icons.add)),
                ))
          ],
        ));
  }
}
