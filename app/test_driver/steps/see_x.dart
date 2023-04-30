import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class SeeX extends And1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"the user sees the {string}");

  @override
  Future<void> executeStep(String key) async {
    final locator = find.byValueKey(key);
    final isPresent = await FlutterDriverUtils.isPresent(world.driver, locator);
    if (!isPresent) {
      throw Exception("User does not see the $key.");
    }
  }
}