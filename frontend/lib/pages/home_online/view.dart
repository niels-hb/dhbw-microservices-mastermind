import 'package:dhbw_swe_mastermind_frontend/pages/account/account.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/friends/friends.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/game/game.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/history/history.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/new_game/new_game.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/ranking_online/ranking_online.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/button.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/connection_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeOnlineView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ONLINE'),
        ),
        body: ConnectionStatus(
          child: ListView(
            padding: EdgeInsets.all(64.0),
            children: <Widget>[
              Consumer<ApiService>(
                builder: (context, bloc, child) => Visibility(
                  visible: bloc.user?.currentGame != null,
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
                icon: Icon(Icons.gamepad),
                title: 'SPIEL STARTEN',
                onPressed: () =>
                    _navigate(context, NewGameModel.routeForOnlineComputer),
              ),
              UIHelper.verticalSpaceDefault,
              AppButton(
                color: Color(0xFFEEA42C),
                borderColor: Color(0xFFB17A2E),
                icon: Icon(Icons.show_chart),
                title: 'RANKING',
                onPressed: () => _navigate(context, RankingOnlineModel.route),
              ),
              UIHelper.verticalSpaceDefault,
              AppButton(
                color: Color(0xFF5CB5E0),
                borderColor: Color(0xFF5A96BB),
                icon: Icon(Icons.playlist_play),
                title: 'HISTORIE',
                onPressed: () => _navigate(context, HistoryModel.route),
              ),
              UIHelper.verticalSpaceDefault,
              AppButton(
                color: Color(0xFF828282),
                borderColor: Color(0xFF6B6266),
                icon: Icon(Icons.group),
                title: 'FREUNDE',
                onPressed: () => _navigate(context, FriendsModel.route),
              ),
              UIHelper.verticalSpaceDefault,
              AppButton(
                color: Color(0xFF828282),
                borderColor: Color(0xFF6B6266),
                icon: Icon(Icons.person),
                title: 'ACCOUNT',
                onPressed: () => _navigate(context, AccountModel.route),
              ),
              UIHelper.verticalSpaceDefault,
              AppButton(
                color: Colors.teal,
                borderColor: Colors.tealAccent,
                icon: Icon(Icons.exit_to_app),
                title: 'LOGOUT',
                onPressed: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  void _continue(BuildContext context, ApiService apiService) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameModel.view(apiService.user.currentGame),
      ),
    );
  }

  void _logout(BuildContext context) {
    Provider.of<PresetsService>(context).oauthAccessToken = null;

    Navigator.of(context).pop();
  }
}
