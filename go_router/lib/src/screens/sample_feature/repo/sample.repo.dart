import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:routing_2_0/src/screens/sample_feature/model/sample_item.dart';

class SampleRepo extends ChangeNotifier {
  static final SampleRepo _sampleRepo = SampleRepo._internal();

  factory SampleRepo() {
    return _sampleRepo;
  }

  SampleRepo._internal() {
    _addInitaSamples();
  }

  final List<SampleItem> _items = [];

  Future<UnmodifiableListView<SampleItem>> get items async {
    return Future.delayed(const Duration(seconds: 1), () {
      return UnmodifiableListView(_items);
    });
  }

  Future<UnmodifiableListView<SampleItem>> get itemsDirectly async {
    return Future.delayed(const Duration(seconds: 0), () {
      return UnmodifiableListView(_items);
    });
  }

  void _addInitaSamples() async {
    _items.add(SampleItem(
        id: 1,
        imageUrl:
            'https://ih1.redbubble.net/image.1076712667.1327/ssrco,classic_tee,flatlay,denim_heather,front,wide_portrait,750x1000.jpg',
        name: 'Join the Dart Side'));
    _items.add(SampleItem(
        id: 2,
        imageUrl:
            'https://ih1.redbubble.net/image.1848721744.2309/ur,mug_lifestyle,square,1000x1000.jpg',
        name: 'Flutter Tasse'));
    _items.add(SampleItem(
        id: 4,
        imageUrl:
            'https://image.spreadshirtmedia.net/image-server/v1/mp/products/T631A2MPA4699PT17X6Y1D195950234FS8679/views/1,width=1200,height=1200,appearanceId=2,backgroundColor=F2F2F2,modelId=2162,crop=detail/lets-flutter-frauen-t-shirt.jpg',
        name: 'Flutter Shirt'));
    _items.add(SampleItem(
        id: 3,
        imageUrl:
            'https://ih1.redbubble.net/image.1003270426.6507/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.jpg',
        name: 'Flutter Stickers'));
  }

  SampleItem getWithid(int id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void reset() {
    _items.clear();
    _addInitaSamples();
  }
}
