//

import 'package:animations/animations.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/DataModels/AlbumModel.dart';
import 'package:harmony_hub/Functions/SeedColor.dart';
import 'package:harmony_hub/Functions/ThemeModeHelper.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Providers/seedColorProvider.dart';
import 'package:harmony_hub/Screens/LyricsScreen.dart';
import 'package:harmony_hub/Widgets/AddToPlaylistButton.dart';
import 'package:harmony_hub/Widgets/ArtWorkWidget.dart';
import 'package:harmony_hub/Widgets/BottomPlaylistSheet.dart';
import 'package:harmony_hub/Widgets/CategoryListView.dart';
import 'package:harmony_hub/Widgets/DownloadButton.dart';
import 'package:harmony_hub/Widgets/LikeButton.dart';
import 'package:harmony_hub/Widgets/MusicListWidget.dart';
import 'package:harmony_hub/Widgets/MusicListWidget2.dart';
import 'package:harmony_hub/utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Miniaudioplayer extends ConsumerStatefulWidget {
  const Miniaudioplayer({super.key});

  @override
  ConsumerState<Miniaudioplayer> createState() => _MiniaudioplayerState();
}

class _MiniaudioplayerState extends ConsumerState<Miniaudioplayer> {
  static const double playerMinHeight = 75;
  late ScrollController _scrollController;
  late ItemScrollController _itemScrollController;

  static const double miniplayerPercentageDeclaration = 0.2;
  static ValueNotifier<double> playerExpandProgress = ValueNotifier(75);
  Future _getColorFromImage(String url) async {
    final imageloc = CachedNetworkImageProvider(url);
    final paletteGenerator = await PaletteGenerator.fromImageProvider(imageloc);

    _songImageColor.value = await ColorScheme.fromImageProvider(
      provider: imageloc,
    );
    // paletteGenerator.dominantColor?.color ?? Colors.transparent;
  }

  final ValueNotifier<ColorScheme> _songImageColor = ValueNotifier<ColorScheme>(
      ColorScheme.fromSeed(seedColor: SeedColor.getSeedColor()));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _itemScrollController = ItemScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final MiniplayerController miniplayerController =
        ref.watch(MiniplayerControllerProvider);
    final double playerMaxHeight = MediaQuery.of(context).size.height * .95;
    final audioPlayer = ref.watch(globalPlayerProvider);
    return StreamBuilder(
        stream: audioPlayer.sequenceStateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.currentSource != null) {
            final metadata = snapshot.data!.currentSource!.tag as MediaItem;
            final isFromDownloads = metadata.extras == null ? true : false;
            _getColorFromImage(metadata.artUri.toString());

            return Miniplayer(
                valueNotifier: playerExpandProgress,
                minHeight: playerMinHeight,
                maxHeight: playerMaxHeight,
                controller: miniplayerController,
                elevation: 4,

                // onDismissed: () => currentlyPlaying.value = null,
                curve: Curves.easeInOutCubic,
                builder: (height, percentage) {
                  return ValueListenableBuilder(
                    valueListenable: _songImageColor,
                    builder: (context, value, child) {
                      return GestureDetector(
                        onTap: () {
                          if (height == playerMinHeight) {
                            miniplayerController.animateToHeight(
                                state: PanelState.MAX);
                          }
                        },
                        onVerticalDragUpdate: (details) {},
                        child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: Gradient.lerp(
                                    LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          _songImageColor.value.primary,
                                          isLightMode
                                              ? Colors.white
                                              : Colors.black
                                        ]),
                                    LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [
                                          .2,
                                          .6
                                        ],
                                        colors: [
                                          // _songImageColor.value.primary,
                                          isLightMode
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                          isLightMode
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                        ]),
                                    percentage)),
                            child: _PlayerWidget(
                                isLightMode: isLightMode,
                                miniplayerController: miniplayerController,
                                playerMaxHeight: playerMaxHeight,
                                percentage: percentage,
                                context: context,
                                isFromDownloads: isFromDownloads,
                                height: height,
                                metadata: metadata,
                                audioPlayer: audioPlayer)),
                      );
                    },
                  );
                });
          } else {
            return const SizedBox();
          }
        });
  }

  Widget _PlayerWidget(
      {required percentage,
      required bool isLightMode,
      required BuildContext context,
      required bool isFromDownloads,
      required double playerMaxHeight,
      required height,
      required MediaItem metadata,
      required MiniplayerController miniplayerController,
      required AudioPlayer audioPlayer}) {
    final bool miniplayer = percentage < miniplayerPercentageDeclaration;
    final double width = MediaQuery.of(context).size.width;
    final maxImgSize = width * .85;

    final img = _artwork(
        isFromDownloads: isFromDownloads,
        metadata: metadata,
        context: context,
        percentage: percentage);
    final text = _songDetailsWidget(
        audioPlayer: audioPlayer,
        context: context,
        isForMiniPlayer: false,
        isFromDownloads: isFromDownloads);

    if (!miniplayer) {
      var percentageExpandedPlayer = percentageFromValueInRange(
          min: playerMaxHeight * .6 + playerMinHeight,
          max: playerMaxHeight,
          value: height);
      if (percentageExpandedPlayer < 0) percentageExpandedPlayer = 0;
      final paddingVertical = valueFromPercentageInRange(
          min: 0, max: 10, percentage: percentageExpandedPlayer);
      final double heightWithoutPadding = height - paddingVertical * 2;
      final double imageSize =
          heightWithoutPadding > maxImgSize ? maxImgSize : heightWithoutPadding;
      final paddingLeft = valueFromPercentageInRange(
            min: 0,
            max: width - imageSize,
            percentage: percentageExpandedPlayer,
          ) /
          2;

      return Stack(
        children: [
          // SingleChildScrollView(
          //   controller: _scrollController,
          //   child:
          CustomScrollView(
            controller: _scrollController,
            // mainAxisSize: MainAxisSize.min,
            // children
            slivers: [
              SliverAppBar(
                floating: true,
                primary: false,
                scrolledUnderElevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                    onPressed: () {
                      miniplayerController.animateToHeight(
                          state: PanelState.MIN);
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 35,
                    )),
                actions: [
                  if (!isFromDownloads)
                    AddToPlayListButton(
                        songdata: metadata.extras as Map<String, dynamic>),
                ],
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              // SliverToBoxAdapter(
              //   child:
              //   Visibility(
              //     visible: percentageExpandedPlayer > 0.2,
              //     child:
              //     Opacity(
              //         opacity: percentageExpandedPlayer,
              //         alwaysIncludeSemantics: false,
              //         child: SizedBox(
              //           height: Size.lerp(const Size.fromHeight(0),
              //                   const Size.fromHeight(70), percentage)!
              //               .height,
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              // IconButton(
              //     onPressed: () {
              //       miniplayerController.animateToHeight(
              //           state: PanelState.MIN);
              //     },
              //     icon: const Icon(
              //       Icons.keyboard_arrow_down_rounded,
              //       size: 35,
              //     )),
              //               if (!isFromDownloads)
              //                 AddToPlayListButton(
              //                     songdata:
              //                         metadata.extras as Map<String, dynamic>),
              //             ],
              //           ),
              //         )),
              //   ),
              // ),
              SliverToBoxAdapter(
                child: Align(
                    alignment: Alignment.centerLeft,
                    // child: Padding(
                    //     padding: EdgeInsets.only(
                    //         left: paddingLeft,
                    //         top: paddingVertical,
                    //         bottom: paddingVertical),
                    child: Artworkwidget(
                        shadowcolor: _songImageColor.value.primary,
                        isFromDownloads: isFromDownloads,
                        metadata: metadata)
                    // SizedBox(
                    //   height: imageSize,
                    //   child: img,
                    // ),
                    // ),
                    ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: Opacity(
                    opacity: percentageExpandedPlayer,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        text,
                        const SizedBox(
                          height: 20,
                        ),
                        _progressBar(
                            audioPlayer: audioPlayer, isLightMode: isLightMode),
                        const SizedBox(
                          height: 20,
                        ),
                        _audioControlButtons(
                            isLightMode: isLightMode,
                            isForMiniPlayer: false,
                            audioPlayer: audioPlayer,
                            context: context,
                            isFromDownloads: isFromDownloads),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: const SizedBox(
                  height: 40,
                ),
              ),
              SliverToBoxAdapter(
                child: Lyrics(
                    isFromDownloads: isFromDownloads,
                    metadata: metadata,
                    isLightMode: isLightMode,
                    audioPlayer: audioPlayer),
              ),
              // SliverToBoxAdapter(
              //   child: const SizedBox(
              //     height: 30,
              //   ),
              // ),
              // SliverToBoxAdapter(
              //   child: Card(
              //     margin: EdgeInsets.all(15),
              //     child: Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.stretch,
              //         children: [
              //           Text(
              //             "About",
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .titleLarge!
              //                 .copyWith(
              //                     color: Theme.of(context).colorScheme.primary),
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           Text(
              //             "Name : ${metadata.extras!["name"]}",
              //             style: Theme.of(context).textTheme.titleMedium,
              //           ),
              //           Text(
              //             "Artist : ${metadata.extras!["subtitle"]}",
              //             style: Theme.of(context).textTheme.titleMedium,
              //           ),
              //           Text(
              //             "Year : ${metadata.extras!["year"]}",
              //             style: Theme.of(context).textTheme.titleMedium,
              //           ),
              //           Text(
              //             "Language : ${metadata.extras!["language"]}",
              //             style: Theme.of(context).textTheme.titleMedium,
              //           ),
              //           Text(
              //             "Release Date : ${metadata.extras!["release_date"]}",
              //             style: Theme.of(context).textTheme.titleMedium,
              //           ),
              //           Text(
              //             "Copyright : ${metadata.extras!["copyright_text"]}",
              //             style: Theme.of(context).textTheme.titleMedium,
              //           ),
              //           Text(
              //             "Play Count : ${metadata.extras!["play_count"]}",
              //             style: Theme.of(context).textTheme.titleMedium,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              SliverToBoxAdapter(
                child: const SizedBox(
                  height: 40,
                ),
              ),
              SliverToBoxAdapter(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: MusicListWidget(musicData: {
                      "title": "Artists",
                      "data": metadata.extras!["artist_map"]["artists"],
                    }),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: const SizedBox(
                  height: 100,
                ),
              ),
            ],
          ),
          // ),
          if (percentage > .7)
            Positioned(
                child: Bottomplaylistsheet(
                    audioPlayer: audioPlayer,
                    isFromDownloads: isFromDownloads,
                    context: context))
        ],
      );
    }

    //Miniplayer
    final percentageMiniplayer = percentageFromValueInRange(
        min: playerMinHeight,
        max:
            playerMaxHeight * miniplayerPercentageDeclaration + playerMinHeight,
        value: height);

    final elementOpacity = 1 - 1 * percentageMiniplayer;
    final progressIndicatorHeight = 4 - 4 * percentageMiniplayer;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: elementOpacity,
          child:
              _progressBarSmall(audioplayer: audioPlayer, isFromOffline: false),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxImgSize),
                  child: img,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Opacity(
                        opacity: elementOpacity,
                        child: _songDetailsWidget(
                            audioPlayer: audioPlayer,
                            context: context,
                            isForMiniPlayer: true,
                            isFromDownloads: isFromDownloads)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: Opacity(
                    opacity: elementOpacity,
                    child: _audioControlButtons(
                        isLightMode: isLightMode,
                        isForMiniPlayer: true,
                        audioPlayer: audioPlayer,
                        context: context,
                        isFromDownloads: isFromDownloads),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget Lyrics(
      {required MediaItem metadata,
      required bool isLightMode,
      required bool isFromDownloads,
      required AudioPlayer audioPlayer}) {
    // if (metadata.extras!["has_lyrics"]) {
    return ValueListenableBuilder<ColorScheme>(
        valueListenable: _songImageColor,
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: OpenContainer(
                middleColor: value.primary,
                tappable: false,
                closedColor: value.primary,
                openColor: value.primary,
                closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                closedBuilder: (context, action) => SizedBox(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),

                        height: 450,

                        // clipBehavior: Clip.hardEdge,
                        // decoration: BoxDecoration(
                        //   color: value,
                        // ),
                        child: Stack(
                          children: [
                            NotificationListener(
                              onNotification:
                                  (OverscrollNotification notification) {
                                if (_scrollController.position.pixels <
                                    _scrollController
                                        .position.maxScrollExtent) {
                                  _scrollController.jumpTo(
                                      _scrollController.offset +
                                          notification.overscroll);
                                }

                                return true;
                              },
                              child: FutureBuilder<List<dynamic>>(
                                  future: SavanApi.getSongLyrics(
                                      lrclib: LRCLIB(
                                          artist_name:
                                              metadata.extras!["subtitle"],
                                          album_name: metadata.extras!["album"],
                                          track_name: metadata.extras!["name"],
                                          duration: metadata.extras!["duration"]
                                              .toString())),
                                  builder: (context, snapshot) {
                                    print("rebuilt");
                                    if (snapshot.hasData) {
                                      final data = snapshot.data;
                                      return StreamBuilder<Duration>(
                                          stream: ref
                                              .read(globalPlayerProvider)
                                              .positionStream,
                                          builder: (context, snapshot) {
                                            if (snapshot.data != null) {
                                              for (var i = 0;
                                                  i < data!.length;
                                                  i++) {
                                                if (i > 5 &&
                                                    snapshot.data!.compareTo(
                                                            data[i][0]) ==
                                                        -1) {
                                                  print(data[i]);
                                                  _itemScrollController
                                                      .scrollTo(
                                                          index: i - 4,
                                                          duration:
                                                              Durations.short4);
                                                  break;
                                                }
                                              }
                                              // print(data!.first[0]);
                                              // int currin = data.indexWhere(
                                              //   (element) =>
                                              // snapshot.data!.compareTo(
                                              //     element[0]) ==
                                              // 1,
                                              // );
                                              // print(currin);
                                              // if (currin != -1) {

                                              // }
                                            }
                                            return ScrollablePositionedList
                                                .separated(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 80, horizontal: 20),
                                              itemScrollController:
                                                  _itemScrollController,
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                height: 10,
                                              ),
                                              itemCount: data!.length,
                                              itemBuilder: (context, index) =>
                                                  Text(
                                                data[index][1],
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: snapshot.data!
                                                                    .compareTo(
                                                                        data[index]
                                                                            [
                                                                            0]) ==
                                                                1
                                                            ? Colors.white
                                                            : Theme.of(context)
                                                                .disabledColor),
                                              ),
                                            );
                                            // SliverList.separated(
                                            //     separatorBuilder:
                                            //         (context, index) =>
                                            //             SizedBox(
                                            //               height: 10,
                                            //             ),
                                            //     itemCount: data!.length,
                                            //     itemBuilder:
                                            //         (context, index) {
                                            //       return Text(
                                            //         data[index][1],
                                            //         textAlign:
                                            //             TextAlign.center,
                                            //         style: Theme.of(
                                            //                 context)
                                            //             .textTheme
                                            //             .titleLarge!
                                            //             .copyWith(
                                            //                 fontWeight:
                                            //                     FontWeight
                                            //                         .w500,
                                            //                 color: snapshot.data!.compareTo(data[index]
                                            //                             [
                                            //                             0]) ==
                                            //                         1
                                            //                     ? Colors
                                            //                         .white
                                            //                     : Theme.of(
                                            //                             context)
                                            //                         .disabledColor),
                                            //       );
                                            //     }),
                                          });
                                    } else if (snapshot.hasError) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "(:",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "No Lyrics Found",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }),
                            ),
                            Positioned(
                                top: 0,
                                right: 0,
                                left: 0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  color: value.primary,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Lyrics",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                      ),
                                      IconButton.filled(
                                          style: IconButton.styleFrom(
                                              backgroundColor: isLightMode
                                                  ? Colors.white54
                                                  : Colors.black54),
                                          onPressed: action,
                                          icon: Icon(
                                            Icons.zoom_out_map,
                                            size: 20,
                                          ))
                                    ],
                                  ),
                                )),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Container(
                                  color: value.primary,
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton.filled(
                                        style: IconButton.styleFrom(
                                            padding: EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            backgroundColor: isLightMode
                                                ? Colors.white24
                                                : Colors.black26),
                                        onPressed: () {
                                          launchUrlString("https://lrclib.net");
                                        },
                                        icon: Text(
                                          "Powered By LRCLIB",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      IconButton.filled(
                                          style: IconButton.styleFrom(
                                              padding: EdgeInsets.all(10),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              backgroundColor: isLightMode
                                                  ? Colors.white24
                                                  : Colors.black26),
                                          onPressed: () async {
                                            _itemScrollController.scrollTo(
                                                index: 20,
                                                duration: Durations.short4);
                                            // Clipboard.setData(
                                            //     ClipboardData(text: "lyrics"));
                                          },
                                          icon: Icon(Icons.copy))
                                    ],
                                  ),
                                ))
                          ],
                        ),
                        // metadata.extras!["has_lyrics"]
                        //     ? ref
                        //         .watch(SongLyricsProvider({
                        //           "artist_name": metadata.extras!["subtitle"],
                        //           "track_name": metadata.extras!["name"],
                        //           "album_name": metadata.extras!["album"],
                        //           "duration": metadata.extras!["duratio"],
                        //         }))
                        //         .when(
                        //           data: (data) => ListView.builder(
                        //             itemCount: data.length,
                        //             itemBuilder: (context, index) =>
                        //                 Text(data[index]),
                        //           ),
                        //           error: (error, stackTrace) =>
                        //               Text(error.toString()),
                        //           loading: () => const Center(
                        //               child: CircularProgressIndicator()),
                        //         )
                        //     : Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             "(:",
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .displayLarge!
                        //                 .copyWith(fontWeight: FontWeight.w600),
                        //           ),
                        //           const SizedBox(
                        //             height: 20,
                        //           ),
                        //           Text(
                        //             "No Lyrics Found",
                        //             style: Theme.of(context).textTheme.titleLarge,
                        //           ),
                        //         ],
                        //       )
                      ),
                    ),
                openBuilder: (context, action) => Lyricsscreen(
                      audiocontrolbuttons: _audioControlButtons(
                          audioPlayer: audioPlayer,
                          context: context,
                          isFromDownloads: isFromDownloads,
                          isForMiniPlayer: false,
                          isLightMode: isLightMode),
                      color: value.primary,
                      metadata: metadata,
                      progressbar: _progressBar(
                          audioPlayer: audioPlayer, isLightMode: isLightMode),
                    )),
          );
        });
  }

  Widget _progressBar(
      {required AudioPlayer audioPlayer, required bool isLightMode}) {
    return StreamBuilder<Duration?>(
      stream: audioPlayer.positionStream,
      builder: (context, snapshot) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * .85,
            child: isLightMode
                ? ProgressBar(
                    barCapShape: BarCapShape.square,
                    thumbColor: Colors.black,
                    baseBarColor: Colors.black12,
                    bufferedBarColor: Colors.black26,
                    progressBarColor: Colors.black,
                    progress: snapshot.data ?? Duration.zero,
                    buffered: audioPlayer.bufferedPosition,
                    onSeek: (value) => audioPlayer.seek(value),
                    total: audioPlayer.duration ?? Duration.zero)
                : ProgressBar(
                    barCapShape: BarCapShape.square,
                    thumbColor: Colors.white,
                    baseBarColor: Colors.white12,
                    bufferedBarColor: Colors.white30,
                    progressBarColor: Colors.white,
                    progress: snapshot.data ?? Duration.zero,
                    buffered: audioPlayer.bufferedPosition,
                    onSeek: (value) => audioPlayer.seek(value),
                    total: audioPlayer.duration ?? Duration.zero));
      },
    );
  }

  Widget _progressBarSmall(
      {required AudioPlayer audioplayer, required bool isFromOffline}) {
    return StreamBuilder<Duration?>(
      stream: audioplayer.positionStream,
      builder: (context, snapshot) {
        return SizedBox(
          child: ValueListenableBuilder(
              valueListenable: _songImageColor,
              builder: (context, value, child) {
                return ProgressBar(
                    barHeight: 3,
                    timeLabelTextStyle: const TextStyle(fontSize: 0),
                    thumbRadius: 0,
                    baseBarColor: Colors.transparent,
                    bufferedBarColor: Colors.transparent,
                    progressBarColor: value.primary,
                    progress: snapshot.data ?? Duration.zero,
                    buffered: audioplayer.bufferedPosition,
                    onSeek: (value) => audioplayer.seek(value),
                    total: audioplayer.duration ?? Duration.zero);
              }),
        );
      },
    );
  }
}

Widget _artwork(
    {required bool isFromDownloads,
    required MediaItem metadata,
    required BuildContext context,
    required double percentage}) {
  return SizedBox(
    child: Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.lerp(
          BorderRadius.circular(10), BorderRadius.circular(20), percentage),
      child: isFromDownloads
          ? QueryArtworkWidget(
              artworkFit: BoxFit.cover,
              artworkBorder: BorderRadius.circular(.5),
              nullArtworkWidget: Image.asset("assets/song.png"),
              id: int.parse(metadata.id),
              type: ArtworkType.AUDIO)
          : CachedNetworkImage(
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Image.asset(fit: BoxFit.cover, "assets/album.png"),
              errorWidget: (context, url, error) =>
                  Image.asset(fit: BoxFit.cover, "assets/album.png"),
              imageUrl: metadata.artUri.toString()),
    ),
  );
}

Widget _songDetailsWidget(
    {required AudioPlayer audioPlayer,
    required BuildContext context,
    required bool isForMiniPlayer,
    required bool isFromDownloads}) {
  return StreamBuilder(
    stream: audioPlayer.sequenceStateStream,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }
      if (snapshot.data == null ||
          snapshot.data!.currentSource == null ||
          snapshot.data!.currentSource!.tag == null) {
        return const SizedBox();
      }
      final Metadata = snapshot.data!.currentSource!.tag as MediaItem;
      // _getColorFromImage(Metadata.artUri.toString());

      return SizedBox(
        width: isForMiniPlayer ? null : MediaQuery.of(context).size.width * .85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Metadata.title,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.fade,
                    style: isForMiniPlayer
                        ? Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600)
                        : Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    isFromDownloads
                        ? Metadata.artist ?? "Unknown"
                        : Metadata.extras!["subtitle"],
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: isForMiniPlayer
                        ? Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.w400)
                        : Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            if (!isFromDownloads && !isForMiniPlayer)
              DownloadButton(
                songData: Metadata.extras!,
                iconSize: 30,
              )
          ],
        ),
      );
    },
  );
}

Widget _audioControlButtons(
    {required AudioPlayer audioPlayer,
    required BuildContext context,
    required bool isFromDownloads,
    required bool isForMiniPlayer,
    required bool isLightMode}) {
  return SizedBox(
    width: isForMiniPlayer ? null : MediaQuery.of(context).size.width * .85,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (!isFromDownloads && !isForMiniPlayer)
          IconButton(
              onPressed: () async {
                if (audioPlayer.shuffleModeEnabled) {
                  await audioPlayer.setShuffleModeEnabled(false);
                  return;
                }
                await audioPlayer.setShuffleModeEnabled(true);
              },
              icon: Icon(Icons.shuffle,
                  size: 30,
                  color: audioPlayer.shuffleModeEnabled
                      ? Theme.of(context).iconTheme.color
                      : Theme.of(context).disabledColor)),
        Row(
          children: [
            StreamBuilder<PlayerState>(
                stream: audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  return IconButton(
                      onPressed: audioPlayer.hasPrevious
                          ? () {
                              audioPlayer.seekToPrevious();
                              audioPlayer.play();
                            }
                          : null,
                      icon: Icon(
                        Icons.skip_previous_rounded,
                        size: isForMiniPlayer ? null : 50,
                      ));
                }),
            StreamBuilder<PlayerState>(
                stream: audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final playingState = snapshot.data?.playing;
                  final processingState = snapshot.data?.processingState;
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return IconButton(
                        iconSize: isForMiniPlayer ? null : 50,
                        onPressed: () {},
                        icon: const CircularProgressIndicator(
                          color: Colors.white,
                        ));
                  } else if (playingState == true) {
                    return IconButton.filled(
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor:
                              isLightMode ? Colors.black : Colors.white,
                        ),
                        onPressed: audioPlayer.pause,
                        icon: Icon(
                          Icons.pause_rounded,
                          size: isForMiniPlayer ? null : 40,
                          color:
                              isLightMode ? Colors.white : Colors.grey.shade900,
                        ));
                  } else if (playingState == false) {
                    return IconButton.filled(
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor:
                              isLightMode ? Colors.black : Colors.white,
                        ),
                        onPressed: audioPlayer.play,
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          size: isForMiniPlayer ? null : 40,
                          color:
                              isLightMode ? Colors.white : Colors.grey.shade900,
                        ));
                  }
                  if (processingState == ProcessingState.completed) {
                    return IconButton(
                        onPressed: audioPlayer.play,
                        icon: Icon(
                          Icons.restart_alt,
                          size: isForMiniPlayer ? null : 50,
                        ));
                  } else {
                    return IconButton(
                        onPressed: audioPlayer.play,
                        icon: Icon(
                          Icons.restart_alt,
                          size: isForMiniPlayer ? null : 50,
                        ));
                  }
                }),
            StreamBuilder<PlayerState>(
                stream: audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  return IconButton(
                      onPressed: audioPlayer.hasNext
                          ? () {
                              audioPlayer.seekToNext();
                              audioPlayer.play();
                            }
                          : null,
                      icon: Icon(
                        Icons.skip_next_rounded,
                        size: isForMiniPlayer ? null : 50,
                      ));
                }),
          ],
        ),
        if (!isFromDownloads && !isForMiniPlayer)
          StreamBuilder(
              stream: audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data!.currentSource != null &&
                    snapshot.data!.currentSource!.tag != null &&
                    snapshot.data!.currentSource!.tag.extras != null) {
                  return Likebutton(
                      iconSize: 30,
                      songData: snapshot.data!.currentSource!.tag.extras);
                } else {
                  return const SizedBox();
                }
              })
      ],
    ),
  );
}
// }
