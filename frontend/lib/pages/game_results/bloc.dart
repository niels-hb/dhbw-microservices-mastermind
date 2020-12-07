import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/services/game.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameResultsBloc extends ChangeNotifier {
  final BuildContext context;

  final Game game;

  GameResultsBloc(this.context, this.game);

  void setUsername(String username) {
    game.username = username;

    notifyListeners();
  }

  bool isUsernameRequired() => game.offline && game.solved && !game.undoUsed;

  bool isUsernameSet() =>
      !isUsernameRequired() || (game.username?.isNotEmpty ?? false);

  void closeDialog() {
    _saveGame();

    Navigator.of(context).pop();
  }

  void closeToHome() {
    _saveGame();

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _saveGame() {
    if (isUsernameRequired() && isUsernameSet()) {
      Provider.of<PresetsService>(context).username = game.username;
      Provider.of<GameService>(context).saveGame(game);
    }
  }
}
