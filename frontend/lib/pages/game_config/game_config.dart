import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/game_config/view.dart';

class GameConfigModel {
  static view(Game game) => GameConfigView(game);
}
