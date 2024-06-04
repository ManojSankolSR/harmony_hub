import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Drawerwidget extends StatelessWidget {
  void Function(int value) changePageIndex;
  final int currentPageIndex;
  Drawerwidget(
      {super.key,
      required this.changePageIndex,
      required this.currentPageIndex});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return NavigationDrawer(
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedIndex: currentPageIndex,
        onDestinationSelected: changePageIndex,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Theme.of(context).colorScheme.onPrimaryFixed,
                  Colors.transparent,
                ])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.my_library_music,
                  size: 90,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
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
                                color: Theme.of(context).colorScheme.primary)),
                        Text("Hub",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                height: 1.1,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary)),
                        RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
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
          NavigationDrawerDestination(
              icon: Icon(CupertinoIcons.home), label: Text("Home")),
          // NavigationDrawerDestination(
          //     selectedIcon: Icon(Icons.my_library_music_rounded),
          //     icon: Icon(Icons.my_library_music_outlined),
          //     label: Text("Playlists")),
          // NavigationDrawerDestination(
          //     selectedIcon: Icon(Icons.favorite),
          //     icon: Icon(Icons.favorite_outline_sharp),
          //     label: Text("Favourates")),
          // NavigationDrawerDestination(
          //     selectedIcon: Icon(Icons.download),
          //     icon: Icon(Icons.download_outlined),
          //     label: Text("Downloads")),
          NavigationDrawerDestination(
              icon: Icon(Icons.history_toggle_off_outlined),
              label: Text("History")),
          NavigationDrawerDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: Text("settings")),
        ]);
  }
}
