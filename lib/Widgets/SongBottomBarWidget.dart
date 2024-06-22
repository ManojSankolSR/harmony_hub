// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:harmony_hub/Navigation.dart';
// import 'package:harmony_hub/Providers/SavanApiProvider.dart';
// import 'package:harmony_hub/Screens/SongPlayScreen.dart';
// import 'package:harmony_hub/main.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:palette_generator/palette_generator.dart';

// class Songbottombarwidget extends ConsumerStatefulWidget {
//   const Songbottombarwidget({super.key});

//   @override
//   ConsumerState<Songbottombarwidget> createState() =>
//       _SongbottombarwidgetState();
// }

// class _SongbottombarwidgetState extends ConsumerState<Songbottombarwidget> {
//   ValueNotifier<Color> _songImageColor =
//       ValueNotifier<Color>(Colors.transparent);

//   Future _getColorFromImage(String url) async {
//     final imageloc = Image.network(url).image;
//     final paletteGenerator = await PaletteGenerator.fromImageProvider(imageloc);

//     _songImageColor.value =
//         paletteGenerator.dominantColor?.color ?? Colors.transparent;
//   }

//   void _FullScreenPlayer(bool isFromOffline) {
//     MyApp.navigatorKey.currentState?.push(PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) => SongsPlayScreen(
//         isFromOffline: isFromOffline,
//         AudioData: [],
//         startIndex: 0,
//         fromMiniPlayer: true,
//       ),
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         return FadeTransition(
//           opacity: animation,
//           child: SlideTransition(
//             position: Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
//                 .animate(animation),
//             child: child,
//           ),
//         );
//       },
//     ));
//     // Navigator.push(
//     //     context,
//     //     PageRouteBuilder(
//     //       pageBuilder: (context, animation, secondaryAnimation) =>
//     //           SongsPlayScreen(
//     //         isFromOffline: isFromOffline,
//     //         AudioData: [],
//     //         startIndex: 0,
//     //         fromMiniPlayer: true,
//     //       ),
//     //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//     //         return FadeTransition(
//     //           opacity: animation,
//     //           child: SlideTransition(
//     //             position: Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
//     //                 .animate(animation),
//     //             child: child,
//     //           ),
//     //         );
//     //       },
//     //     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _audioPlayer = ref.watch(globalPlayerProvider);
//     return StreamBuilder<SequenceState?>(
//         stream: _audioPlayer.sequenceStateStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data!.currentSource != null) {
//             final metadata = snapshot.data!.currentSource!.tag as MediaItem;
//             final isFromDownloads = metadata.extras == null ? true : false;

//             return
//                 // Dismissible(
//                 //   confirmDismiss: (direction) async {
//                 //     if (direction == DismissDirection.up) {
//                 //       _FullScreenPlayer(isFromDownloads);
//                 //       false;
//                 //     }
//                 //     false;
//                 //   },
//                 //   key: ValueKey("fd"),
//                 //   direction: DismissDirection.vertical,
//                 //   child:
//                 Material(
//               borderRadius: BorderRadius.circular(15),
//               // color: Theme.of(context).colorScheme.onSecondaryFixed,
//               clipBehavior: Clip.hardEdge,
//               child: ValueListenableBuilder(
//                   valueListenable: _songImageColor,
//                   builder: (context, value, child) {
//                     return AnimatedContainer(
//                         duration: Duration(milliseconds: 500),
//                         decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                                 colors: [value.withOpacity(.4), Colors.black])),
//                         width: MediaQuery.of(context).size.width,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             _songDetails(
//                                 audioplayer: _audioPlayer,
//                                 isFromOffline: isFromDownloads),
//                             _progressBar(
//                                 audioplayer: _audioPlayer,
//                                 isFromOffline: isFromDownloads),
//                           ],
//                         ));
//                   }),
//             );
//             // );
//           }
//           return SizedBox();
//         });
//   }

//   Widget _songDetails(
//       {required AudioPlayer audioplayer, required bool isFromOffline}) {
//     return StreamBuilder(
//         stream: audioplayer.sequenceStateStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data!.currentSource != null) {
//             final metadata = snapshot.data!.currentSource!.tag as MediaItem;
//             final isFromDownloads = metadata.extras == null ? true : false;
//             _getColorFromImage(metadata.artUri.toString());
//             return ListTile(
//               contentPadding: EdgeInsets.only(top: 5, right: 0, left: 15),
//               title: Text(
//                 metadata.title,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               subtitle: Text(
//                 isFromDownloads
//                     ? metadata.artist ?? "Unknown"
//                     : metadata.extras!["subtitle"],
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               trailing: _controls(
//                   audioplayer: audioplayer, isFromOffline: isFromDownloads),
//               leading: Hero(
//                 tag: "lead",
//                 child: Material(
//                   clipBehavior: Clip.hardEdge,
//                   borderRadius: BorderRadius.circular(10),
//                   child: isFromDownloads
//                       ? QueryArtworkWidget(
//                           artworkBorder: BorderRadius.circular(.5),
//                           nullArtworkWidget: Image.asset("assets/song.png"),
//                           id: int.parse(metadata.id),
//                           type: ArtworkType.AUDIO)
//                       : CachedNetworkImage(
//                           fit: BoxFit.cover,
//                           placeholder: (context, url) => Image.asset(
//                               fit: BoxFit.cover, "assets/album.png"),
//                           errorWidget: (context, url, error) => Image.asset(
//                               fit: BoxFit.cover, "assets/album.png"),
//                           imageUrl: metadata.artUri.toString()),
//                 ),
//               ),
//             );
//           }
//           return SizedBox();
//         });
//   }

//   Widget _progressBar(
//       {required AudioPlayer audioplayer, required bool isFromOffline}) {
//     return StreamBuilder<Duration?>(
//       stream: audioplayer.positionStream,
//       builder: (context, snapshot) {
//         if (snapshot.hasData && snapshot.data!.inSeconds > 1) {
//           return SizedBox(
//             child: ValueListenableBuilder(
//                 valueListenable: _songImageColor,
//                 builder: (context, value, child) {
//                   return ProgressBar(
//                       barHeight: 3,
//                       timeLabelTextStyle: TextStyle(fontSize: 0),
//                       thumbRadius: 0,
//                       baseBarColor: Colors.transparent,
//                       bufferedBarColor: Colors.transparent,
//                       progressBarColor:
//                           value ?? Theme.of(context).colorScheme.primary,
//                       progress: snapshot.data ?? Duration.zero,
//                       buffered: audioplayer.bufferedPosition,
//                       onSeek: (value) => audioplayer.seek(value),
//                       total: audioplayer.duration ?? Duration.zero);
//                 }),
//           );
//         }
//         return SizedBox();
//       },
//     );
//   }

//   Widget _controls(
//       {required AudioPlayer audioplayer, required bool isFromOffline}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         StreamBuilder<PlayerState>(
//             stream: audioplayer.playerStateStream,
//             builder: (context, snapshot) {
//               return IconButton(
//                   onPressed: audioplayer.hasPrevious
//                       ? audioplayer.seekToPrevious
//                       : null,
//                   icon: Icon(
//                     Icons.skip_previous_rounded,
//                   ));
//             }),
//         StreamBuilder<PlayerState>(
//             stream: audioplayer.playerStateStream,
//             builder: (context, snapshot) {
//               final playingState = snapshot.data?.playing;
//               final processingState = snapshot.data?.processingState;
//               if (processingState == ProcessingState.loading ||
//                   processingState == ProcessingState.buffering) {
//                 return Stack(
//                   children: [
//                     SizedBox(
//                       height: 50,
//                       width: 50,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                       ),
//                     ),
//                     Positioned(
//                         bottom: 0,
//                         top: 0,
//                         child: IconButton.filled(
//                             onPressed: null,
//                             icon: Icon(
//                               Icons.play_arrow_rounded,
//                             ))),
//                   ],
//                 );
//               } else if (playingState == true) {
//                 return IconButton.filled(
//                     color: Colors.white,
//                     style: IconButton.styleFrom(
//                       backgroundColor: Colors.white,
//                     ),
//                     onPressed: audioplayer.pause,
//                     icon: Icon(
//                       Icons.pause_rounded,
//                       color: Colors.grey.shade900,
//                     ));
//               } else if (playingState == false) {
//                 return IconButton.filled(
//                     color: Colors.white,
//                     style: IconButton.styleFrom(
//                       backgroundColor: Colors.white,
//                     ),
//                     onPressed: audioplayer.play,
//                     icon: Icon(
//                       Icons.play_arrow_rounded,
//                       color: Colors.grey.shade900,
//                     ));
//               } else {
//                 return IconButton(
//                     onPressed: audioplayer.play,
//                     icon: Icon(
//                       Icons.restart_alt,
//                     ));
//               }
//             }),
//         StreamBuilder<PlayerState>(
//             stream: audioplayer.playerStateStream,
//             builder: (context, snapshot) {
//               return IconButton(
//                   onPressed:
//                       audioplayer.hasNext ? audioplayer.seekToNext : null,
//                   icon: Icon(
//                     Icons.skip_next_rounded,
//                   ));
//             })
//       ],
//     );
//   }
// }
