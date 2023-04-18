import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class ThenAMessagesIsShown extends Then1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"a {string} message is shown");

  @override
  Future<void> executeStep(String key) async {
    final locator = find.text(key);
    final driver = world.driver;
    if (driver == null) {
      throw Exception("FlutterDriver not found.");
    }
    final text = await FlutterDriverUtils.getText(driver, locator);
    if (text == null) {
      throw Exception("Message with key '$key' not found.");
    }
  }
}

