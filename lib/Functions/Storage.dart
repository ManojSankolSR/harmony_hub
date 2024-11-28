import 'dart:io';

import 'package:audiotags/audiotags.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Functions/AppPermissions.dart';
import 'package:harmony_hub/Functions/UserPreferredQuality.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Widgets/CustomSnackbar.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class Downloads {
  static Future addDownloadedSongId(String id) async {
    if (Boxes.UserBox.containsKey('user')) {
      UserModel user = Boxes.UserBox.get("user")!;

      user.downloadedSongIds = [id, ...user.downloadedSongIds];
      await user.save();
    }
  }

  static Future deleteDownloadedSongId(String id) async {
    if (Boxes.UserBox.containsKey('user')) {
      UserModel user = Boxes.UserBox.get("user")!;
      List<String> newlist = user.downloadedSongIds;
      newlist.remove(id);
      user.downloadedSongIds = [...newlist];
      await user.save();
    }
  }

  static List<String> getDownloadedSongIds() {
    if (Boxes.UserBox.containsKey('user')) {
      UserModel user = Boxes.UserBox.get("user")!;
      return user.downloadedSongIds;
    }
    return [];
  }

  static Future downloadSong(
      Map<String, dynamic> Songdata, BuildContext context) async {
    PermissionStatus storagePermissionStatus =
        await AppPermissions.requestStoragePermissions();

    if (storagePermissionStatus == PermissionStatus.granted) {
      final String Songtitle =
          Songdata["name"].replaceAll(RegExp('[^A-Za-z0-9]'), '');

      final String downloadUrl =
          Userpreferredquality.getUserPereferedQualityLinkFomData(
              Songdata["download_url"]);

      final dir = await path.getExternalStorageDirectories(
          type: path.StorageDirectory.music);
      final savepath = "/storage/emulated/0/Music/$Songtitle.m4a";
      File file = File(savepath);
      final downloadedSong = await http.get(Uri.parse(downloadUrl));
      await file.writeAsBytes(downloadedSong.bodyBytes);
      final picture = await http.get(Uri.parse(
        Songdata["image"].runtimeType == List
            ? Songdata["image"][2]["link"]
            : Songdata["image"],
      ));

      await AudioTags.write(
          "/storage/emulated/0/Music/$Songtitle.m4a",
          Tag(
            title: Songdata["name"],
            genre: Songdata["id"],
            trackArtist: Songdata["artist_map"]["artists"][0]["name"],
            album: Songdata["album"],
            duration: Songdata["duration"],
            year: Songdata["year"],
            pictures: [
              Picture(pictureType: PictureType.other, bytes: picture.bodyBytes)
            ],
          ));
      addDownloadedSongId(Songdata["id"]);
      Customsnackbar(
          title: "Song Downloaded",
          subTitle: "Check In Downloads Section",
          context: context,
          type: ContentType.success);
    } else {
      storagePermissionStatus =
          await AppPermissions.requestStoragePermissions();
    }
  }

  static Future deleteDownloadedFile(
      String name, BuildContext context, String id) async {
    String path = "/storage/emulated/0/Music/$name";

    File file = File(path);

    if (await file.exists()) {
      await file.delete();
      deleteDownloadedSongId(id);
      Customsnackbar(
          title: "Song Deleted",
          subTitle: "$name Sucessfully Deleted",
          context: context,
          type: ContentType.success);
    } else {
      Customsnackbar(
          title: "File does Not Exist",
          subTitle: "$name Does not Exist",
          context: context,
          type: ContentType.failure);
    }
  }
}
