import 'package:es/Database/RemoteDBHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:es/Model/CategoryModel.dart' as c_model;

class NewCategoryController {
  static final textcontrollerNAME = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color color = Colors.red;

  RemoteDBHelper remoteDBHelper = RemoteDBHelper(
      userInstance: FirebaseAuth.instance,
      firebaseInstance: FirebaseFirestore.instance);

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
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                titlePadding: const EdgeInsets.all(0),
                title: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32.0)),
                      color: Colors.lightBlue,
                    ),
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
                                } else if (value == 'Default') {
                                  return 'This name is invalid';
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
                              key: const Key('Pick Color'),
                              child: const Text(
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
                    key: const Key("Add"),
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    color: Colors.lightBlue,
                    child: const Text('Add',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterCategory(color.value);
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

  Widget buildColorPicker(StateSetter setState) => ColorPicker(
      key: const Key("Color Picker"),
      pickerColor: color,
      onColorChanged: (color) {
        setState(() => this.color = color);
      });

  void pickColor(BuildContext context, StateSetter setState) => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pick your color'),
            content: Column(
              children: [
                buildColorPicker(setState),
                TextButton(
                  key: const Key("Select"),
                  child: const Text(
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
}
