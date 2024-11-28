import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Widgets/CategoryListView.dart';
import 'package:harmony_hub/Widgets/ErrorWidget.dart';
import 'package:http/http.dart' as http;

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
    if (type == "song") {
      return const Icon(Icons.music_note);
    } else if (type == "playlist") {
      return const Icon(Icons.my_library_music);
    } else if (type == "album") {
      return const Icon(Icons.album);
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
    final data = await http
        .get(Uri.parse('https://jiosaavn-api-ts.vercel.app/search?q=$value'
            //'https://jiosaavn-api-ts.vercel.app/search/all?query=one+love'
            ));
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
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            stretch: true,
            pinned: true,
            expandedHeight: 90,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              expandedTitleScale: 1.2,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sea",
                  ),
                  Text("rch  ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  Icon(
                    CupertinoIcons.search,
                    color: Theme.of(context).colorScheme.primary,
                  )
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Theme.of(context).colorScheme.onPrimary,
                      Theme.of(context).colorScheme.surface,
                    ])),
              ),
            ),
          ),
          SliverAppBar(
            primary: false,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            title: SearchAnchor.bar(
              viewShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              viewBackgroundColor: Theme.of(context).colorScheme.onPrimary,
              constraints: const BoxConstraints(maxHeight: 45, minHeight: 45),
              barBackgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onPrimary),
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
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                              ),
                              Wrap(
                                  spacing: 10,
                                  alignment: WrapAlignment.center,
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: List.generate(
                                      data["data"].length,
                                      (index) => ActionChip(
                                            onPressed: () {
                                              _searchController.openView();
                                              _searchController.closeView(
                                                  data["data"][index]["name"]);
                                              setState(() {
                                                _query =
                                                    data["data"][index]["name"];
                                              });
                                              // _triggerSearch(
                                              //     data["data"][index]["name"]);
                                            },
                                            avatar: _getIconBasedOnType(
                                                data["data"][index]["type"]),
                                            label: Text(
                                                data["data"][index]["name"]),
                                          ))
                                  //  data["data"].map((e) {
                                  //   return ActionChip(label: Text(e["name"]));
                                  // }),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: data.entries
                            .map(
                              (e) => CategorylistviewWidget(
                                searchcategoryData: e.value["data"],
                                categoryTitle: e.key,
                              ),
                            )
                            .toList(),
                      ),
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
      ),
    );
  }
}
