import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'UserModel.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  Map<String, dynamic> latSessionSongs;

  @HiveField(1)
  String userName;

  @HiveField(2)
  String perfferdLanguage;

  @HiveField(3)
  String audioQuality;

  @HiveField(4)
  List<Map<String, dynamic>> songsHistory;

  @HiveField(5)
  List<Map<String, dynamic>> favouriteSongs;

  @HiveField(6)
  List<Map<String, dynamic>> userPlaylists;

  @HiveField(7)
  Map<String, dynamic> homeScreenData;

  @HiveField(8)
  Color seedColor;

  @HiveField(9)
  List<String> downloadedSongIds;

  UserModel({
    this.seedColor = const Color.fromARGB(255, 74, 0, 87),
    this.latSessionSongs = const {},
    this.homeScreenData = const {},
    this.songsHistory = const [],
    this.userPlaylists = const [],
    this.favouriteSongs = const [],
    this.downloadedSongIds = const [],
    required this.userName,
    required this.perfferdLanguage,
    required this.audioQuality,
  });
}

enum AudioQuality {
  veryLow("12kbps"),
  low("48kbps"),
  medium("96kbps"),
  high("160kbps"),
  veryHigh("320kbps");

  final String kbps;

  const AudioQuality(this.kbps);
}

enum Language {
  hindi,
  english,
  punjabi,
  tamil,
  telugu,
  marathi,
  gujarati,
  bengali,
  kannada,
  bhojpuri,
  malayalam,
  urdu,
  haryanvi,
  rajasthani,
  odia,
  assamese
}
