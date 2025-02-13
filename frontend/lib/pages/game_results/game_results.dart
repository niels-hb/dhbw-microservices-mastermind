import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/game_results/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/game_results/view.dart';
import 'package:provider/provider.dart';

class GameResultsModel {
  static ChangeNotifierProvider<GameResultsBloc> view(Game game) =>
      ChangeNotifierProvider<GameResultsBloc>(
        create: (context) => GameResultsBloc(context, game),
        child: GameResultsView(),
      );
}
