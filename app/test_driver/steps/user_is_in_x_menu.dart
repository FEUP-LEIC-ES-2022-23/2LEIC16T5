import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class GivenUserIsInXmenu extends Given1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"the user is in the {string} menu");

  @override
  Future<void> executeStep(String menuName) async {
    final isPresent = await FlutterDriverUtils.waitForFlutter(world.driver);
    if (!isPresent) {
      throw Exception("User is not in $menuName menu.");
    }
  }
}

