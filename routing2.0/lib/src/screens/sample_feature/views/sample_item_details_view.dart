import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routing_2_0/src/enum/page_state.dart';
import 'package:routing_2_0/src/routing/page_action.dart';
import 'package:routing_2_0/src/routing/page_configuration.dart';
import 'package:routing_2_0/src/screens/sample_feature/model/sample_item.dart';
import 'package:routing_2_0/src/screens/sample_feature/repo/sample.repo.dart';
import 'package:routing_2_0/src/state/app_state.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  SampleItemDetailsView({Key? key, int? this.id}) : super(key: key);

  int? id;

  late AppState appState;
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
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
                              return Center(
                                child: InkWell(
                                  onTap: () {
                                    detailPageConfiguration.id = item.id;
                                    appState.currentConfiguration =
                                        detailPageConfiguration;
                                    appState.currentAction = PageAction(
                                        state: PageState.replace,
                                        page: detailPageConfiguration,
                                        widget: SampleItemDetailsView(
                                          id: item.id,
                                        ));
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
