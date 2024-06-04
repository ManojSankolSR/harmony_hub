import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Widgets/CategoryListView.dart';
import 'package:harmony_hub/Widgets/SongBottomBarWidget.dart';
import 'package:http/http.dart' as http;

class Searchscreen extends StatefulWidget {
  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  Map<String, dynamic>? searchResults;
  bool _loading = false;

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        bottomNavigationBar: const Songbottombarwidget(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 10,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 54, 54, 54)),
            child: Row(
              children: [
                BackButton(),
                // Icon(Icons.search),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: (value) async {
                      setState(() {
                        _loading = true;
                      });
                      final data = await http.get(Uri.parse(
                          'https://jiosaavn-api-ts.vercel.app/search?q=$value'
                          //'https://jiosaavn-api-ts.vercel.app/search/all?query=one+love'
                          ));

                      setState(() {
                        searchResults = jsonDecode(data.body)['data'];
                        _loading = false;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Songs,Abums or Playlists",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 17,
                          color: Colors.grey.shade100),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : searchResults == null
                ? Center(child: Text("No Data found"))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        CategorylistviewWidget(
                          searchcategoryData: searchResults!['top_query']
                              ['data'],
                          categoryTitle: "Top Query",
                        ),
                        CategorylistviewWidget(
                          searchcategoryData: searchResults!['albums']['data'],
                          categoryTitle: "Albums",
                        ),
                        CategorylistviewWidget(
                          searchcategoryData: searchResults!['playlists']
                              ['data'],
                          categoryTitle: "Plyalists",
                        ),
                        CategorylistviewWidget(
                          searchcategoryData: searchResults!['artists']['data'],
                          categoryTitle: "Artists",
                        ),
                      ],
                    ),
                  )

        // Text(searchResults != null ? searchResults.toString() : ""),
        );
  }
}
