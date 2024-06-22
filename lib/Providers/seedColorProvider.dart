import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Functions/SeedColor.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:miniplayer/miniplayer.dart';

class seedColorNotifier extends StateNotifier<Color> {
  seedColorNotifier() : super(SeedColor.getSeedColor());

  Color loadColor() {
    state = SeedColor.getSeedColor();
    return state;
  }

  Future updateColor(Color color) async {
    state = color;
    await SeedColor.updateSeedColor(state);
  }
}

final seedColorProvider = StateNotifierProvider<seedColorNotifier, Color>(
  (ref) => seedColorNotifier(),
);

final MiniplayerControllerProvider = StateProvider<MiniplayerController>(
  (ref) {
    return MiniplayerController();
  },
);
