import 'package:dhbw_swe_mastermind_frontend/interfaces/game_color.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/mode.dart';
import 'package:dhbw_swe_mastermind_frontend/util/extensions.dart';
import 'package:dhbw_swe_mastermind_frontend/util/mappable.dart';
import 'package:flutter/material.dart';

class GameConfig implements Mappable {
  final Mode mode;

  int pins;

  int maxRounds;

  List<GameColor> gameColors;

  bool allowDuplicateColors;

  bool allowEmptyFields;

  GameConfig({
    @required this.mode,
    this.pins = 4,
    this.maxRounds = 5,
    List<GameColor> gameColors,
    this.allowDuplicateColors = false,
    this.allowEmptyFields = false,
  }) : this.gameColors = gameColors ?? GameColor.availableColors;

  factory GameConfig.fromJson(Map<String, dynamic> json) => GameConfig(
        mode: Mode.values.firstWhere(
          (mode) => mode.toString() == json['mode'],
          orElse: () => null,
        ),
        pins: json['pins'],
        maxRounds: json['maxRounds'],
        gameColors: List.from(json['gameColors'])
            .map((gameColor) => GameColor.fromJson(gameColor))
            .toList(),
        allowDuplicateColors: json['allowDuplicateColors'],
        allowEmptyFields: json['allowEmptyFields'],
      );

  GameConfig copyWith({
    Mode mode,
  }) =>
      GameConfig(
        mode: mode,
        pins: pins,
        maxRounds: maxRounds,
        gameColors: gameColors,
        allowDuplicateColors: allowDuplicateColors,
        allowEmptyFields: allowEmptyFields,
      );

  GameConfigValidationError validate() {
    pins ??= 0;
    maxRounds ??= 0;

    if (pins < 4 || pins > 8 || pins == 7) {
      return GameConfigValidationError.pins;
    } else if (maxRounds < 1) {
      return GameConfigValidationError.maxRounds;
    } else if (gameColors.length < 6) {
      return GameConfigValidationError.gameColors;
    } else if (!allowDuplicateColors &&
        !allowEmptyFields &&
        gameColors.length < pins) {
      return GameConfigValidationError.impossibleConfig;
    }

    return null;
  }

  bool validateGameColors(List<GameColor> gameColors) {
    return validateEmptyFields(gameColors) &&
        validateDuplicateGameColors(gameColors) &&
        validateLength(gameColors);
  }

  bool validateEmptyFields(List<GameColor> gameColors) {
    return allowEmptyFields || !gameColors.contains(GameColor.unselected);
  }

  bool validateDuplicateGameColors(List<GameColor> gameColors) {
    List<GameColor> gameColorsCopy = []..addAll(gameColors);
    gameColorsCopy.removeWhere(
      (gameColor) => gameColor == GameColor.unselected,
    );

    return allowDuplicateColors || !gameColorsCopy.hasDuplicates();
  }

  bool validateLength(List<GameColor> gameColors) {
    return pins == gameColors.length;
  }

  List<GameColor> generateSolution() {
    List<GameColor> allowedColors = []..addAll(gameColors);
    List<GameColor> solution = List(pins);

    if (allowEmptyFields) {
      allowedColors.add(GameColor.unselected);
    }

    for (int i = 0; i < pins; i++) {
      GameColor gameColor;

      do {
        gameColor = (allowedColors..shuffle()).first;
      } while (!allowDuplicateColors &&
          solution.contains(gameColor) &&
          gameColor != GameColor.unselected);

      solution[i] = gameColor;
    }

    print(
      'Generated: ${solution.map((gameColor) => gameColor.name).join(', ')}',
    );

    return solution;
  }

  @override
  Map<String, dynamic> toMap() => {
        'mode': mode.toString(),
        'pins': pins,
        'maxRounds': maxRounds,
        'gameColors': gameColors.toMappedList(),
        'gameColorsCount': gameColors.length,
        'allowDuplicateColors': allowDuplicateColors,
        'allowEmptyFields': allowEmptyFields,
      };
}

enum GameConfigValidationError {
  pins,
  maxRounds,
  gameColors,
  impossibleConfig,
}
