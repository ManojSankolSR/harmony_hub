import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/DataModels/AlbumModel.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Lyricsscreen extends ConsumerStatefulWidget {
  final Color color;
  final MediaItem metadata;
  final Widget progressbar;
  final Widget audiocontrolbuttons;

  Lyricsscreen(
      {super.key,
      required this.color,
      required this.metadata,
      required this.progressbar,
      required this.audiocontrolbuttons});

  @override
  ConsumerState<Lyricsscreen> createState() => _LyricsscreenState();
}

class _LyricsscreenState extends ConsumerState<Lyricsscreen> {
  late ItemScrollController _itemScrollController;
  // late FutureProvider<List<dynamic>> lyricsdata;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _itemScrollController = ItemScrollController();
    // lyricsdata = ref.watch(SongLyricsProvider({
    //   "artist_name": widget.metadata.extras!["subtitle"],
    //   "track_name": widget.metadata.extras!["name"],
    //   "album_name": widget.metadata.extras!["album"],
    //   "duration": widget.metadata.extras!["duration"].toString(),
    // }));
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // final lyricsProvider = ref.watch(SongLyricsProvider(LRCLIB(
    //     artist_name: widget.metadata.extras!["subtitle"],
    //     album_name: widget.metadata.extras!["album"],
    //     track_name: widget.metadata.extras!["name"],
    //     duration:widget.metadata.extras!["duration"].toString()
    //     )));
    // TODO: implement build
    return Scaffold(
      backgroundColor: widget.color,
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(
          "${widget.metadata.extras!["name"]}\n${widget.metadata.extras!["subtitle"]}",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // lyricsProvider.when(
            //     data: (data) => StreamBuilder<Duration>(
            //         stream: ref.read(globalPlayerProvider).positionStream,
            //         builder: (context, snapshot) {
            //           if (snapshot.data != null) {
            //             for (var i = 0; i < data.length; i++) {
            //               if (i > 5 &&
            //                   snapshot.data!.compareTo(data[i][0]) == -1) {
            //                 print(data[i]);
            //                 _itemScrollController.scrollTo(
            //                     index: i - 4, duration: Durations.short4);
            //                 break;
            //               }
            //             }
            //             // print(data!.first[0]);
            //             // int currin = data.indexWhere(
            //             //   (element) =>
            //             // snapshot.data!.compareTo(
            //             //     element[0]) ==
            //             // 1,
            //             // );
            //             // print(currin);
            //             // if (currin != -1) {

            //             // }
            //           }
            //           return ScrollablePositionedList.separated(
            //             padding:
            //                 EdgeInsets.symmetric(vertical: 80, horizontal: 20),
            //             itemScrollController: _itemScrollController,
            //             separatorBuilder: (context, index) => SizedBox(
            //               height: 10,
            //             ),
            //             itemCount: data!.length,
            //             itemBuilder: (context, index) => Text(
            //               data[index][1],
            //               textAlign: TextAlign.center,
            //               style: Theme.of(context)
            //                   .textTheme
            //                   .titleLarge!
            //                   .copyWith(
            //                       fontWeight: FontWeight.w500,
            //                       color: snapshot.data!
            //                                   .compareTo(data[index][0]) ==
            //                               1
            //                           ? Colors.white
            //                           : Theme.of(context).disabledColor),
            //             ),
            //           );
            //         }),
            //     error: (error, stackTrace) => Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Text(
            //               "(:",
            //               style: Theme.of(context)
            //                   .textTheme
            //                   .displayLarge!
            //                   .copyWith(fontWeight: FontWeight.w600),
            //             ),
            //             const SizedBox(
            //               height: 20,
            //             ),
            //             Text(
            //               "No Lyrics Found",
            //               style: Theme.of(context).textTheme.titleLarge,
            //             ),
            //           ],
            //         ),
            //     loading: () => const Center(
            //           child: CircularProgressIndicator(),
            //         )),
            SizedBox(
              height: MediaQuery.of(context).size.height * .6,
              child: FutureBuilder<List<dynamic>>(
                  future: ref.read(SongLyricsProvider(LRCLIB(
                          artist_name: widget.metadata.extras!["subtitle"],
                          album_name: widget.metadata.extras!["album"],
                          track_name: widget.metadata.extras!["name"],
                          duration:
                              widget.metadata.extras!["duration"].toString()))
                      .future),
                  // SavanApi.getSongLyrics(
                  // lrclib: LRCLIB(
                  //     artist_name: widget.metadata.extras!["subtitle"],
                  //     album_name: widget.metadata.extras!["album"],
                  //     track_name: widget.metadata.extras!["name"],
                  //     duration:
                  //         widget.metadata.extras!["duration"].toString())),
                  builder: (context, snapshot) {
                    print("rebuilt");
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      return StreamBuilder<Duration>(
                          stream: ref.read(globalPlayerProvider).positionStream,
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              for (var i = 0; i < data!.length; i++) {
                                if (i > 5 &&
                                    snapshot.data!.compareTo(data[i][0]) ==
                                        -1) {
                                  print(data[i]);
                                  _itemScrollController.scrollTo(
                                      index: i - 4, duration: Durations.short4);
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
                            return ScrollablePositionedList.separated(
                              padding: EdgeInsets.symmetric(
                                  vertical: 80, horizontal: 20),
                              itemScrollController: _itemScrollController,
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                              itemCount: data!.length,
                              itemBuilder: (context, index) => Text(
                                data[index][1],
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: snapshot.data!.compareTo(
                                                    data[index][0]) ==
                                                1
                                            ? Colors.white
                                            : Theme.of(context).disabledColor),
                              ),
                            );
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
                  }),
            ),
            widget.progressbar,
            widget.audiocontrolbuttons,
          ],
        ),
      ),
    );
  }
}
