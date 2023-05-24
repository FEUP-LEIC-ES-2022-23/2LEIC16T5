import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:es/database/LocalDBHelper.dart';
import 'package:quickalert/quickalert.dart';
import 'package:es/Controller/LoginScreenController.dart';

class SettingsPopUpViewer {
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
                key: Key("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("NO",
                      style: TextStyle(color: Colors.lightBlue))),
              TextButton(
                  key: const Key("Yes"),
                  onPressed: () async {
                    if (!(await RemoteDBHelper(userInstance: FirebaseAuth.instance,firebaseInstance: FirebaseFirestore.instance).hasTransactions())
                    && !(await RemoteDBHelper(userInstance: FirebaseAuth.instance,firebaseInstance: FirebaseFirestore.instance).hasCategories())){
                      Navigator.of(context).pop();
                      errorDeleteData(context, 'No data has been inserted into the app');
                    }
                    else{
                      try {
                        RemoteDBHelper(userInstance: FirebaseAuth.instance,firebaseInstance: FirebaseFirestore.instance)
                            .userResetData();
                            
                        Navigator.of(context).pop();
                        deletdData(context);
                      } catch (e) {
                        Navigator.of(context).pop();
                        errorDeleteData(context, 'Error deleting data');
                      }
                    }
                  },
                  child: const Text(
                    "YES",
                    style: TextStyle(color: Colors.lightBlue),
                  ))
            ],
          );
        });
  }

  void deletdData(BuildContext context) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Miau miau!',
        text: 'Your data has been successfully deleted');
  }

  void errorDeleteData(BuildContext context, String text) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Miau...',
        text: text);
  }

  void sureLogout(BuildContext context, loginScreenController loginController) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'WARNING',
      text: 'You will be logged out!',
      confirmBtnColor: Colors.lightBlue,
      onConfirmBtnTap: () {
        loginController.signOut();
        loginController.toLogInScreen(context);
        QuickAlert.show(
            context: context,
            text: "Sucessfully logged out!",
            type: QuickAlertType.success);
      },
    );
  }
}
