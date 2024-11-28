import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Widgets/CustomSliverGrid.dart';
import 'package:harmony_hub/Widgets/CustomSnackbar.dart';

class OfflineHomescreen extends ConsumerWidget {
  List<Map<String, dynamic>> LastSessiondata = Boxes.getSongsHistory();
  List<Map<String, dynamic>> FavSongs = Boxes.getFavSongs();

  OfflineHomescreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    // TODO: implement build
    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(
            leading: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.horizontal_split_rounded),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
            // centerTitle: true,
            pinned: true,
            title: Row(
              children: [
                const Text(
                  "Harmony ",
                ),
                Text("Hub",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ))
              ],
            )),
        SliverAppBar(
          primary: false,
          floating: true,
          snap: true,
          automaticallyImplyLeading: false,
          titleSpacing: 10,
          title: Material(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.onPrimary,
            // const Color.fromARGB(255, 54, 54, 54),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Customsnackbar(
                    title: "Offline",
                    subTitle:
                        "Please Turn on Your Internet to acess This Feature",
                    context: context,
                    type: ContentType.warning);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 45,
                decoration: const BoxDecoration(),
                child: const Row(
                  children: [
                    Icon(CupertinoIcons.search),
                    SizedBox(width: 10),
                    Text(
                      "Search Songs,Abums or Playlists",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),
        Customslivergrid(data: LastSessiondata),
      ],
    );
  }
}
