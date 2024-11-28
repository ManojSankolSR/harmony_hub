import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Screens/WelcomeScreen.dart';
import 'package:harmony_hub/Widgets/CustomSnackbar.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Boxes {
  static late Box<UserModel> UserBox;
  static List<Map<String, dynamic>> lastsees = [];
  static Future InitilizeBoxes() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ColorAdapter());

    UserBox = await Hive.openBox<UserModel>('UserBox');
  }

  static Future SaveLastSsssionData(Map<String, dynamic> data) async {
    if (UserBox.containsKey('user')) {
      UserModel user = Boxes.UserBox.get("user")!;
      user.latSessionSongs = data;
      await user.save();
    }
  }

  static Map<String, dynamic> getLastSessionData() {
    Map<String, dynamic> data = Boxes.UserBox.get("user")!.latSessionSongs;

    return data;
  }

  static String getUserrPeferedAudioQuality() {
    String Quality = Boxes.UserBox.get("user")!.audioQuality;

    return Quality;
  }

  static Future SaveSongsHistory(Map<String, dynamic> data) async {
    if (UserBox.containsKey('user')) {
      UserModel user = Boxes.UserBox.get("user")!;
      final isDuplicate =
          Boxes.getSongsHistory().any((e) => e["id"] == data["id"]);
      if (isDuplicate) {
        List<Map<String, dynamic>> list = user.songsHistory;
        final index =
            list.indexWhere((e) => e["download_url"] == data["download_url"]);

        if (index >= 0) {
          list.removeAt(index);

          user.songsHistory = [
            data,
            ...list,
          ];
        }
      } else {
        user.songsHistory = [
          data,
          ...user.songsHistory,
        ];
      }
      user.save();
    }
  }

  static List<Map<String, dynamic>> getSongsHistory() {
    if (UserBox.containsKey("user")) {
      return Boxes.UserBox.get("user")!.songsHistory;
    }
    return [];
  }

  static Future saveHomeScreendata(Map<String, dynamic> data) async {
    if (UserBox.containsKey("user")) {
      UserModel user = Boxes.UserBox.get("user")!;
      user.homeScreenData = data;
      user.save();
    }
  }

  static Map<String, dynamic> getHomeScreendata() {
    if (UserBox.containsKey("user")) {
      return Boxes.UserBox.get("user")!.homeScreenData;
    }
    return {};
  }

  static List<Map<String, dynamic>> getFavSongs() {
    if (UserBox.containsKey("user")) {
      return Boxes.UserBox.get("user")!.favouriteSongs;
    }
    return [];
  }

  static Future addSongToFav(Map<String, dynamic> data) async {
    if (UserBox.containsKey("user")) {
      UserModel user = Boxes.UserBox.get("user")!;
      final isDuplicate = user.favouriteSongs.any((e) => e["id"] == data["id"]);

      if (!isDuplicate) {
        user.favouriteSongs = [
          data,
          ...user.favouriteSongs,
        ];
        await user.save();
      }
    }
  }

  static Future deleteSongFromFav(Map<String, dynamic> data) async {
    if (UserBox.containsKey("user")) {
      UserModel user = Boxes.UserBox.get("user")!;
      List<Map<String, dynamic>> newFavList = user.favouriteSongs;
      int index = newFavList.indexWhere((e) => e["id"] == data["id"]);
      if (index >= 0) {
        newFavList.removeAt(index);
        user.favouriteSongs = [
          ...newFavList,
        ];
        await user.save();
      }
    }
  }

  static Future deleteUser({required BuildContext context}) async {
    await UserBox.delete("user");
    pushReplacementWithoutNavBar(
        context,
        MaterialPageRoute(
          builder: (context) => const Welcomescreen(),
        ));
    Customsnackbar(
        title: "User deleted",
        subTitle: "Allthe data related to user has been erased",
        context: context,
        type: ContentType.warning);
  }

  static Future createUser(
    String userName,
    String perfferdLanguage,
    String audioQuality, {
    List<Map<String, dynamic>> songsHistory = const [],
    List<Map<String, dynamic>> favouriteSongs = const [],
    Map<String, dynamic> homeScreenData = const {},
    Map<String, dynamic> latSessionSongs = const {},
  }) async {
    await UserBox.put(
        "user",
        UserModel(
            homeScreenData: homeScreenData,
            songsHistory: songsHistory,
            latSessionSongs: latSessionSongs,
            userName: userName,
            favouriteSongs: favouriteSongs,
            perfferdLanguage: perfferdLanguage,
            audioQuality: audioQuality));
  }

  static dynamic getUserData() {
    if (UserBox.containsKey("user")) {
      dynamic data = UserBox.get("user");

      if (data.latSessionSongs.isNotEmpty) {
        return data;
      }
    }
    return false;
  }
}
