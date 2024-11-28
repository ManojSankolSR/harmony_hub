import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Functions/MusicPlayer.dart';
import 'package:harmony_hub/Screens/DownloadScreen.dart';
import 'package:harmony_hub/Screens/FavouritesScreen.dart';
import 'package:harmony_hub/Screens/HistoryScreen.dart';
import 'package:harmony_hub/Screens/OnlineHomeScreen.dart';
import 'package:harmony_hub/Screens/OfflineHomeScreen.dart';
import 'package:harmony_hub/Screens/PlaylistsScreen.dart';
import 'package:harmony_hub/Screens/SettingsScreen.dart';
import 'package:harmony_hub/Widgets/DrawerWidget.dart';
import 'package:harmony_hub/Widgets/MiniAudioPlayer.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  final int _PageIndex = 0;
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        navBarOverlap: const NavBarOverlap.none(),
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
              screen:
                  //  _isInternetConncted
                  //     ?
                  const OnlineHomeScreen(),
              // :
              //  OfflineHomescreen(),
              item: ItemConfig(icon: const Icon(Icons.home))),
          PersistentTabConfig(
              screen: Playlistscreen(
                persistentTabController: controller,
              ),
              item: ItemConfig(icon: const Icon(Icons.home))),
          PersistentTabConfig(
              screen: const Favouritesscreen(),
              item: ItemConfig(icon: const Icon(Icons.home))),
          PersistentTabConfig(
              screen: Downloadscreen(),
              item: ItemConfig(icon: const Icon(Icons.home))),
          PersistentTabConfig(
              screen: const Historyscreen(),
              item: ItemConfig(icon: const Icon(Icons.home))),
          PersistentTabConfig(
              screen: const Settingsscreen(),
              item: ItemConfig(icon: const Icon(Icons.home))),
        ],
        navBarBuilder: (p0) => const Column(
              mainAxisSize: MainAxisSize.min,
              children: [Miniaudioplayer()],
            ));
  }
}
