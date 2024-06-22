import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Functions/UserPreferredQuality.dart';
import 'package:harmony_hub/Functions/language.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Musicplayer {
  static StreamSubscription<SequenceState?>? subscription;

  static Future<void> setUpAudioPlayer(
    WidgetRef ref, {
    List<dynamic> AudioData = const [],
    int startIndex = 0,
  }) async {
    try {
      ConcatenatingAudioSource PlayList = AudioData[0].runtimeType == SongModel
          ? ConcatenatingAudioSource(
              children: List.generate(
              AudioData.length,
              (index) {
                return AudioSource.uri(Uri.parse(AudioData[index].uri),
                    tag: MediaItem(
                        artist: AudioData[index].artist,
                        id: AudioData[index].id.toString(),
                        title: AudioData[index].title));
              },
            ))
          : ConcatenatingAudioSource(
              shuffleOrder: DefaultShuffleOrder(),
              children: List.generate(
                AudioData.length,
                (index) {
                  final link =
                      Userpreferredquality.getUserPereferedQualityLinkFomData(
                          AudioData[index]["download_url"]);

                  return LockCachingAudioSource(Uri.parse(link),
                      tag: MediaItem(
                          id: index.toString(),
                          artist: AudioData[index]["subtitle"],
                          artUri: Uri.parse(
                            AudioData[index]["image"].runtimeType == List
                                ? AudioData[index]["image"][2]["link"]
                                : AudioData[index]["image"],
                          ),
                          title: AudioData[index]["name"],
                          extras: {
                            ...AudioData[index],

                            // "download_url": AudioData[index]["download_url"],
                            // "subtitle": AudioData[index]["subtitle"]
                          }));
                },
              ));
      ref.read(globalPlayerProvider).setAudioSource(
            PlayList,
            initialIndex: startIndex,
          );
    } catch (e) {
      print("errorapec $e");
    }
  }

  static Future<void> initEventlistnerToSaveSessionData(WidgetRef ref) async {
    if (subscription != null) {
      await subscription!.cancel();
      subscription = null;
    } else {}

    subscription = ref.read(globalPlayerProvider).sequenceStateStream.listen(
        (event) async {
      if (event == null ||
          event.currentSource == null ||
          event.currentSource!.tag == null) {
        return;
      }

      final currentExtras = event.currentSource!.tag.extras;

      await Boxes.SaveLastSsssionData({
        "currentIndex": event!.currentIndex,
        "data": List.generate(
          event.sequence.length,
          (index) {
            Map<String, dynamic> songdata = event.sequence[index].tag.extras;
            return {...songdata};
          },
        )
      });

      if (currentExtras != null) {
        await Boxes.SaveSongsHistory(event.currentSource!.tag.extras);
      }
    }, onError: (Object e) {
      print("Stack trace stram $e");
    });
  }
}
