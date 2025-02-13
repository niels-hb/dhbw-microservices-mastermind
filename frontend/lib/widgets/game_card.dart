import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/user.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/game/game.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameCard {
  static ChangeNotifierProvider<_GameCardBloc> view(Game game) =>
      ChangeNotifierProvider<_GameCardBloc>(
        create: (context) => _GameCardBloc(context),
        child: _GameCardView(game),
      );
}

class _GameCardView extends StatelessWidget {
  final Game game;

  _GameCardView(this.game);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: game.solved ? Colors.green : Colors.red,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: _buildContent(context),
      ),
    );
  }

  Column _buildContent(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(context),
          UIHelper.verticalSpaceSmall,
          _buildSubtitle(context),
          if (!game.offline) ...[
            UIHelper.verticalSpaceSmall,
            _buildActions(context),
          ]
        ],
      );

  Text _buildTitle(BuildContext context) => Text(
        (game.username ?? 'Anonym').toUpperCase(),
        style: Theme.of(context).textTheme.subtitle1,
      );

  Column _buildSubtitle(BuildContext context) => Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildRounds(context),
              _buildConfig(context),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Pins: ${game.config.pins}${!game.undoUsed ? ', Undo' : ''}',
            ),
          ),
        ],
      );

  RichText _buildRounds(BuildContext context) => RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyText1,
          children: <TextSpan>[
            TextSpan(
              text: 'Züge:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: ' ${game.rounds.length}/${game.config.maxRounds}',
            ),
          ],
        ),
      );

  RichText _buildConfig(BuildContext context) => RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyText1,
          children: <TextSpan>[
            TextSpan(
              text: 'Farben:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: ' ${game.config.gameColors.length}',
            ),
            if (game.config.allowDuplicateColors) TextSpan(text: ', mehrfach'),
            if (game.config.allowEmptyFields) TextSpan(text: ', leer'),
          ],
        ),
      );

  Widget _buildActions(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Consumer<_GameCardBloc>(
            builder: (context, bloc, child) {
              User user = User(username: game.username);
              bool follows =
                  Provider.of<ApiService>(context).user.follows(user);

              return FlatButton(
                onPressed: follows
                    ? () => bloc.unfollow(user)
                    : () => bloc.follow(user),
                child: Text(follows ? 'ENTFOLGEN' : 'FOLGEN'),
                visualDensity: VisualDensity.compact,
              );
            },
          ),
          if (Provider.of<ApiService>(context).user.username != game.username)
            FlatButton(
              onPressed: () => Provider.of<_GameCardBloc>(context).replay(game),
              child: Text('REPLAY'),
              visualDensity: VisualDensity.compact,
            ),
        ],
      );
}

class _GameCardBloc extends ChangeNotifier {
  final BuildContext context;

  _GameCardBloc(this.context);

  void replay(Game base) async {
    Game game = await Provider.of<ApiService>(context).gamesReplay(base);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameModel.view(game),
      ),
    );
  }

  void follow(User user) async {
    await Provider.of<ApiService>(context).usersFollow(user.username);
    await Provider.of<ApiService>(context).loadUser();
  }

  void unfollow(User user) async {
    await Provider.of<ApiService>(context).usersUnfollow(user.username);
    await Provider.of<ApiService>(context).loadUser();
  }
}
