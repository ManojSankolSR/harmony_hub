import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:hive_flutter/adapters.dart';

class Likebutton extends StatelessWidget {
  final Map<String, dynamic> songData;
  final double iconSize;

  const Likebutton({super.key, required this.songData, this.iconSize = 25});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Boxes.UserBox.listenable(),
        builder: (context, value, child) {
          bool isFavourite = Boxes.getFavSongs().any(
            (element) => songData["id"] == element["id"],
          );
          return IconButton(
              onPressed: () async {
                if (isFavourite) {
                  await Boxes.deleteSongFromFav(songData);
                } else {
                  await Boxes.addSongToFav(songData);
                }
              },
              icon: isFavourite
                  ? Icon(
                      Icons.favorite_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: iconSize,
                    ).animate().scale(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.elasticOut)
                  : Icon(
                      Icons.favorite_border,
                      size: iconSize,
                    ).animate().scale(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut));
        });
  }
}
