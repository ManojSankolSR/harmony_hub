import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Functions/MusicPlayer.dart';
import 'package:harmony_hub/Providers/seedColorProvider.dart';
import 'package:harmony_hub/Screens/DownloadScreen.dart';
import 'package:harmony_hub/Screens/FavouritesScreen.dart';
import 'package:harmony_hub/Screens/HistoryScreen.dart';
import 'package:harmony_hub/Screens/LibraryScreen.dart';
import 'package:harmony_hub/Screens/OnlineHomeScreen.dart';
import 'package:harmony_hub/Screens/OfflineHomeScreen.dart';
import 'package:harmony_hub/Screens/PlaylistsScreen.dart';
import 'package:harmony_hub/Screens/SearchScreen.dart';
import 'package:harmony_hub/Screens/SettingsScreen.dart';
import 'package:harmony_hub/Widgets/DrawerWidget.dart';
import 'package:harmony_hub/Widgets/MiniAudioPlayer.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
  late MiniplayerController miniplayerController;

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
    miniplayerController = MiniplayerController();
    miniplayerController.addListener(() => setState(() {}));
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
    print("pamelsatet ${miniplayerController.value?.panelState}");
    return PersistentTabView(
        controller: controller,
        avoidBottomPadding: true,
        // backgroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.surface,
        navBarOverlap: const NavBarOverlap.none(),

        // drawer: Builder(builder: (context) {
        //   return Drawerwidget(
        //     changePageIndex: (value) {
        //       controller.jumpToTab(value);

        //       controller.scaffoldKey.currentState!.closeDrawer();
        //     },
        //     controller: controller,
        //   );
        // }),
        tabs: [
          PersistentTabConfig(
              screen:
                  //  _isInternetConncted
                  //     ?
                  const OnlineHomeScreen(),
              // :
              //  OfflineHomescreen(),

              item: ItemConfig(
                  icon: const Icon(Clarity.home_solid),
                  inactiveIcon: const Icon(Clarity.home_line),
                  title: "Home",
                  activeForegroundColor: Theme.of(context).colorScheme.primary,
                  inactiveForegroundColor:
                      Theme.of(context).colorScheme.secondary)),

          PersistentTabConfig(
              screen: const Searchscreen(),
              item: ItemConfig(
                  icon: const Icon(Clarity.search_line),
                  title: "Search",
                  // activeForegroundColor: Colors.white,
                  activeForegroundColor: Theme.of(context).colorScheme.primary,
                  inactiveForegroundColor:
                      Theme.of(context).colorScheme.secondary)),

          PersistentTabConfig(
              screen: LibraryScreen(),
              item: ItemConfig(
                  inactiveIcon: const Icon(
                    Clarity.library_line,
                  ),
                  icon: const Icon(
                    Clarity.library_solid,
                  ),
                  title: "Library",
                  // activeForegroundColor: Colors.white,
                  activeForegroundColor: Theme.of(context).colorScheme.primary,
                  inactiveForegroundColor:
                      Theme.of(context).colorScheme.secondary)),

          PersistentTabConfig(
              screen: Settingsscreen(),
              item: ItemConfig(
                  icon: const Icon(Clarity.settings_solid),
                  inactiveIcon: const Icon(Clarity.settings_line),
                  title: "Settings",
                  // activeForegroundColor: Colors.white,
                  activeForegroundColor: Theme.of(context).colorScheme.primary,
                  inactiveForegroundColor:
                      Theme.of(context).colorScheme.secondary)),
          // PersistentTabConfig(
          //     screen: const Favouritesscreen(),
          //     item: ItemConfig(icon: const Icon(Icons.home))),
          // PersistentTabConfig(
          //     screen: Downloadscreen(),
          //     item: ItemConfig(icon: const Icon(Icons.home))),
          // PersistentTabConfig(
          //     screen: const Historyscreen(),
          //     item: ItemConfig(icon: const Icon(Icons.home))),
          // PersistentTabConfig(
          //     screen: const Settingsscreen(),
          //     item: ItemConfig(icon: const Icon(Icons.home))),
        ],
        navBarBuilder: (p0) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MiniAudioPlayer(),
                // Container(
                //   color: Colors.grey.shade600,
                //   height: 3.sp,
                // ),
                // if (miniplayerController.value?.panelState == null ||
                //     miniplayerController.value?.panelState == PanelState.MIN)
                Style7BottomNavBar(
                  navBarDecoration: NavBarDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  navBarConfig: p0,
                ),
              ],
            ));
  }
}
