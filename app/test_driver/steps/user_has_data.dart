import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class UserHasData extends AndWithWorld<FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"the user has inserted data into the app");

  @override
  Future<void> executeStep() async {
    final locatorSettings = find.byValueKey("Settings");
    final isSettings = await FlutterDriverUtils.isPresent(world.driver, locatorSettings);

    final locatorHome = find.byValueKey("Home");
    await FlutterDriverUtils.tap(world.driver, locatorHome);

    if (!isSettings){
      await FlutterDriverUtils.tap(world.driver, locatorSettings);
      final locatorResetData = find.byValueKey("Reset Data");
      await FlutterDriverUtils.tap(world.driver, locatorResetData);
      final locatorYes = find.text("Yes");
      await FlutterDriverUtils.tap(world.driver, locatorYes);
      final locatorOkay = find.text("Okay");
      await FlutterDriverUtils.tap(world.driver, locatorOkay);
      await FlutterDriverUtils.tap(world.driver, locatorHome);
    }

    final locatorTransactions = find.byValueKey("Transactions");
    await FlutterDriverUtils.tap(world.driver, locatorTransactions);
    final locatorPlus = find.byValueKey("Plus");
    await FlutterDriverUtils.tap(world.driver, locatorPlus);
    final locatorTotal = find.byValueKey("Total");
    await FlutterDriverUtils.enterText(world.driver, locatorTotal, "2304");
    final locatorAdd = find.byValueKey("Add");
    await FlutterDriverUtils.tap(world.driver, locatorAdd);
    await FlutterDriverUtils.tap(world.driver, locatorHome);
    if (isSettings){
      await FlutterDriverUtils.tap(world.driver, locatorSettings);
    }
    else{
      final locatorCategories = find.byValueKey("Transactions");
      await FlutterDriverUtils.tap(world.driver, locatorCategories);
    }
  }
}