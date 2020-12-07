import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_color.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_config.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/round.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/game_config/game_config.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/game_results/game_results.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/services/game.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:dhbw_swe_mastermind_frontend/util/color_selector.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBloc extends ChangeNotifier with ColorSelector {
  final BuildContext context;

  ApiService apiService;

  final Game game;

  final List<GameColor> selectedColors;

  GameService gameService;

  @override
  GameConfig get config => game.config;

  GameBloc(this.context, this.game)
      : selectedColors = List.filled(game.config.pins, GameColor.unselected);

  void makeGuess() async {
    await _addRound();
    notifyListeners();

    saveProgress();

    if (game.finished) {
      Future.microtask(showResultsScreen);
    }
  }

  void showGameConfig() {
    showDialog(
      context: context,
      builder: (_) => GameConfigModel.view(game),
    );
  }

  void showResultsScreen() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameResultsModel.view(game),
    );
  }

  void undo() {
    ConfirmationDialog.show(
      context: context,
      title: 'Rückgängig',
      description: 'Das Spiel fließt dadurch nicht in die Gesamtwertung ein.',
      onAccept: () async {
        if (game.rounds.isNotEmpty) {
          game.undoUsed = true;

          if (!game.offline) {
            await apiService.gamesDeleteRounds(game, game.rounds[0]);
          }

          game.rounds.removeAt(0);
          notifyListeners();

          saveProgress();
        }
      },
    );
  }

  void saveProgress() {
    if (game.offline) {
      Provider.of<PresetsService>(context).unfinishedGame =
          game.finished ? null : game;
    } else {
      Provider.of<ApiService>(context)
          .updateCurrentGame(game.finished ? null : game);
    }
  }

  Future<void> _addRound() async {
    if (!config.validateGameColors(selectedColors)) {
      throw 'Selected game colors violate config.';
    }

    List<GameColor> gameColorsCopy = []..addAll(selectedColors);

    game.rounds.insert(
      0,
      game.offline
          ? Round(
              guess: gameColorsCopy,
              rating: game.getRatingForColors(gameColorsCopy),
            )
          : await apiService.gamesPostRounds(game, selectedColors),
    );
  }
}
