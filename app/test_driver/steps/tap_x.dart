import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class TapX extends When1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String key) async {
    var locator = find.byValueKey(key);
    final isPresent = await FlutterDriverUtils.isPresent(world.driver, locator);
    if (!isPresent){
      locator = find.text(key);
    }
    await FlutterDriverUtils.tap(world.driver, locator);
  }

  @override
  RegExp get pattern => RegExp(r"the user taps the {string}");
}