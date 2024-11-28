import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/DataModels/AlbumModel.dart';
import 'package:harmony_hub/GlobalConstants.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class SavanApi {
  static Future<Map<String, dynamic>> HomeScreenData() async {
    final Data = await http.get(Uri.parse(
        'https://jiosaavn-api-ts-79ec.onrender.com/modules?lang=${Boxes.UserBox.get("user")!.perfferdLanguage}'));

    return jsonDecode(Data.body)["data"];
  }

  static Future<Map<String, dynamic>> getPlayListdata(String id) async {
    final data = await http.get(
        Uri.parse("https://jiosaavn-api-ts-79ec.onrender.com/playlist?id=$id"));

    return jsonDecode(data.body)["data"];
  }

  static Future<Map<String, dynamic>> getAlbumdata(String id) async {
    final data = await http.get(
        Uri.parse("https://jiosaavn-api-ts-79ec.onrender.com/album?id=$id"));

    return jsonDecode(data.body)["data"];
  }

  static Future<Map<String, dynamic>> getSongData(String id) async {
    final data = await http.get(
        Uri.parse("https://jiosaavn-api-ts-79ec.onrender.com/song?id=$id"));

    return jsonDecode(data.body)["data"];
  }

  static Future<Map<String, dynamic>> getArtistdata(String id) async {
    final data = await http.get(
        Uri.parse("https://jiosaavn-api-ts-79ec.onrender.com/artist?id=$id"));

    return jsonDecode(data.body)["data"];
  }

  static Future<Map<String, dynamic>> getSearchdata(String query) async {
    if (query.isEmpty) {
      final response = await http.get(
          Uri.parse("https://jiosaavn-api-ts-79ec.onrender.com/search/top"));
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return data;
    }

    final data = await http.get(
        Uri.parse("https://jiosaavn-api-ts-79ec.onrender.com/search?q=$query"));
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

  static Future<List<List<Object>>> getSongLyrics(
      {required LRCLIB lrclib}) async {
    // print(track_Data);
    final str =
        "https://lrclib.net/api/get?artist_name=${lrclib.artist_name}&track_name=${lrclib.track_name}&album_name=${lrclib.album_name}&duration=${lrclib.duration}";
    final data = await http.get(Uri.parse(str));
    //"https://jiosaavn-api-ts-79ec.onrender.com/get/lyrics?id=$id"

    print("codestatus ${data.statusCode}");

    final String rawlyrics = jsonDecode(data.body)["syncedLyrics"];

    final List<String> lyrics1 = rawlyrics.split('\n');
    final lyrics = lyrics1.map((e) {
      return [
        Globalconstants.parseDuration(e.split("]")[0].replaceAll("[", "")),
        utf8.decode(e.split("]")[1].runes.toList())
      ];
    }).toList();

    print(lyrics);
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

FutureProviderFamily<List<dynamic>, LRCLIB> SongLyricsProvider =
    FutureProviderFamily((ref, arg) => SavanApi.getSongLyrics(lrclib: arg));

StateProvider<AudioPlayer> globalPlayerProvider = StateProvider<AudioPlayer>(
  (ref) {
    return AudioPlayer();
  },
);
