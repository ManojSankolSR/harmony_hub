import 'dart:ffi';
import 'dart:ui' as ui;

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Functions/MusicPlayer.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Widgets/DownloadButton.dart';
import 'package:harmony_hub/Widgets/LikeButton.dart';
import 'package:harmony_hub/Widgets/SongBottomBarWidget.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SongsPlayScreen extends ConsumerStatefulWidget {
  final List<dynamic> AudioData;
  final int startIndex;
  final bool fromMiniPlayer;

  const SongsPlayScreen({
    super.key,
    required this.AudioData,
    required this.startIndex,
    required this.fromMiniPlayer,
  });
  @override
  ConsumerState<SongsPlayScreen> createState() => _SongsPlayScreenState();
}

class _SongsPlayScreenState extends ConsumerState<SongsPlayScreen> {
  late ConcatenatingAudioSource PlayList;
  late DraggableScrollableController _draggableScrollableController;
  late PanelController _panelController;
  late bool isFromDownloads;

  ValueNotifier _songImageColor = ValueNotifier<Color>(Colors.transparent);

  Future _getColorFromImage(String url) async {
    final imageloc = Image.network(url).image;
    final paletteGenerator = await PaletteGenerator.fromImageProvider(imageloc);

    _songImageColor.value =
        paletteGenerator.dominantColor?.color ?? Colors.transparent;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _draggableScrollableController = DraggableScrollableController();
    _panelController = PanelController();
    isFromDownloads = widget.AudioData.runtimeType == List<SongModel>;

    // TODO: implement initState
    super.initState();
    if (!widget.fromMiniPlayer) {
      print("starin ${widget.startIndex}");
      Musicplayer.setUpAudioPlayer(ref,
          AudioData: widget.AudioData, startIndex: widget.startIndex);
      ref.read(globalPlayerProvider).play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: SizedBox.expand(
        child: Stack(
          children: [
            ValueListenableBuilder(
                valueListenable: _songImageColor,
                builder: (context, value, child) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [value, Colors.transparent])),
                  );
                }),
            Container(
              height: MediaQuery.of(context).size.height * .9,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppBar(
                    automaticallyImplyLeading: true,
                    primary: false,
                    backgroundColor: Colors.transparent,
                    scrolledUnderElevation: 0,
                  ),
                  _songDetailsWidget(),
                  _progressBar(),
                  _audioControlButtons(),
                ],
              ),
            ),
            _playListDetailsWidget()
          ],
        ),
      ),
    );
  }

  Widget _songDetailsWidget() {
    return StreamBuilder(
      stream: ref.read(globalPlayerProvider).sequenceStateStream,
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
        _getColorFromImage(Metadata.artUri.toString());

        return SizedBox(
          width: MediaQuery.of(context).size.width * .85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Dismissible(
                key: ValueKey("awdf"),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    ref.read(globalPlayerProvider).hasPrevious
                        ? ref.read(globalPlayerProvider).seekToPrevious()
                        : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                                title: "No Previous Track Found",
                                message: "Sorry No Previous Track Found",
                                contentType: ContentType.failure)));
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    ref.read(globalPlayerProvider).hasNext
                        ? ref.read(globalPlayerProvider).seekToNext()
                        : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                                title: "No Next Track Found",
                                message: "Sorry No Next Track Found",
                                contentType: ContentType.failure)));
                    return false;
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * .85,
                  width: MediaQuery.of(context).size.width * .85,
                  clipBehavior: ui.Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: isFromDownloads
                      ? QueryArtworkWidget(
                          nullArtworkWidget: Image.asset("assets/song.png"),
                          id: int.parse(Metadata.id),
                          type: ArtworkType.AUDIO)
                      : CachedNetworkImage(
                          imageUrl: Metadata.artUri.toString(),
                          placeholder: (context, url) => Image.asset(
                              fit: BoxFit.cover, "assets/album.png"),
                          errorWidget: (context, url, error) => Image.asset(
                              fit: BoxFit.cover, "assets/album.png"),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
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
                          style: Theme.of(context)
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
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  if (!isFromDownloads)
                    DownloadButton(
                      songData: Metadata.extras!,
                      iconSize: 30,
                    )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _playListDetailsWidget() {
    return SlidingUpPanel(
        minHeight: 70,
        maxHeight: 300,
        color: Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: ui.Radius.circular(10),
          topRight: ui.Radius.circular(10),
        ),
        header: GestureDetector(
          onTap: () {
            if (_panelController.isPanelOpen) {
              _panelController.close();
            } else {
              if (_panelController.panelPosition > 0.9) {
                _panelController.close();
              } else {
                _panelController.open();
              }
            }
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            if (details.delta.dy > 0.0) {
              _panelController.animatePanelToPosition(0.0);
            }
          },
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: ui.Radius.circular(10),
                  topRight: ui.Radius.circular(10),
                ),
                color: Colors.transparent),
            clipBehavior: ui.Clip.hardEdge,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Up Next",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
        controller: _panelController,
        panelBuilder: (sc) => ClipRect(
              clipBehavior: ui.Clip.hardEdge,
              child: Container(
                margin: EdgeInsets.only(top: 70),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: StreamBuilder(
                    stream: ref.read(globalPlayerProvider).sequenceStateStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final metadatasequence = snapshot.data!.sequence;
                        return ListView.builder(
                          padding: EdgeInsets.all(0),
                          controller: sc,
                          itemCount: metadatasequence.length,
                          itemBuilder: (context, index) {
                            final bool isPlaying =
                                metadatasequence[index].tag.id ==
                                    snapshot.data!.currentSource!.tag.id;
                            return ListTile(
                              selected: isPlaying,
                              onTap: () {
                                ref
                                    .read(globalPlayerProvider)
                                    .seek(Duration.zero, index: index);
                              },
                              title: Text(
                                metadatasequence[index].tag.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Container(
                                clipBehavior: ui.Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                                child: isFromDownloads
                                    ? QueryArtworkWidget(
                                        artworkBorder: BorderRadius.circular(2),
                                        nullArtworkWidget:
                                            Image.asset("assets/song.png"),
                                        id: int.parse(
                                            metadatasequence[index].tag.id),
                                        type: ArtworkType.AUDIO)
                                    : CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            Image.asset(
                                                fit: BoxFit.cover,
                                                "assets/album.png"),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                fit: BoxFit.cover,
                                                "assets/album.png"),
                                        imageUrl: metadatasequence[index]
                                            .tag
                                            .artUri
                                            .toString()),
                              ),
                              subtitle: Text(
                                isFromDownloads
                                    ? metadatasequence[index].tag.artist ??
                                        "Unknown"
                                    : metadatasequence[index]
                                        .tag
                                        .extras["subtitle"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: isPlaying
                                  ? Icon(Icons.equalizer_rounded,
                                      size: 30,
                                      color:
                                          Theme.of(context).colorScheme.primary)
                                  : Icon(
                                      Icons.play_arrow,
                                      size: 35,
                                    ),
                            );
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),
            ));
  }

  Widget _progressBar() {
    return StreamBuilder<Duration?>(
      stream: ref.read(globalPlayerProvider).positionStream,
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
              buffered: ref.read(globalPlayerProvider).bufferedPosition,
              onSeek: (value) => ref.read(globalPlayerProvider).seek(value),
              total: ref.read(globalPlayerProvider).duration ?? Duration.zero),
        );
      },
    );
  }

  Widget _audioControlButtons() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!isFromDownloads)
            IconButton(
                onPressed: () async {
                  if (ref.read(globalPlayerProvider).shuffleModeEnabled) {
                    await ref
                        .read(globalPlayerProvider)
                        .setShuffleModeEnabled(false);
                    return;
                  }
                  await ref
                      .read(globalPlayerProvider)
                      .setShuffleModeEnabled(true);
                },
                icon: Icon(
                  Icons.shuffle,
                  size: 30,
                  color: ref.watch(globalPlayerProvider).shuffleModeEnabled
                      ? Colors.white
                      : Colors.white10,
                )),
          Row(
            children: [
              StreamBuilder<PlayerState>(
                  stream: ref.read(globalPlayerProvider).playerStateStream,
                  builder: (context, snapshot) {
                    return IconButton(
                        onPressed: ref.read(globalPlayerProvider).hasPrevious
                            ? () {
                                ref.read(globalPlayerProvider).seekToPrevious();
                                ref.read(globalPlayerProvider).play();
                              }
                            : null,
                        icon: Icon(
                          Icons.skip_previous_rounded,
                          size: 50,
                        ));
                  }),
              StreamBuilder<PlayerState>(
                  stream: ref.read(globalPlayerProvider).playerStateStream,
                  builder: (context, snapshot) {
                    final playingState = snapshot.data?.playing;
                    final processingState = snapshot.data?.processingState;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return Stack(
                        children: [
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              top: 0,
                              child: IconButton.filled(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.play_arrow_rounded,
                                    size: 40,
                                  ))),
                        ],
                      );
                    } else if (playingState == true) {
                      return IconButton.filled(
                          color: Colors.white,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: ref.read(globalPlayerProvider).pause,
                          icon: Icon(
                            Icons.pause_rounded,
                            size: 40,
                            color: Colors.grey.shade900,
                          ));
                    } else if (playingState == false) {
                      return IconButton.filled(
                          color: Colors.white,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: ref.read(globalPlayerProvider).play,
                          icon: Icon(
                            Icons.play_arrow_rounded,
                            size: 40,
                            color: Colors.grey.shade900,
                          ));
                    } else {
                      return IconButton(
                          onPressed: ref.read(globalPlayerProvider).play,
                          icon: Icon(
                            Icons.restart_alt,
                            size: 50,
                          ));
                    }
                  }),
              StreamBuilder<PlayerState>(
                  stream: ref.read(globalPlayerProvider).playerStateStream,
                  builder: (context, snapshot) {
                    return IconButton(
                        onPressed: ref.read(globalPlayerProvider).hasNext
                            ? () {
                                ref.read(globalPlayerProvider).seekToNext();
                                ref.read(globalPlayerProvider).play();
                              }
                            : null,
                        icon: Icon(
                          Icons.skip_next_rounded,
                          size: 50,
                        ));
                  }),
            ],
          ),
          if (!isFromDownloads)
            StreamBuilder(
                stream: ref.read(globalPlayerProvider).sequenceStateStream,
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
}
