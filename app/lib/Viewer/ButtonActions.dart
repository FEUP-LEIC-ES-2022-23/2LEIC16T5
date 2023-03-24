import 'package:es/Viewer/TransactionsMenu.dart';
import 'package:flutter/material.dart';
import 'package:es/database/LocalDBHelper.dart';
import 'package:es/model/transaction.dart' as t_model;

class ButtonActions {
  static final textcontrollerAMOUNT = TextEditingController();
  static final textcontrollerNAME = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  //Transactions
  void _enterTransaction() {
    t_model.Transaction transaction = t_model.Transaction(
        name: textcontrollerNAME.text,
        total: num.parse(textcontrollerAMOUNT.text));

    LocalDBHelper.instance.add_transaction(transaction);
    
  }

  void newTransaction(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        barrierColor: Color.fromRGBO(20, 25, 46, 0.5),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                titlePadding: EdgeInsets.all(0),
                title: Container(
                    color: Colors.lightBlue,
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
                        Text(
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Expense'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          Text('Income'),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?',
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'For what?',
                              ),
                              controller: textcontrollerNAME,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.lightBlue,
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  //Settings
  void resetData(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("WARNING"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("All your data will be deleted"),
                SizedBox(height: 5),
                Text("This action is irreversible"),
                SizedBox(height: 5),
                Text("Do you wish to continue?")
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [Text("YES"), Text("NO")]))
            ],
          );
        });
  }
}
