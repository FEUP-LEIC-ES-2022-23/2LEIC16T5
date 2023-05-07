import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Controller/MapMenuController.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:es/Model/TransactionsModel.dart' as t_model;
import 'package:es/Model/CategoryModel.dart' as c_model;
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewTransactionController {
  static final textcontrollerNAME = TextEditingController();
  static final textcontrollerTOTAL = TextEditingController();
  static final textcontrollerDATE = TextEditingController();
  static final textcontrollerNOTES = TextEditingController();
  GeoPoint? position;
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;
  NumberFormat euro = NumberFormat.currency(locale: 'pt_PT', name: "€");
  c_model.CategoryModel selected_category=c_model.CategoryModel(categoryID: '',userID: '',name: 'Category',color: 0);

  RemoteDBHelper remoteDBHelper =
      RemoteDBHelper(userInstance: FirebaseAuth.instance);
  //Transactions
  void _enterTransaction() {
    t_model.TransactionModel transaction = t_model.TransactionModel(
        userID: FirebaseAuth.instance.currentUser!.uid,
        categoryID: selected_category.categoryID,
        name: textcontrollerNAME.text.isEmpty
            ? "Transaction"
            : textcontrollerNAME.text,
        expense: _isIncome ? 0 : 1,
        total: num.parse(textcontrollerTOTAL.text),
        date: textcontrollerDATE.text.isEmpty
            ? DateTime.now()
            : DateFormat('dd-MM-yyyy').parse(textcontrollerDATE.text),
        location: _isIncome ? null : position,
        categoryColor: selected_category.color,
        notes: textcontrollerNOTES.text);

    remoteDBHelper.addTransaction(transaction).then((String? value) {
      remoteDBHelper.updateBudgetBar(value!, true);
    });

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
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                titlePadding: const EdgeInsets.all(0),
                title: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(32.0)),
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
                          const Text(
                            'Expense',
                            style: TextStyle(color: Colors.black54),
                          ),
                          Switch(
                            key: _isIncome? const Key("Income") :  const Key("Expense"),
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          const Text(
                            'Income',
                            style: TextStyle(color: Colors.black54),
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
                      buildDropdownList(remoteDBHelper),
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
                      !_isIncome
                          ? FloatingActionButton(
                              mini: true,
                              backgroundColor: Colors.lightBlue,
                              heroTag: "Map",
                              onPressed: () {
                                MapMenuController()
                                    .getCurrentLocation(context)
                                    .then((value) {
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.confirm,
                                      confirmBtnColor: Colors.lightBlue,
                                      text:
                                          "Do you wish to set your current location as this transaction's location?",
                                      confirmBtnText: "Yes",
                                      cancelBtnText: "No",
                                      onConfirmBtnTap: () {
                                        setState(() {
                                          position = GeoPoint(
                                              double.parse('${value.latitude}'),
                                              double.parse(
                                                  '${value.longitude}'));
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
                              child: (position == null)
                                  ? const Icon(Icons.pin_drop_rounded)
                                  : const Icon(Icons.done_all_rounded))
                          : const SizedBox(
                              width: 48.0,
                            ),
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

  Widget buildDropdownList(RemoteDBHelper db) {
    return StreamBuilder<List<c_model.CategoryModel>>(
        stream: db.readCategories(),
        builder: (BuildContext context,
            AsyncSnapshot<List<c_model.CategoryModel>> snapshot) {
          List<c_model.CategoryModel?> categories = [];
          if (!snapshot.hasData) {
            return Row(
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 15,
                ),
                DropdownButton(
                    dropdownColor: Colors.black,
                    iconEnabledColor: Colors.white,
                    value: '',
                    items: const [],
                    onChanged: (val) {}),
              ],
            );
          }
          snapshot.data!.forEach((element) {
            categories.add(element);
          });
          categories.add(selected_category);

          return snapshot.hasData
              ? StatefulBuilder(builder: (BuildContext context, setState) {
                  return Row(
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: DropdownButton(
                            dropdownColor: Colors.white,
                            value: selected_category,
                            items: categories
                                .map((c_model.CategoryModel? c) => DropdownMenuItem(
                                    value: c,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          c!.name,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(c.color),
                                          ),
                                          width: 20,
                                          height: 20,
                                        ),
                                      ],
                                    )))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selected_category =
                                    val as c_model.CategoryModel;
                              });
                            }),
                      ),
                    ],
                  );
                })
              : DropdownButton(
                  dropdownColor: Colors.black,
                  iconEnabledColor: Colors.white,
                  value: '',
                  items: const [],
                  onChanged: (val) {});
        });
  }

  void showTransaction(BuildContext context, t_model.TransactionModel transac) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              key: const Key("Transaction Info"),
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
                          Text(
                            transac.name,
                            key: const Key("Name"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  content: SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                (transac.expense == 1)
                                    ? const Icon(Icons.money_off)
                                    : const Icon(Icons.wallet),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      euro.format(transac.total),
                                      key: const Key("Total"),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.calendar_today),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text(
                                    DateFormat('dd-MM-yyyy')
                                        .format(transac.date),
                                        key: const Key("Date"),
                                        style: TextStyle(fontSize: 20),
                                  )),
                                ),
                              ],
                            ),
                          ),
                          (transac.notes?.isEmpty ?? true)
                              ? SizedBox()
                              : Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child:
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Notes:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Container(
                                          width: 250,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            //borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            transac.notes!,
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                
                              ),
                          (transac.location != null)
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Location:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    SizedBox(
                                      width: 250,
                                      height: 150,
                                      child: GoogleMap(
                                        mapType: MapType.normal,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                            transac.location!.latitude,
                                            transac.location!.longitude,
                                          ),
                                          zoom: 14.0,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId: MarkerId(
                                                transac.transactionID!),
                                            position: LatLng(
                                              transac.location!.latitude,
                                              transac.location!.longitude,
                                            ),
                                          ),
                                        },
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          MapMenuController()
                                              .setMapController(controller);
                                        },
                                        myLocationEnabled: true,
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
