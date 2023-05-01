@Skip('Cannot run acceptance tests alongside unit tests.')

import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'steps/press_x_button.dart';
import 'steps/x_message_is_shown.dart';
import 'steps/user_is_in_x_menu.dart';
import 'steps/user_has_data.dart';
import 'steps/fill_x_field.dart';
import 'steps/see_X.dart';
import 'steps/select_x_option.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/**.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    //..hooks = [HookExample()]
    ..stepDefinitions = [GivenUserIsInXmenu(), AndPressXButton(), WhenPressXButton(), ThenAMessagesIsShown(), UserHasData(), FillXField(), SelectXOption(), SeeX()]
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";
  // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
  return GherkinRunner().execute(config);
}
