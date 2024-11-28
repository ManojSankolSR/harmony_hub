import 'package:flutter/material.dart';
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
      } else {}
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
      backgroundColor: Colors.transparent,
      // showDragHandle: true
      isScrollControlled: true,

      isDismissible: true,
      useRootNavigator: true,

      context: context,
      builder: (context) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surface),
            // height: 400,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.5,
                maxChildSize: 0.7,
                expand: false,
                snap: true,
                builder: (context, scrollController) {
                  return CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        scrolledUnderElevation: 0,
                        elevation: 0,
                        shadowColor: Theme.of(context).colorScheme.surface,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        pinned: true,
                        toolbarHeight: 130,
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 5,
                              width: 35,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Playlists  ",
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                  ),
                                  Icon(
                                    Icons.library_music_outlined,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                ],
                              ),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                              child: ListTile(
                                trailing: const Icon(Icons.add),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        titleTextStyle: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                        title: const Text("Playlist Name"),
                                        content: TextField(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              label: Text("Title")),
                                          controller: textEditingController,
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("cancel")),
                                          TextButton(
                                              onPressed: () async {
                                                if (textEditingController
                                                        .text !=
                                                    "") {
                                                  await createPlaylist(
                                                      playlistName:
                                                          textEditingController
                                                              .text);
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text("ok")),
                                        ],
                                      );
                                    },
                                  );
                                },
                                title: const Text("Create Playlist"),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      ValueListenableBuilder(
                          valueListenable: Boxes.UserBox.listenable(),
                          builder: (context, value, child) {
                            final playlist = getPlylists();
                            return SliverList.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              // shrinkWrap: true,
                              itemCount: playlist.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: ListTile(
                                      onTap: () {
                                        addSongToPlaylist(
                                            playlistName: playlist[index]
                                                ["name"],
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
                                                return playlist[index]["songs"]
                                                                [ind]["image"]
                                                            .runtimeType ==
                                                        List
                                                    ? playlist[index]["songs"]
                                                            [ind]["image"][2]
                                                        ["link"]
                                                    : playlist[index]["songs"]
                                                        [ind]["image"];
                                              },
                                            ),
                                            length: playlist[index]["songs"]
                                                .length),
                                      ),
                                      title: Text(playlist[index]["name"]),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                    ],
                  );
                }));
      },
    );
  }
}
