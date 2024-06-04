import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Widgets/PlaylistImageWidget.dart';
import 'package:hive_flutter/adapters.dart';

class Playlists {
  static Future createPlaylist({required String playlistName}) async {
    if (Boxes.UserBox.containsKey("user")) {
      UserModel user = Boxes.UserBox.get("user")!;
      user.userPlaylists = [
        {"name": playlistName, "songs": <Map<String, dynamic>>[]},
        ...user.userPlaylists,
      ];
    }
  }

  static Future addSongToPlaylist(
      {required String playlistName,
      required Map<String, dynamic> song}) async {
    if (Boxes.UserBox.containsKey("user")) {
      UserModel user = Boxes.UserBox.get("user")!;

      final UpdatedPlaylists = user.userPlaylists;
      final index =
          UpdatedPlaylists.indexWhere((e) => e["name"] == playlistName);
      final List<dynamic> songs = UpdatedPlaylists[index]["songs"];
      final bool isDuplicate =
          songs.any((element) => element["id"] == song["id"]);

      if (!isDuplicate) {
        UpdatedPlaylists[index]
            ["songs"] = [song, ...UpdatedPlaylists[index]["songs"]];

        user.userPlaylists = [...UpdatedPlaylists];
        await user.save();
      } else {
        print("ducplicate");
      }
    }
  }

  static List<Map<String, dynamic>> getPlylists() {
    if (Boxes.UserBox.containsKey("user")) {
      return Boxes.UserBox.get("user")!.userPlaylists;
    }
    return [];
  }

  static showPlayListDialog(
      {required Map<String, dynamic> songdata,
      required TextEditingController textEditingController,
      required BuildContext context}) {
    showModalBottomSheet(
      //backgroundColor: Colors.transparent,
      // showDragHandle: true,

      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 40,
      ),
      context: context,
      builder: (context) {
        return Container(
          // height: 400,
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Text(
                    "Playlists",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          titleTextStyle:
                              Theme.of(context).textTheme.titleLarge,
                          title: Text("Playlist Name"),
                          content: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Title")),
                            controller: textEditingController,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("cancel")),
                            TextButton(
                                onPressed: () {
                                  if (textEditingController.text != "") {
                                    createPlaylist(
                                        playlistName:
                                            textEditingController.text);
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text("ok")),
                          ],
                        );
                      },
                    );
                  },
                  title: Text("Create Playlist"),
                ),
                ValueListenableBuilder(
                    valueListenable: Boxes.UserBox.listenable(),
                    builder: (context, value, child) {
                      final playlist = getPlylists();
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: playlist.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: ListTile(
                              onTap: () {
                                addSongToPlaylist(
                                    playlistName: playlist[index]["name"],
                                    song: songdata);
                                Navigator.pop(context);
                              },
                              leading: SizedBox(
                                height: 50,
                                width: 50,
                                child: Playlistimagewidget(
                                    images: List.generate(
                                      playlist[index]["songs"].length,
                                      (ind) {
                                        return playlist[index]["songs"][ind]
                                                        ["image"]
                                                    .runtimeType ==
                                                List
                                            ? playlist[index]["songs"][ind]
                                                ["image"][2]["link"]
                                            : playlist[index]["songs"][ind]
                                                ["image"];
                                      },
                                    ),
                                    length: playlist[index]["songs"].length),
                              ),
                              title: Text(playlist[index]["name"]),
                            ),
                          );
                        },
                      );
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
