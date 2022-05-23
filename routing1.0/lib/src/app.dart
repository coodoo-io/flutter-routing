import 'package:flutter/material.dart';
import 'package:routing_1_0/src/screens/sample_feature/views/sample_item_details_view.dart';
import 'package:routing_1_0/src/screens/sample_feature/views/sample_item_list_view.dart';
import 'screens/settings/settings_controller.dart';
import 'screens/settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          title: "Flutter Shopping",
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Methode zum aufbauen von DeepLinking und Flutter Web Unterstützung
          onGenerateRoute: (RouteSettings routeSettings) {
            var name = routeSettings.name!.split('?')[0];
            //Aufbauen der PageRoutes
            return PageRouteBuilder(
              settings: routeSettings,
              pageBuilder: (BuildContext context, __, ___) {
                switch (name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case SampleItemDetailsView.routeName:
                    //Paramter auslesen um direkt auf das Element zu springen
                    var params = (routeSettings.name!.split('?'));

                    if (params.length > 1) {
                      params = params[1].split('=');
                      return SampleItemDetailsView(
                        id: int.parse(params[1]),
                      );
                    } else {
                      return SampleItemDetailsView();
                    }

                  case SampleItemListView.routeName:
                  default:
                    return SampleItemListView();
                }
              },
              //Transition Builder um Übergänge zu erzeugen
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
            );
          },
        );
      },
    );
  }
}
