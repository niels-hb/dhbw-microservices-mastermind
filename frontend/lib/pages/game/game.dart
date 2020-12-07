import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/game/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/game/view.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/services/game.dart';
import 'package:provider/provider.dart';

class GameModel {
  static ChangeNotifierProxyProvider2<GameService, ApiService, GameBloc> view(
          Game game) =>
      ChangeNotifierProxyProvider2<GameService, ApiService, GameBloc>(
        create: (context) => GameBloc(context, game),
        update: (context, gameService, apiService, previous) => previous
          ..gameService = gameService
          ..apiService = apiService,
        child: GameView(),
      );
}
