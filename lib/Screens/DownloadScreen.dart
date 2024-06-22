import 'package:audiotags/audiotags.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Functions/AppPermissions.dart';
import 'package:harmony_hub/Functions/Storage.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Widgets/NotFoundWidget.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';

class Downloadscreen extends ConsumerWidget {
  final OnAudioQuery AudioQuery = OnAudioQuery();

  Future<List<SongModel>> _getDownloadedSongs() async {
    final songs = await AudioQuery.querySongs(
      path: "/storage/emulated/0/Music",
      uriType: UriType.EXTERNAL,
    );

    return songs;
  }

  Future<Tag> getAudioTag(String diaplayname) async {
    Tag? tag = await AudioTags.read("/storage/emulated/0/Music/$diaplayname");
    return tag!;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            stretchModes: [StretchMode.fadeTitle],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Down",
                ),
                Text("loads  ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    )),
                Icon(
                  Icons.file_download_outlined,
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
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.horizontal_split_rounded),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          pinned: true,
        ),
        // SliverAppBar.medium(
        //     leading: Builder(builder: (context) {
        //       return IconButton(
        //         icon: Icon(Icons.horizontal_split_rounded),
        //         onPressed: () {
        //           Scaffold.of(context).openDrawer();
        //         },
        //       );
        //     }),
        //     // centerTitle: true,
        //     pinned: true,
        //     title: Row(
        //       children: [
        //         Text(
        //           "Down",
        //         ),
        //         Text("loads",
        //             style: TextStyle(
        //               color: Theme.of(context).colorScheme.primary,
        //             ))
        //       ],
        //     )),
        FutureBuilder<PermissionStatus>(
            future: AppPermissions.requestAudioPermission(),
            builder: (context, snapshot) {
              if (snapshot.data == PermissionStatus.granted) {
                return ValueListenableBuilder(
                    valueListenable: Boxes.UserBox.listenable(),
                    builder: (context, value, child) {
                      return FutureBuilder(
                          future: _getDownloadedSongs(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              return SliverList.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: ValueKey(index),
                                    direction: DismissDirection.startToEnd,
                                    // confirmDismiss: (direction) async {},
                                    onDismissed: (direction) async {
                                      Tag tag = await getAudioTag(
                                          snapshot.data![index].displayName);
                                      await Downloads.deleteDownloadedFile(
                                          snapshot.data![index].displayName,
                                          context,
                                          tag.genre!);
                                    },
                                    background: Container(
                                      color: Colors.red,
                                    ),
                                    child: ListTile(
                                        leading: Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: QueryArtworkWidget(
                                              errorBuilder: (p0, p1, p2) {
                                                return Image.asset(
                                                    "assets/song.png");
                                              },
                                              nullArtworkWidget: Image.asset(
                                                  "assets/song.png"),
                                              artworkBorder:
                                                  BorderRadius.circular(1),
                                              id: snapshot.data![index].id,
                                              type: ArtworkType.AUDIO),
                                        ),
                                        title: Text(
                                          snapshot.data![index].title,
                                          maxLines: 1,
                                        ),
                                        subtitle: Text(
                                          snapshot.data![index].artist ??
                                              "Unknown",
                                          maxLines: 1,
                                        ),
                                        onTap: () {
                                          CustomNavigation.NavigateTo(
                                            ref: ref,
                                            "song",
                                            context,
                                            "",
                                            snapshot.data,
                                            index,
                                            false,
                                          );
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons
                                                    .download_done_rounded)),
                                          ],
                                        )),
                                  );
                                },
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SliverFillRemaining(
                                hasScrollBody: false,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                            return SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(child: Notfoundwidget()),
                            );
                          });
                    });
              } else {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Please Allow Audio Permission To Acess Downloaded songs",
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                            onPressed: () async {
                              final _permissionStatus =
                                  await AppPermissions.requestAudioPermission();
                              if (_permissionStatus ==
                                  PermissionStatus.permanentlyDenied) {
                                await openAppSettings();
                              }
                            },
                            child: Text("Click Here")),
                      ],
                    ),
                  ),
                );
              }
            })
      ],
    );
  }
}
