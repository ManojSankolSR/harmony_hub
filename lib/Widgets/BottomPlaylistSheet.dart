import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harmony_hub/Widgets/AddToPlaylistButton.dart';
import 'package:harmony_hub/Widgets/DownloadButton.dart';
import 'package:harmony_hub/Widgets/LikeButton.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Bottomplaylistsheet extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final bool isFromDownloads;
  final BuildContext context;

  const Bottomplaylistsheet({super.key, 
    required this.audioPlayer,
    required this.isFromDownloads,
    required this.context,
  });

  @override
  State<Bottomplaylistsheet> createState() => _BottomplaylistsheetState();
}

class _BottomplaylistsheetState extends State<Bottomplaylistsheet> {
  late PanelController _panelController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _panelController = PanelController();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    // TODO: implement build
    return SlidingUpPanel(
        minHeight: 70,
        maxHeight: 350,
        controller: _panelController,
        isDraggable: true,
        color: isLightMode ? Colors.white12 : Colors.black12,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
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
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.transparent),
            clipBehavior: Clip.hardEdge,
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
                      color: isLightMode ? Colors.grey[700] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Up Next",
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
        panelBuilder: (sc) => ClipRect(
              clipBehavior: Clip.hardEdge,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.only(top: 70),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: StreamBuilder(
                      stream: widget.audioPlayer.sequenceStateStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final metadatasequence = snapshot.data!.sequence;
                          return ListView.builder(
                            padding: const EdgeInsets.all(0),
                            controller: sc,
                            itemCount: metadatasequence.length,
                            itemBuilder: (context, index) {
                              final bool isPlaying =
                                  metadatasequence[index].tag.id ==
                                      snapshot.data!.currentSource!.tag.id;
                              return ListTile(
                                  selected: isPlaying,
                                  onTap: () {
                                    widget.audioPlayer
                                        .seek(Duration.zero, index: index);
                                  },
                                  title: Text(
                                    metadatasequence[index].tag.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: widget.isFromDownloads
                                        ? QueryArtworkWidget(
                                            artworkBorder:
                                                BorderRadius.circular(2),
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
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                                        fit: BoxFit.cover,
                                                        "assets/album.png"),
                                            imageUrl: metadatasequence[index]
                                                .tag
                                                .artUri
                                                .toString()),
                                  ),
                                  subtitle: Text(
                                    widget.isFromDownloads
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)
                                      : widget.isFromDownloads
                                          ? null
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Likebutton(
                                                    songData:
                                                        metadatasequence[index]
                                                            .tag
                                                            .extras),
                                                AddToPlayListButton(
                                                    songdata:
                                                        metadatasequence[index]
                                                            .tag
                                                            .extras),
                                                DownloadButton(
                                                    songData:
                                                        metadatasequence[index]
                                                            .tag
                                                            .extras),
                                              ],
                                            ));
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ));
  }
}
