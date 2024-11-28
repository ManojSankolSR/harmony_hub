import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Functions/Playlist.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Widgets/NotFoundWidget.dart';
import 'package:harmony_hub/Widgets/PlaylistImageWidget.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Playlistscreen extends ConsumerWidget {
  final PersistentTabController _persistentTabController;

  const Playlistscreen(
      {super.key, required PersistentTabController persistentTabController})
      : _persistentTabController = persistentTabController;
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
                  "Play",
                ),
                Text("Liststs  ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    )),
                Icon(
                  Icons.my_library_music_rounded,
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
                    Theme.of(context).colorScheme.surface,
                  ])),
            ),
          ),
          expandedHeight: 150,
          centerTitle: true,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.horizontal_split_rounded),
                onPressed: () {
                  _persistentTabController.openDrawer();
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
        //     title:
        //         // RichText(
        //         //     text: TextSpan(
        //         //         style: Theme.of(context).textTheme.titleLarge!,
        //         //         children: [
        //         //       TextSpan(
        //         //         text: "Play",
        //         //       ),
        //         //       TextSpan(
        //         //           text: "Liststs",
        //         //           style: TextStyle(
        //         //             color: Theme.of(context).colorScheme.primary,
        //         //           ))
        //         //     ]))
        //         Row(
        //       children: [
        //         Text(
        //           "Play",
        //         ),
        //         Text("Liststs",
        //             style: TextStyle(
        //               color: Theme.of(context).colorScheme.primary,
        //             ))
        //       ],
        //     )),
        ValueListenableBuilder(
            valueListenable: Boxes.UserBox.listenable(),
            builder: (context, value, child) {
              List<Map<String, dynamic>> playlists = Playlists.getPlylists();
              if (playlists.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Notfoundwidget()),
                );
              }
              return SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: (1 / 1.2),
                    mainAxisSpacing: 0,
                    crossAxisCount: 2),
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return showPlaylist(playlist: playlists[index]);
                        },
                      ));
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Playlistimagewidget(
                                  images: List.generate(
                                    playlists[index]["songs"].length,
                                    (ind) {
                                      return playlists[index]["songs"][ind]
                                                      ["image"]
                                                  .runtimeType ==
                                              List
                                          ? playlists[index]["songs"][ind]
                                              ["image"][2]["link"]
                                          : playlists[index]["songs"][ind]
                                              ["image"];
                                    },
                                  ),
                                  length: playlists[index]["songs"].length),
                            ),
                            Text(
                              playlists[index]["name"],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w500),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${playlists[index]["songs"].length} Songs",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w400),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            )
                            // Positioned(
                            //     bottom: 0,
                            //     left: 0,
                            //     right: 0,
                            //     child: Container(
                            //       clipBehavior: Clip.antiAliasWithSaveLayer,
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.only(
                            //               bottomLeft: Radius.circular(10),
                            //               bottomRight: Radius.circular(10)),
                            //           gradient: LinearGradient(
                            //               begin: Alignment.topCenter,
                            //               end: Alignment.bottomCenter,
                            //               colors: [
                            //                 Colors.black45,
                            //                 Colors.black
                            //               ])),
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //               _playlists[index]["name"],
                            //               style: Theme.of(context)
                            //                   .textTheme
                            //                   .titleMedium!
                            //                   .copyWith(
                            //                       fontWeight: FontWeight.w500),
                            //               softWrap: false,
                            //               overflow: TextOverflow.ellipsis,
                            //             ),
                            //             Text(
                            //               "${_playlists[index]["songs"].length} Songs",
                            //               style: Theme.of(context)
                            //                   .textTheme
                            //                   .labelSmall!
                            //                   .copyWith(
                            //                       color: Colors.white70,
                            //                       fontWeight: FontWeight.w400),
                            //               softWrap: false,
                            //               overflow: TextOverflow.ellipsis,
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ))
                          ],
                        )),
                  );
                },
              );
            })
      ],
    );
  }
}

class showPlaylist extends ConsumerWidget {
  final Map<String, dynamic> playlist;

  const showPlaylist({super.key, required this.playlist});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              stretchModes: const [
                StretchMode.fadeTitle,
                StretchMode.blurBackground,
                StretchMode.zoomBackground
              ],
              titlePadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "PlayList : ",
                    overflow: TextOverflow.ellipsis,
                  ),
                  Flexible(
                    child: Text(playlist["name"],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.my_library_music_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  )
                ],
              ),
              background: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Theme.of(context).colorScheme.onPrimary,
                      Colors.transparent
                    ])),
                child: UnconstrainedBox(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.width * .4,
                    child: Playlistimagewidget(
                        images: List.generate(
                          playlist["songs"].length,
                          (ind) {
                            return playlist["songs"][ind]["image"]
                                        .runtimeType ==
                                    List
                                ? playlist["songs"][ind]["image"][2]["link"]
                                : playlist["songs"][ind]["image"];
                          },
                        ),
                        length: playlist["songs"].length),
                  ),
                ),
              ),
            ),
            expandedHeight: 300,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            pinned: true,
          ),
          // SliverAppBar.medium(

          //     // centerTitle: true,
          //     pinned: true,
          //     title: Row(
          //       children: [
          //         Text(
          //           "PlayList: ",
          //         ),
          //         Text(playlist["name"],
          //             style: TextStyle(
          //               color: Theme.of(context).colorScheme.primary,
          //             ))
          //       ],
          //     )),
          SliverList.builder(
            itemCount: playlist["songs"].length,
            itemBuilder: (context, index) {
              Map<dynamic, dynamic> song = playlist["songs"][index];
              return ListTile(
                  leading: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                        imageUrl: song["image"].runtimeType == List
                            ? song["image"][2]["link"]
                            : song["image"]),
                  ),
                  title: Text(
                    song["name"],
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    song["subtitle"],
                    maxLines: 1,
                  ),
                  onTap: () {
                    CustomNavigation.NavigateTo(
                      ref: ref,
                      song["type"],
                      context,
                      "",
                      playlist["songs"],
                      index,
                      false,
                    );
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => SongsPlayScreen(
                    //         AudioData: playlist,
                    //         startIndex: index,
                    //       ),
                    //     ));
                    // CustomNavigation.NavigateTo(
                    //     type, context, id, [data]);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Likebutton(songData: _song),
                    ],
                  ));
            },
          ),
        ],
      ),
    );
  }
}
