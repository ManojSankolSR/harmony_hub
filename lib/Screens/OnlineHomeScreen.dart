import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/GlobalConstants.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Screens/SearchScreen.dart';
import 'package:harmony_hub/Widgets/ErrorWidget.dart';
import 'package:harmony_hub/Widgets/MusicListWidget.dart';
import 'package:harmony_hub/Widgets/MusicListWidget2.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OnlineHomeScreen extends ConsumerWidget {
  static const HomePageLoadingData = Globalconstants.HomePageloadingData;

  const OnlineHomeScreen({super.key});
  Widget _nullCheckAndDisplayWidget(
      Map<String, dynamic> data, String catrgory) {
    return data[catrgory] != null
        ? MusicListWidget(musicData: data[catrgory])
        : const SizedBox();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return CustomScrollView(
      slivers: [
        SliverLayoutBuilder(builder: (context, constraints) {
          return SliverAppBar.medium(
              scrolledUnderElevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.horizontal_split_rounded),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              actions: [
                if (constraints.scrollOffset > 110)
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Searchscreen(),
                            ));
                      },
                      icon: const Icon(CupertinoIcons.search))
              ],
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
              ));
        }),
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
                      builder: (context) => const Searchscreen(),
                    ));
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
                error: (error, stackTrace) => Errorwidget(ontap: () {
                  ref.invalidate(HomeScreenDataProvider);
                }),
                loading: () {
                  return Skeletonizer(
                    enabled: true,
                    effect: ShimmerEffect.raw(colors: [
                      Theme.of(context).colorScheme.onPrimary.withOpacity(.6),
                      Theme.of(context)
                          .colorScheme
                          .onSecondaryFixed
                          .withOpacity(.6)
                    ]),
                    enableSwitchAnimation: true,
                    textBoneBorderRadius:
                        TextBoneBorderRadius(BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Musiclistwidget2(
                            musicData: HomePageLoadingData["trending"]),
                        _nullCheckAndDisplayWidget(
                            HomePageLoadingData, "charts"),
                        _nullCheckAndDisplayWidget(
                            HomePageLoadingData, "albums"),
                        _nullCheckAndDisplayWidget(
                            HomePageLoadingData, "playlists"),
                        // // _nullCheckAndDisplayWidget(data, "radio"),
                        // _nullCheckAndDisplayWidget(
                        //     HomePageLoadingData, "artist_recos"),
                        // _nullCheckAndDisplayWidget(
                        //     HomePageLoadingData, "promo0"),
                        // _nullCheckAndDisplayWidget(
                        //     HomePageLoadingData, "promo1"),
                        // _nullCheckAndDisplayWidget(
                        //     HomePageLoadingData, "promo2"),
                        // _nullCheckAndDisplayWidget(
                        //     HomePageLoadingData, "promo3"),
                        // _nullCheckAndDisplayWidget(
                        //     HomePageLoadingData, "promo4"),
                        // _nullCheckAndDisplayWidget(
                        //     HomePageLoadingData, "promo5"),
                        // _nullCheckAndDisplayWidget(
                        //     HomePageLoadingData, "promo6"),
                        // _nullCheckAndDisplayWidget(
                        //     HomePageLoadingData, "promo7"),
                      ],
                    ),
                  );
                },
              ),
        )
      ],
    );
  }
}
