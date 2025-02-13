import 'package:dhbw_swe_mastermind_frontend/interfaces/game_color.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/mode.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/game/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/round.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/help/help.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/color_indicator.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/connection_status.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/round_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Mastermind'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () => Provider.of<GameBloc>(context).showGameConfig(),
            ),
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () => Navigator.of(context).pushNamed(HelpModel.route),
            ),
          ],
        ),
        body: ConnectionStatus(
          enabled: Provider.of<GameBloc>(context).game.config.mode ==
              Mode.online_computer,
          child: Stack(
            children: <Widget>[
              _buildRoundCounter(),
              Column(
                children: <Widget>[
                  _buildHistory(context),
                  _ColorSelector(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Consumer<GameBloc> _buildRoundCounter() {
    return Consumer<GameBloc>(
      builder: (context, bloc, child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '${bloc.game.rounds.length}/${bloc.game.config.maxRounds}',
        ),
      ),
    );
  }

  Expanded _buildHistory(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (BuildContext context, GameBloc bloc, Widget child) =>
            ListView.builder(
          padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: bloc.game.rounds.length + 1,
          itemBuilder: (context, i) => Center(
            child: SingleChildScrollView(
              child: i == 0
                  ? _buildActiveColumn(context)
                  : _buildRound(bloc.game.rounds.elementAt(i - 1)),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildActiveColumn(BuildContext context) {
    GameBloc bloc = Provider.of<GameBloc>(context);

    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white24
          : Colors.black26,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < bloc.selectedColors.length; i++)
            GestureDetector(
              onTap: () => bloc.toggleSelection(i),
              child: ColorIndicator(
                color: bloc.selectedColors[i].color,
                border: true,
                size: 44.0,
              ),
            ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: bloc.game.finished || !bloc.validateGameColors()
                ? null
                : bloc.makeGuess,
          )
        ],
      ),
    );
  }

  Center _buildRound(Round round) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...round.guess.map(
            (gameColor) => ColorIndicator(
              color: gameColor.color,
              border: true,
              size: 44.0,
            ),
          ),
          UIHelper.verticalSpaceSmall,
          RoundStatus(rating: round.rating),
        ],
      ),
    );
  }
}

class _ColorSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      height: 52.0,
      child: Consumer(
        builder: (BuildContext context, GameBloc bloc, Widget child) => Row(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bloc.game.config.gameColors.length,
                itemBuilder: (context, index) {
                  GameColor gameColor = bloc.game.config.gameColors[index];

                  return GestureDetector(
                    onTap: () => bloc.activeColor = gameColor,
                    child: ColorIndicator(
                      color: gameColor.color,
                      border: bloc.activeColor == gameColor,
                      size: 44.0,
                    ),
                  );
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.undo),
              onPressed: bloc.game.rounds.isEmpty || bloc.game.finished
                  ? null
                  : bloc.undo,
            ),
          ],
        ),
      ),
    );
  }
}
