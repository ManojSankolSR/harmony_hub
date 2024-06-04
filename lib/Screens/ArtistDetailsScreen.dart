import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Widgets/MusicListWidget.dart';
import 'package:harmony_hub/Widgets/CategoryListView.dart';
import 'package:harmony_hub/Widgets/SongBottomBarWidget.dart';
import 'package:palette_generator/palette_generator.dart';

class Artistdetailsscreen extends ConsumerWidget {
  final String id;

  Artistdetailsscreen({super.key, required this.id});
  Future<Color> _getColorFromImage(String url) async {
    final imageloc = Image.network(url).image;
    final paletteGenerator = await PaletteGenerator.fromImageProvider(imageloc);

    return paletteGenerator.dominantColor?.color ?? Colors.transparent;
  }

  Widget _AlbumAndPlaylist_ListWidget(
    Map<String, dynamic> data,
    String tag,
  ) {
    return SliverToBoxAdapter(
      child: data[tag].isNotEmpty
          ? MusicListWidget(musicData: {
              "title": data["modules"][tag]["title"],
              "data": data[tag]
            })
          : SizedBox(),
    );
  }

  ValueNotifier _songImageColor = ValueNotifier<Color>(Colors.transparent);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: const Songbottombarwidget(),
      body: ref.watch(ArtistDataProvider(id)).when(
            data: (data) {
              return CustomScrollView(
                cacheExtent: 0,
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 400,

                    // title: ListTile(
                    //   tileColor: Colors.red,
                    //   contentPadding: EdgeInsets.all(0),
                    //   leading: CachedNetworkImage(
                    //     fit: BoxFit.fill,
                    //     imageUrl: data["image"].runtimeType == List
                    //         ? data["image"][2]["link"]
                    //         : data["image"],
                    //   ),
                    //   title: Text(data["name"]),
                    //   subtitle: Text(data["subtitle"]),
                    // ),

                    stretch: true,
                    flexibleSpace: FutureBuilder(
                        future: _getColorFromImage(
                            data["image"].runtimeType == List
                                ? data["image"][2]["link"]
                                : data["image"]),
                        builder: (context, snapshot) {
                          return Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  snapshot.data ?? Colors.transparent,
                                  Colors.transparent
                                ])),
                            clipBehavior: Clip.hardEdge,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              double _progress =
                                  (constraints.maxHeight - 70) / (400 - 70) > 1
                                      ? 1
                                      : (constraints.maxHeight - 70) /
                                          (400 - 70);

                              return FlexibleSpaceBar(
                                stretchModes: [
                                  StretchMode.blurBackground,
                                  StretchMode.zoomBackground
                                ],
                                title: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      data["name"].toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      data["subtitle"].toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                titlePadding: EdgeInsets.lerp(
                                    EdgeInsets.only(bottom: 10),
                                    EdgeInsets.only(bottom: 1),
                                    _progress),
                                centerTitle: true,
                                background: UnconstrainedBox(
                                  child: Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .7,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .35,
                                        margin: EdgeInsets.all(15),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
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
                                      Positioned(
                                          bottom: 0,
                                          right: 45,
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: snapshot.data ??
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryFixedVariant,
                                            ),
                                            child: Icon(
                                              Icons.play_arrow,
                                              size: 35,
                                            ),
                                          )).animate().scale(),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                  ),
                  SliverToBoxAdapter(
                    child: CategorylistviewWidget(
                        searchcategoryData: data["top_songs"],
                        categoryTitle: data["modules"]["top_songs"]["title"]),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 15,
                    ),
                  ),
                  _AlbumAndPlaylist_ListWidget(data, "latest_release"),
                  _AlbumAndPlaylist_ListWidget(data, "top_albums"),
                  _AlbumAndPlaylist_ListWidget(
                      data, "dedicated_artist_playlist"),
                  _AlbumAndPlaylist_ListWidget(
                      data, "featured_artist_playlist"),
                  _AlbumAndPlaylist_ListWidget(data, "singles"),
                  _AlbumAndPlaylist_ListWidget(data, "similar_artists"),
                ],
              );
            },
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
