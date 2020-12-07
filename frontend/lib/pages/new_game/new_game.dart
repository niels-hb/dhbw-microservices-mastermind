import 'package:dhbw_swe_mastermind_frontend/interfaces/mode.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/new_game/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/new_game/view.dart';
import 'package:dhbw_swe_mastermind_frontend/services/game.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:provider/provider.dart';

class NewGameModel {
  static final String routeForOfflineComputer = 'new_game_offline_computer';
  static final String routeForOfflinePlayer = 'new_game_offline_player';
  static final String routeForOnlineComputer = 'new_game_online_player';
  static final viewForOfflineComputer = _view(Mode.offline_computer);
  static final viewForOfflinePlayer = _view(Mode.offline_player);
  static final viewForOnlineComputer = _view(Mode.online_computer);

  static ChangeNotifierProxyProvider2<PresetsService, GameService,
      NewGameBloc> _view(
    Mode mode,
  ) =>
      ChangeNotifierProxyProvider2<PresetsService, GameService, NewGameBloc>(
        create: (context) => NewGameBloc(context, mode),
        update: (context, presetsService, gameService, previous) => previous
          ..presetsService = presetsService
          ..gameService = gameService
          ..loadGameConfig(),
        child: NewGameView(),
      );
}
