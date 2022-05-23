import 'package:flutter/material.dart';
import 'package:routing_2_0/src/routing/router_delegate.dart';

// 1
class SampleBackButtonDispatcher extends RootBackButtonDispatcher {
  // 2
  final SampleRouterDelegate _routerDelegate;

  SampleBackButtonDispatcher(this._routerDelegate) : super();

  // 3
  Future<bool> didPopRoute() {
    var val = _routerDelegate.popRoute();

    return val;
  }
}
