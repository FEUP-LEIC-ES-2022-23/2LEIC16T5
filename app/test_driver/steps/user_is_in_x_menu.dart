import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class GivenUserIsInXmenu extends Given1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"the user is in the {string} menu");

  @override
  Future<void> executeStep(String menuName) async {
    final locator = find.byValueKey(menuName);
    final isPresent = await FlutterDriverUtils.isPresent(world.driver, locator);

    final mainMenu = find.byValueKey("Main");
    final isMainMenu = await FlutterDriverUtils.isPresent(world.driver, mainMenu);
    if (isMainMenu && menuName != "Login"){
      await FlutterDriverUtils.tap(world.driver, locator);
    }

    if (!isPresent) {
      final loginMenu = find.byValueKey("Login");
      final isLogInMenu = await FlutterDriverUtils.isPresent(world.driver, loginMenu);
      if (isLogInMenu) {
        final email = find.byValueKey("Email");
        await FlutterDriverUtils.enterText(world.driver, email, "fortuneko@gmail.com");
        final password = find.byValueKey("Password");
        await FlutterDriverUtils.enterText(world.driver, password, "Fortuneko2023");
        final signIn = find.byValueKey("Sign in");
        await FlutterDriverUtils.tap(world.driver, signIn);
        if (menuName == "Main"){
          await FlutterDriverUtils.isPresent(world.driver, locator);
        }
        else {
          await FlutterDriverUtils.tap(world.driver, locator);
          await FlutterDriverUtils.isPresent(world.driver, locator);
        }
      }
      else {
        if (menuName == "Login") {
            final locatorSettings = find.byValueKey("Settings");
            await FlutterDriverUtils.tap(world.driver, locatorSettings);
            final locatorLogout = find.byValueKey("Logout");
            await FlutterDriverUtils.tap(world.driver, locatorLogout);
            final locatorOk = find.text("Okay");
            await FlutterDriverUtils.tap(world.driver, locatorOk);
            await FlutterDriverUtils.tap(world.driver, locatorOk);
            await FlutterDriverUtils.isPresent(world.driver, locator);
        }
        else {
            await FlutterDriverUtils.tap(world.driver, locator);
            await FlutterDriverUtils.isPresent(world.driver, locator);
        }
      }
    }
  }
}

class ThenUserIsInXmenu extends Then1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"the user is in the {string} menu");

  @override
  Future<void> executeStep(String menuName) async {
    final locator = find.byValueKey(menuName);
    await FlutterDriverUtils.isPresent(world.driver, locator);
  }
}

