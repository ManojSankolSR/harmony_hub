import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Functions/Storage.dart';
import 'package:harmony_hub/GlobalConstants.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Functions/Playlist.dart';
import 'package:harmony_hub/Functions/MusicPlayer.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Providers/seedColorProvider.dart';
import 'package:harmony_hub/Screens/SongPlayScreen.dart';
import 'package:harmony_hub/Widgets/AddToPlaylistButton.dart';
import 'package:harmony_hub/Widgets/CategoryListView.dart';
import 'package:harmony_hub/Widgets/CustomButton.dart';
import 'package:harmony_hub/Widgets/DownloadButton.dart';
import 'package:harmony_hub/Widgets/LikeButton.dart';
import 'package:harmony_hub/Widgets/MiniPlayerNavigationHandler.dart';
import 'package:harmony_hub/Widgets/SongBottomBarWidget.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    final imageloc = NetworkImage(url);
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
              skipLoadingOnRefresh: false,
              skipLoadingOnReload: false,
              data: (playlistData) {
                return _TracksListWidget(
                    playlistData: playlistData, context: context, ref: ref);
              },
              error: (error, stackTrace) =>
                  _error(context: context, ref: ref, error: error.toString()),
              loading: () => _loading(context: context, ref: ref),
            ));
  }

  Widget _error(
      {required BuildContext context,
      required WidgetRef ref,
      required String error}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 50,
          ),
          SizedBox(
            height: 20,
          ),
          Text("Sorry Some Error Occured"),
          TextButton(
              onPressed: () {
                ref.invalidate(type == "playlist"
                    ? PlayListDataProvider(id)
                    : AlbumDataProvider(id));
              },
              child: Text("Refresh"))
        ],
      ),
    );
  }

  Widget _loading({required BuildContext context, required WidgetRef ref}) {
    const Map<String, dynamic> _playlistData =
        Globalconstants.PlaylistLoadingData;
    return Skeletonizer(
        child: _TracksListWidget(
            playlistData: _playlistData, context: context, ref: ref));
  }

  Widget _TracksListWidget(
      {required Map<String, dynamic> playlistData,
      required BuildContext context,
      required WidgetRef ref}) {
    return CustomScrollView(
      slivers: [
        _appBar(playlistData: playlistData, ref: ref),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              "Songs",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        _songsListview(playlistData: playlistData, context: context, ref: ref),
      ],
    );
  }

  Widget _songsListview(
      {required Map<String, dynamic> playlistData,
      required BuildContext context,
      required WidgetRef ref}) {
    return ValueListenableBuilder(
        valueListenable: Boxes.UserBox.listenable(),
        builder: (context, value, child) {
          return SliverList.builder(
              itemCount: playlistData["songs"].length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: ListTile(
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
                            imageUrl: playlistData["songs"][index]["image"]
                                        .runtimeType ==
                                    List
                                ? playlistData["songs"][index]["image"][2]
                                    ["link"]
                                : playlistData["songs"][index]["image"]),
                      ),
                      title: Text(
                        playlistData["songs"][index]["name"],
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        playlistData["songs"][index]["subtitle"],
                        maxLines: 1,
                      ),
                      onTap: () async {
                        CustomNavigation.NavigateTo(
                          ref: ref,
                          playlistData["songs"][index]["type"],
                          context,
                          id,
                          playlistData["songs"],
                          index,
                          false,
                        );
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Likebutton(songData: playlistData["songs"][index]),
                          AddToPlayListButton(
                              songdata: playlistData["songs"][index]),
                          DownloadButton(songData: playlistData["songs"][index])
                        ],
                      )),
                );
              });
        });
  }

  Widget _appBar(
      {required Map<String, dynamic> playlistData, required WidgetRef ref}) {
    return FutureBuilder(
        future: _getColorFromImage(playlistData["image"].runtimeType == List
            ? playlistData["image"][2]["link"]
            : playlistData["image"]),
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        clipBehavior: Clip.antiAlias,
                        height: MediaQuery.of(context).size.width * .42,
                        width: MediaQuery.of(context).size.width * .42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                                fit: BoxFit.cover, "assets/album.png"),
                            errorWidget: (context, url, error) => Image.asset(
                                fit: BoxFit.cover, "assets/album.png"),
                            imageUrl: playlistData["image"].runtimeType == List
                                ? playlistData["image"][2]["link"]
                                : playlistData["image"]),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playlistData["name"],
                              maxLines: 2,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              "${playlistData["list_count"]} Songs",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "${playlistData["subtitle"]} ${playlistData["type"]}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Custombutton(
                                backgroundcolor:
                                    snapshot.data ?? Colors.transparent,
                                ontap: () {
                                  CustomNavigation.NavigateTo(
                                    ref: ref,
                                    playlistData["songs"][0]["type"],
                                    context,
                                    id,
                                    playlistData["songs"],
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
        });
  }
}
