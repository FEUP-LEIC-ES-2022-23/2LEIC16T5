import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class FillXField extends And3WithWorld<String, String, String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"the user {string} in {string} field - ex: {string}");

  @override
  Future<void> executeStep(String key, String button, String text) async {
    final locatorTotal = find.byValueKey(button);
    await FlutterDriverUtils.enterText(world.driver, locatorTotal, text);
  }
}