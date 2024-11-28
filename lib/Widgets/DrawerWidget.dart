import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Drawerwidget extends StatefulWidget {
  final void Function(int value) changePageIndex;

  final PersistentTabController controller;
  const Drawerwidget(
      {super.key, required this.controller, required this.changePageIndex});

  @override
  State<Drawerwidget> createState() => _DrawerwidgetState();
}

class _DrawerwidgetState extends State<Drawerwidget> {
  // Drawerwidget(
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    // TODO: implement build
    return NavigationDrawer(
        selectedIndex: widget.controller.index,
        onDestinationSelected: widget.changePageIndex,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  if (isLightMode)
                    Theme.of(context).colorScheme.primaryContainer,
                  if (!isLightMode)
                    Theme.of(context).colorScheme.onPrimaryFixed,
                  Theme.of(context).colorScheme.surfaceContainerLow
                ])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset(
                        fit: BoxFit.contain,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        "assets/icon.png")),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Harmony",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                height: 1.1,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer)),
                        Text("Hub",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                height: 1.1,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer)),
                        RichText(
                            textAlign: TextAlign.start,
                            text: const TextSpan(
                                style: TextStyle(
                                    height: 1.1,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: "Music",
                                  ),
                                  TextSpan(
                                    text: ".",
                                  )
                                ])),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          const NavigationDrawerDestination(
              icon: Icon(CupertinoIcons.home), label: Text("Home")),
          const NavigationDrawerDestination(
              selectedIcon: Icon(Icons.my_library_music_rounded),
              icon: Icon(Icons.my_library_music_outlined),
              label: Text("Playlists")),
          const NavigationDrawerDestination(
              selectedIcon: Icon(Icons.favorite),
              icon: Icon(Icons.favorite_outline_sharp),
              label: Text("Favourites")),
          const NavigationDrawerDestination(
              selectedIcon: Icon(Icons.download),
              icon: Icon(Icons.download_outlined),
              label: Text("Downloads")),
          const NavigationDrawerDestination(
              icon: Icon(Icons.history_toggle_off_outlined),
              label: Text("History")),
          const NavigationDrawerDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: Text("settings")),
        ]);
  }
}
