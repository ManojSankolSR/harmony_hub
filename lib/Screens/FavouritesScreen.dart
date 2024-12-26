import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Widgets/DownloadButton.dart';
import 'package:harmony_hub/Widgets/NotFoundWidget.dart';
import 'package:hive_flutter/adapters.dart';

class Favouritesscreen extends ConsumerWidget {
  const Favouritesscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: Boxes.UserBox.listenable(keys: ["user"]),
          builder: (context, value, child) {
            List<Map<String, dynamic>> SongsHistory = Boxes.getFavSongs();
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    stretchModes: const [StretchMode.fadeTitle],
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Favourite ",
                        ),
                        Text("Songs  ",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                        Icon(
                          Icons.favorite,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ],
                    ),
                    // background: Container(
                    //   decoration: BoxDecoration(
                    //       gradient: LinearGradient(
                    //           begin: Alignment.topCenter,
                    //           end: Alignment.bottomCenter,
                    //           colors: [
                    //         Theme.of(context).colorScheme.onPrimary,
                    //         Theme.of(context).colorScheme.surface,
                    //       ])),
                    // ),
                  ),
                  // expandedHeight: 150,
                  centerTitle: true,
                  pinned: true,
                ),
                if (SongsHistory.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Notfoundwidget()),
                  ),
                if (SongsHistory.isNotEmpty)
                  SliverList.builder(
                    itemCount: SongsHistory.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey(SongsHistory[index]["id"]),
                        onDismissed: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            await Boxes.deleteSongFromFav(SongsHistory[index]);
                          }
                        },
                        background: Container(
                          color: Colors.red,
                        ),
                        child: ListTile(
                            leading: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 60,
                                width: 60,
                                imageUrl: SongsHistory[index]["image"]
                                            .runtimeType ==
                                        List
                                    ? SongsHistory[index]["image"][2]["link"]
                                    : SongsHistory[index]["image"],
                                placeholder: (context, url) => Image.asset(
                                    fit: BoxFit.cover, "assets/album.png"),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        fit: BoxFit.cover, "assets/album.png"),
                              ),
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
                                DownloadButton(songData: SongsHistory[index])
                              ],
                            )),
                      );
                    },
                  )
              ],
            );
          }),
    );
  }
}
