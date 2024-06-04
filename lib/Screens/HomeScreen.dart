import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Functions/MusicPlayer.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Screens/DownloadScreen.dart';
import 'package:harmony_hub/Screens/FavouritesScreen.dart';
import 'package:harmony_hub/Screens/HistoryScreen.dart';
import 'package:harmony_hub/Screens/HomeScreen1.dart';
import 'package:harmony_hub/Screens/PlaylistsScreen.dart';
import 'package:harmony_hub/Screens/SearchScreen.dart';
import 'package:harmony_hub/Screens/SettingsScreen.dart';
import 'package:harmony_hub/Widgets/DrawerWidget.dart';
import 'package:harmony_hub/Widgets/MusicListWidget.dart';
import 'package:harmony_hub/Widgets/MusicListWidget2.dart';
import 'package:harmony_hub/Widgets/SongBottomBarWidget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Homescreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  int _PageIndex = 0;
  void changeNavBarPageIndex(value) {
    setState(() {
      _PageIndex = value;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final data = Boxes.getLastSessionData();
    if (data.containsKey("data") && data.containsKey("currentIndex")) {
      Musicplayer.setUpAudioPlayer(ref,
          AudioData: data["data"], startIndex: data["currentIndex"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: [
          PersistentTabView(
            avoidBottomPadding: false,
            stateManagement: false,
            screenTransitionAnimation: ScreenTransitionAnimation.none(),
            backgroundColor: Theme.of(context).colorScheme.surface,
            drawer: Drawerwidget(
                changePageIndex: changeNavBarPageIndex,
                currentPageIndex: _PageIndex),
            tabs: [
              PersistentTabConfig(
                  screen: Homescreen1(),
                  item: ItemConfig(
                      inactiveForegroundColor: Colors.white,
                      activeForegroundColor:
                          Theme.of(context).colorScheme.primary,
                      icon: Icon(CupertinoIcons.home),
                      title: "Home")),
              PersistentTabConfig(
                  screen: Favouritesscreen(),
                  item: ItemConfig(
                      inactiveForegroundColor: Colors.white,
                      activeForegroundColor:
                          Theme.of(context).colorScheme.primary,
                      icon: Icon(Icons.favorite_outline_sharp),
                      title: "Favourates")),
              PersistentTabConfig(
                  screen: Downloadscreen(),
                  item: ItemConfig(
                      inactiveForegroundColor: Colors.white,
                      activeForegroundColor:
                          Theme.of(context).colorScheme.primary,
                      icon: Icon(Icons.download_outlined),
                      title: "Downloads")),
              PersistentTabConfig(
                  screen: Playlistscreen(),
                  item: ItemConfig(
                      inactiveForegroundColor: Colors.white,
                      activeForegroundColor:
                          Theme.of(context).colorScheme.primary,
                      inactiveIcon: Icon(Icons.my_library_music_outlined),
                      icon: Icon(Icons.my_library_music_rounded),
                      title: "Playlists")),
            ],
            navBarBuilder: (p0) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Songbottombarwidget(),
                Style8BottomNavBar(
                  navBarConfig: p0,
                  navBarDecoration: NavBarDecoration(
                      color: Theme.of(context).colorScheme.surface),
                ),
              ],
            ),
          ),
          Historyscreen(),
          Settingsscreen(),
        ][_PageIndex]

        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // bottomNavigationBar: const Songbottombarwidget(),
        // body: [
        // CustomScrollView(
        //   slivers: [
        //     SliverAppBar.medium(
        //         leading: Builder(builder: (context) {
        //           return IconButton(
        //             icon: Icon(Icons.horizontal_split_rounded),
        //             onPressed: () {
        //               Scaffold.of(context).openDrawer();
        //             },
        //           );
        //         }),
        //         // centerTitle: true,
        //         pinned: true,
        //         title: Row(
        //           children: [
        //             Text(
        //               "Harmony ",
        //             ),
        //             Text("Hub",
        //                 style: TextStyle(
        //                   color: Theme.of(context).colorScheme.primary,
        //                 ))
        //           ],
        //         )),
        //     SliverAppBar(
        //       primary: false,
        //       floating: true,
        //       snap: true,
        //       automaticallyImplyLeading: false,
        //       titleSpacing: 10,
        //       title: Material(
        //         borderRadius: BorderRadius.circular(10),
        //         color: Theme.of(context).colorScheme.onPrimary,
        //         // const Color.fromARGB(255, 54, 54, 54),
        //         clipBehavior: Clip.antiAlias,
        //         child: InkWell(
        //           onTap: () {
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) => Searchscreen(),
        //                 ));
        //           },
        //           child: Container(
        //             padding: EdgeInsets.symmetric(horizontal: 10),
        //             height: 45,
        //             decoration: BoxDecoration(),
        //             child: Row(
        //               children: [
        //                 Icon(CupertinoIcons.search),
        //                 SizedBox(width: 10),
        //                 Text(
        //                   "Search Songs,Abums or Playlists",
        //                   style: TextStyle(
        //                       fontWeight: FontWeight.w300,
        //                       fontSize: 17,
        //                       color: Colors.grey.shade100),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //     CupertinoSliverRefreshControl(
        //         onRefresh: () => ref.refresh(HomeScreenDataProvider.future)),
        //     SliverToBoxAdapter(
        //       child: ref.watch(HomeScreenDataProvider).when(
        //             data: (data) {
        //               Boxes.saveHomeScreendata(data);

        //               return Column(
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Musiclistwidget2(musicData: data["trending"]),
        //                   _nullCheckAndDisplayWidget(data, "charts"),
        //                   _nullCheckAndDisplayWidget(data, "albums"),
        //                   _nullCheckAndDisplayWidget(data, "playlists"),
        //                   // _nullCheckAndDisplayWidget(data, "radio"),
        //                   _nullCheckAndDisplayWidget(data, "artist_recos"),
        //                   _nullCheckAndDisplayWidget(data, "promo0"),
        //                   _nullCheckAndDisplayWidget(data, "promo1"),
        //                   _nullCheckAndDisplayWidget(data, "promo2"),
        //                   _nullCheckAndDisplayWidget(data, "promo3"),
        //                   _nullCheckAndDisplayWidget(data, "promo4"),
        //                   _nullCheckAndDisplayWidget(data, "promo5"),
        //                   _nullCheckAndDisplayWidget(data, "promo6"),
        //                   _nullCheckAndDisplayWidget(data, "promo7"),
        //                 ],
        //               );
        //             },
        //             error: (error, stackTrace) => Text(error.toString()),
        //             loading: () => Center(
        //               child: CircularProgressIndicator(),
        //             ),
        //           ),
        //     )
        //   ],
        // ),
        //   Playlistscreen(),
        //   Favouritesscreen(),
        //   Downloadscreen(),
        //   Historyscreen(),
        //   Settingsscreen()
        // ][_PageIndex]
        );
  }
}
