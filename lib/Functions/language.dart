import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';

class UserPeferedLanguage {
  static String getUserPreferedlanguage() {
    if (Boxes.UserBox.containsKey('user')) {
      String langauage = Boxes.UserBox.get("user")!.perfferdLanguage;

      return langauage;
    }
    return "kannada";
  }

  static Future setUserPreferedlanguage(String langauage) async {
    if (Boxes.UserBox.containsKey('user')) {
      UserModel user = Boxes.UserBox.get("user")!;
      user.perfferdLanguage = langauage;
      await user.save();
    }
  }

  static Future showLanguageSelectDialog(
    BuildContext context,
    WidgetRef ref, {
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
              itemCount: Language.values.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.language_outlined),
                  onTap: () async {
                    if (isFromWlecomeScreen) {
                      Navigator.pop(context, [Language.values[index].name]);
                      return;
                    }
                    await setUserPreferedlanguage(Language.values[index].name);
                    ref.invalidate(HomeScreenDataProvider);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        content: AwesomeSnackbarContent(
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
                            title: "Content Updated",
                            message:
                                "Langauge Changed to ${UserPeferedLanguage.getUserPreferedlanguage()}",
                            contentType: ContentType.success)));
                  },
                  title: Text(Language.values[index].name.toUpperCase()),
                );
              },
            ),
          );
        });
  }
}
