import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Functions/ThemeModeHelper.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeModeHelper.getThemeMode());

  Future changeThemeMode(ThemeMode ThemeMode) async {
    state = ThemeMode;
    ThemeModeHelper.setThemeMode(state);
    // await SeedColor.updateSeedColor(state);
  }
}

final ThemeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);
