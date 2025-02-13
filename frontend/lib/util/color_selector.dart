import 'package:dhbw_swe_mastermind_frontend/interfaces/game_color.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_config.dart';
import 'package:flutter/material.dart';

mixin ColorSelector on ChangeNotifier {
  GameConfig get config;

  List<GameColor> get selectedColors;

  GameColor _activeColor;

  GameColor get activeColor => _activeColor;

  set activeColor(GameColor activeColor) {
    _activeColor = activeColor;

    notifyListeners();
  }

  void toggleSelection(int index) {
    if (activeColor == null) {
      return;
    }

    if (selectedColors[index] == activeColor) {
      selectedColors[index] = GameColor.unselected;
    } else {
      if (!config.allowDuplicateColors &&
          selectedColors.contains(activeColor)) {
        return;
      }

      selectedColors[index] = activeColor;
    }

    notifyListeners();
  }

  bool validateGameColors() => config.validateGameColors(selectedColors);
}
