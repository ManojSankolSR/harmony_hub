import 'dart:async';
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
import 'package:harmony_hub/Providers/seedColorProvider.dart';
import 'package:harmony_hub/Screens/DownloadScreen.dart';
import 'package:harmony_hub/Screens/FavouritesScreen.dart';
import 'package:harmony_hub/Screens/HistoryScreen.dart';
import 'package:harmony_hub/Screens/OnlineHomeScreen.dart';
import 'package:harmony_hub/Screens/OfflineHomeScreen.dart';
import 'package:harmony_hub/Screens/PlaylistsScreen.dart';
import 'package:harmony_hub/Screens/SearchScreen.dart';
import 'package:harmony_hub/Screens/SettingsScreen.dart';
import 'package:harmony_hub/Widgets/DrawerWidget.dart';
import 'package:harmony_hub/Widgets/MiniAudioPlayer.dart';
import 'package:harmony_hub/Widgets/MiniPlayerNavigationHandler.dart';
import 'package:harmony_hub/Widgets/MusicListWidget.dart';
import 'package:harmony_hub/Widgets/MusicListWidget2.dart';
import 'package:harmony_hub/Widgets/SongBottomBarWidget.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Homescreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  int _PageIndex = 0;
  bool _isInternetConncted = false;
  PersistentTabController controller = PersistentTabController();
  late StreamSubscription _internetstreamSubscription;
  // void changeNavBarPageIndex(value) {
  //   setState(() {
  //     _PageIndex = value;
  //   });
  //   Navigator.pop(context);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final data = Boxes.getLastSessionData();
    if (data.containsKey("data") && data.containsKey("currentIndex")) {
      Musicplayer.setUpAudioPlayer(ref,
          AudioData: data["data"], startIndex: data["currentIndex"]);
    }
    Musicplayer.initEventlistnerToSaveSessionData(ref);
    InternetConnection().onStatusChange.listen(
      (event) {
        setState(() {
          if (event == InternetStatus.connected) {
            setState(() {
              _isInternetConncted = true;
            });
          } else {
            _isInternetConncted = false;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _internetstreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        controller: controller,
        avoidBottomPadding: true,
        screenTransitionAnimation: ScreenTransitionAnimation(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        navBarOverlap: NavBarOverlap.none(),
        drawer: Builder(builder: (context) {
          return Drawerwidget(
            changePageIndex: (value) {
              controller.jumpToTab(value);
              controller.scaffoldKey.currentState!.closeDrawer();
            },
            controller: controller,
          );
        }),
        tabs: [
          PersistentTabConfig(
              screen: _isInternetConncted
                  ? OnlineHomeScreen()
                  : OfflineHomescreen(),
              item: ItemConfig(icon: Icon(Icons.home))),
          PersistentTabConfig(
              screen: Playlistscreen(
                persistentTabController: controller,
              ),
              item: ItemConfig(icon: Icon(Icons.home))),
          PersistentTabConfig(
              screen: Favouritesscreen(),
              item: ItemConfig(icon: Icon(Icons.home))),
          PersistentTabConfig(
              screen: Downloadscreen(),
              item: ItemConfig(icon: Icon(Icons.home))),
          PersistentTabConfig(
              screen: Historyscreen(),
              item: ItemConfig(icon: Icon(Icons.home))),
          PersistentTabConfig(
              screen: Settingsscreen(),
              item: ItemConfig(icon: Icon(Icons.home))),
        ],
        navBarBuilder: (p0) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [Miniaudioplayer()],
            ));
  }
}
