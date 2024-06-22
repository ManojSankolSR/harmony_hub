import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class SavanApi {
  static Future<Map<String, dynamic>> HomeScreenData() async {
    final Data = await http.get(Uri.parse(
        'https://jiosaavn-api-ts.vercel.app/modules?lang=${Boxes.UserBox.get("user")!.perfferdLanguage}'));

    return jsonDecode(Data.body)["data"];
  }

  static Future<Map<String, dynamic>> getPlayListdata(String id) async {
    final data = await http
        .get(Uri.parse("https://jiosaavn-api-ts.vercel.app/playlist?id=$id"));

    return jsonDecode(data.body)["data"];
  }

  static Future<Map<String, dynamic>> getAlbumdata(String id) async {
    final data = await http
        .get(Uri.parse("https://jiosaavn-api-ts.vercel.app/album?id=$id"));

    return jsonDecode(data.body)["data"];
  }

  static Future<Map<String, dynamic>> getSongData(String id) async {
    final data = await http
        .get(Uri.parse("https://jiosaavn-api-ts.vercel.app/song?id=$id"));

    return jsonDecode(data.body)["data"];
  }

  static Future<Map<String, dynamic>> getArtistdata(String id) async {
    final data = await http
        .get(Uri.parse("https://jiosaavn-api-ts.vercel.app/artist?id=$id"));

    return jsonDecode(data.body)["data"];
  }

  static Future<Map<String, dynamic>> getSearchdata(String query) async {
    final data = await http
        .get(Uri.parse("https://jiosaavn-api-ts.vercel.app/search?q=$query"));
    List<Map<String, dynamic>> newSongs = [];

    Map<String, dynamic> decodedData = jsonDecode(data.body)["data"];

    if (decodedData.containsKey("top_query")) {
      final List topquerydata = decodedData["top_query"]["data"];
      if (topquerydata.isNotEmpty) {
        List<Map<String, dynamic>> newtopquerylist = [];
        for (Map<String, dynamic> e in topquerydata) {
          if (e["type"] == "song") {
            final newSonsData = await getSongData(e["id"]);
            final listofFetchedSongs = newSonsData["songs"];
            for (Map<String, dynamic> element in listofFetchedSongs) {
              newtopquerylist.add(element);
            }
          }
        }

        decodedData["top_query"] = {
          "data": newtopquerylist,
        };
      }
    }

    if (decodedData.containsKey("songs")) {
      final songsData = decodedData["songs"]["data"];
      if (songsData.isNotEmpty) {
        for (Map<String, dynamic> e in songsData) {
          final newSonsData = await getSongData(e["id"]);
          final listofFetchedSongs = newSonsData["songs"];

          for (Map<String, dynamic> song in listofFetchedSongs) {
            newSongs.add(song);
          }
        }
        decodedData["songs"] = {
          "data": newSongs,
        };
      }
    }

    return decodedData;
  }

  static Future<String> getSongLyrics(String id) async {
    final data = await http
        .get(Uri.parse("https://jiosaavn-api-ts.vercel.app/get/lyrics?id=$id"));

    final String rawlyrics = jsonDecode(data.body)["data"]["lyrics"];
    final String lyrics = rawlyrics.toString().replaceAll('<br>', '\n');
    return lyrics;
  }
}

FutureProvider<Map<String, dynamic>> HomeScreenDataProvider = FutureProvider(
  (ref) => SavanApi.HomeScreenData(),
);

FutureProviderFamily<Map<String, dynamic>, String> PlayListDataProvider =
    FutureProviderFamily((ref, arg) => SavanApi.getPlayListdata(arg));

FutureProviderFamily<Map<String, dynamic>, String> SongDataProvider =
    FutureProviderFamily((ref, arg) => SavanApi.getSongData(arg));

FutureProviderFamily<Map<String, dynamic>, String> AlbumDataProvider =
    FutureProviderFamily((ref, arg) => SavanApi.getAlbumdata(arg));

FutureProviderFamily<Map<String, dynamic>, String> ArtistDataProvider =
    FutureProviderFamily((ref, arg) => SavanApi.getArtistdata(arg));

FutureProviderFamily<Map<String, dynamic>, String> SearchDataProvider =
    FutureProviderFamily((ref, arg) => SavanApi.getSearchdata(arg));

FutureProviderFamily<String, String> SongLyricsProvider =
    FutureProviderFamily((ref, arg) => SavanApi.getSongLyrics(arg));

StateProvider<AudioPlayer> globalPlayerProvider = StateProvider<AudioPlayer>(
  (ref) {
    return AudioPlayer();
  },
);
