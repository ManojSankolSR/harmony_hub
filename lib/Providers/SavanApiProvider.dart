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

  static Future<Map<String, dynamic>> getArtistdata(String id) async {
    final data = await http
        .get(Uri.parse("https://jiosaavn-api-ts.vercel.app/artist?id=$id"));

    return jsonDecode(data.body)["data"];
  }
}

FutureProvider<Map<String, dynamic>> HomeScreenDataProvider = FutureProvider(
  (ref) => SavanApi.HomeScreenData(),
);

FutureProviderFamily<Map<String, dynamic>, String> PlayListDataProvider =
    FutureProviderFamily((ref, arg) => SavanApi.getPlayListdata(arg));

FutureProviderFamily<Map<String, dynamic>, String> AlbumDataProvider =
    FutureProviderFamily((ref, arg) => SavanApi.getAlbumdata(arg));

FutureProviderFamily<Map<String, dynamic>, String> ArtistDataProvider =
    FutureProviderFamily((ref, arg) => SavanApi.getArtistdata(arg));

StateProvider<AudioPlayer> globalPlayerProvider = StateProvider<AudioPlayer>(
  (ref) {
    return AudioPlayer();
  },
);
