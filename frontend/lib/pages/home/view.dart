import 'package:dhbw_swe_mastermind_frontend/pages/about/about.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/game/game.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/help/help.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/home_online/home_online.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/login/login.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/new_game/new_game.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/ranking/ranking.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/settings/settings.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(64.0),
          children: <Widget>[
            Consumer<PresetsService>(
              builder: (context, bloc, child) => Visibility(
                visible: bloc.unfinishedGame != null,
                child: Column(
                  children: <Widget>[
                    AppButton(
                      color: Colors.indigo,
                      borderColor: Colors.indigoAccent,
                      icon: Icon(Icons.play_arrow),
                      title: 'FORTSETZEN',
                      onPressed: () => _continue(context, bloc),
                    ),
                    UIHelper.verticalSpaceDefault,
                  ],
                ),
              ),
            ),
            AppButton(
              color: Color(0xFFDF527D),
              borderColor: Color(0xFFB54468),
              icon: Icon(Icons.computer),
              title: 'VS. COMPUTER',
              onPressed: () =>
                  _navigate(context, NewGameModel.routeForOfflineComputer),
            ),
            UIHelper.verticalSpaceDefault,
            AppButton(
              color: Color(0xFF5CB5E0),
              borderColor: Color(0xFF5A96BB),
              icon: Icon(Icons.gamepad),
              title: 'DUELL SPIELEN',
              onPressed: () =>
                  _navigate(context, NewGameModel.routeForOfflinePlayer),
            ),
            UIHelper.verticalSpaceDefault,
            AppButton(
              color: Color(0xFFEEA42C),
              borderColor: Color(0xFFB17A2E),
              icon: Icon(Icons.show_chart),
              title: 'RANKING',
              onPressed: () => _navigate(context, RankingModel.route),
            ),
            UIHelper.verticalSpaceDefault,
            AppButton(
              color: Color(0xFF828282),
              borderColor: Color(0xFF6B6266),
              icon: Icon(Icons.settings),
              title: 'EINSTELLUNGEN',
              onPressed: () => _navigate(context, SettingsModel.route),
            ),
            UIHelper.verticalSpaceDefault,
            AppButton(
              color: Color(0xFF828282),
              borderColor: Color(0xFF6B6266),
              icon: Icon(Icons.help),
              title: 'HILFE',
              onPressed: () => _navigate(context, HelpModel.route),
            ),
            UIHelper.verticalSpaceDefault,
            AppButton(
              color: Color(0xFF828282),
              borderColor: Color(0xFF6B6266),
              icon: Icon(Icons.person),
              title: 'IMPRESSUM',
              onPressed: () => _navigate(context, AboutModel.route),
            ),
            UIHelper.verticalSpaceDefault,
            AppButton(
              color: Colors.teal,
              borderColor: Colors.tealAccent,
              icon: Icon(Icons.cloud),
              title: 'ONLINE',
              onPressed: () => _online(context),
            ),
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  void _continue(BuildContext context, PresetsService presetsService) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameModel.view(presetsService.unfinishedGame),
      ),
    );
  }

  void _online(BuildContext context) {
    _navigate(
      context,
      Provider.of<PresetsService>(context).oauthAccessToken == null
          ? LoginModel.route
          : HomeOnlineModel.route,
    );
  }
}
