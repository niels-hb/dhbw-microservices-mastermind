import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_config.dart';
import 'package:dhbw_swe_mastermind_frontend/services/database.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:dhbw_swe_mastermind_frontend/util/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

class PresetsService extends ChangeNotifier with BlocState, DatabaseHelper {
  static const String _USERNAME = 'USERNAME';

  static const String _PRV_GME_CNF = 'PREVIOUS_GAME_CONFIG';

  static const String _UNF_GME = 'UNFINISHED_GAME';

  static const String _OAT_ACC_TKN = 'OAUTH_ACCESS_TOKEN';

  DatabaseService databaseService;

  StoreRef<String, Map<String, dynamic>> get store =>
      databaseService.presetsStore;

  Map<String, dynamic> values = {};

  String get username => values[_USERNAME];
  set username(String username) => putRecord(
        _USERNAME,
        username,
      );

  GameConfig get previousGameConfig => values[_PRV_GME_CNF];
  set previousGameConfig(GameConfig gameConfig) => putRecord(
        _PRV_GME_CNF,
        gameConfig,
      );

  Game get unfinishedGame => values[_UNF_GME];
  set unfinishedGame(Game game) => putRecord(
        _UNF_GME,
        game,
      );

  String get oauthAccessToken => values[_OAT_ACC_TKN];
  set oauthAccessToken(String oauthAccessToken) => putRecord(
        _OAT_ACC_TKN,
        oauthAccessToken,
      );

  Future<void> loadPresets() async {
    if (databaseService.state == BlocStateSelector.created) {
      state = BlocStateSelector.waiting;

      await getAndAssign(_USERNAME, (username) => username);

      await getAndAssign(
        _PRV_GME_CNF,
        (gameConfig) => GameConfig.fromJson(gameConfig),
      );

      await getAndAssign(
        _UNF_GME,
        (game) => Game.fromJson(game),
      );

      await getAndAssign(_OAT_ACC_TKN, (oauthAccessToken) => oauthAccessToken);

      state = BlocStateSelector.created;
    }
  }

  Future<void> reset() async {
    await store.drop(databaseService.db);

    values = {};
    notifyListeners();
  }
}
