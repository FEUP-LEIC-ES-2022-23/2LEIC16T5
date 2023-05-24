import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class SelectColor extends And1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"the user (selects|selects a different) a color");

  @override
  Future<void> executeStep(String option) async {
    final pickColor = find.byValueKey('Pick Color');
    await FlutterDriverUtils.tap(world.driver, pickColor);

    final colorPicker = find.byValueKey('Color Picker');

    if (option != 'selects'){
      await FlutterDriverUtils.tap(world.driver, colorPicker);
    }

    final select = find.byValueKey('Select');
    await FlutterDriverUtils.tap(world.driver, select);
  }
}