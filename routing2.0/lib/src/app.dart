import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routing_2_0/src/routing/back_button.dart';
import 'package:routing_2_0/src/routing/parser.dart';
import 'package:routing_2_0/src/routing/page_configuration.dart';
import 'package:routing_2_0/src/routing/router_delegate.dart';

import 'package:routing_2_0/src/state/app_state.dart';
import 'screens/settings/settings_controller.dart';

/// The Widget that configures your application.
class SampleApp extends StatefulWidget {
  const SampleApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  State<SampleApp> createState() => _MyAppState();
}

class _MyAppState extends State<SampleApp> {
  final appState = AppState();

  late SampleRouterDelegate delegate;
  final parser = RouterParser();
  late SampleBackButtonDispatcher backButtonDispatcher;

  // ignore: non_constant_identifier_names
  _MyAppState() {
    delegate = SampleRouterDelegate(appState);
    delegate.setNewRoutePath(homePageConfiguration);
    backButtonDispatcher = SampleBackButtonDispatcher(delegate);
  }

  @override
  void initState() {
    super.initState();
    appState.settingsController = widget.settingsController;
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppState>(create: (_) => appState),
        ],
        child: AnimatedBuilder(
          animation: widget.settingsController,
          builder: (BuildContext context, Widget? child) {
            return MaterialApp.router(
              restorationScopeId: 'app',
              title: "Flutter Shopping",
              theme: ThemeData(),
              darkTheme: ThemeData.dark(),
              themeMode: widget.settingsController.themeMode,
              backButtonDispatcher: backButtonDispatcher,
              routerDelegate: delegate,
              routeInformationParser: parser,
            );
          },
        ));
  }
}
