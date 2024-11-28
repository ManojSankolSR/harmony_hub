import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Providers/ThemeProvider.dart';
import 'package:harmony_hub/Widgets/AppDialogs.dart';

class ThemeModeHelper {
  static Future setThemeMode(ThemeMode thememode) async {
    if (Boxes.UserBox.containsKey('user')) {
      UserModel user = Boxes.UserBox.get("user")!;

      user.themeMode = thememode.name;
      await user.save();
    }
  }

  static ThemeMode getThemeMode() {
    if (Boxes.UserBox.containsKey('user')) {
      UserModel user = Boxes.UserBox.get("user")!;
      String savedThemeode = user.themeMode;
      return ThemeMode.values.firstWhere(
        (element) => element.name == savedThemeode,
      );
    }
    return ThemeMode.system;
  }

  static void themeModeSelectorDialog(
      {required BuildContext context, required WidgetRef ref}) async {
    final themeModeList = ThemeMode.values
        .map(
          (e) => e.name,
        )
        .toList();
    final currentlySelectedTheme = getThemeMode();

    final String? result = await AppDialogs.showPickerDialog(
        pickerTitle: "Themes",
        itemsList: themeModeList,
        context: context,
        currentlySelecteditem: currentlySelectedTheme.name);
    print(result);
    if (result != null) {
      ref
          .read(ThemeModeProvider.notifier)
          .changeThemeMode(ThemeMode.values.firstWhere(
            (element) => element.name == result,
          ));
    }
  }
}
