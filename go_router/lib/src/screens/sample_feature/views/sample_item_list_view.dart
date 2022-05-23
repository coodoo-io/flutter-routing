import 'dart:collection';
import 'dart:html';

import 'package:flutter/material.dart';

import 'package:routing_2_0/src/screens/sample_feature/model/sample_item.dart';
import 'package:routing_2_0/src/screens/sample_feature/repo/sample.repo.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  SampleItemListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sample Items'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.go('/home/settings');
              },
            ),
          ],
        ),
        body: FutureBuilder<UnmodifiableListView<SampleItem>>(
            future: SampleRepo().items,
            builder: (context,
                AsyncSnapshot<UnmodifiableListView<SampleItem>> snapshot) {
              if (snapshot.hasData) {
                final items = snapshot.data;
                return ListView.builder(
                    restorationId: 'sampleItemListView',
                    itemCount: items?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = items![index];
                      String imageUrl = item.imageUrl!.isEmpty
                          ? 'https://flutter.de/images/flutter_de-logo_klein.png'
                          : item.imageUrl ??
                              'https://flutter.de/images/flutter_de-logo_klein.png';
                      ui.platformViewRegistry.registerViewFactory(
                        imageUrl,
                        (int _) => ImageElement()..src = imageUrl,
                      );
                      return ListTile(
                          title: Text('${item.name} ${item.id}'),
                          subtitle: Text(item.description ?? ''),
                          leading: !kIsWeb
                              ? CircleAvatar(
                                  // Display the Flutter Logo image asset.
                                  backgroundImage: NetworkImage(imageUrl),
                                )
                              : Container(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(45.0),
                                    ),
                                    child: HtmlElementView(
                                      viewType: imageUrl,
                                    ),
                                  ),
                                ),
                          onTap: () {
                            context.go('/home/items/${item.id}');
                          });
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
