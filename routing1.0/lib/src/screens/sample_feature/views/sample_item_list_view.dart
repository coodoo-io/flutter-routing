import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:routing_1_0/src/screens/sample_feature/model/sample_item.dart';
import 'package:routing_1_0/src/screens/sample_feature/repo/sample.repo.dart';
import 'package:routing_1_0/src/screens/settings/settings_view.dart';

import 'sample_item_details_view.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  SampleItemListView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sample Items'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
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
                      return ListTile(
                          title: Text('${item.name} ${item.id}'),
                          subtitle: Text(item.description ?? ''),
                          leading: CircleAvatar(
                            // Display the Flutter Logo image asset.
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                          onTap: () {
                            Navigator.restorablePushNamed(
                                context, SampleItemDetailsView.routeName,
                                arguments: item.id);
                          });
                    });
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
