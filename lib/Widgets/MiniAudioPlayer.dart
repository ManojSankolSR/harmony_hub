//

import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Providers/seedColorProvider.dart';
import 'package:harmony_hub/Screens/SongPlayScreen.dart';
import 'package:harmony_hub/Widgets/AddToPlaylistButton.dart';
import 'package:harmony_hub/Widgets/ArtWorkWidget.dart';
import 'package:harmony_hub/Widgets/BottomPlaylistSheet.dart';
import 'package:harmony_hub/Widgets/DownloadButton.dart';
import 'package:harmony_hub/Widgets/LikeButton.dart';
import 'package:harmony_hub/Widgets/SongBottomBarWidget.dart';
import 'package:harmony_hub/utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';

class Miniaudioplayer extends ConsumerStatefulWidget {
  @override
  ConsumerState<Miniaudioplayer> createState() => _MiniaudioplayerState();
}

class _MiniaudioplayerState extends ConsumerState<Miniaudioplayer> {
  static const double playerMinHeight = 75;

  static const double miniplayerPercentageDeclaration = 0.2;
  static ValueNotifier<double> playerExpandProgress = ValueNotifier(75);
  Future _getColorFromImage(String url) async {
    final imageloc = Image.network(url).image;
    final paletteGenerator = await PaletteGenerator.fromImageProvider(imageloc);

    _songImageColor.value =
        paletteGenerator.dominantColor?.color ?? Colors.transparent;
  }

  ValueNotifier<Color> _songImageColor =
      ValueNotifier<Color>(Colors.transparent);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MiniplayerController _miniplayerController =
        ref.watch(MiniplayerControllerProvider);
    final double playerMaxHeight = MediaQuery.of(context).size.height * .95;
    final _audioPlayer = ref.watch(globalPlayerProvider);
    return StreamBuilder(
        stream: _audioPlayer.sequenceStateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.currentSource != null) {
            final metadata = snapshot.data!.currentSource!.tag as MediaItem;
            final isFromDownloads = metadata.extras == null ? true : false;
            _getColorFromImage(metadata.artUri.toString());

            return Miniplayer(
                valueNotifier: playerExpandProgress,
                minHeight: playerMinHeight,
                maxHeight: playerMaxHeight,
                controller: _miniplayerController,
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
                            _miniplayerController.animateToHeight(
                                state: PanelState.MAX);
                          }
                        },
                        onVerticalDragUpdate: (details) {},
                        child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: Gradient.lerp(
                                    LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          _songImageColor.value,
                                          Colors.transparent
                                        ]),
                                    LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          _songImageColor.value,
                                          Colors.transparent
                                        ]),
                                    percentage)),
                            child: _PlayerWidget(
                                miniplayerController: _miniplayerController,
                                playerMaxHeight: playerMaxHeight,
                                percentage: percentage,
                                context: context,
                                isFromDownloads: isFromDownloads,
                                height: height,
                                metadata: metadata,
                                audioPlayer: _audioPlayer)),
                      );
                    },
                  );
                });
          } else {
            return SizedBox();
          }
        });
  }

  Widget _PlayerWidget(
      {required percentage,
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
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: percentageExpandedPlayer > 0.2,
                  child: Opacity(
                      opacity: percentageExpandedPlayer,
                      alwaysIncludeSemantics: false,
                      child: SizedBox(
                        height: Size.lerp(Size.fromHeight(0),
                                Size.fromHeight(70), percentage)!
                            .height,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  miniplayerController.animateToHeight(
                                      state: PanelState.MIN);
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 35,
                                )),
                            if (!isFromDownloads)
                              AddToPlayListButton(
                                  songdata:
                                      metadata.extras as Map<String, dynamic>),
                          ],
                        ),
                      )),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    // child: Padding(
                    //     padding: EdgeInsets.only(
                    //         left: paddingLeft,
                    //         top: paddingVertical,
                    //         bottom: paddingVertical),
                    child: Artworkwidget(
                        isFromDownloads: isFromDownloads, metadata: metadata)
                    // SizedBox(
                    //   height: imageSize,
                    //   child: img,
                    // ),
                    // ),
                    ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: Opacity(
                    opacity: percentageExpandedPlayer,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        text,
                        SizedBox(
                          height: 20,
                        ),
                        _progressBar(audioPlayer: audioPlayer),
                        SizedBox(
                          height: 20,
                        ),
                        _audioControlButtons(
                            isForMiniPlayer: false,
                            audioPlayer: audioPlayer,
                            context: context,
                            isFromDownloads: isFromDownloads),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                // Lyrics(metadata: metadata),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
          if (percentage > .7)
            Positioned(
                child: Bottomplaylistsheet(
                    audioPlayer: audioPlayer,
                    isFromDownloads: isFromDownloads,
                    context: context))
        ],
      );

      //  ListView.builder(
      //   itemCount: 10,
      //   itemBuilder: (context, index) => ListTile(
      //     title: Text("dhfdfgbh"),
      //   ),
      // );
      // Stack(
      //   children: [
      //     SingleChildScrollView(
      //       child: Column(
      //         children: [
      //           Visibility(
      //             visible: percentageExpandedPlayer > 0.2,
      //             child: Opacity(
      //                 opacity: percentageExpandedPlayer,
      //                 alwaysIncludeSemantics: false,
      //                 child: SizedBox(
      //                   height: Size.lerp(Size.fromHeight(0),
      //                           Size.fromHeight(70), percentage)!
      //                       .height,
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       IconButton(
      //                           onPressed: () {
      //                             _miniplayerController.animateToHeight(
      //                                 state: PanelState.MIN);
      //                           },
      //                           icon: Icon(
      //                             Icons.keyboard_arrow_down_rounded,
      //                             size: 35,
      //                           )),
      //                       if (!isFromDownloads)
      //                         AddToPlayListButton(
      //                             songdata:
      //                                 metadata.extras as Map<String, dynamic>),
      //                     ],
      //                   ),
      //                 )),
      //           ),
      //           Align(
      //             alignment: Alignment.centerLeft,
      //             child: Padding(
      //               padding: EdgeInsets.only(
      //                   left: paddingLeft,
      //                   top: paddingVertical,
      //                   bottom: paddingVertical),
      //               child: SizedBox(
      //                 height: imageSize,
      //                 child: img,
      //               ),
      //             ),
      //           ),
      //           Expanded(
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 33),
      //               child: Opacity(
      //                 opacity: percentageExpandedPlayer,
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.start,
      //                   children: [
      //                     SizedBox(
      //                       height: 20,
      //                     ),
      //                     text,
      //                     SizedBox(
      //                       height: 20,
      //                     ),
      //                     _progressBar(audioPlayer: audioPlayer),
      //                     SizedBox(
      //                       height: 20,
      //                     ),
      //                     Flexible(
      //                       child: _audioControlButtons(
      //                           isForMiniPlayer: false,
      //                           audioPlayer: audioPlayer,
      //                           context: context,
      //                           isFromDownloads: isFromDownloads),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     if (percentage > .7)
      //       Positioned(
      //           child: Bottomplaylistsheet(
      //               audioPlayer: audioPlayer,
      //               isFromDownloads: isFromDownloads,
      //               context: context))
      //   ],
      // );
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

  Widget Lyrics({required MediaItem metadata}) {
    // if (metadata.extras!["has_lyrics"]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Lyrics",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 20,
        ),
        ValueListenableBuilder<Color?>(
            valueListenable: _songImageColor,
            builder: (context, value, child) {
              return Container(
                  width: MediaQuery.of(context).size.width * .9,
                  height: 400,
                  decoration: BoxDecoration(
                      color: value, borderRadius: BorderRadius.circular(20)),
                  child: metadata.extras!["has_lyrics"]
                      ? ref
                          .watch(SongLyricsProvider(metadata.extras!["id"]))
                          .when(
                            data: (data) => SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 40),
                              child: Text(
                                data,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            error: (error, stackTrace) =>
                                Text(error.toString()),
                            loading: () =>
                                Center(child: CircularProgressIndicator()),
                          )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "(:",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "No Lyrics Found",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ));
            }),
      ],
    );
  }

  Widget _progressBar({required AudioPlayer audioPlayer}) {
    return StreamBuilder<Duration?>(
      stream: audioPlayer.positionStream,
      builder: (context, snapshot) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * .85,
          child: ProgressBar(
              barCapShape: BarCapShape.square,
              thumbColor: Colors.white,
              baseBarColor: Colors.white12,
              bufferedBarColor: Colors.white30,
              progressBarColor: Colors.white,
              progress: snapshot.data ?? Duration.zero,
              buffered: audioPlayer.bufferedPosition,
              onSeek: (value) => audioPlayer.seek(value),
              total: audioPlayer.duration ?? Duration.zero),
        );
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
                    timeLabelTextStyle: TextStyle(fontSize: 0),
                    thumbRadius: 0,
                    baseBarColor: Colors.transparent,
                    bufferedBarColor: Colors.transparent,
                    progressBarColor:
                        value ?? Theme.of(context).colorScheme.primary,
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
        return CircularProgressIndicator();
      }
      if (snapshot.data == null ||
          snapshot.data!.currentSource == null ||
          snapshot.data!.currentSource!.tag == null) {
        return SizedBox();
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

Widget _audioControlButtons({
  required AudioPlayer audioPlayer,
  required BuildContext context,
  required bool isFromDownloads,
  required bool isForMiniPlayer,
}) {
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
              icon: Icon(
                Icons.shuffle,
                size: 30,
                color: audioPlayer.shuffleModeEnabled
                    ? Colors.white
                    : Colors.white10,
              )),
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
                        icon: CircularProgressIndicator(
                          color: Colors.white,
                        ));
                  } else if (playingState == true) {
                    return IconButton.filled(
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: audioPlayer.pause,
                        icon: Icon(
                          Icons.pause_rounded,
                          size: isForMiniPlayer ? null : 40,
                          color: Colors.grey.shade900,
                        ));
                  } else if (playingState == false) {
                    return IconButton.filled(
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: audioPlayer.play,
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          size: isForMiniPlayer ? null : 40,
                          color: Colors.grey.shade900,
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
                  return SizedBox();
                }
              })
      ],
    ),
  );
}
// }
