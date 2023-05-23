import 'package:es/Controller/NewCategoryController.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Controller/NewTransactionController.dart';
import 'package:es/Model/CategoryModel.dart' as c_model;

class CategoriesMenu extends StatefulWidget {
  const CategoriesMenu({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CategoriesMenu> createState() => _CategoriesMenuState();
}

class _CategoriesMenuState extends State<CategoriesMenu> {
  RemoteDBHelper remoteDBHelper =
      RemoteDBHelper(userInstance: FirebaseAuth.instance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 25, 46, 1.0),
      appBar: AppBar(
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
                                contentPadding: EdgeInsets.only(left: 0),
                                tileColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  textColor: Colors.black,
                                  iconColor: Colors.white,
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
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
                                    setState(() {
                                      remoteDBHelper.removeCategory(categor);
                                      remoteDBHelper
                                          .removeBudgetBar(categor.name);
                                    });
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
                  heroTag: "Add",
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
