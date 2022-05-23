import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:routing_2_0/src/enum/page_state.dart';
import 'package:routing_2_0/src/routing/page_action.dart';

import 'package:routing_2_0/src/routing/page_configuration.dart';
import 'package:routing_2_0/src/screens/sample_feature/views/sample_item_list_view.dart';
import 'package:routing_2_0/src/screens/settings/settings_view.dart';
import 'package:routing_2_0/src/state/app_state.dart';

class SampleRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  final List<Page> _pages = [];

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  bool _isOverlay = false;
  final AppState appState;

  SampleRouterDelegate(this.appState) : navigatorKey = GlobalKey() {
    appState.addListener(() {
      notifyListeners();
    });
  }

  /// Getter for a list that cannot be changed
  List<MaterialPage> get pages => List.unmodifiable(_pages);

  /// Number of pages function
  int numPages() => _pages.length;

  /// Holt die aktuelle Seiten Configuration
  @override
  PageConfiguration get currentConfiguration {
    return appState.currentConfiguration;
  }

  /// Methode zum Prüfen ob man eine Route entfernen darf
  bool _onPopPage(Route<dynamic> route, result) {
    final didPop = route.didPop(result);

    if (!didPop) {
      return false;
    }

    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

  /// entfernt eine Seite aus dem Stack
  void _removePage(Page page) {
    _pages.remove(page);
    appState.currentConfiguration = homePageConfiguration;
    appState.currentAction =
        PageAction(state: PageState.addPage, page: homePageConfiguration);
  }

  /// fügt eine Seite hinzu wenn er erlaubt ist und entfernt die letzte
  void pop() {
    if (canPop()) {
      _removePage(_pages.last);
    }
  }

  ///
  bool canPop() {
    return _pages.length > 1;
  }

  @override
  Future<bool> popRoute() {
    if (_isOverlay) {
      _isOverlay = false;
      navigatorKey.currentState?.pop(true);
      return Future.value(true);
    }
    if (canPop()) {
      navigatorKey.currentState?.pop(true);
      return Future.value(true);
    }

    /// Wenn TRUE dann wird die APP nicht geschlosen.
    return Future.value(false);
  }

  @override

  /// build methode des router delegate widgets
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: buildPages(),
    );
  }

  /// erzeugt eine Seite
  MaterialPage _createPage(Widget? child, PageConfiguration pageConfig) {
    return MaterialPage(
        child: child ?? Container(),
        key: ValueKey(pageConfig.key),
        name: pageConfig.path,
        arguments: pageConfig,
        fullscreenDialog: pageConfig.fullScreenDialog ?? false);
  }

  /// fügt eine Seite dem Stack hinzu
  void _addPageData(Widget? child, PageConfiguration pageConfig) {
    _pages.add(
      _createPage(child, pageConfig),
    );
  }

  /// Eine Seite zur Liste hinzufügen
  void addPage(PageConfiguration? pageConfig) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            (pageConfig?.uiPage ?? Pages.List);

    if (shouldAddPage) {
      appState.currentConfiguration = pageConfig ?? homePageConfiguration;

      switch (pageConfig?.uiPage) {
        case Pages.Settings:
          _addPageData(
              SettingsView(
                controller: appState.settingsController,
              ),
              settingsPageConfiguration);
          break;
        case Pages.List:
          _addPageData(SampleItemListView(key: const Key("list")),
              listPageConfiguration);
          break;
        case Pages.Home:
          _addPageData(
              SampleItemListView(
                key: const Key("home"),
              ),
              homePageConfiguration);
          break;
        case Pages.Details:
          if (pageConfig?.currentPageAction != null) {
            _addPageData(pageConfig?.currentPageAction?.widget,
                pageConfig ?? homePageConfiguration);
          }
          break;
        default:
          break;
      }
    }
  }

  /// Eine Seite ersetzten
  void replace(PageConfiguration? newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(newRoute);
  }

  /// setzt einen neuen pfad
  void setPath(List<MaterialPage> path) {
    _pages.clear();
    _pages.addAll(path);
  }

  /// alte Seiten löschen und neue hinzufügen
  void replaceAll(PageConfiguration newRoute) {
    setNewRoutePath(newRoute);
  }

  /// fügt eine Seite hinzu
  void push(PageConfiguration newRoute) {
    addPage(newRoute);
  }

  void pushWidget(Widget child, PageConfiguration newRoute) {
    _addPageData(child, newRoute);
  }

  /// Eine Liste von Seiten hinzufügen
  void addAll(List<PageConfiguration> routes) {
    _pages.clear();
    routes.forEach((route) {
      addPage(route);
    });
  }

  @override

  ///Überschreibt den aktuellen Stack wenn es mehr als eine Route gibt
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    if (_pages.length > 1) {
      _pages.clear();
    }
    addPage(configuration);
    return SynchronousFuture(null);
  }

  /// setzt die aktuell page action
  void _setPageAction(PageAction action) {
    switch (action.page?.uiPage) {
      case Pages.Settings:
        settingsPageConfiguration.currentPageAction = action;
        break;
      case Pages.List:
        listPageConfiguration.currentPageAction = action;
        break;
      case Pages.Home:
        homePageConfiguration.currentPageAction = action;
        break;
      case Pages.Details:
        detailPageConfiguration.currentPageAction = action;
        break;
      default:
        break;
    }
  }

  /// Baut alle Seiten auf
  List<Page> buildPages() {
    switch (appState.currentAction.state) {
      case PageState.overlay:
        final context = navigatorKey.currentState!.overlay!.context;
        final dialog = Dialog(
          child: appState.currentAction.widget,
        );
        showDialog(context: context, builder: (x) => dialog);
        _isOverlay = true;
        break;
      case PageState.none:
        break;
      case PageState.addPage:
        _setPageAction(appState.currentAction);
        addPage(appState.currentAction.page);
        break;
      case PageState.pop:
        pop();
        break;
      case PageState.replace:
        _setPageAction(appState.currentAction);
        replace(appState.currentAction.page);
        break;
      case PageState.replaceAll:
        _setPageAction(appState.currentAction);
        replaceAll(appState.currentAction.page ?? homePageConfiguration);
        break;
      case PageState.addWidget:
        _setPageAction(appState.currentAction);
        pushWidget(appState.currentAction.widget ?? Container(),
            appState.currentAction.page ?? homePageConfiguration);
        break;
      case PageState.addAll:
        addAll(appState.currentAction.pages ?? [homePageConfiguration]);
        break;
    }
    return List.of(_pages);
  }
}
