import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:routing_1_0/src/screens/sample_feature/model/sample_item.dart';
import 'package:routing_1_0/src/screens/sample_feature/repo/sample.repo.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  SampleItemDetailsView({Key? key, int? this.id}) : super(key: key);

  static const routeName = '/sample_item';
  int? id;

  @override
  Widget build(BuildContext context) {
    SampleItem item;
    try {
      // Special Case if we come from app page
      var arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        id = arg as int;
      }
      //
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
    print(item.id);
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
                      child: Image.network(
                        imageUrl,
                        height: 200,
                        width: 200,
                      )),
                ],
              ),
            )),
            Container(
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
                            restorationId: 'sampleItemListView',
                            itemCount: items!.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = items[index];
                              String imageUrl = item.imageUrl!.isEmpty
                                  ? 'https://flutter.de/images/flutter_de-logo_klein.png'
                                  : item.imageUrl ??
                                      'https://flutter.de/images/flutter_de-logo_klein.png';
                              return Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.restorablePushNamed(context,
                                        SampleItemDetailsView.routeName,
                                        arguments: item.id);
                                  },
                                  child: Container(
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
                                                child: Image.network(
                                                  imageUrl,
                                                  height: 50,
                                                  width: 50,
                                                )),
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
