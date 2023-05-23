import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class XisSetOn extends And2WithWorld<String, String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"{string} is set on the {string} menu");
  @override
  Future<void> executeStep(String key, String menu) async {
    final locatorHome = find.byValueKey("Home");
    await FlutterDriverUtils.tap(world.driver, locatorHome);
    final locatorMenu = find.byValueKey(menu);
    await FlutterDriverUtils.tap(world.driver, locatorMenu);
    final locatorPlus = find.byValueKey("Plus");
    await FlutterDriverUtils.tap(world.driver, locatorPlus);
    final locatorTotal = find.byValueKey("Total");
    await FlutterDriverUtils.enterText(world.driver, locatorTotal, "2304");
    final locatorAdd = find.byValueKey("Add");
    await FlutterDriverUtils.tap(world.driver, locatorAdd);
    final locatorKey = find.text(key);
    await FlutterDriverUtils.isPresent(world.driver, locatorKey);
  }
}