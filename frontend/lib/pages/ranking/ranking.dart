import 'package:dhbw_swe_mastermind_frontend/pages/ranking/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/ranking/view.dart';
import 'package:dhbw_swe_mastermind_frontend/services/game.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:provider/provider.dart';

class RankingModel {
  static final String route = 'ranking';
  static final ChangeNotifierProxyProvider2<GameService, PresetsService,
          RankingBloc> view =
      ChangeNotifierProxyProvider2<GameService, PresetsService, RankingBloc>(
    create: (context) => RankingBloc(context),
    update: (context, gameService, presetsService, previous) => previous
      ..gameService = gameService
      ..presetsService = presetsService
      ..loadInitialFilter()
      ..getGames(),
    child: RankingView(),
  );
}
