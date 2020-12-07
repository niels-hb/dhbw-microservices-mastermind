import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/game_results/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/util/validators.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/color_indicator.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/scrollable_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

class GameResultsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableAlertDialog(
      title: Text(
        Provider.of<GameResultsBloc>(context).game.solved
            ? 'Gewonnen!'
            : 'Leider verloren!',
      ),
      content: ListView(
        shrinkWrap: true,
        children: <Widget>[
          _buildContent(context),
          UIHelper.verticalSpaceDefault,
          _buildSolutionOrTextField(context),
        ],
      ),
      actions: _buildActions(context),
    );
  }

  MarkdownBody _buildContent(BuildContext context) {
    Game game = Provider.of<GameResultsBloc>(context).game;

    return MarkdownBody(
      data: '''
### Einstellungen

* ${game.config.pins} Stellen
* Doppelte Farben ${game.config.allowDuplicateColors ? 'erlaubt' : 'nicht erlaubt'}
* Leere Felder ${game.config.allowEmptyFields ? 'erlaubt' : 'nicht erlaubt'}

### Statistiken

* **${game.rounds.length}** Runden gespielt
            ''',
    );
  }

  Widget _buildSolutionOrTextField(BuildContext context) {
    GameResultsBloc bloc = Provider.of<GameResultsBloc>(context);

    return bloc.isUsernameRequired()
        ? UIHelper.buildTextField(
            label: 'Dein Name',
            initialValue: bloc.game.username,
            onChanged: bloc.setUsername,
            validator: Validators.username,
          )
        : Container(
            height: 58.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: bloc.game.solution
                  .map(
                    (gameColor) => ColorIndicator(
                      color: gameColor.color,
                      border: true,
                    ),
                  )
                  .toList(),
            ),
          );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      Consumer<GameResultsBloc>(
        builder: (context, bloc, child) => FlatButton(
          child: Text('ZURÜCK'),
          onPressed: bloc.isUsernameSet() ? bloc.closeDialog : null,
        ),
      ),
      Consumer<GameResultsBloc>(
        builder: (context, bloc, child) => FlatButton(
          child: Text('MENÜ'),
          onPressed: bloc.isUsernameSet() ? bloc.closeToHome : null,
        ),
      ),
    ];
  }
}
