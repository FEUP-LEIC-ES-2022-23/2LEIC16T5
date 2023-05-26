import 'package:es/Database/RemoteDBHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es/LocalStorage/LocalStorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:es/Controller/LoginScreenController.dart';

class SettingsPopUpViewer {
  void resetData(BuildContext context) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'WARNING',
        text:
            'All your data will be deleted.\nThis action is irreversible.\nDo you wish to continue?',
        confirmBtnText: 'Yes',
        cancelBtnText: 'No',
        showCancelBtn: true,
        confirmBtnColor: Colors.lightBlue,
        onConfirmBtnTap: () async {
          if (!(await RemoteDBHelper(
                      userInstance: FirebaseAuth.instance,
                      firebaseInstance: FirebaseFirestore.instance)
                  .hasTransactions()) &&
              !(await RemoteDBHelper(
                      userInstance: FirebaseAuth.instance,
                      firebaseInstance: FirebaseFirestore.instance)
                  .hasCategories())) {
            Navigator.of(context).pop();
            errorDeleteData(context, 'No data has been inserted into the app');
          } else {
            try {
              await RemoteDBHelper(
                      userInstance: FirebaseAuth.instance,
                      firebaseInstance: FirebaseFirestore.instance)
                  .userResetData();
              LocalStorage().reset();
              Navigator.of(context).pop();
              deletedData(context);
            } catch (e) {
              Navigator.of(context).pop();
              errorDeleteData(context, 'Error deleting data');
            }
          }
        });
  }

  void deletedData(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Miau miau!',
      text: 'Your data has been successfully deleted',
      confirmBtnColor: Colors.lightBlue,
    );
  }

  void errorDeleteData(BuildContext context, String text) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Miau...',
      text: text,
      confirmBtnColor: Colors.lightBlue,
    );
  }

  void sureLogout(BuildContext context, LoginScreenController loginController) {
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
          title: 'Miau miau!',
          text: "Successfully logged out!",
          type: QuickAlertType.success,
          confirmBtnColor: Colors.lightBlue,
        );
      },
    );
  }
}
