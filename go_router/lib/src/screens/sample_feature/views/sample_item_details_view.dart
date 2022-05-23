import 'dart:collection';
import 'dart:html';

import 'package:flutter/material.dart';

import 'package:routing_2_0/src/screens/sample_feature/model/sample_item.dart';
import 'package:routing_2_0/src/screens/sample_feature/repo/sample.repo.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui' as ui;

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  SampleItemDetailsView({Key? key, int? this.id}) : super(key: key);

  int? id;

  @override
  Widget build(BuildContext context) {
    SampleItem item;

    try {
      if (id != null) {
        item = SampleRepo().getWithid(id!);
      } else {
        item = SampleRepo().getWithid(1);
      }
    } on Exception catch (_) {
      item = SampleRepo().getWithid(1);
    }

    String imageUrl = item.imageUrl!.isEmpty
        ? 'https://flutter.de/images/flutter_de-logo_klein.png'
        : item.imageUrl ??
            'https://flutter.de/images/flutter_de-logo_klein.png';

    ui.platformViewRegistry.registerViewFactory(
      imageUrl,
      (int _) => ImageElement()..src = imageUrl,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details ${item.id}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
                child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    title: Text(item.name ?? ''),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: !kIsWeb
                        ? Image.network(
                            imageUrl,
                            height: 200,
                            width: 200,
                          )
                        : Container(
                            height: 200,
                            width: 200,
                            child: HtmlElementView(
                              viewType: imageUrl,
                            ),
                          ),
                  ),
                ],
              ),
            )),
            SizedBox(
                height: 200,
                child: FutureBuilder<UnmodifiableListView<SampleItem>>(
                    future: SampleRepo().itemsDirectly,
                    builder: (context,
                        AsyncSnapshot<UnmodifiableListView<SampleItem>>
                            snapshot) {
                      if (snapshot.hasData) {
                        var items = snapshot.data;
                        return ListView.builder(
                            shrinkWrap: false,
                            scrollDirection: Axis.horizontal,
                            itemCount: items!.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = items[index];
                              String imageUrl = item.imageUrl!.isEmpty
                                  ? 'https://flutter.de/images/flutter_de-logo_klein.png'
                                  : item.imageUrl ??
                                      'https://flutter.de/images/flutter_de-logo_klein.png';

                              ui.platformViewRegistry.registerViewFactory(
                                imageUrl,
                                (int _) => ImageElement()..src = imageUrl,
                              );
                              return Center(
                                child: InkWell(
                                  onTap: () {
                                    context.go('/home/items/${item.id}');
                                  },
                                  child: SizedBox(
                                    height: 150,
                                    width: 200,
                                    child: Center(
                                      child: Card(
                                        clipBehavior: Clip.antiAlias,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: Text(item.name ?? ''),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: !kIsWeb
                                                  ? Image.network(
                                                      imageUrl,
                                                      height: 50,
                                                      width: 50,
                                                    )
                                                  : Container(
                                                      height: 50,
                                                      width: 50,
                                                      child: HtmlElementView(
                                                        viewType: imageUrl,
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                      return Text('');
                    }))
          ],
        ),
      ),
    );
  }
}
