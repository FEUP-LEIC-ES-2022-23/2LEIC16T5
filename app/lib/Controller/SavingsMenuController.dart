import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Model/SavingsModel.dart';
import 'package:es/Model/TransactionsModel.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:quickalert/quickalert.dart';

class SavingsMenuController {
  RemoteDBHelper remoteDBHelper =
      RemoteDBHelper(userInstance: FirebaseAuth.instance);
  FirebaseAuth userInstance = FirebaseAuth.instance;
  static double totalSliderVal = 1000;

  static final textcontrollerNAME = TextEditingController();
  static final textcontrollerTOTAL = TextEditingController();
  static final textcontrollerNOTES = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? newSavings(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        barrierColor: Colors.black,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                titlePadding: const EdgeInsets.all(0),
                title: Container(
                    color: Color.fromRGBO(226, 177, 60, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          'NEW  SAVINGS',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                icon: Icon(Icons.text_snippet),
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
                        height: 30,
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
                  MaterialButton(
                    color: Color.fromRGBO(226, 177, 60, 10),
                    child: const Text('Add',
                        style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        remoteDBHelper.addSaving(SavingsModel(
                            userID: FirebaseAuth.instance.currentUser!.uid,
                            name: textcontrollerNAME.text,
                            notes: textcontrollerNOTES.text,
                            value: 0,
                            total: num.tryParse(textcontrollerTOTAL.text)));
                        setState(
                          () {},
                        );
                        Navigator.of(context).pop();
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: "Item added/reset successfully!");
                      }
                    },
                  )
                ],
              );
            },
          );
        });
    return textcontrollerNAME.text;
  }

  static TextEditingController textcontrollerValue = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();

  void changeSavingValue(BuildContext context, double currVal,
      double multiplier, String name, bool ifAdd) {
    showDialog(
      barrierDismissible: true,
      context: context,
      barrierColor: Colors.black,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                insetPadding:
                    EdgeInsets.symmetric(vertical: 200, horizontal: 10),
                titlePadding: const EdgeInsets.all(0),
                title: Container(
                    color: Color.fromRGBO(226, 177, 60, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          'Value',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                content: Row(
                  children: [
                    Slider(
                      value: multiplier,
                      onChanged: (value_) {
                        setState(
                          () {
                            textcontrollerValue.text =
                                (value_ * totalSliderVal).toStringAsFixed(2);
                            multiplier = value_;
                          },
                        );
                      },
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey1,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: 'Value',
                          ),
                          onChanged: (value) {
                            // if (_formKey.currentState!.validate()) {
                            setState(
                              () {
                                if (value.isNotEmpty) {
                                  multiplier =
                                      (num.tryParse(value.trim())!.toDouble() /
                                                  totalSliderVal) >
                                              1
                                          ? 1
                                          : (num.tryParse(value.trim())!
                                                  .toDouble() /
                                              totalSliderVal);
                                }
                              },
                            );
                          },
                          //},
                          keyboardType: const TextInputType.numberWithOptions(
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
                          controller: textcontrollerValue,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Color.fromRGBO(226, 177, 60, 10),
                    child: const Text('Update',
                        style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      double res =
                          num.tryParse(textcontrollerValue.text.trim())!
                              .toDouble();
                      Navigator.of(context).pop();

                      updateSavingValue(context, name, currVal, res, ifAdd);
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  dynamic checkSavingOverflow(
      BuildContext context, bool hasOverflowed, double value) {
    if (hasOverflowed) {
      return QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          text: "Saving has overflowed by: " + value.toString());
    } else {
      return Text("");
    }
  }

  Future updateSavingValue(BuildContext context, String? name_, double currVal,
      double valueToAdd, bool ifAdd) async {
    if ((!ifAdd && currVal - valueToAdd >= 0) || (ifAdd)) {
      remoteDBHelper.updateSavingValue(name_, currVal, valueToAdd, ifAdd);
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Item updated successfully!");
    } else {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Value to update leads to a negative saving!");
    }
    if (ifAdd) {
      remoteDBHelper.addTransaction(TransactionModel(
          userID: userInstance.currentUser!.uid,
          expense: 1,
          name: name_!,
          total: valueToAdd,
          date: DateTime.now()));
    } else {
      remoteDBHelper.addTransaction(TransactionModel(
          userID: userInstance.currentUser!.uid,
          expense: 0,
          name: name_!,
          total: valueToAdd,
          date: DateTime.now()));
    }
  }
}
