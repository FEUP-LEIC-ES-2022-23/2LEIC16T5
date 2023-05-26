import 'dart:ui';
import 'package:es/Model/ExpenseModel.dart';
import 'package:es/Database/RemoteDBHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import '../Controller/NewTransactionController.dart';
import 'package:es/Model/TransactionsModel.dart' as t_model;
import 'package:es/Viewer/MapMenu.dart';

class TransactionsMenu extends StatefulWidget {
  const TransactionsMenu(
      {Key? key, required this.title, required this.currency})
      : super(key: key);
  final String title;
  final String currency;

  @override
  State<TransactionsMenu> createState() => _TransactionsMenuState();
}

class _TransactionsMenuState extends State<TransactionsMenu> {
  RemoteDBHelper remoteDBHelper = RemoteDBHelper(
      userInstance: FirebaseAuth.instance,
      firebaseInstance: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    NumberFormat coin =
        NumberFormat.currency(locale: 'pt_PT', name: widget.currency);
    return Scaffold(
        key: const Key("Transactions"),
        backgroundColor: const Color.fromRGBO(20, 25, 46, 1.0),
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(widget.title,
              style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic)),
          centerTitle: true,
          leading: IconButton(
            key: const Key("Home"),
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
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapMenu(
                                title: 'Transactions Map',
                              )));
                },
                icon: const Icon(
                  Icons.map_sharp,
                  color: Colors.white,
                ))
          ],
        ),
        body: Stack(
          children: [
            StreamBuilder<List<t_model.TransactionModel>>(
                stream: remoteDBHelper.readTransactions(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<t_model.TransactionModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: Text('Loading...',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)));
                  }
                  return snapshot.data!.isEmpty
                      ? const Center(
                          child: Text("Nothing to show",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        )
                      : ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.map((transac) {
                            return Center(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.white24))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        left: 0, right: 10, bottom: 0),
                                    key: Key(transac.name),
                                    textColor: Colors.black,
                                    tileColor: Colors.white,
                                    iconColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    leading: Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12)),
                                        color: Color(transac.categoryColor!),
                                      ),
                                      width: 80,
                                      child: (transac is ExpenseModel)
                                          ? const Icon(Icons.money_off)
                                          : const Icon(Icons.wallet),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          transac.name,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        Text(DateFormat('dd-MM-yyyy')
                                            .format(transac.date)),
                                      ],
                                    ),
                                    trailing: Text(
                                      (transac is ExpenseModel ? '-' : '+') +
                                          coin.format(transac.total),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        NewTransactionController()
                                            .showTransaction(context, transac, widget.currency);
                                      });
                                    },
                                    onLongPress: () {
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.warning,
                                        title: 'WARNING',
                                        text: 'Are you sure you want to permanently delete this transaction?',
                                        confirmBtnText: 'Yes',
                                        cancelBtnText: 'No',
                                        showCancelBtn: true,
                                        confirmBtnColor: Colors.lightBlue,
                                        onConfirmBtnTap: () async {
                                            await remoteDBHelper
                                                .updateBudgetBarValOnChangedTransaction(
                                                transac.transactionID!, false);
                                            remoteDBHelper
                                                .removeTransaction(transac);
                                            if (Navigator.canPop(context)) {
                                              Navigator.pop(context);
                                            }
                                            QuickAlert.show(
                                                context: context,
                                                title: 'Miau miau!',
                                                text: "Transaction successfully deleted!",
                                                type: QuickAlertType.success,
                                                confirmBtnColor: Colors.lightBlue);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                }),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                      key: const Key("Plus"),
                      onPressed: () {
                        NewTransactionController().newTransaction(context);
                      },
                      backgroundColor: Colors.lightBlue,
                      child: const Icon(Icons.add)),
                ))
          ],
        ));
  }
}
