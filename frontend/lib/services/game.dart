import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_color.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_config.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/mode.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/new_game_solution/new_game_solution.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/services/database.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';

class GameService {
  DatabaseService databaseService;

  ApiService apiService;

  Future<Game> createGame(BuildContext context, GameConfig config) async {
    if (config.mode == Mode.online_computer) {
      return apiService.gamesPost(config);
    }

    List<GameColor> solution;

    switch (config.mode) {
      case Mode.offline_computer:
        solution = config.generateSolution();
        break;
      case Mode.offline_player:
        solution = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => NewGameSolutionModel.view(config),
          ),
        );

        if (solution == null) {
          throw 'Solution selection cancelled.';
        }

        break;
      default:
        return null;
    }

    return Game(
      config: config,
      solution: solution,
      username: Provider.of<PresetsService>(context).username,
    );
  }

  Future<List<Game>> getAll([Finder finder]) async {
    QueryRef query = databaseService.gamesStore.query(finder: finder);

    return (await query.getSnapshots(databaseService.db))
        .map((record) => Game.fromJson(record.value))
        .toList();
  }

  Future<void> saveGame(Game game) {
    if (game.offline) {
      return databaseService.gamesStore.add(databaseService.db, game.toMap());
    } else {
      throw 'Can\'t persist online games!';
    }
  }

  Future<void> reset() {
    return databaseService.gamesStore.drop(databaseService.db);
  }
}
