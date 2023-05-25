import 'package:es/Database/RemoteDBHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:es/Model/BudgetBarModel.dart';
import 'package:flutter/material.dart';
import '../Model/TransactionsModel.dart';

class BudgetMenuController {
  BudgetMenuController({this.callback});

  RemoteDBHelper remoteDBHelper =
      RemoteDBHelper(userInstance: FirebaseAuth.instance,firebaseInstance: FirebaseFirestore.instance);
  FirebaseAuth userInstance = FirebaseAuth.instance;
  static final textcontrollerTotalBudgetLimit = TextEditingController();
  static final textcontrollerCategoryBudgetLimit = TextEditingController();
  final Function? callback;
  final _formKey = GlobalKey<FormState>();
  String selectedVal = '';
  List<String> listitems = [];
  bool initState_ = true;
  double totalBudgetValue = -1;

  void editBudgetMenu(BuildContext context) {
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
                          'Edit budget',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (context.mounted)
                            buildDropdownList(
                                remoteDBHelper, context, setState),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 224, 224, 224),
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Limit',
                                        border: InputBorder.none),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    validator: (text) {
                                      if (text == null ||
                                          text.isEmpty ||
                                          num.tryParse(text) == null) {
                                        return 'Operation on this field ignored';
                                      } else if (num.tryParse(text)!
                                          .isNegative) {
                                        return 'Enter a positive amount';
                                      }
                                      return null;
                                    },
                                    controller:
                                        textcontrollerCategoryBudgetLimit,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await remoteDBHelper.updateBudgetBarLimit(
                            selectedVal,
                            num.parse(textcontrollerCategoryBudgetLimit.text)
                                .toDouble());
                      }

                      textcontrollerCategoryBudgetLimit.clear();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  void loadBudgetBars(RemoteDBHelper db,BuildContext context, Function? callback) async {
    Stream<List<BudgetBarModel>> stream = db.readBudgetBars();
    stream.listen((budgetBars) {
      if (context.mounted) {
        callback!(() {
          listitems = [];
          for (var budgetBar in budgetBars) {
            listitems.add(budgetBar.categoryName!);
          }
          selectedVal = listitems.first;
        });
      }
    });
  }

  Widget buildDropdownList(
      RemoteDBHelper db, BuildContext context, Function callback) {
    if (initState_) {
      loadBudgetBars(db,context, callback);
      callback(() {
        initState_ = false;
      });
    }

    return DropdownButtonHideUnderline(
        child: DropdownButton(
            dropdownColor: Colors.white,
            iconEnabledColor: Colors.black,
            value: selectedVal,
            items: listitems
                .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    )))
                .toList(),
            onChanged: (val) {
              if (context.mounted) {
                callback(() {
                  selectedVal = val as String;
                });
              }
            }));
  }

  void getTransactions(RemoteDBHelper db, Function? callback) {
    Stream<List<TransactionModel>> transacs = db.readTransactions();
    transacs.listen((transacs) {
      List<TransactionModel> transactions = [];
      for (TransactionModel transac in transacs) {
        if (transac.date.month == DateTime.now().month &&
            transac.date.year == DateTime.now().year) {
          transactions.add(transac);
        }
      }
      callback!(transactions);
    });
  }

  void checkLimit(BudgetBarModel model, double threshold) {
    if (threshold <= 1) {
      if (model.y! >=
          model.limit!.toDouble() - model.limit!.toDouble() * threshold) {
        model.onLimit = true;
      } else {
        model.onLimit = false;
      }
      if (model.y! >= model.limit!.toDouble()) {
        model.overLimit = true;
      } else {
        model.overLimit = false;
      }
    } else {
      throw 'Threshold bigger than 1';
    }
  }
}
