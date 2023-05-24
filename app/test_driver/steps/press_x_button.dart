import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class WhenPressXButton extends When1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String button) async {
    var locator = find.byValueKey(button);
    final isPresent = await FlutterDriverUtils.isPresent(world.driver, locator);
    if (!isPresent){
      locator = find.text(button);
    }
    await FlutterDriverUtils.tap(world.driver, locator);
  }

  @override
  RegExp get pattern => RegExp(r"the user presses the {string} button");
}

class AndPressXButton extends And1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"the user presses the {string} button");

  @override
  Future<void> executeStep(String button) async {
    var locator = find.byValueKey(button);
    final isPresent = await FlutterDriverUtils.isPresent(world.driver, locator);
    if (!isPresent){
      locator = find.text(button);
    }
    await FlutterDriverUtils.tap(world.driver, locator);
  }
}
