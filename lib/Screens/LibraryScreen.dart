import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harmony_hub/Screens/DownloadScreen.dart';
import 'package:harmony_hub/Screens/FavouritesScreen.dart';
import 'package:harmony_hub/Screens/HistoryScreen.dart';
import 'package:harmony_hub/Screens/PlaylistsScreen.dart';
import 'package:harmony_hub/Widgets/CustomListView.dart';
import 'package:harmony_hub/Widgets/NotFoundWidget.dart';
import 'package:harmony_hub/Widgets/PlaylistImageWidget.dart';
import 'package:harmony_hub/main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:harmony_hub/Hive/Boxes.dart';

import '../Functions/Playlist.dart';

class LibraryScreen extends StatefulWidget {
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Widget> getTopListWidgets() => [
        CustomListView(
            leading: Icon(size: 25.sp, Icons.favorite_border_rounded),
            title: "Liked Songs",
            subTitle: "Liked Songs Will Appear Here",
            onPressed: () => {
                  pushScreen(context,
                      screen: const Favouritesscreen(),
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                      withNavBar: true)
                }),
        CustomListView(
            leading: Icon(size: 25.sp, Icons.file_download_outlined),
            title: "Downloads",
            subTitle: "Downloaded Songs Will Appear Here",
            onPressed: () => {
                  pushScreen(context,
                      screen: Downloadscreen(),
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                      withNavBar: true)
                }),
        CustomListView(
            leading: Icon(size: 25.sp, Icons.history),
            title: "Recently Played",
            subTitle: "Recent Songs Will Appear Here",
            onPressed: () => {
                  pushScreen(context,
                      screen: Historyscreen(),
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                      withNavBar: true)
                }),
        CustomListView(
            leading: Icon(size: 25.sp, Icons.history),
            title: "PlayLists",
            subTitle: "PlayLists Will Appear Here",
            onPressed: () => {
                  pushScreen(context,
                      screen: Playlistscreen(),
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                      withNavBar: true)
                })
      ];

  late List<Widget> topListWidgets;
  @override
  void initState() {
    super.initState();
    topListWidgets = getTopListWidgets();
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          // titleSpacing: 6,

          floating: true,
          leading: Icon(
            color: Theme.of(context).colorScheme.primary,
            Icons.library_music_outlined,
            size: 23.sp,
          ),
          // actions: [
          //   SizedBox(
          //     height: 22.sp,
          //     width: 22.sp,
          //     child: Image.asset(
          //       "assets/splash.png",
          //     ),
          //   ),
          //   SizedBox(
          //     width: 20,
          //   ),
          // ],
          title: Row(
            children: [
              Text(
                "Your ",
                style: GoogleFonts.permanentMarker(
                    // color: Theme.of(context).colorScheme.primary,,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w100),
              ),
              Text(
                "Library",
                style: GoogleFonts.permanentMarker(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w100),
              ),
            ],
          ),
        ),

        // SliverAppBar(
        //   stretch: true,
        //   flexibleSpace: FlexibleSpaceBar(
        //     centerTitle: true,
        //     stretchModes: [StretchMode.fadeTitle],
        //     title: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           "Your ",
        //         ),
        //         Text("Library  ",
        //             style: TextStyle(
        //               color: Theme.of(context).colorScheme.primary,
        //             )),
        //         Icon(
        //           Icons.library_music_outlined,
        //           color: Theme.of(context).colorScheme.primary,
        //         )
        //       ],
        //     ),
        //   ),
        //   // expandedHeight: 130,
        //   centerTitle: true,
        //   // leading: Builder(
        //   //   builder: (context) {
        //   //     return IconButton(
        //   //       icon: Icon(Icons.horizontal_split_rounded),
        //   //       onPressed: () {
        //   //         Scaffold.of(context).openDrawer();
        //   //       },
        //   //     );
        //   //   },
        //   // ),
        //   pinned: true,
        // ),

        ValueListenableBuilder(
            valueListenable: Boxes.UserBox.listenable(),
            builder: (context, value, child) {
              List<Map<String, dynamic>> playlists = Playlists.getPlylists();
              if (playlists.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Notfoundwidget()),
                );
              }
              return SliverList.builder(
                itemCount: playlists.length + topListWidgets.length,
                itemBuilder: (context, index) {
                  if (index < topListWidgets.length) {
                    return topListWidgets[index];
                  }
                  int itemIndex = index - topListWidgets.length;
                  return CustomListView(
                    title: playlists[itemIndex]["name"],
                    subTitle: "${playlists[itemIndex]["songs"].length} Songs",
                    onPressed: () => {
                      pushScreen(context,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                          withNavBar: true,
                          screen: showPlaylist(
                              playlist: playlists[
                                  playlists[itemIndex]["songs"].length]))
                    },
                    leading: Playlistimagewidget(
                        images: List.generate(
                          playlists[itemIndex]["songs"].length,
                          (ind) {
                            return playlists[itemIndex]["songs"][ind]["image"]
                                        .runtimeType ==
                                    List
                                ? playlists[itemIndex]["songs"][ind]["image"][2]
                                    ["link"]
                                : playlists[itemIndex]["songs"][ind]["image"];
                          },
                        ),
                        length: playlists[itemIndex]["songs"].length),
                  );
                },
              );
            })

        // SliverList.builder(itemBuilder: )
        // SliverList(
        //     delegate: SliverChildListDelegate([
        // CustomListView(
        //     leading: Icon(size: 25.sp, Icons.favorite_border_rounded),
        //     title: "Liked Songs",
        //     subTitle: "Liked Songs Will Appear Here",
        //     onPressed: () => {
        //           pushScreen(context,
        //               screen: const Favouritesscreen(),
        //               pageTransitionAnimation:
        //                   PageTransitionAnimation.slideUp,
        //               withNavBar: true)
        //         }),
        // CustomListView(
        //     leading: Icon(size: 25.sp, Icons.file_download_outlined),
        //     title: "Downloads",
        //     subTitle: "Downloaded Songs Will Appear Here",
        //     onPressed: () => {
        //           pushScreen(context,
        //               screen: Downloadscreen(),
        //               pageTransitionAnimation:
        //                   PageTransitionAnimation.slideUp,
        //               withNavBar: true)
        //         }),
        // CustomListView(
        //     leading: Icon(size: 25.sp, Icons.history),
        //     title: "Recently Played",
        //     subTitle: "Recent Songs Will Appear Here",
        //     onPressed: () => {
        //           pushScreen(context,
        //               screen: Historyscreen(),
        //               pageTransitionAnimation:
        //                   PageTransitionAnimation.slideUp,
        //               withNavBar: true)
        //         }),
        // CustomListView(
        //     leading: Icon(size: 25.sp, Icons.history),
        //     title: "PlayLists",
        //     subTitle: "PlayLists Will Appear Here",
        //     onPressed: () => {
        //           pushScreen(context,
        //               screen: Playlistscreen(),
        //               pageTransitionAnimation:
        //                   PageTransitionAnimation.slideUp,
        //               withNavBar: true)
        //         }),
        // ])),
      ],
    );
  }
}
