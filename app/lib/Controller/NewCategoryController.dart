import 'package:es/database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:es/Model/CategoryModel.dart' as c_model;
import 'package:intl/intl.dart';

class NewCategoryController {
  static final textcontrollerNAME = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color color = Colors.red;

  RemoteDBHelper remoteDBHelper =
      RemoteDBHelper(userInstance: FirebaseAuth.instance);

  Future<void> _enterCategory(int c) async {
    c_model.CategoryModel category = c_model.CategoryModel(
      userID: FirebaseAuth.instance.currentUser!.uid,
      name: textcontrollerNAME.text.isEmpty
          ? "Category"
          : textcontrollerNAME.text,
      color: c,
    );
    await remoteDBHelper.addCategory(category);
    await remoteDBHelper.addEmptyBudgetBar(category);
    textcontrollerNAME.clear();
  }

  void newCategory(BuildContext context) {
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
                          'NEW  CATEGORY',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              key: const Key("Name"),
                              decoration: const InputDecoration(
                                icon: Icon(Icons.category),
                                labelText: 'Name',
                              ),
                              controller: textcontrollerNAME,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter category name';
                                }
                                return null;
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
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                            width: 50,
                            height: 50,
                          ),
                          ElevatedButton(
                              child: Text(
                                'Pick Color',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                pickColor(context, setState);
                              })
                        ],
                      )
                    ]),
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.lightBlue,
                    child: const Text('Add',
                        key: Key("Add"),
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterCategory(color.value);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  Widget buildColorPicker(StateSetter setState) => ColorPicker(
      pickerColor: this.color,
      onColorChanged: (color) {
        setState!(() => this.color = color);
      });

  void pickColor(BuildContext context, StateSetter setState) => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Pick your color'),
            content: Column(
              children: [
                buildColorPicker(setState),
                TextButton(
                  child: Text(
                    'SELECT',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );

  void showTransaction(BuildContext context) {
    /*TO BE DONE*/
  }
}
