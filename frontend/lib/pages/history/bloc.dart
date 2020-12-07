import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:flutter/material.dart';

class HistoryBloc extends ChangeNotifier with BlocState {
  final BuildContext context;

  ApiService apiService;

  List<Game> history;

  HistoryBloc(this.context);

  void loadData() async {
    try {
      state = BlocStateSelector.waiting;

      history = await apiService.gamesGetHistoryFriends();

      state = BlocStateSelector.created;
    } catch (e) {
      print(e);
      state = BlocStateSelector.error;
    }
  }
}
