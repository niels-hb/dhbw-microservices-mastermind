import 'dart:io';

import 'package:dhbw_swe_mastermind_frontend/apis/games.dart';
import 'package:dhbw_swe_mastermind_frontend/apis/users.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/user.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ApiService extends ChangeNotifier with BlocState, UsersApi, GamesApi {
  static const API_BASE_URL = 'https://api.mastermind.derbl4ck.com/api';

  PresetsService presetsService;

  BaseClient baseClient = Client();

  String get oauthAccessToken => presetsService.oauthAccessToken;

  User user;

  Future<void> loadUser() async {
    if (oauthAccessToken != null) {
      try {
        state = BlocStateSelector.waiting;

        user = await usersGetMe();

        state = BlocStateSelector.created;
      } catch (e) {
        print(e);

        if (e == HttpStatus.unauthorized) {
          presetsService.oauthAccessToken = null;
        }

        state = BlocStateSelector.error;
      }
    }
  }

  void updateCurrentGame(Game game) {
    user.currentGame = game;
    notifyListeners();
  }
}
