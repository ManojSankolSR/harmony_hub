import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/DataModels/AlbumModel.dart';
import 'package:harmony_hub/GlobalConstants.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Artworkwidget extends ConsumerStatefulWidget {
  final bool isFromDownloads;
  final MediaItem metadata;
  final Color shadowcolor;

  const Artworkwidget({
    super.key,
    required this.isFromDownloads,
    required this.metadata,
    required this.shadowcolor,
  });
  @override
  ConsumerState<Artworkwidget> createState() => _ArtworkwidgetState();
}

class _ArtworkwidgetState extends ConsumerState<Artworkwidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;
  bool _frontSide = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOutCirc),
    );
    _animationController.addListener(
      () {
        if ((_frontSide && _animationController.value >= 0.5) ||
            (!_frontSide && _animationController.value <= 0.5)) {
          setState(() {
            _frontSide = !_frontSide;
          });
        }
      },
    );
    _flipAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: widget.isFromDownloads
            ? null
            : () {
                if (_animationController.status == AnimationStatus.completed) {
                  _animationController.reverse();
                } else {
                  _animationController.forward();
                }
              },
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(_flipAnimation.value * pi),
          child: Container(
              height: MediaQuery.of(context).size.width * .85,
              width: MediaQuery.of(context).size.width * .85,
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset(1, 1),
                      spreadRadius: 5,
                      color: widget.shadowcolor)
                ],
                color: _frontSide ? Colors.transparent : Colors.black26,
                borderRadius: BorderRadius.circular(20),
              ),
              child: _frontSide ? _firstWidget() : _SecondWidget()),
        ),
      ),
    );
  }

  Widget _firstWidget() {
    return widget.isFromDownloads
        ? QueryArtworkWidget(
            artworkBorder: BorderRadius.circular(.5),
            artworkHeight: MediaQuery.of(context).size.width * .85,
            artworkWidth: MediaQuery.of(context).size.width * .85,
            nullArtworkWidget: Image.asset("assets/song.png"),
            id: int.parse(widget.metadata.id),
            type: ArtworkType.AUDIO)
        : CachedNetworkImage(
            imageUrl: widget.metadata.artUri.toString(),
            placeholder: (context, url) =>
                Image.asset(fit: BoxFit.cover, "assets/album.png"),
            errorWidget: (context, url, error) =>
                Image.asset(fit: BoxFit.cover, "assets/album.png"),
          );
  }

  Widget _SecondWidget() {
    return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(-1 * pi),
        child: Lyrics());
  }

  Widget Lyrics() {
    // if (widget.metadata.extras!["has_lyrics"]) {

    return FutureBuilder<List<dynamic>>(
        future: SavanApi.getSongLyrics(
            lrclib: LRCLIB(
                artist_name: widget.metadata.extras!["subtitle"],
                album_name: widget.metadata.extras!["album"],
                track_name: widget.metadata.extras!["name"],
                duration: widget.metadata.extras!["duration"].toString())),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return StreamBuilder<Duration>(
                stream: ref.read(globalPlayerProvider).positionStream,
                builder: (context, snapshot) {
                  return ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        return Text(
                          data[index][1],
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: snapshot.data!
                                              .compareTo(data[index][0]) ==
                                          1
                                      ? Colors.white
                                      : Theme.of(context).disabledColor),
                        );
                      });
                });
          } else if (snapshot.hasError) {
            return Column(
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
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "No Lyrics Found",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
    // return ref
    // .watch(SongLyricsProvider({
    //   "artist_name": widget.metadata.extras!["subtitle"],
    //   "track_name": widget.metadata.extras!["name"],
    //   "album_name": widget.metadata.extras!["album"],
    //   "duration": widget.metadata.extras!["duration"].toString(),
    // }))
    //     .when(
    //       data: (data) => ListView.builder(
    //         itemCount: data.length,
    //         itemBuilder: (context, index) => Text(data[index]),
    //       ),
    //       error: (error, stackTrace) => Text(error.toString()),
    //       loading: () => const Center(child: CircularProgressIndicator()),
    //     );
    // ref.watch(SongLyricsProvider(widget.metadata.extras!["id"])).when(
    //       data: (data) => SingleChildScrollView(
    // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    //         child: Text(
    //           "",
    //           textAlign: TextAlign.center,
    //           overflow: TextOverflow.fade,
    // style: Theme.of(context)
    //     .textTheme
    //     .titleLarge!
    //     .copyWith(fontWeight: FontWeight.w400),
    //         ),
    //       ),
    //       error: (error, stackTrace) => Text(error.toString()),
    //       loading: () => const CircularProgressIndicator(),
    //     );
    // }
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     Text(
    //       "(:",
    //       style: Theme.of(context)
    //           .textTheme
    //           .displayLarge!
    //           .copyWith(fontWeight: FontWeight.w600),
    //     ),
    //     const SizedBox(
    //       height: 20,
    //     ),
    //     Text(
    //       "No Lyrics Found",
    //       style: Theme.of(context).textTheme.titleLarge,
    //     ),
    //   ],
    // );
  }
}
