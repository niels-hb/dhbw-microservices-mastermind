import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_config.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/config_filter_dialog.dart';
import 'package:flutter/material.dart';

class RankingOnlineBloc extends ChangeNotifier with BlocState {
  final BuildContext context;

  ApiService apiService;

  PresetsService presetsService;

  List<Game> me;

  List<Game> friends;

  List<Game> global;

  GameConfig _filter;

  RankingOnlineBloc(this.context);

  void loadInitialFilter() {
    _filter = presetsService.previousGameConfig?.copyWith();
  }

  void loadData() async {
    try {
      state = BlocStateSelector.waiting;

      me = await apiService.gamesGetRanking(
        filter: _filter,
        endpoint: 'me',
      );
      friends = await apiService.gamesGetRanking(
        filter: _filter,
        endpoint: 'friends',
      );
      global = await apiService.gamesGetRanking(
        filter: _filter,
        endpoint: 'global',
      );

      state = BlocStateSelector.created;
    } catch (e) {
      print(e);
      state = BlocStateSelector.error;
    }
  }

  Future<void> editFilter() async {
    GameConfig filter = await showDialog(
      context: context,
      builder: (_) => ConfigFilterDialog(_filter),
    );

    if (filter != null) {
      _filter = filter;
      print('Applied new filter:\n${_filter.toMap()}');

      loadData();
    }
  }
}
