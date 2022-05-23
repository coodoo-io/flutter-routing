import 'package:flutter/material.dart';
import 'package:routing_2_0/src/enum/page_state.dart';
import 'package:routing_2_0/src/routing/page_configuration.dart';

class PageAction {
  PageState state;
  PageConfiguration? page;
  List<PageConfiguration>? pages;
  Widget? widget;

  PageAction({this.state = PageState.none, this.page, this.pages, this.widget});
  @override
  toString() {
    var pageString = "";
    if (page != null) {
      pageString = page!.path;
    }
    return "PageState: " + state.toString() + " Page:" + pageString;
  }
}
