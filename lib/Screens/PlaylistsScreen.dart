import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Functions/Playlist.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Widgets/NotFoundWidget.dart';
import 'package:harmony_hub/Widgets/PlaylistImageWidget.dart';
import 'package:hive_flutter/adapters.dart';

class Playlistscreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return CustomScrollView(
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
                  "Play",
                ),
                Text("Liststs",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ))
              ],
            )),
        ValueListenableBuilder(
            valueListenable: Boxes.UserBox.listenable(),
            builder: (context, value, child) {
              List<Map<String, dynamic>> _playlists = Playlists.getPlylists();
              if (_playlists.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Notfoundwidget()),
                );
              }
              return SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: (1 / 1.2),
                    mainAxisSpacing: 0,
                    crossAxisCount: 2),
                itemCount: _playlists.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return showPlaylist(playlist: _playlists[index]);
                        },
                      ));
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Playlistimagewidget(
                                  images: List.generate(
                                    _playlists[index]["songs"].length,
                                    (ind) {
                                      return _playlists[index]["songs"][ind]
                                                      ["image"]
                                                  .runtimeType ==
                                              List
                                          ? _playlists[index]["songs"][ind]
                                              ["image"][2]["link"]
                                          : _playlists[index]["songs"][ind]
                                              ["image"];
                                    },
                                  ),
                                  length: _playlists[index]["songs"].length),
                            ),
                            Text(
                              _playlists[index]["name"],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w500),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${_playlists[index]["songs"].length} Songs",
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

class showPlaylist extends StatelessWidget {
  final Map<String, dynamic> playlist;

  const showPlaylist({super.key, required this.playlist});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(

              // centerTitle: true,
              pinned: true,
              title: Row(
                children: [
                  Text(
                    "PlayList: ",
                  ),
                  Text(playlist["name"],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ))
                ],
              )),
          SliverList.builder(
            itemCount: playlist["songs"].length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                        imageUrl:
                            playlist["songs"][index]["image"].runtimeType ==
                                    List
                                ? playlist["songs"][index]["image"][2]["link"]
                                : playlist["songs"][index]["image"]),
                  ),
                  title: Text(
                    playlist["songs"][index]["name"],
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    playlist["songs"][index]["subtitle"],
                    maxLines: 1,
                  ),
                  onTap: () {
                    CustomNavigation.NavigateTo(
                      playlist["songs"][index]["type"],
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.share)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.download)),
                    ],
                  ));
            },
          ),
        ],
      ),
    );
  }
}
