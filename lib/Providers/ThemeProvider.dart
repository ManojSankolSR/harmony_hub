import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Functions/SeedColor.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:miniplayer/miniplayer.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.dark);

  // ThemeMode loadThemeThemeMode() {
  //   // state = SeedColor.getSeedColor();
  //   return ThemeMode.dark;
  // }

  Future changeThemeMode(ThemeMode ThemeMode) async {
    state = ThemeMode;
    // await SeedColor.updateSeedColor(state);
  }
}

final ThemeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);
