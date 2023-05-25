import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/Controller/NewCategoryController.dart';
import 'package:es/Database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:es/Model/CategoryModel.dart' as c_model;
import 'package:quickalert/quickalert.dart';

class CategoriesMenu extends StatefulWidget {
  const CategoriesMenu({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CategoriesMenu> createState() => _CategoriesMenuState();
}

class _CategoriesMenuState extends State<CategoriesMenu> {
  RemoteDBHelper remoteDBHelper =
      RemoteDBHelper(userInstance: FirebaseAuth.instance,firebaseInstance: FirebaseFirestore.instance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 25, 46, 1.0),
      appBar: AppBar(
        key: const Key("Categories"),
        title: Text(widget.title,
            style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<List<c_model.CategoryModel>>(
            stream: remoteDBHelper.readCategories(),
            builder: (BuildContext context, AsyncSnapshot<List<c_model.CategoryModel>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('Loading...',
                  style: TextStyle(fontSize: 20, color: Colors.white)));
              }
              return snapshot.data!.isEmpty
                  ? const Center(
                      child: Text("Nothing to show",
                          style:
                              TextStyle(fontSize: 20, color: Colors.white)),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.map((categor) {
                        return Center(
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.white24))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                key: const Key("Category"),
                                contentPadding: const EdgeInsets.only(left: 0),
                                tileColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  textColor: Colors.black,
                                  iconColor: Colors.white,
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                      color: Color(categor.color),
                                    ),
                                    width: 80,
                                  ),
                                  title: Text(
                                    categor.name,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  onLongPress: () {
                                    (categor.name == 'Default')?
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      title: 'Miau...',
                                      text: 'The Default category can\'t be deleted',
                                      confirmBtnColor: Colors.lightBlue
                                    ) :
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.warning,
                                      title: 'WARNING',
                                      text: 'Are you sure you want to permanently delete this category?',
                                      confirmBtnText: 'Yes',
                                      cancelBtnText: 'No',
                                      showCancelBtn: true,
                                      confirmBtnColor: Colors.lightBlue,
                                      onConfirmBtnTap: () {
                                        setState(() {
                                          remoteDBHelper.removeCategory(categor);
                                          remoteDBHelper
                                              .removeBudgetBar(categor.name);
                                          if (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                          QuickAlert.show(
                                              context: context,
                                              title: 'Miau miau!',
                                              text: "Category successfully deleted!",
                                              type: QuickAlertType.success,
                                              confirmBtnColor: Colors.lightBlue);
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
              }),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FloatingActionButton(
                  key: const Key("Plus"),
                  onPressed: () {
                    NewCategoryController().newCategory(context);
                  },
                  child: const Icon(Icons.add)),
            ),
          ),
        ],
      ),
    );
  }
}
