import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Widgets/CategoryListView.dart';
import 'package:harmony_hub/Widgets/CustomListView.dart';
import 'package:harmony_hub/Widgets/ErrorWidget.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Searchscreen extends ConsumerStatefulWidget {
  const Searchscreen({super.key});

  @override
  ConsumerState<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends ConsumerState<Searchscreen> {
  Map<String, dynamic>? searchResults;
  final bool _loading = false;
  String _query = "";
  final SearchController _searchController = SearchController();

  late TextEditingController _textController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _textController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
  }

  Icon _getIconBasedOnType(String type) {
    if (type == "song" || type == "songs") {
      return const Icon(Icons.music_note);
    } else if (type == "playlist" || type == "playlists") {
      return const Icon(Icons.my_library_music);
    } else if (type == "album" || type == 'albums') {
      return const Icon(Icons.album);
    } else if (type == "show" || type == 'shows') {
      return const Icon(Icons.show_chart_sharp);
    } else {
      return const Icon(Icons.account_circle);
    }
  }

  void _triggerSearch(String value) {
    setState(() {
      _query = value;
    });
    _searchController.closeView(_query);
  }

  Future<List<List<String>>> getSuggesions(String value) async {
    List<List<String>> SuggesionsList = [];
    final data = await http.get(
      Uri.parse('https://jiosaavn-api-ts-79ec.onrender.com/search?q=$value'
          //'https://jiosaavn-api-ts.vercel.app/search/all?query=one+love'
          ),
    );
    print("body da ${data.body}");
    Map<String, dynamic> Searchdata = await jsonDecode(data.body)["data"];
    final keys = Searchdata.entries.map(
      (e) {
        return e.key;
      },
    ).toList();
    if (keys.isNotEmpty) {
      for (var item in keys) {
        for (Map<String, dynamic> listdata in Searchdata[item]["data"]) {
          if (listdata.containsKey("title")) {
            SuggesionsList.add([listdata["title"], listdata["type"]]);
          } else if (listdata.containsKey("name")) {
            SuggesionsList.add([listdata["name"], listdata["type"]]);
          }
        }
      }
    }
    return SuggesionsList;
  }

  @override
  Widget build(BuildContext context) {
    print("rebuilt");
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        // floating: true,
        titleSpacing: 4,
        // pinned: true,
        leading: Icon(
          color: Theme.of(context).colorScheme.primary,
          AntDesign.search_outline,
          size: 23.sp,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SearchAnchor.bar(
              viewShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              viewBackgroundColor: Theme.of(context).colorScheme.onPrimary,
              constraints: BoxConstraints(maxHeight: 27.sp, minHeight: 27.sp),
              barBackgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.primaryContainer),
              isFullScreen: false,
              textInputAction: TextInputAction.search,
              onSubmitted: _triggerSearch,
              barLeading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.my_library_music_outlined)),
              barHintText: "Search Songs,Abums or Playlists",
              barShape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Custom border radius
              )),
              searchController: _searchController,
              suggestionsBuilder: (context, controller) async {
                final searchSuggestions = await getSuggesions(controller.text);
                return List.generate(
                  searchSuggestions.length,
                  (index) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    onTap: () {
                      _triggerSearch(searchSuggestions[index][0]);
                    },
                    leading: _getIconBasedOnType(searchSuggestions[index][1]),
                    title: Text(searchSuggestions[index][0]),
                  ),
                );
              },
            ),
          ),
        ),
        // actions: [
        //   SizedBox(
        //     height: 22.sp,
        //     width: 22.sp,
        //     child: Image.asset(
        //       "assets/splash.png",
        //     ),
        //   ),
        //   SizedBox(
        //     width: 20,
        //   ),
        // ],
        title: Row(
          children: [
            Text(
              "Sea",
              style: GoogleFonts.permanentMarker(
                  // color: Theme.of(context).colorScheme.primary,,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w100),
            ),
            Text(
              "rch",
              style: GoogleFonts.permanentMarker(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w100),
            ),
          ],
        ),
      ),
      body: ref.watch(SearchDataProvider(_query
              // {"query": _query, "isTopSearch": _query.isEmpty}
              )).when(
            skipError: false,
            skipLoadingOnRefresh: false,
            skipLoadingOnReload: false,
            data: (data) {
              if (_query.isEmpty) {
                return ListView.builder(
                    itemCount: data["data"].length,
                    itemBuilder: (context, index) => CustomListView(
                          title: data["data"][index]["name"],
                          subTitle: data["data"][index]["type"],
                          onPressed: () {
                            _searchController.openView();
                            _searchController
                                .closeView(data["data"][index]["name"]);
                            setState(() {
                              _query = data["data"][index]["name"];
                            });
                            // _triggerSearch(
                            //     data["data"][index]["name"]);
                          },
                          leading: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      data["data"][index]["image"]
                                                  .runtimeType ==
                                              List
                                          ? data["data"][index]["image"][2]
                                              ["link"]
                                          : data["data"][index]["image"],
                                    ))),
                          ),
                          //  _getIconBasedOnType(
                          //     data["data"][index]["type"]),
                        ));
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 10, vertical: 10),
                //       child: Text(
                //         "Trending Searchs",
                //         textAlign: TextAlign.start,
                //         style: Theme.of(context)
                //             .textTheme
                //             .titleMedium!
                //             .copyWith(
                //                 fontSize: 19,
                //                 fontWeight: FontWeight.w500,
                //                 color: Theme.of(context).colorScheme.primary),
                //       ),
                //     ),
                //     ...List.generate(
                //         data["data"].length,
                //         (index) => CustomListView(
                //               title: data["data"][index]["name"],
                //               subTitle: data["data"][index]["type"],
                //               onPressed: () {
                //                 _searchController.openView();
                //                 _searchController
                //                     .closeView(data["data"][index]["name"]);
                //                 setState(() {
                //                   _query = data["data"][index]["name"];
                //                 });
                //                 // _triggerSearch(
                //                 //     data["data"][index]["name"]);
                //               },
                //               leading: Container(
                //                 decoration: BoxDecoration(
                //                     image: DecorationImage(
                //                         fit: BoxFit.cover,
                //                         image: CachedNetworkImageProvider(
                //                           data["data"][index]["image"]
                //                                       .runtimeType ==
                //                                   List
                //                               ? data["data"][index]["image"][2]
                //                                   ["link"]
                //                               : data["data"][index]["image"],
                //                         ))),
                //               ),
                //               //  _getIconBasedOnType(
                //               //     data["data"][index]["type"]),
                //             )
                //         //       ActionChip(
                //         // onPressed: () {
                //         //   _searchController.openView();
                //         //   _searchController.closeView(
                //         //       data["data"][index]["name"]);
                //         //   setState(() {
                //         //     _query =
                //         //         data["data"][index]["name"];
                //         //   });
                //         //   // _triggerSearch(
                //         //   //     data["data"][index]["name"]);
                //         // },
                //         //   avatar: _getIconBasedOnType(
                //         //       data["data"][index]["type"]),
                //         //   label: Text(
                //         //       data["data"][index]["name"]),
                //         // )
                //         )
                //   ],
                // );
              } else {
                return DynamicTabBarWidget(
                  dividerColor: Colors.transparent,
                  dynamicTabs: data.entries
                      .map(
                        (e) => TabData(
                          index: 1,
                          content: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerLow),
                            child: CategorylistviewWidget(
                              searchcategoryData: e.value["data"],
                              categoryTitle: e.key,
                            ),
                          ),
                          title: Tab(
                            // icon:  _getIconBasedOnType(e.key),
                            child: Row(
                              children: [
                                _getIconBasedOnType(e.key),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(e.key),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  // labelPadding: EdgeInsets.all(0),

                  indicatorSize: TabBarIndicatorSize.tab,
                  // indicator: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: Theme.of(context).colorScheme.secondaryContainer),
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Theme.of(context).colorScheme.surfaceContainerLow),

                  onTabControllerUpdated: (controller) {},
                  onTabChanged: (index) {},
                  showBackIcon: false,
                  showNextIcon: false,

                  // onAddTabMoveTo: MoveToTab.last,
                  // showBackIcon: showBackIcon,
                  // showNextIcon: showNextIcon,
                );
              }
            },
            error: (error, stackTrace) => Errorwidget(
              ontap: () {
                ref.refresh(SearchDataProvider(_query
                    // {"query": _query, "isTopSearch": false}
                    ));
              },
            ),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
    );

    CustomScrollView(
      // physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          floating: true,
          titleSpacing: 4,
          pinned: true,
          leading: Icon(
            color: Theme.of(context).colorScheme.primary,
            AntDesign.search_outline,
            size: 23.sp,
          ),
          // actions: [
          //   SizedBox(
          //     height: 22.sp,
          //     width: 22.sp,
          //     child: Image.asset(
          //       "assets/splash.png",
          //     ),
          //   ),
          //   SizedBox(
          //     width: 20,
          //   ),
          // ],
          title: Row(
            children: [
              Text(
                "Sea",
                style: GoogleFonts.permanentMarker(
                    // color: Theme.of(context).colorScheme.primary,,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w100),
              ),
              Text(
                "rch",
                style: GoogleFonts.permanentMarker(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w100),
              ),
            ],
          ),
        ),

        // SliverAppBar(
        //   stretch: true,
        //   flexibleSpace: FlexibleSpaceBar(
        //     centerTitle: true,
        //     stretchModes: [StretchMode.fadeTitle],
        //     title: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           "Sear",
        //         ),
        //         Text("ch  ",
        //             style: TextStyle(
        //               color: Theme.of(context).colorScheme.primary,
        //             )),
        //         Icon(
        //           Icons.search,
        //           color: Theme.of(context).colorScheme.primary,
        //         )
        //       ],
        //     ),
        //   ),
        //   // expandedHeight: 130,
        //   centerTitle: true,
        //   // leading: Builder(
        //   //   builder: (context) {
        //   //     return IconButton(
        //   //       icon: Icon(Icons.horizontal_split_rounded),
        //   //       onPressed: () {
        //   //         Scaffold.of(context).openDrawer();
        //   //       },
        //   //     );
        //   //   },
        //   // ),
        //   pinned: true,
        // ),

        SliverAppBar(
          primary: false,
          pinned: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: SearchAnchor.bar(
            viewShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            viewBackgroundColor: Theme.of(context).colorScheme.onPrimary,
            constraints: BoxConstraints(maxHeight: 27.sp, minHeight: 27.sp),
            barBackgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primaryContainer),
            isFullScreen: false,
            textInputAction: TextInputAction.search,
            onSubmitted: _triggerSearch,
            barLeading: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.my_library_music_outlined)),
            barHintText: "Search Songs,Abums or Playlists",
            barShape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Custom border radius
            )),
            searchController: _searchController,
            suggestionsBuilder: (context, controller) async {
              final searchSuggestions = await getSuggesions(controller.text);
              return List.generate(
                searchSuggestions.length,
                (index) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: () {
                    _triggerSearch(searchSuggestions[index][0]);
                  },
                  leading: _getIconBasedOnType(searchSuggestions[index][1]),
                  title: Text(searchSuggestions[index][0]),
                ),
              );
            },
          ),
        ),
        ref.watch(SearchDataProvider(_query
                // {"query": _query, "isTopSearch": _query.isEmpty}
                )).when(
              skipError: false,
              skipLoadingOnRefresh: false,
              skipLoadingOnReload: false,
              data: (data) {
                if (_query.isEmpty) {
                  return SliverToBoxAdapter(
                      child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            "Trending Searchs",
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        ...List.generate(
                            data["data"].length,
                            (index) => CustomListView(
                                  title: data["data"][index]["name"],
                                  subTitle: data["data"][index]["type"],
                                  onPressed: () {
                                    _searchController.openView();
                                    _searchController
                                        .closeView(data["data"][index]["name"]);
                                    setState(() {
                                      _query = data["data"][index]["name"];
                                    });
                                    // _triggerSearch(
                                    //     data["data"][index]["name"]);
                                  },
                                  leading: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              data["data"][index]["image"]
                                                          .runtimeType ==
                                                      List
                                                  ? data["data"][index]["image"]
                                                      [2]["link"]
                                                  : data["data"][index]
                                                      ["image"],
                                            ))),
                                  ),
                                  //  _getIconBasedOnType(
                                  //     data["data"][index]["type"]),
                                )
                            //       ActionChip(
                            // onPressed: () {
                            //   _searchController.openView();
                            //   _searchController.closeView(
                            //       data["data"][index]["name"]);
                            //   setState(() {
                            //     _query =
                            //         data["data"][index]["name"];
                            //   });
                            //   // _triggerSearch(
                            //   //     data["data"][index]["name"]);
                            // },
                            //   avatar: _getIconBasedOnType(
                            //       data["data"][index]["type"]),
                            //   label: Text(
                            //       data["data"][index]["name"]),
                            // )
                            )
                      ],
                    ),
                  )
                      // Card(
                      //   // margin: const EdgeInsets.symmetric(
                      //   //     horizontal: 15, vertical: 10),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(5),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 10, vertical: 10),
                      //   child: Text(
                      //     "Trending Searchs",
                      //     textAlign: TextAlign.start,
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .titleMedium!
                      //         .copyWith(
                      //             fontSize: 19,
                      //             fontWeight: FontWeight.w500,
                      //             color: Theme.of(context)
                      //                 .colorScheme
                      //                 .primary),
                      //   ),
                      // ),
                      //         // Wrap(
                      //         //     spacing: 10,
                      //         //     alignment: WrapAlignment.center,
                      //         //     runAlignment: WrapAlignment.center,
                      //         //     crossAxisAlignment: WrapCrossAlignment.center,
                      //         //     children:
                      //         //      List.generate(
                      //         //         data["data"].length,
                      //         //         (index) => CustomListView(
                      //         //               title: data["data"][index]["name"],
                      //         //               subTitle: data["data"][index][],
                      //         //               onPressed: () => {},
                      //         //               leading: _getIconBasedOnType(
                      //         //                   data["data"][index]["type"]),
                      //         //             )
                      //         //         //       ActionChip(
                      //         //         //   onPressed: () {
                      //         //         //     _searchController.openView();
                      //         //         //     _searchController.closeView(
                      //         //         //         data["data"][index]["name"]);
                      //         //         //     setState(() {
                      //         //         //       _query =
                      //         //         //           data["data"][index]["name"];
                      //         //         //     });
                      //         //         //     // _triggerSearch(
                      //         //         //     //     data["data"][index]["name"]);
                      //         //         //   },
                      //         //         //   avatar: _getIconBasedOnType(
                      //         //         //       data["data"][index]["type"]),
                      //         //         //   label: Text(
                      //         //         //       data["data"][index]["name"]),
                      //         //         // )
                      //         //         )
                      //         //     //  data["data"].map((e) {
                      //         //     //   return ActionChip(label: Text(e["name"]));
                      //         //     // }),
                      //         //     ),

                      //       ],
                      //     ),
                      //   ),
                      // ),

                      );
                } else {
                  return SliverFillRemaining(
                    child: DynamicTabBarWidget(
                      dynamicTabs: data.entries
                          .map(
                            (e) => TabData(
                              index: 1,
                              content: CategorylistviewWidget(
                                searchcategoryData: e.value["data"],
                                categoryTitle: e.key,
                              ),
                              title: Tab(
                                child: Text(e.key),
                              ),
                            ),
                          )
                          .toList(),
                      isScrollable: true,
                      onTabControllerUpdated: (controller) {},
                      onTabChanged: (index) {},
                      showBackIcon: false,
                      showNextIcon: false,

                      // onAddTabMoveTo: MoveToTab.last,
                      // showBackIcon: showBackIcon,
                      // showNextIcon: showNextIcon,
                    ),
                    // Column(children: [
                    //   SizedBox(
                    //     height: 60,
                    //     child: ListView.separated(
                    //       padding: EdgeInsets.symmetric(horizontal: 10),
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: data.entries.length,
                    //       separatorBuilder: (context, index) => SizedBox(
                    //         width: 12.sp,
                    //       ),
                    //       itemBuilder: (context, index) => ActionChip(
                    //         label: Text(data.entries.toList()[index].key),
                    //       ),
                    //     ),
                    //   )
                    // ]
                    // data.entries
                    //     .map(
                    // (e) => CategorylistviewWidget(
                    //   searchcategoryData: e.value["data"],
                    //   categoryTitle: e.key,
                    // ),
                    //     )
                    //     .toList(),
                    // ),
                  );
                }
              },
              error: (error, stackTrace) => SliverFillRemaining(
                hasScrollBody: false,
                child: Errorwidget(
                  ontap: () {
                    ref.refresh(SearchDataProvider(_query
                        // {"query": _query, "isTopSearch": false}
                        ));
                  },
                ),
              ),
              loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator())),
            )
      ],
    );
  }
}
