import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Hive/Boxes.dart';

class Userpreferredquality {
  static Future setUserpreferredquality({required AudioQuality quality}) async {
    if (Boxes.UserBox.containsKey("user")) {
      UserModel user = Boxes.UserBox.get("user")!;
      user.audioQuality = quality.kbps;
      await user.save();
    }
  }

  static String getUserPereferedQualityLinkFomData(List<dynamic> data) {
    print(data);
    String link = data
        .firstWhere((e) => e["quality"] == getUserpreferredquality())["link"];
    print(link);
    return link;
  }

  static String getUserpreferredquality() {
    if (Boxes.UserBox.containsKey("user")) {
      UserModel user = Boxes.UserBox.get("user")!;
      return user.audioQuality;
    }
    return "320kbps";
  }

  static Future showQualitySelectDialog(
    BuildContext context, {
    bool isFromWlecomeScreen = false,
  }) async {
    return showModalBottomSheet<dynamic>(
        showDragHandle: true,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 30,
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400,
            padding: EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: AudioQuality.values.length,
              itemBuilder: (context, index) {
                bool isSelectedQuality =
                    Userpreferredquality.getUserpreferredquality() ==
                        AudioQuality.values[index].kbps;
                return ListTile(
                  leading: Icon(Icons.high_quality),
                  onTap: () async {
                    if (isFromWlecomeScreen) {
                      Navigator.pop(context, [AudioQuality.values[index].kbps]);
                      return;
                    }
                    await setUserpreferredquality(
                        quality: AudioQuality.values[index]);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        content: AwesomeSnackbarContent(
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
                            title: " Audio Quality Changed",
                            message:
                                "AudioQuality Changed to ${Userpreferredquality.getUserpreferredquality()}",
                            contentType: ContentType.success)));
                  },
                  trailing:
                      isSelectedQuality ? Icon(Icons.verified_outlined) : null,
                  title: Text(
                    AudioQuality.values[index].name.toUpperCase(),
                  ),
                );
              },
            ),
          );
        });
  }
}
