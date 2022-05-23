import 'package:flutter/material.dart';

import 'package:routing_2_0/src/routing/page_action.dart';
import 'package:routing_2_0/src/routing/page_configuration.dart';

import 'package:routing_2_0/src/screens/settings/settings_controller.dart';

class AppState extends ChangeNotifier {
  /// die aktuell auszuführende aktion
  PageAction _currentAction = PageAction();

  ///
  PageAction get currentAction => _currentAction;

  late SettingsController settingsController;

  PageConfiguration currentConfiguration = homePageConfiguration;

  /// setzten der nächsten aktion und
  set currentAction(PageAction action) {
    _currentAction = action;
    notifyListeners();
  }
}
