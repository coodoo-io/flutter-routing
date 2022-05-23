import 'package:routing_2_0/src/routing/page_action.dart';

const String ListItemsPath = '/listitems';
const String DetailsPath = '/details';
const String SettingsPath = '/settings';
const String HomePath = '/home';

enum Pages { Settings, List, Details, Overlay, Home }

class PageConfiguration {
  final String key;
  final String path;
  final Pages? uiPage;
  PageAction? currentPageAction;
  final bool? fullScreenDialog;
  int? id;

  PageConfiguration(
      {required this.key,
      required this.path,
      required this.uiPage,
      this.currentPageAction,
      this.fullScreenDialog = false,
      this.id = 0});
}

PageConfiguration listPageConfiguration = PageConfiguration(
    key: 'list',
    path: ListItemsPath,
    uiPage: Pages.List,
    currentPageAction: null);
PageConfiguration detailPageConfiguration = PageConfiguration(
    key: 'detail',
    path: DetailsPath,
    uiPage: Pages.Details,
    currentPageAction: null,
    fullScreenDialog: false);
PageConfiguration settingsPageConfiguration = PageConfiguration(
    key: 'settings',
    path: SettingsPath,
    uiPage: Pages.Settings,
    currentPageAction: null,
    fullScreenDialog: false);
PageConfiguration homePageConfiguration = PageConfiguration(
    key: 'home',
    path: HomePath,
    uiPage: Pages.Home,
    currentPageAction: null,
    fullScreenDialog: false);
