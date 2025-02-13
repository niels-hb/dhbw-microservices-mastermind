import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/mode.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/game/game.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_color.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_config.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/services/game.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewGameBloc extends ChangeNotifier with BlocState {
  final BuildContext context;

  final Mode mode;

  PresetsService presetsService;

  GameService gameService;

  GameConfig _config;

  NewGameBloc(this.context, this.mode);

  int get pins => _config.pins;

  set pins(int pins) {
    _config.pins = pins;

    notifyListeners();
  }

  int get maxRounds => _config.maxRounds;

  set maxRounds(int maxRounds) {
    _config.maxRounds = maxRounds;

    notifyListeners();
  }

  void toggleGameColor(GameColor color) {
    isGameColorChecked(color)
        ? _config.gameColors.remove(color)
        : _config.gameColors.add(color);

    notifyListeners();
  }

  bool isGameColorChecked(GameColor color) =>
      _config.gameColors.contains(color);

  bool get allowDuplicateColors => _config.allowDuplicateColors;

  set allowDuplicateColors(bool allowDuplicateColors) {
    _config.allowDuplicateColors = allowDuplicateColors;

    notifyListeners();
  }

  bool get allowEmptyFields => _config.allowEmptyFields;

  set allowEmptyFields(bool allowEmptyFields) {
    _config.allowEmptyFields = allowEmptyFields;

    notifyListeners();
  }

  void loadGameConfig() {
    if (_config == null && presetsService.state == BlocStateSelector.created) {
      state = BlocStateSelector.waiting;

      _config = presetsService.previousGameConfig?.copyWith(mode: mode) ??
          GameConfig(mode: mode);

      state = BlocStateSelector.created;
    }
  }

  void startGame(BuildContext context) async {
    if (!_validateConfig(context)) {
      return;
    }

    try {
      Game game = await gameService.createGame(context, _config);
      presetsService.previousGameConfig = _config;
      if (game.offline) {
        presetsService.unfinishedGame = game;
      } else {
        Provider.of<ApiService>(context).updateCurrentGame(game);
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => GameModel.view(game),
        ),
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  bool _validateConfig(BuildContext context) {
    String message;

    switch (_config.validate()) {
      case GameConfigValidationError.gameColors:
        message = 'Du musst mindestens 6 Farben auswählen!';
        break;
      case GameConfigValidationError.impossibleConfig:
        message = 'Unmögliche Konfiguration!';
        break;
      default:
        return true;
    }

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );

    return false;
  }
}
