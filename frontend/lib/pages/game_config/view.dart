import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:flutter/material.dart';

class GameConfigView extends StatelessWidget {
  final Game game;

  GameConfigView(this.game);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Einstellungen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '- ${game.config.pins} Stellen',
          ),
          UIHelper.verticalSpaceSmall,
          Text(
            '- Doppelte Farben ${game.config.allowDuplicateColors ? 'erlaubt' : 'nicht erlaubt'}',
          ),
          UIHelper.verticalSpaceSmall,
          Text(
            '- Leere Felder ${game.config.allowEmptyFields ? 'erlaubt' : 'nicht erlaubt'}',
          ),
          UIHelper.verticalSpaceSmall,
          Text(
            '- ${game.config.gameColors.length} Farben',
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
