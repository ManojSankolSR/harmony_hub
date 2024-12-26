import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Musiclistwidget2 extends ConsumerStatefulWidget {
  final Map<String, dynamic> musicData;
  const Musiclistwidget2({super.key, required this.musicData});

  @override
  ConsumerState<Musiclistwidget2> createState() => _Musiclistwidget2State();
}

class _Musiclistwidget2State extends ConsumerState<Musiclistwidget2> {
  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            widget.musicData["title"],
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
              // height: 260,
              height: .85.dp,
              // width: MediaQuery.of(context).size.width,
              child: CarouselView(
                  elevation: 2,
                  // reverse: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onTap: (value) {
                    final data = widget.musicData["data"][value];
                    CustomNavigation.NavigateTo(
                        ref: ref,
                        data["type"],
                        context,
                        data["id"],
                        data["type"] == "song"
                            ? [data]
                            : widget.musicData["data"],
                        data["type"] == "song" ? 0 : value,
                        false);
                  },
                  itemExtent: MediaQuery.of(context).size.width * .8,
                  shrinkExtent: MediaQuery.of(context).size.width * .2,
                  // itemSnapping: true,
                  children: List.generate(
                    widget.musicData["data"].length,
                    (index) => Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    widget.musicData["data"][index]["image"]
                                                .runtimeType ==
                                            List
                                        ? widget.musicData["data"][index]
                                            ["image"][2]["link"]
                                        : widget.musicData["data"][index]
                                            ["image"],
                                  ))),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            top: 0,

                            // right: 0,
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  width: 200,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                        Colors.black,
                                        Colors.transparent
                                      ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topCenter)),
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.musicData["data"][index]["name"],
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // IconButton(
                                          //     iconSize: 40,
                                          //     onPressed: () => {},
                                          //     icon: Icon(Icons
                                          //         .favorite_border_rounded)),
                                          IconButton.filled(
                                              iconSize: 20.sp,
                                              onPressed: () => {},
                                              icon: Icon(
                                                Icons.play_arrow,
                                                color: Colors.black,
                                              ))
                                        ],
                                      ),
                                      // Text(
                                      //   "${widget.musicData["data"][index]["type"].toUpperCase()}  • ${widget.musicData["data"][index]["subtitle"] == null ? "" : widget.musicData["data"][index]["subtitle"].toUpperCase()}",
                                      //   style: Theme.of(context)
                                      //       .textTheme
                                      //       .titleSmall!
                                      //       .copyWith(
                                      //           color: Colors.white,
                                      //           fontWeight: FontWeight.w400),
                                      //   softWrap: false,
                                      //   overflow: TextOverflow.ellipsis,
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ))
              //  M3Carousel(
              //     childClick: (p0) {
              // final data = widget.musicData["data"][p0];
              // CustomNavigation.NavigateTo(
              //     ref: ref,
              //     data["type"],
              //     context,
              //     data["id"],
              //     data["type"] == "song"
              //         ? [data]
              //         : widget.musicData["data"],
              //     data["type"] == "song" ? 0 : p0,
              //     false);
              //     },
              //     visible: 3, // number of visible slabs
              //     borderRadius: 20,
              //     slideAnimationDuration: 500, // milliseconds
              //     titleFadeAnimationDuration: 300,
              //     children: List.generate(
              //       widget.musicData["data"].length,
              //       (index) => {
              //         "image": widget.musicData["data"][index]["image"]
              //                     .runtimeType ==
              //                 List
              //             ? widget.musicData["data"][index]["image"][2]["link"]
              //             : widget.musicData["data"][index]["image"],
              //         "title": widget.musicData["data"][index]["name"],
              //         "subtitle": widget.musicData["data"][index]["subtitle"],
              //       },
              //     )),
              // ListView.builder(
              //   scrollDirection: Axis.horizontal,
              //   itemBuilder: (context, index) {
              //     bool image =
              //         widget.musicData["data"][index]["image"].runtimeType ==
              //             List;
              //     return InkWell(
              //       onTap: () {
              //         CustomNavigation.NavigateTo(
              //             widget.musicData["data"][index]["type"],
              //             context,
              //             widget.musicData["data"][index]["id"],
              //             widget.musicData["data"][index]["type"] == "song"
              //                 ? [widget.musicData["data"][index]]
              //                 : widget.musicData["data"],
              //             widget.musicData["data"][index]["type"] == "song"
              //                 ? 0
              //                 : index,
              //             false);
              //       },
              //       child: Stack(
              //         children: [
              //           Card(
              //             // elevation: _currentIndex == realIndex ? 2 : 0,
              //             margin: EdgeInsets.only(
              //                 bottom: 20, top: 0, left: 10, right: 10),
              //             child: Container(
              //                 // height: 340,
              //                 width: 180,
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(25),
              //                   image: DecorationImage(
              //                       fit: BoxFit.cover,
              //                       image: NetworkImage(image
              //                           ? widget.musicData["data"][index]["image"]
              //                               [2]["link"]
              //                           : widget.musicData["data"][index]
              //                               ["image"])),
              //                 ),
              //                 clipBehavior: Clip.hardEdge,
              //                 child: Stack(
              //                   fit: StackFit.expand,
              //                   alignment: Alignment.bottomLeft,
              //                   children: [
              //                     Positioned(
              //                       bottom: 0,
              //                       left: 0,
              //                       right: 0,
              //                       child: Container(
              //                         clipBehavior: Clip.hardEdge,
              //                         padding: EdgeInsets.all(10),
              //                         decoration: BoxDecoration(
              //                             gradient: LinearGradient(
              //                                 begin: Alignment.bottomCenter,
              //                                 end: Alignment.topCenter,
              //                                 colors: [
              //                               Colors.black87,
              //                               Colors.transparent
              //                             ])),
              //                         child: BackdropFilter(
              //                           filter: ImageFilter.blur(
              //                               sigmaX: 10, sigmaY: 10),
              //                           child: Column(
              //                             crossAxisAlignment:
              //                                 CrossAxisAlignment.start,
              //                             children: [
              //                               Text(
              // widget.musicData["data"][index]
              //     ["name"],
              //                                 style: Theme.of(context)
              //                                     .textTheme
              //                                     .titleMedium!
              //                                     .copyWith(
              //                                         fontWeight:
              //                                             FontWeight.w500),
              //                                 overflow: TextOverflow.ellipsis,
              //                               ),
              //                               Text(
              // widget.musicData["data"][index]
              //     ["subtitle"],
              //                                 style: Theme.of(context)
              //                                     .textTheme
              //                                     .bodySmall!
              //                                     .copyWith(
              //                                         fontWeight:
              //                                             FontWeight.w400),
              //                                 overflow: TextOverflow.ellipsis,
              //                               ),
              //                             ],
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 )),
              //           ),
              //           if (_currentIndex == index)
              // Positioned(
              //     bottom: 0,
              //     right: 30,
              //     child: Container(
              //       padding: EdgeInsets.all(8),
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: Theme.of(context)
              //             .colorScheme
              //             .onPrimaryFixedVariant,
              //       ),
              //       child: Icon(
              //         Icons.play_arrow,
              //         size: 35,
              //       ),
              //     )).animate().scale(),
              //         ],
              //       ),
              //     );
              //   },
              // )

              //  CarouselSlider.builder(
              //     itemCount: widget.musicData["data"].length,
              //     itemBuilder: (context, index, realIndex) {
              //       bool image =
              //           widget.musicData["data"][index]["image"].runtimeType ==
              //               List;
              //       return InkWell(
              //         onTap: () {
              //           CustomNavigation.NavigateTo(
              //               widget.musicData["data"][index]["type"],
              //               context,
              //               widget.musicData["data"][index]["id"],
              //               widget.musicData["data"][index]["type"] == "song"
              //                   ? [widget.musicData["data"][index]]
              //                   : widget.musicData["data"],
              //               widget.musicData["data"][index]["type"] == "song"
              //                   ? 0
              //                   : index,
              //               false);
              //         },
              //         child: Stack(
              //           children: [
              //             Card(
              //               elevation: _currentIndex == realIndex ? 2 : 0,
              //               margin: EdgeInsets.only(
              //                   bottom: 20, top: 0, left: 10, right: 10),
              //               child: Container(
              //                   height: 340,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(10),
              //                     image: DecorationImage(
              //                         fit: BoxFit.cover,
              //                         image: NetworkImage(image
              //                             ? widget.musicData["data"][index]
              //                                 ["image"][2]["link"]
              //                             : widget.musicData["data"][index]
              //                                 ["image"])),
              //                   ),
              //                   clipBehavior: Clip.hardEdge,
              //                   child: Stack(
              //                     fit: StackFit.expand,
              //                     alignment: Alignment.bottomLeft,
              //                     children: [
              //                       Positioned(
              //                         bottom: 0,
              //                         left: 0,
              //                         right: 0,
              //                         child: Container(
              //                           clipBehavior: Clip.hardEdge,
              //                           padding: EdgeInsets.all(10),
              //                           decoration: BoxDecoration(
              //                               gradient: LinearGradient(
              //                                   begin: Alignment.bottomCenter,
              //                                   end: Alignment.topCenter,
              //                                   colors: [
              //                                 Colors.black87,
              //                                 Colors.transparent
              //                               ])),
              //                           child: BackdropFilter(
              //                             filter: ImageFilter.blur(
              //                                 sigmaX: 10, sigmaY: 10),
              //                             child: Column(
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               children: [
              //                                 Text(
              //                                   widget.musicData["data"][index]
              //                                       ["name"],
              //                                   style: Theme.of(context)
              //                                       .textTheme
              //                                       .titleLarge!
              //                                       .copyWith(
              //                                           fontWeight:
              //                                               FontWeight.w500),
              //                                   overflow: TextOverflow.ellipsis,
              //                                 ),
              //                                 Text(
              //                                   widget.musicData["data"][index]
              //                                       ["subtitle"],
              //                                   style: Theme.of(context)
              //                                       .textTheme
              //                                       .titleSmall!
              //                                       .copyWith(
              //                                           fontWeight:
              //                                               FontWeight.w400),
              //                                   overflow: TextOverflow.ellipsis,
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   )),
              //             ),
              //             if (_currentIndex == index)
              //               Positioned(
              //                   bottom: 0,
              //                   right: 30,
              //                   child: Container(
              //                     padding: EdgeInsets.all(8),
              //                     decoration: BoxDecoration(
              //                       shape: BoxShape.circle,
              //                       color: Theme.of(context)
              //                           .colorScheme
              //                           .onPrimaryFixedVariant,
              //                     ),
              //                     child: Icon(
              //                       Icons.play_arrow,
              //                       size: 35,
              //                     ),
              //                   )).animate().scale(),
              //           ],
              //         ),
              //       );
              //     },
              //     options: CarouselOptions(
              //       enableInfiniteScroll: true,
              //       enlargeCenterPage: true,
              //       onPageChanged: (index, reason) {
              //         print(index);
              //         setState(() {
              //           _currentIndex = index;
              //         });
              //       },
              //       enlargeFactor: .3,
              //       viewportFraction: .70,
              //       enlargeStrategy: CenterPageEnlargeStrategy.zoom,
              //     ))
              ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
