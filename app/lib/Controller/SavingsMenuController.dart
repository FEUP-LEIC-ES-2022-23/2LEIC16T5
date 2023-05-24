import 'package:es/Model/SavingsModel.dart';
import 'package:es/Database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:quickalert/quickalert.dart';

class SavingsMenuController {
  RemoteDBHelper remoteDBHelper =
      RemoteDBHelper(userInstance: FirebaseAuth.instance);
  FirebaseAuth userInstance = FirebaseAuth.instance;
  static double totalSliderVal = 0;

  static final textcontrollerNAME = TextEditingController();
  static final textcontrollerTOTAL = TextEditingController();
  static final textcontrollerDATE = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? newSavings(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                titlePadding: const EdgeInsets.all(0),
                title: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(32.0)),
                      color: Colors.lightBlue,
                    ),
                    height: 60,
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
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'NEW  SAVING',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                icon: Icon(Icons.calendar_today),
                                labelText: 'Target Date',
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
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    color: Colors.lightBlue,
                    child: const Text('Add',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        remoteDBHelper.addSaving(SavingsModel(
                            userID: FirebaseAuth.instance.currentUser!.uid,
                            name: textcontrollerNAME.text,
                            targetDate: textcontrollerDATE.text.isEmpty
                                ? null
                                : DateFormat('dd-MM-yyyy')
                                    .parse(textcontrollerDATE.text),
                            value: 0,
                            total: num.tryParse(textcontrollerTOTAL.text)));

                        textcontrollerNAME.clear();
                        textcontrollerTOTAL.clear();
                        textcontrollerDATE.clear();

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
      double multiplier, String name, bool ifAdd, double totalVal) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                insetPadding:
                    const EdgeInsets.symmetric(vertical: 200, horizontal: 10),
                titlePadding: const EdgeInsets.all(0),
                title: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.0),
                        topRight: (Radius.circular(32.0)),
                      ),
                      color: Colors.lightBlue,
                    ),
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
                        if (context.mounted) {
                          setState(
                            () {
                              textcontrollerValue.text =
                                  (value_ * totalVal).toStringAsFixed(2);
                              multiplier = value_;
                            },
                          );
                        }
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
                            if (context.mounted) {
                              setState(
                                () {
                                  if (value.isNotEmpty) {
                                    multiplier = (num.tryParse(value.trim())!
                                                    .toDouble() /
                                                totalVal) >
                                            1
                                        ? 1
                                        : (num.tryParse(value.trim())!
                                                .toDouble() /
                                            totalVal);
                                  }
                                },
                              );
                            }
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        color: Colors.lightBlue,
                        child: const Text('Update',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          double res =
                              num.tryParse(textcontrollerValue.text.trim())!
                                  .toDouble();
                          textcontrollerValue.clear();
                          Navigator.of(context).pop();
                          if (res <= totalVal) {
                            updateSavingValue(
                                context, name, currVal, res, ifAdd);
                          } else {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                text:
                                    "Value needs to be within total saving value! Nothing was done.");
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future updateSavingValue(BuildContext context, String? name_, double currVal,
      double valueToAdd, bool ifAdd) async {
    if ((!ifAdd && currVal - valueToAdd >= 0) || (ifAdd)) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Item updated successfully!");
      await remoteDBHelper.updateSavingValue(name_, currVal, valueToAdd, ifAdd);
    } else {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Value to update leads to a negative saving!");
    }
    /*if (ifAdd) {
      await remoteDBHelper.addTransaction(TransactionModel(
          userID: userInstance.currentUser!.uid,
          expense: 1,
          name: name_!,
          total: valueToAdd,
          date: DateTime.now()));
    } else {
      await remoteDBHelper.addTransaction(TransactionModel(
          userID: userInstance.currentUser!.uid,
          expense: 0,
          name: name_!,
          total: valueToAdd,
          date: DateTime.now()));
    }*/
  }
}
