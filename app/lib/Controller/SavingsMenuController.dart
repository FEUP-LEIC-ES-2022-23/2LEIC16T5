import 'package:es/Model/SavingsModel.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:quickalert/quickalert.dart';

class SavingsMenuController {
  RemoteDBHelper remoteDBHelper =
      RemoteDBHelper(userInstance: FirebaseAuth.instance);

  static final textcontrollerNAME = TextEditingController();
  static final textcontrollerTOTAL = TextEditingController();
  static final textcontrollerNOTES = TextEditingController();
  final _formKey = GlobalKey<FormState>();

 void newSavings(BuildContext context) {
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
                          'NEW  SAVINGS',
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
                    color: Colors.lightBlue,
                    child: const Text('Add',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        remoteDBHelper.addSavings(SavingsModel(
                            userID: FirebaseAuth.instance.currentUser!.uid,
                            name: textcontrollerNAME.text,
                            notes: textcontrollerNOTES.text,
                            value: 0,
                            total: num.tryParse(textcontrollerTOTAL.text)));

                        Navigator.of(context).pop();

                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: "Item added/updated successfully!");
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

   
}
