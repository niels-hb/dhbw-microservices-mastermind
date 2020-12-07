import 'package:dhbw_swe_mastermind_frontend/interfaces/game_config.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/new_game_solution/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/button.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/color_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewGameSolutionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lösung eingeben'),
        ),
        body: _buildContent(context),
      ),
    );
  }

  ListView _buildContent(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(32.0),
      children: [
        Text(
          'Gib dein Handy einem/-r Freund/-in, damit er/sie die Lösung vorgeben kann.',
        ),
        UIHelper.verticalSpaceDefault,
        ..._buildSettings(context),
        UIHelper.verticalSpaceDefault,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildPossibleColors(context),
            _buildColors(),
          ],
        ),
        UIHelper.verticalSpaceDefault,
        _buildStartButton(),
      ],
    );
  }

  List<Widget> _buildSettings(BuildContext context) {
    GameConfig config = Provider.of<NewGameSolutionBloc>(context).config;

    return [
      Text(
        'Einstellungen:',
        style: Theme.of(context).textTheme.headline6,
      ),
      UIHelper.verticalSpaceSmall,
      Text(
        '- ${config.pins} Stellen',
      ),
      UIHelper.verticalSpaceSmall,
      Text(
        '- Doppelte Farben ${config.allowDuplicateColors ? 'erlaubt' : 'nicht erlaubt'}',
      ),
      UIHelper.verticalSpaceSmall,
      Text(
        '- Leere Felder ${config.allowEmptyFields ? 'erlaubt' : 'nicht erlaubt'}',
      ),
      UIHelper.verticalSpaceSmall,
      Text(
        '- ${config.gameColors.length} Farben',
      ),
    ];
  }

  Consumer _buildPossibleColors(BuildContext context) {
    return Consumer<NewGameSolutionBloc>(
      builder: (context, bloc, child) => Column(
        children: bloc.config.gameColors
            .map(
              (gameColor) => ColorIndicator(
                onTap: () => bloc.activeColor = gameColor,
                color: gameColor.color,
                border: bloc.activeColor == gameColor,
              ),
            )
            .toList(),
      ),
    );
  }

  Consumer _buildColors() {
    return Consumer<NewGameSolutionBloc>(
      builder: (context, bloc, child) => Column(
        children: <Widget>[
          for (int i = 0; i < bloc.config.pins; i++)
            ColorIndicator(
              onTap: () => bloc.toggleSelection(i),
              color: bloc.selectedColors[i].color,
              border: true,
            ),
        ],
      ),
    );
  }

  Consumer<NewGameSolutionBloc> _buildStartButton() {
    return Consumer<NewGameSolutionBloc>(
      builder: (context, bloc, child) => AppButton(
        color: Colors.red,
        borderColor: Colors.redAccent,
        icon: Icon(Icons.play_arrow),
        title: 'Starten',
        onPressed: () => bloc.setGameColors(context),
      ),
    );
  }
}
