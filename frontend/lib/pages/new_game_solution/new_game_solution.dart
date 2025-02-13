import 'package:dhbw_swe_mastermind_frontend/interfaces/game_config.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/new_game_solution/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/new_game_solution/view.dart';
import 'package:provider/provider.dart';

class NewGameSolutionModel {
  static ChangeNotifierProvider<NewGameSolutionBloc> view(GameConfig config) =>
      ChangeNotifierProvider<NewGameSolutionBloc>(
        create: (context) => NewGameSolutionBloc(context, config),
        child: NewGameSolutionView(),
      );
}
