import 'package:flutter/material.dart';
import 'package:routing_2_0/src/enum/page_state.dart';
import 'package:routing_2_0/src/routing/page_action.dart';
import 'package:routing_2_0/src/routing/page_configuration.dart';
import 'package:routing_2_0/src/screens/sample_feature/views/sample_item_details_view.dart';
import 'package:routing_2_0/src/screens/sample_feature/views/sample_item_list_view.dart';

class RouterParser extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? "");

    if (uri.pathSegments.isEmpty) {
      return homePageConfiguration;
    }

    final path = uri.pathSegments[0];

    switch ('/${path}') {
      case SettingsPath:
        return settingsPageConfiguration;
      case DetailsPath:
        if (uri.pathSegments.length == 2) {
          var remaining = uri.pathSegments[1];
          detailPageConfiguration.id = int.tryParse(remaining);
        }
        detailPageConfiguration.currentPageAction = PageAction(
            state: PageState.addPage,
            page: detailPageConfiguration,
            widget: SampleItemDetailsView(
              id: detailPageConfiguration.id,
            ));
        return detailPageConfiguration;
      case ListItemsPath:
        return listPageConfiguration;
      case HomePath:
        return homePageConfiguration;
      default:
        return homePageConfiguration;
    }
  }

  @override

  /// setzten der aktuellen URL für web
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    switch (configuration.uiPage) {
      case Pages.Settings:
        return RouteInformation(location: SettingsPath);
      case Pages.List:
        return RouteInformation(location: ListItemsPath);
      case Pages.Details:
        return RouteInformation(location: '$DetailsPath/${configuration.id}');
      default:
        return RouteInformation(location: HomePath);
    }
  }
}
