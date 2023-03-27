import 'package:es/Viewer/TransactionsMenu.dart';
import 'package:flutter/material.dart';
import 'package:es/database/LocalDBHelper.dart';
import 'package:es/model/TransactionsModel.dart' as t_model;
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class ButtonActions {
  static final textcontrollerNAME = TextEditingController();
  static final textcontrollerTOTAL = TextEditingController();
  static final textcontrollerDATE = TextEditingController();
  static final textcontrollerNOTES = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  //Transactions
  void _enterTransaction() {
    t_model.Transaction transaction = t_model.Transaction(
        name: textcontrollerNAME.text.isEmpty? "Transaction" : textcontrollerNAME.text,
        expense: _isIncome? 0 : 1,
        total: num.parse(textcontrollerTOTAL.text),
        //date:  DateFormat('dd-MM-yyyy').parse(textcontrollerDATE.text),
        notes: textcontrollerNOTES.text
    );

    LocalDBHelper.instance.addTransaction(transaction);

    textcontrollerNAME.clear();
    textcontrollerTOTAL.clear();
    textcontrollerDATE.clear();
    textcontrollerNOTES.clear();
  }

  void newTransaction(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                titlePadding: const EdgeInsets.all(0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Expense'),
                          Switch(
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
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.attach_money_rounded),
                                  labelText: 'Total',
                                ),
                                keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true),
                                validator: (text) {
                                  if (text == null || text.isEmpty || num.tryParse(text) == null) {
                                    return 'Enter an amount';
                                  }
                                  else if (num.tryParse(text)!.isNegative){
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
                                          primary: Colors.lightBlue, // header background color
                                          onPrimary: Colors.white, // header text color
                                          onSurface: Colors.black, // body text color
                                        ),),
                                        child: child!,);},
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime (2000),
                                    lastDate: DateTime (2101));

                                if (pickeddate != null){
                                  setState(() {
                                    textcontrollerDATE.text = DateFormat('dd-MM-yyyy').format(pickeddate);
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
                  MaterialButton(
                    color: Colors.lightBlue,
                    child: const Text('Add', style: TextStyle(color: Colors.white)),
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

  void showTransaction(BuildContext context){
    /*TO BE DONE*/
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
                  child: const Text("NO", style: TextStyle(color: Colors.lightBlue))),
              TextButton(
                  onPressed: () async {
                      if(await LocalDBHelper.instance.isLocalDBEmpty()){
                        Navigator.of(context).pop();
                        noData(context);
                      }
                      else{
                        LocalDBHelper.instance.deleteLocalDB();
                        Navigator.of(context).pop();
                        deletdData(context);
                      }
                  },
                  child: const Text("YES", style: TextStyle(color: Colors.lightBlue),))
            ],
          );
        });
  }

  void deletdData(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Your data has been successfully deleted", textAlign: TextAlign.center)
          );
        });
  }

  void noData(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
              title: Text("No data has been inserted into the app", textAlign: TextAlign.center)
          );
        });
  }

}
