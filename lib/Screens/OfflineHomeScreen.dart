import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Screens/SearchScreen.dart';
import 'package:harmony_hub/Widgets/CustomSnackbar.dart';
import 'package:harmony_hub/Widgets/MusicListWidget.dart';

class OfflineHomescreen extends ConsumerWidget {
  List<Map<String, dynamic>> LastSessiondata = Boxes.getSongsHistory();
  List<Map<String, dynamic>> FavSongs = Boxes.getFavSongs();

  // Widget _nullCheckAndDisplayWidget(
  //     Map<String, dynamic> data, String catrgory) {
  //   return data[catrgory] != null
  //       ? MusicListWidget(musicData: data[catrgory])
  //       : SizedBox();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(
            leading: Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.horizontal_split_rounded),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
            // centerTitle: true,
            pinned: true,
            title: Row(
              children: [
                Text(
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
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 45,
                decoration: BoxDecoration(),
                child: Row(
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
        SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),

        SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (1 / 1.2),
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          itemCount: LastSessiondata.length,
          itemBuilder: (context, index) {
            bool isImageList =
                LastSessiondata[index]["image"].runtimeType == List;
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                CustomNavigation.NavigateTo(
                  ref: ref,
                  LastSessiondata[index]["type"],
                  context,
                  LastSessiondata[index]["id"],
                  LastSessiondata,
                  index,
                  false,
                );
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                              fit: BoxFit.cover, "assets/album.png"),
                          errorWidget: (context, url, error) => Image.asset(
                              fit: BoxFit.cover, "assets/album.png"),
                          imageUrl: isImageList
                              ? LastSessiondata[index]["image"][2]["link"]
                              : LastSessiondata[index]["image"]),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      LastSessiondata[index]["name"],
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${LastSessiondata[index]["type"].toUpperCase()}  • ${LastSessiondata[index]["subtitle"] == null ? "" : LastSessiondata[index]["subtitle"].toUpperCase()}",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Colors.white70, fontWeight: FontWeight.w400),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            );
          },
        )
        // SliverToBoxAdapter(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       SizedBox(
        //         height: 15,
        //       ),
        //       MusicListWidget(musicData: {
        //         "title": "Last Session",
        //         "data": LastSessiondata,
        //       }),
        //       MusicListWidget(musicData: {
        //         "title": "Favourites",
        //         "data": FavSongs,
        //       })

        //       // _nullCheckAndDisplayWidget(data, "albums"),
        //       // _nullCheckAndDisplayWidget(data, "playlists"),
        //       // // _nullCheckAndDisplayWidget(data, "radio"),
        //       // _nullCheckAndDisplayWidget(data, "artist_recos"),
        //       // _nullCheckAndDisplayWidget(data, "promo0"),
        //       // _nullCheckAndDisplayWidget(data, "promo1"),
        //       // _nullCheckAndDisplayWidget(data, "promo2"),
        //       // _nullCheckAndDisplayWidget(data, "promo3"),
        //       // _nullCheckAndDisplayWidget(data, "promo4"),
        //       // _nullCheckAndDisplayWidget(data, "promo5"),
        //       // _nullCheckAndDisplayWidget(data, "promo6"),
        //       // _nullCheckAndDisplayWidget(data, "promo7"),
        //     ],
        //   ),
        // )
      ],
    );
  }
}
