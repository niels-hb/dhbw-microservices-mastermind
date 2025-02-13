import 'package:dhbw_swe_mastermind_frontend/interfaces/game_color.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_config.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/mode.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/rating.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/round.dart';
import 'package:dhbw_swe_mastermind_frontend/util/extensions.dart';
import 'package:dhbw_swe_mastermind_frontend/util/mappable.dart';
import 'package:flutter/material.dart';

class Game implements Mappable {
  final String id;

  final GameConfig config;

  final List<GameColor> solution;

  final List<Round> rounds;

  bool undoUsed;

  String username;

  bool get solved =>
      rounds.isNotEmpty && rounds.first.rating.exactMatch == config.pins;

  bool get finished => solved || rounds.length >= config.maxRounds;

  bool get offline => const [
        Mode.offline_computer,
        Mode.offline_player,
      ].contains(config.mode);

  Game({
    this.id,
    @required this.config,
    @required this.solution,
    List<Round> rounds,
    this.undoUsed = false,
    this.username,
  }) : this.rounds = rounds ?? [];

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: json['id'],
        config: GameConfig.fromJson(json['config']),
        solution: List.from(json['solution'] ?? [])
            .map((gameColor) => GameColor.fromJson(gameColor))
            .toList(),
        rounds: List.from(json['rounds'] ?? [])
            .map((round) => Round.fromJson(round))
            .toList(),
        undoUsed: json['undoUsed'],
        username: json['username'],
      );

  Rating getRatingForColors(List<GameColor> gameColors) {
    int exactMatch = 0;
    int partMatch = 0;

    List<GameColor> solutionCopy = []..addAll(solution);
    List<GameColor> roundCopy = []..addAll(gameColors);

    for (int i = 0; i < roundCopy.length; i++) {
      if (roundCopy[i] == solutionCopy[i]) {
        exactMatch++;

        roundCopy[i] = null;
        solutionCopy[i] = null;
      }
    }

    for (int i = 0; i < solutionCopy.length; i++) {
      for (int j = 0; j < roundCopy.length; j++) {
        if (solutionCopy[i] != null &&
            roundCopy[j] != null &&
            solutionCopy[i] == roundCopy[j]) {
          partMatch++;

          solutionCopy[i] = null;
          roundCopy[j] = null;
          break;
        }
      }
    }

    return Rating(
      exactMatch: exactMatch,
      partMatch: partMatch,
      noMatch: config.pins - exactMatch - partMatch,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'config': config.toMap(),
        'solution': solution.toMappedList(),
        'rounds': rounds.toMappedList(),
        'roundsCount': rounds.length,
        'undoUsed': undoUsed,
        'username': username,
      };
}
