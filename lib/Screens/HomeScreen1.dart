import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Screens/SearchScreen.dart';
import 'package:harmony_hub/Widgets/MusicListWidget.dart';
import 'package:harmony_hub/Widgets/MusicListWidget2.dart';

class Homescreen1 extends ConsumerWidget {
  Widget _nullCheckAndDisplayWidget(
      Map<String, dynamic> data, String catrgory) {
    return data[catrgory] != null
        ? MusicListWidget(musicData: data[catrgory])
        : SizedBox();
  }

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Searchscreen(),
                    ));
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
                          fontSize: 17,
                          color: Colors.grey.shade100),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        CupertinoSliverRefreshControl(
            onRefresh: () => ref.refresh(HomeScreenDataProvider.future)),
        SliverToBoxAdapter(
          child: ref.watch(HomeScreenDataProvider).when(
                data: (data) {
                  Boxes.saveHomeScreendata(data);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Musiclistwidget2(musicData: data["trending"]),
                      _nullCheckAndDisplayWidget(data, "charts"),
                      _nullCheckAndDisplayWidget(data, "albums"),
                      _nullCheckAndDisplayWidget(data, "playlists"),
                      // _nullCheckAndDisplayWidget(data, "radio"),
                      _nullCheckAndDisplayWidget(data, "artist_recos"),
                      _nullCheckAndDisplayWidget(data, "promo0"),
                      _nullCheckAndDisplayWidget(data, "promo1"),
                      _nullCheckAndDisplayWidget(data, "promo2"),
                      _nullCheckAndDisplayWidget(data, "promo3"),
                      _nullCheckAndDisplayWidget(data, "promo4"),
                      _nullCheckAndDisplayWidget(data, "promo5"),
                      _nullCheckAndDisplayWidget(data, "promo6"),
                      _nullCheckAndDisplayWidget(data, "promo7"),
                    ],
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        )
      ],
    );
  }
}
