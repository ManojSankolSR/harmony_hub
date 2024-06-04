import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Widgets/DownloadButton.dart';
import 'package:harmony_hub/Widgets/NotFoundWidget.dart';
import 'package:hive_flutter/adapters.dart';

class Historyscreen extends ConsumerWidget {
  // List<Map<dynamic, dynamic>> SongsHistory = Boxes.getSongsHistory();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
              leading: Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.horizontal_split_rounded),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
              // centerTitle: true,
              pinned: true,
              title: Row(
                children: [
                  Text(
                    "Recently ",
                  ),
                  Text("Played",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ))
                ],
              )),
          ValueListenableBuilder(
              valueListenable: Boxes.UserBox.listenable(),
              builder: (context, value, child) {
                List<Map<String, dynamic>> SongsHistory =
                    Boxes.getSongsHistory();
                if (SongsHistory.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Notfoundwidget()),
                  );
                }
                return SliverList.builder(
                  itemCount: SongsHistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: 60,
                              width: 60,
                              placeholder: (context, url) => Image.asset(
                                  fit: BoxFit.cover, "assets/album.png"),
                              errorWidget: (context, url, error) => Image.asset(
                                  fit: BoxFit.cover, "assets/album.png"),
                              imageUrl:
                                  SongsHistory[index]["image"].runtimeType ==
                                          List
                                      ? SongsHistory[index]["image"][2]["link"]
                                      : SongsHistory[index]["image"]),
                        ),
                        title: Text(
                          SongsHistory[index]["name"],
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          SongsHistory[index]["subtitle"],
                          maxLines: 1,
                        ),
                        onTap: () {
                          CustomNavigation.NavigateTo(
                            SongsHistory[index]["type"],
                            context,
                            "",
                            SongsHistory,
                            index,
                            false,
                          );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DownloadButton(
                              songData: SongsHistory[index],
                            )
                          ],
                        ));
                  },
                );
              })
        ],
      ),
    );
  }
}
