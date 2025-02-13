import 'package:dhbw_swe_mastermind_frontend/interfaces/game_color.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_config.dart';
import 'package:dhbw_swe_mastermind_frontend/util/color_selector.dart';
import 'package:flutter/material.dart';

class NewGameSolutionBloc extends ChangeNotifier with ColorSelector {
  final BuildContext context;

  final GameConfig config;

  final List<GameColor> selectedColors;

  NewGameSolutionBloc(this.context, this.config)
      : selectedColors = List.filled(config.pins, GameColor.unselected);

  void setGameColors(BuildContext context) {
    if (validateGameColors()) {
      Navigator.of(context).pop(selectedColors);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Lösung entspricht nicht den Einstellungen.'),
        ),
      );
    }
  }
}
