import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Widgets/DownloadButton.dart';
import 'package:harmony_hub/Widgets/LikeButton.dart';
import 'package:harmony_hub/Widgets/NotFoundWidget.dart';
import 'package:hive_flutter/adapters.dart';

class Historyscreen extends ConsumerWidget {
  const Historyscreen({super.key});

  // List<Map<dynamic, dynamic>> SongsHistory = Boxes.getSongsHistory();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            stretchModes: const [StretchMode.fadeTitle],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Recently ",
                ),
                Text("Played  ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    )),
                Icon(
                  Icons.history,
                  color: Theme.of(context).colorScheme.primary,
                )
              ],
            ),
            background: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Theme.of(context).colorScheme.onPrimary,
                    Theme.of(context).colorScheme.surface
                  ])),
            ),
          ),
          expandedHeight: 150,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.horizontal_split_rounded),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          pinned: true,
        ),
        // SliverAppBar.medium(
        //     leading: IconButton(
        //       icon: Icon(Icons.horizontal_split_rounded),
        //       onPressed: () {
        //         Scaffold.of(context).openDrawer();
        //       },
        //     ),
        //     // centerTitle: true,
        //     pinned: true,
        //     title: Row(
        //       children: [
        //         Text(
        //           "Recently ",
        //         ),
        //         Text("Played",
        //             style: TextStyle(
        //               color: Theme.of(context).colorScheme.primary,
        //             ))
        //       ],
        //     )),
        ValueListenableBuilder(
            valueListenable: Boxes.UserBox.listenable(),
            builder: (context, value, child) {
              List<Map<String, dynamic>> SongsHistory = Boxes.getSongsHistory();
              if (SongsHistory.isEmpty) {
                return const SliverFillRemaining(
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
                                SongsHistory[index]["image"].runtimeType == List
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
                          ref: ref,
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
                          Likebutton(songData: SongsHistory[index]),
                          DownloadButton(
                            songData: SongsHistory[index],
                          )
                        ],
                      ));
                },
              );
            })
      ],
    );
  }
}
