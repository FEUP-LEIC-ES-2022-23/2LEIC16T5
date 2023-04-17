import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class SelectXOption extends Given1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"the user selects {string} option");

  @override
  Future<void> executeStep(String option) async {
    final locator = find.byValueKey(option);
    final isPresent = await FlutterDriverUtils.isPresent(world.driver, locator);

    if (!isPresent){
      final switchButton = find.byValueKey("Switch");
      if (option == "Income"){
          await FlutterDriverUtils.tap(world.driver, switchButton);
          final expense = find.byValueKey("Expense");
          await FlutterDriverUtils.isPresent(world.driver, expense);
      }
      else if (option == "Expense"){
        if (!isPresent){
          await FlutterDriverUtils.tap(world.driver, switchButton);
          final income = find.byValueKey("Income");
          await FlutterDriverUtils.isPresent(world.driver, income);
        }
      }
    }
  }
}