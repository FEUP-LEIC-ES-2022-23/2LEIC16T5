import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class GivenCurrentIs extends Given2WithWorld<String, String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"current {string} is {string}");

  @override
  Future<void> executeStep(String text, String value) async {
    final locator = find.byValueKey(value);
    final isPresent = await FlutterDriverUtils.isPresent(world.driver, locator);

    if (!isPresent){
      final dropDownButton = find.byValueKey("DropDown");
      await FlutterDriverUtils.tap(world.driver, dropDownButton);
      await FlutterDriverUtils.tap(world.driver, locator);
      await FlutterDriverUtils.isPresent(world.driver, locator);
    }
  }
}

class ThenCurrentIs extends Then2WithWorld<String, String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"current {string} is {string}");

  @override
  Future<void> executeStep(String text, String value) async {
    final locator = find.byValueKey(value);
    await FlutterDriverUtils.isPresent(world.driver, locator);
  }
}