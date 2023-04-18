import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Controller/MapMenuController.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:es/Model/TransactionsModel.dart' as t_model;
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

class NewTransactionController {
  static final textcontrollerNAME = TextEditingController();
  static final textcontrollerTOTAL = TextEditingController();
  static final textcontrollerDATE = TextEditingController();
  static final textcontrollerNOTES = TextEditingController();
  GeoPoint? position;
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  RemoteDBHelper remoteDBHelper =
  RemoteDBHelper(userInstance: FirebaseAuth.instance);
  //Transactions
  void _enterTransaction() {
    t_model.TransactionModel transaction = t_model.TransactionModel(
        userID: FirebaseAuth.instance.currentUser!.uid,
        categoryID: null,
        name: textcontrollerNAME.text.isEmpty
            ? "Transaction"
            : textcontrollerNAME.text,
        expense: _isIncome ? 0 : 1,
        total: num.parse(textcontrollerTOTAL.text),
        date: textcontrollerDATE.text.isEmpty
            ? DateTime.now()
            : DateFormat('dd-MM-yyyy').parse(textcontrollerDATE.text),
        location: _isIncome? null : position,
        notes: textcontrollerNOTES.text);

    remoteDBHelper.addTransaction(transaction);

    textcontrollerNAME.clear();
    textcontrollerTOTAL.clear();
    textcontrollerDATE.clear();
    textcontrollerNOTES.clear();
    position = null;
  }

  void newTransaction(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            key: const Key("New Transaction"),
            builder: (BuildContext context, setState) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                titlePadding: const EdgeInsets.all(0),
                title: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
                      color: Colors.lightBlue,
                    ),
                    height: 75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'NEW  TRANSACTION',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        key: const Key("Switch"),
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Expense'),
                          Switch(
                            key: _isIncome? Key("Income") :  Key("Expense"),
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          const Text('Income'),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                icon: Icon(Icons.shopping_bag_rounded),
                                labelText: 'Name',
                              ),
                              controller: textcontrollerNAME,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                key: const Key("Total"),
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.attach_money_rounded),
                                  labelText: 'Total',
                                ),
                                keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                                validator: (text) {
                                  if (text == null ||
                                      text.isEmpty ||
                                      num.tryParse(text) == null) {
                                    return 'Enter an amount';
                                  } else if (num.tryParse(text)!.isNegative) {
                                    return 'Enter a positive amount';
                                  }
                                  return null;
                                },
                                controller: textcontrollerTOTAL,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                icon: Icon(Icons.calendar_today),
                                labelText: 'Date',
                              ),
                              controller: textcontrollerDATE,
                              onTap: () async {
                                DateTime? pickeddate = await showDatePicker(
                                    context: context,
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Colors
                                                .lightBlue, // header background color
                                            onPrimary: Colors
                                                .white, // header text color
                                            onSurface:
                                            Colors.black, // body text color
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101));

                                if (pickeddate != null) {
                                  setState(() {
                                    textcontrollerDATE.text =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickeddate);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Notes',
                              ),
                              controller: textcontrollerNOTES,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      !_isIncome?
                      FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.lightBlue,
                          heroTag: "Map",
                          onPressed: () {
                            MapMenuController().getCurrentLocation(context).then((value) {
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  confirmBtnColor: Colors.lightBlue,
                                  text: "Do you wish to set your current location as this transaction's location?",
                                  confirmBtnText: "Yes",
                                  cancelBtnText: "No",
                                  onConfirmBtnTap: () {
                                    setState(() {
                                      position = GeoPoint(double.parse('${value.latitude}'), double.parse('${value.longitude}'));
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  onCancelBtnTap: () {
                                    setState(() {
                                      position = null;
                                    });
                                    Navigator.of(context).pop();
                                  });
                            });
                          },
                          child: (position == null)? const Icon(Icons.pin_drop_rounded) :  const Icon(Icons.done_all_rounded))
                          : const SizedBox(width: 48.0,),
                      MaterialButton(
                        key: const Key("Add"),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        color: Colors.lightBlue,
                        child: const Text('Add',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _enterTransaction();
                            Navigator.of(context).pop();
                          }
                        },
                      )
                    ],
                  )
                ],
              );
            },
          );
        });
  }

  void showTransaction(BuildContext context) {
    /*TO BE DONE*/
  }
}
