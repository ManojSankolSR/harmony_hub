import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/GlobalConstants.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Widgets/AddToPlaylistButton.dart';
import 'package:harmony_hub/Widgets/CustomButton.dart';
import 'package:harmony_hub/Widgets/DownloadButton.dart';
import 'package:harmony_hub/Widgets/LikeButton.dart';
import 'package:hive_flutter/adapters.dart';
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
    final imageloc = CachedNetworkImageProvider(url);
    final paletteGenerator = await PaletteGenerator.fromImageProvider(imageloc);

    return paletteGenerator.dominantColor?.color ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body:
            //   FutureBuilder(
            //     future: type == "playlist"
            //         ? SavanApi.getPlayListdata(id)
            //         : SavanApi.getAlbumdata(id),
            //     builder: (context, snapshot) {
            //       print(snapshot.hasData);
            //       if (snapshot.hasData) {
            //         final playlistData = snapshot.data!;
            //         return _TracksListWidget(
            //             playlistData: playlistData, context: context, ref: ref);
            //       } else if (snapshot.hasError) {
            //         final error = snapshot.error!;
            //         return _error(context: context, ref: ref, error: error.toString());
            //       }
            //       return _loading(context: context, ref: ref);
            //     },
            //   ),
            // );

            ref
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
                  error: (error, stackTrace) => _error(
                      context: context, ref: ref, error: error.toString()),
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
          const Icon(
            Icons.error,
            size: 50,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Sorry Some Error Occured"),
          TextButton(
              onPressed: () {
                ref.invalidate(type == "playlist"
                    ? PlayListDataProvider(id)
                    : AlbumDataProvider(id));
              },
              child: const Text("Refresh"))
        ],
      ),
    );
  }

  Widget _loading({required BuildContext context, required WidgetRef ref}) {
    const Map<String, dynamic> playlistData =
        Globalconstants.PlaylistLoadingData;
    return Skeletonizer(
        child: _TracksListWidget(
            playlistData: playlistData, context: context, ref: ref));
  }

  Widget _TracksListWidget(
      {required Map<String, dynamic> playlistData,
      required BuildContext context,
      required WidgetRef ref}) {
    return CustomScrollView(
      cacheExtent: 20,
      slivers: [
        _appBar(playlistData: playlistData, ref: ref),
        const SliverToBoxAdapter(
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
    final String playListImage = playlistData["image"].runtimeType == List
        ? playlistData["image"][2]["link"]
        : playlistData["image"];
    return FutureBuilder(
        future: _getColorFromImage(playListImage),
        builder: (context, snapshot) {
          return SliverLayoutBuilder(builder: (context, constraints) {
            bool isCollapsed = constraints.scrollOffset >= 190;

            return SliverAppBar(
              pinned: true,
              stretch: true,
              titleSpacing: 0,
              toolbarHeight: 65,
              expandedHeight: 240,
              automaticallyImplyLeading: !isCollapsed,
              title: isCollapsed
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton.outlined(
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // backgroundColor: snapshot.data
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios_new_rounded)),
                        // GestureDetector(
                        //     onTap: () {
                        //       Navigator.pop(context);
                        //     },
                        //     child: const Icon(Icons.arrow_back)),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Image.asset(
                                  fit: BoxFit.cover, "assets/album.png"),
                              errorWidget: (context, url, error) => Image.asset(
                                  fit: BoxFit.cover, "assets/album.png"),
                              imageUrl: playListImage),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                playlistData["name"],
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "${playlistData["list_count"]} Songs",
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton.outlined(
                            color: Colors.white,
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // backgroundColor: snapshot.data
                            ),
                            onPressed: () {
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
                            icon: const Icon(Icons.play_arrow)),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ).animate().fadeIn()
                  : null,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
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
                        Theme.of(context).colorScheme.surface
                      ])),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
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
                              imageUrl: playListImage),
                        ),
                        const SizedBox(
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
                              const SizedBox(
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
                                  icon: const Icon(Icons.play_arrow))
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
        });
  }
}
