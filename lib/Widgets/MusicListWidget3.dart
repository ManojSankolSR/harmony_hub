import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Screens/LibraryScreen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MusicListWidget3 extends ConsumerWidget {
  final Map<String, dynamic> musicData;
  const MusicListWidget3({super.key, required this.musicData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Text(
            musicData["title"],
            style: TextStyle(
                fontSize: 20,
                //Theme.of(context).textTheme.titleLarge!.fontSize,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        SizedBox(
          height: .75.dp,
          child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: musicData["data"].length,
              itemBuilder: (context, index) {
                bool isImageList =
                    musicData["data"][index]["image"].runtimeType == List;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        CustomNavigation.NavigateTo(
                          ref: ref,
                          musicData["data"][index]["type"],
                          context,
                          musicData["data"][index]["id"],
                          [musicData["data"][index]],
                          0,
                          false,
                        );
                      },
                      child: SizedBox(
                          width: 90.w,
                          child: Row(
                            children: [
                              Container(
                                // clipBehavior: Clip.antiAlias,
                                // decoration: BoxDecoration(
                                //   shape: (musicData["data"][index]["type"] ==
                                //               "radio_station") ||
                                //           (musicData["data"][index]["type"] == "artist")
                                //       ? BoxShape.circle
                                //       : BoxShape.rectangle,
                                //   borderRadius: musicData["data"][index]["type"] ==
                                //               "radio_station" ||
                                //           (musicData["data"][index]["type"] == "artist")
                                //       ? null
                                //       : BorderRadius.circular(10),
                                // ),
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset(
                                        fit: BoxFit.cover, "assets/album.png"),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            fit: BoxFit.cover,
                                            "assets/album.png"),
                                    imageUrl: isImageList
                                        ? musicData["data"][index]["image"][2]
                                            ["link"]
                                        : musicData["data"][index]["image"]),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            musicData["data"][index]["name"],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "${musicData["data"][index]["type"].toUpperCase()}  • ${musicData["data"][index]["subtitle"] == null ? "" : musicData["data"][index]["subtitle"].toUpperCase()}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(
                                                    color: isLightMode
                                                        ? Colors.black87
                                                        : Colors.white70,
                                                    fontWeight:
                                                        FontWeight.w400),
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                              iconSize: 20.sp,
                                              onPressed: () => {},
                                              icon: Icon(Icons
                                                  .favorite_border_rounded)),
                                          IconButton.filled(
                                              iconSize: 20.sp,
                                              onPressed: () => {},
                                              icon: Icon(
                                                Icons.play_arrow,
                                                color: Colors.black,
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                          //  Column(
                          //   children: [
                          // Container(
                          //   height: 160,
                          //   width: 170,
                          //   clipBehavior: Clip.antiAlias,
                          //   decoration: BoxDecoration(
                          //     shape: (musicData["data"][index]["type"] ==
                          //                 "radio_station") ||
                          //             (musicData["data"][index]["type"] == "artist")
                          //         ? BoxShape.circle
                          //         : BoxShape.rectangle,
                          //     borderRadius: musicData["data"][index]["type"] ==
                          //                 "radio_station" ||
                          //             (musicData["data"][index]["type"] == "artist")
                          //         ? null
                          //         : BorderRadius.circular(10),
                          //   ),
                          //   child: CachedNetworkImage(
                          //       fit: BoxFit.cover,
                          //       placeholder: (context, url) => Image.asset(
                          //           fit: BoxFit.cover, "assets/album.png"),
                          //       errorWidget: (context, url, error) => Image.asset(
                          //           fit: BoxFit.cover, "assets/album.png"),
                          //       imageUrl: isImageList
                          //           ? musicData["data"][index]["image"][2]["link"]
                          //           : musicData["data"][index]["image"]),
                          // ),
                          //     // SizedBox(
                          //     //   height: 2,
                          //     // ),
                          // Text(
                          //   musicData["data"][index]["name"],
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .bodyMedium!
                          //       .copyWith(fontWeight: FontWeight.w500),
                          //   softWrap: false,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          // Text(
                          //   "${musicData["data"][index]["type"].toUpperCase()}  • ${musicData["data"][index]["subtitle"] == null ? "" : musicData["data"][index]["subtitle"].toUpperCase()}",
                          //   style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          //       color: isLightMode ? Colors.black87 : Colors.white70,
                          //       fontWeight: FontWeight.w400),
                          //   softWrap: false,
                          //   overflow: TextOverflow.ellipsis,
                          // )
                          //   ],
                          // ),

                          ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
