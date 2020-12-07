import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_config.dart';
import 'package:dhbw_swe_mastermind_frontend/services/game.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/config_filter_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';

class RankingBloc extends ChangeNotifier with BlocState {
  final BuildContext context;

  GameService gameService;

  PresetsService presetsService;

  List<Game> games;

  GameConfig _filter;

  RankingBloc(this.context);

  void loadInitialFilter() {
    _filter = presetsService.previousGameConfig?.copyWith();
  }

  Future<void> getGames() async {
    state = BlocStateSelector.waiting;

    games = await gameService.getAll(
      _filter == null
          ? null
          : Finder(
              filter: Filter.and([
                Filter.equals(
                  'config.pins',
                  _filter.pins,
                ),
                Filter.equals(
                  'config.maxRounds',
                  _filter.maxRounds,
                ),
                Filter.equals(
                  'config.gameColorsCount',
                  _filter.gameColors.length,
                ),
                Filter.equals(
                  'config.allowDuplicateColors',
                  _filter.allowDuplicateColors,
                ),
                Filter.equals(
                  'config.allowEmptyFields',
                  _filter.allowEmptyFields,
                ),
              ]),
              sortOrders: [
                SortOrder('roundsCount'),
              ],
            ),
    );

    state = BlocStateSelector.created;
  }

  Future<void> editFilter() async {
    GameConfig filter = await showDialog(
      context: context,
      builder: (_) => ConfigFilterDialog(_filter),
    );

    if (filter != null) {
      _filter = filter;
      print('Applied new filter:\n${_filter.toMap()}');

      getGames();
    }
  }

  Future<void> reset() async {
    await Provider.of<GameService>(context).reset();
    games = null;
    notifyListeners();
  }
}
