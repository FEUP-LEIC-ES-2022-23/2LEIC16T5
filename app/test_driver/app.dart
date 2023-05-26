import 'package:es/Database/LocalDBHelper.dart';

import '../lib/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // This line enables the extension
  enableFlutterDriverExtension();

  // Call the `main()` function of your app or call `runApp` with any widget you
  // are interested in testing.
  await Firebase.initializeApp();

  await LocalDBHelper.init();

  runApp(MyApp());
}