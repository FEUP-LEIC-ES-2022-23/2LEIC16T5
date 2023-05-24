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
import 'package:geocoding/geocoding.dart' as geocoding;

class NewTransactionController {
  static final textcontrollerNAME = TextEditingController();
  static final textcontrollerTOTAL = TextEditingController();
  static final textcontrollerDATE = TextEditingController();
  static final textcontrollerNOTES = TextEditingController();
  static final textcontrollerADDRESS = TextEditingController();

  GeoPoint? position;
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;
  NumberFormat euro = NumberFormat.currency(locale: 'pt_PT', name: "€");

  RemoteDBHelper remoteDBHelper = RemoteDBHelper(
      userInstance: FirebaseAuth.instance,
      firebaseInstance: FirebaseFirestore.instance);

  c_model.CategoryModel emptyCategory = c_model.CategoryModel(
      categoryID: '', userID: '', name: 'Category', color: 0);
  c_model.CategoryModel selectedCategory=c_model.CategoryModel(
    categoryID: 'default',userID: FirebaseAuth.instance.currentUser?.uid,name: 'Category',color: 0xFF808080);

  void _enterTransaction() async {
    if (textcontrollerADDRESS.text != '' && position == null) {
      await getGeoPointFromAddress(textcontrollerADDRESS.text);
    }

    t_model.TransactionModel transaction = t_model.TransactionModel(
        userID: FirebaseAuth.instance.currentUser!.uid,
        categoryID: selectedCategory.categoryID,
        name: textcontrollerNAME.text.isEmpty
            ? "Transaction"
            : textcontrollerNAME.text,
        expense: _isIncome ? 0 : 1,
        total: num.parse(textcontrollerTOTAL.text),
        date: textcontrollerDATE.text.isEmpty
            ? DateTime.now()
            : DateFormat('dd-MM-yyyy').parse(textcontrollerDATE.text),
        location: _isIncome ? null : position,
        categoryColor: selectedCategory.color,
        notes: textcontrollerNOTES.text);

    remoteDBHelper.addTransaction(transaction).then((transac) {
      if (!_isIncome) {
        remoteDBHelper.updateBudgetBarValOnChangedTransaction(
            transac.transactionID!, true);
      }
    });

    textcontrollerNAME.clear();
    textcontrollerTOTAL.clear();
    textcontrollerDATE.clear();
    textcontrollerNOTES.clear();
    textcontrollerADDRESS.clear();
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
                            key: _isIncome
                                ? const Key("Income")
                                : const Key("Expense"),
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
                      !_isIncome
                          ? Row(
                              children: [
                                FloatingActionButton(
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
                                            onConfirmBtnTap: () async {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                position = GeoPoint(
                                                    double.parse(
                                                        '${value.latitude}'),
                                                    double.parse(
                                                        '${value.longitude}'));
                                              });
                                              textcontrollerADDRESS.text =
                                              await getAddressFromGeoPoint(
                                                  position!);
                                              setState(() {});
                                            },
                                            onCancelBtnTap: () {
                                              setState(() {
                                                position = null;
                                                textcontrollerADDRESS.text = '';
                                              });
                                              Navigator.of(context).pop();
                                            });
                                      });
                                    },
                                    child: (position == null)
                                        ? const Icon(Icons.pin_drop_rounded)
                                        : const Icon(Icons.done_all_rounded)),
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText:
                                          'Address (Street, Number, City, State, Country)',
                                    ),
                                    controller: textcontrollerADDRESS,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(
                              width: 48.0,
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
          } else {
            if (selectedCategory.name != emptyCategory.name) {
              categories.add(emptyCategory);
            }
            for (var element in snapshot.data!) {
              if (element.name != selectedCategory.name) {
                categories.add(element);
              }
            }
            categories.add(selectedCategory);
          }

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
                            value: selectedCategory,
                            items: categories
                                .map((c_model.CategoryModel? c) =>
                                    DropdownMenuItem(
                                        value: c,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                selectedCategory = val as c_model.CategoryModel;
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

  void showTransaction(
      BuildContext context, t_model.TransactionModel transac) async {
    c_model.CategoryModel category =
        await remoteDBHelper.getCategory(transac.categoryID!);

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
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(32.0)),
                        color: Color(transac.categoryColor!),
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
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('Category:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      category.name,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                (transac.expense == 1)
                                    ? const Text('Expense:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18))
                                    : const Text('Income:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
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
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('Date:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text(
                                    DateFormat('dd-MM-yyyy')
                                        .format(transac.date),
                                        key: const Key("Date"),
                                        style: const TextStyle(fontSize: 20),
                                  )),
                                ),
                              ],
                            ),
                          ),
                          (transac.notes?.isEmpty ?? true)
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        ),
                                        padding: const EdgeInsets.all(10),
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
                                            icon: BitmapDescriptor
                                                .defaultMarkerWithHue(HSVColor
                                                        .fromColor(Color(transac
                                                            .categoryColor!))
                                                    .hue),
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
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  Future<void> getGeoPointFromAddress(String address) async {
    List<geocoding.Location> locations =
        await geocoding.locationFromAddress(address);
    if (locations.isNotEmpty) {
      double latitude = locations[0].latitude;
      double longitude = locations[0].longitude;
      position = GeoPoint(latitude, longitude);
    }
  }

  Future<String> getAddressFromGeoPoint(GeoPoint geoPoint) async {
    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(
      geoPoint.latitude,
      geoPoint.longitude,
    );

    if (placemarks.isNotEmpty) {
      geocoding.Placemark placemark = placemarks[0];
      String address =
          '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.postalCode}';
      return address;
    }
    return '';
  }
}
