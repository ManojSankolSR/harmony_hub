import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Functions/Storage.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Functions/Playlist.dart';
import 'package:harmony_hub/Functions/MusicPlayer.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Screens/SongPlayScreen.dart';
import 'package:harmony_hub/Widgets/CategoryListView.dart';
import 'package:harmony_hub/Widgets/CustomButton.dart';
import 'package:harmony_hub/Widgets/DownloadButton.dart';
import 'package:harmony_hub/Widgets/LikeButton.dart';
import 'package:harmony_hub/Widgets/SongBottomBarWidget.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:sliver_snap/sliver_snap.dart';

class Trackslistscreen extends ConsumerWidget {
  final String id;
  final String type;
  final TextEditingController _textEditingController = TextEditingController();

  Trackslistscreen({
    super.key,
    required this.id,
    required this.type,
  });

  Future<Color> _getColorFromImage(String url) async {
    final imageloc = Image.network(url).image;
    final paletteGenerator = await PaletteGenerator.fromImageProvider(imageloc);

    return paletteGenerator.dominantColor?.color ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: ref
            .watch(type == "playlist"
                ? PlayListDataProvider(id)
                : AlbumDataProvider(id))
            .when(
              data: (data) {
                return CustomScrollView(
                  slivers: [
                    FutureBuilder(
                        future: _getColorFromImage(
                            data["image"].runtimeType == List
                                ? data["image"][2]["link"]
                                : data["image"]),
                        builder: (context, snapshot) {
                          return SliverAppBar(
                            pinned: true,
                            stretch: true,
                            expandedHeight: 240,
                            flexibleSpace: FlexibleSpaceBar(
                              stretchModes: [
                                StretchMode.zoomBackground,
                                // StretchMode.blurBackground
                              ],
                              background: Container(
                                alignment: Alignment.bottomCenter,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                      snapshot.data ?? Colors.transparent,
                                      Colors.transparent
                                    ])),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: SizedBox(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        clipBehavior: Clip.antiAlias,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                .42,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .42,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                                    fit: BoxFit.cover,
                                                    "assets/album.png"),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                                        fit: BoxFit.cover,
                                                        "assets/album.png"),
                                            imageUrl:
                                                data["image"].runtimeType ==
                                                        List
                                                    ? data["image"][2]["link"]
                                                    : data["image"]),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data["name"],
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                            Text(
                                              "${data["list_count"]} Songs",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            Text(
                                              "${data["subtitle"]} ${data["type"]}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Custombutton(
                                                backgroundcolor:
                                                    snapshot.data ??
                                                        Colors.transparent,
                                                ontap: () {
                                                  CustomNavigation.NavigateTo(
                                                    data["songs"][0]["type"],
                                                    context,
                                                    id,
                                                    data["songs"],
                                                    0,
                                                    false,
                                                  );
                                                },
                                                lable: "Play",
                                                icon: Icon(Icons.play_arrow))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Text(
                          "Songs",
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                        valueListenable: Boxes.UserBox.listenable(),
                        builder: (context, value, child) {
                          return SliverList.builder(
                              itemCount: data["songs"].length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: ListTile(
                                      leading: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            height: 60,
                                            width: 60,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                                    fit: BoxFit.cover,
                                                    "assets/album.png"),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                                        fit: BoxFit.cover,
                                                        "assets/album.png"),
                                            imageUrl: data["songs"][index]
                                                            ["image"]
                                                        .runtimeType ==
                                                    List
                                                ? data["songs"][index]["image"]
                                                    [2]["link"]
                                                : data["songs"][index]
                                                    ["image"]),
                                      ),

                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.circular(5)),
                                      //   clipBehavior: Clip.hardEdge,
                                      //   child: Image.network(
                                      //       data["songs"][index]["image"].runtimeType ==
                                      //               List
                                      //           ? data["songs"][index]["image"][2]["link"]
                                      //           : data["songs"][index]["image"]),
                                      // ),
                                      title: Text(
                                        data["songs"][index]["name"],
                                        maxLines: 1,
                                      ),
                                      subtitle: Text(
                                        data["songs"][index]["subtitle"],
                                        maxLines: 1,
                                      ),
                                      onTap: () async {
                                        CustomNavigation.NavigateTo(
                                          data["songs"][index]["type"],
                                          context,
                                          id,
                                          data["songs"],
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
                                          Likebutton(
                                              songData: data["songs"][index]),
                                          IconButton(
                                              onPressed: () {
                                                Playlists.showPlayListDialog(
                                                    songdata: data["songs"]
                                                        [index],
                                                    textEditingController:
                                                        _textEditingController,
                                                    context: context);
                                              },
                                              icon: Icon(Icons.playlist_add)),
                                          DownloadButton(
                                              songData: data["songs"][index])
                                        ],
                                      )),
                                );
                              });
                        })
                  ],
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
            ));
  }
}
