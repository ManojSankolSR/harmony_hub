import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Widgets/CategoryListView.dart';
import 'package:harmony_hub/Widgets/ErrorWidget.dart';
import 'package:harmony_hub/Widgets/MiniPlayerNavigationHandler.dart';
import 'package:harmony_hub/Widgets/SongBottomBarWidget.dart';
import 'package:http/http.dart' as http;

class Searchscreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends ConsumerState<Searchscreen> {
  Map<String, dynamic>? searchResults;
  bool _loading = false;
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

  void _triggerSearch(String value) {
    setState(() {
      _query = value;
    });
    _searchController.closeView(_query);
  }

  Future<List<String>> getSuggesions(String value) async {
    List<String> SuggesionsList = [];
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
            SuggesionsList.add(listdata["title"]);
          } else if (listdata.containsKey("name")) {
            SuggesionsList.add(listdata["name"]);
          }
        }
      }
    }
    return SuggesionsList;
  }

  @override
  Widget build(BuildContext context) {
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
                  Text(
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
              constraints: BoxConstraints(maxHeight: 45, minHeight: 45),
              barBackgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onPrimary),
              isFullScreen: false,
              textInputAction: TextInputAction.search,
              onSubmitted: _triggerSearch,
              barLeading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.my_library_music_outlined)),
              barHintText: "Search Songs,Abums or Playlists",
              barShape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Custom border radius
              )),
              searchController: _searchController,
              suggestionsBuilder: (context, controller) async {
                final _searchSuggestions = await getSuggesions(controller.text);
                return List.generate(
                  _searchSuggestions.length,
                  (index) => ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    onTap: () {
                      _triggerSearch(_searchSuggestions[index]);
                    },
                    leading: Icon(Icons.search),
                    title: Text(_searchSuggestions[index]),
                  ),
                );
              },
            ),
          ),
          if (_query != "")
            ref.watch(SearchDataProvider(_query)).when(
                  skipError: false,
                  skipLoadingOnRefresh: false,
                  skipLoadingOnReload: false,
                  data: (data) => SliverToBoxAdapter(
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
                  ),
                  error: (error, stackTrace) => SliverFillRemaining(
                    hasScrollBody: false,
                    child: Errorwidget(
                      ontap: () {
                        ref.refresh(SearchDataProvider(_query));
                      },
                    ),
                  ),
                  loading: () => SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator())),
                )
        ],
      ),
    );
  }
}
