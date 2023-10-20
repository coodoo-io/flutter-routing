import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routing_2_0/src/enum/page_state.dart';
import 'package:routing_2_0/src/routing/page_action.dart';
import 'package:routing_2_0/src/routing/page_configuration.dart';
import 'package:routing_2_0/src/screens/sample_feature/model/sample_item.dart';
import 'package:routing_2_0/src/screens/sample_feature/repo/sample.repo.dart';
import 'package:routing_2_0/src/screens/sample_feature/views/sample_item_details_view.dart';
import 'package:routing_2_0/src/screens/settings/settings_view.dart';
import 'package:routing_2_0/src/state/app_state.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  SampleItemListView({
    Key? key,
  }) : super(key: key);
  late AppState appState;

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sample Items'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                appState.currentConfiguration = settingsPageConfiguration;
                appState.currentAction = PageAction(
                    state: PageState.addPage,
                    page: settingsPageConfiguration,
                    widget:
                        SettingsView(controller: appState.settingsController));
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
                            detailPageConfiguration.id = item.id;
                            appState.currentConfiguration =
                                detailPageConfiguration;
                            appState.currentAction = PageAction(
                                state: PageState.addPage,
                                page: detailPageConfiguration,
                                widget: SampleItemDetailsView(
                                  id: item.id,
                                ));
                          });
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
