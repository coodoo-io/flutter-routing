import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:routing_2_0/src/screens/sample_feature/views/sample_item_details_view.dart';
import 'package:routing_2_0/src/screens/sample_feature/views/sample_item_list_view.dart';
import 'package:routing_2_0/src/screens/settings/settings_view.dart';

import 'screens/settings/settings_controller.dart';

/// The Widget that configures your application.
class SampleApp extends StatelessWidget {
  SampleApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  late final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/home',
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, _) => FadeTransitionPage(
          key: const ValueKey<String>('scaffold'),
          child: SampleItemListView(),
        ),
        routes: [
          GoRoute(
            path: 'items/:id',
            pageBuilder: (context, state) => FadeTransitionPage(
              key: const ValueKey<String>('detail'),
              child: SampleItemDetailsView(
                  id: int.tryParse(state.pathParameters['id']!)),
            ),
          ),
          GoRoute(
            path: 'settings',
            pageBuilder: (context, _) => FadeTransitionPage(
              key: const ValueKey<String>('settings'),
              child: SettingsView(
                controller: settingsController,
              ),
            ),
          )
        ],
      )
    ],
    debugLogDiagnostics: true,
  );

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          title: "Flutter Shopping",
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          routerConfig: _router,
        );
      },
    );
  }
}

class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
            key: key,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(-1.0, 0.0);
              const end = Offset(0.0, 0.0);
              final tween = Tween(begin: begin, end: end);
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            child: child);
}
