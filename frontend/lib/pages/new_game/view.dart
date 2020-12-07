import 'package:dhbw_swe_mastermind_frontend/interfaces/mode.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/new_game/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_color.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:dhbw_swe_mastermind_frontend/util/extensions.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/util/validators.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/button.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/color_indicator.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/connection_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewGameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Neues Spiel'),
        ),
        body: ConnectionStatus(
          enabled:
              Provider.of<NewGameBloc>(context).mode == Mode.online_computer,
          child: Consumer<NewGameBloc>(
            builder: (context, bloc, child) {
              if (bloc.state == BlocStateSelector.waiting) {
                return child;
              } else if (bloc.state == BlocStateSelector.created) {
                return _buildInputFields(context);
              } else {
                return Center(
                  child: Text('Es ist ein Fehler aufgetreten!'),
                );
              }
            },
            child: UIHelper.centeredProgressIndicator,
          ),
        ),
      ),
    );
  }

  ListView _buildInputFields(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(32.0),
      children: <Widget>[
        Consumer<NewGameBloc>(
          builder: (context, bloc, child) => UIHelper.buildNumberTextField(
            label: 'Anzahl Stellen',
            initialValue: bloc.pins,
            onChanged: (int pins) => bloc.pins = pins,
            validator: Validators.pins,
          ),
        ),
        UIHelper.verticalSpaceDefault,
        Consumer<NewGameBloc>(
          builder: (context, bloc, child) => UIHelper.buildNumberTextField(
            label: 'Anzahl Versuche',
            initialValue: bloc.maxRounds,
            onChanged: (int maxRounds) => bloc.maxRounds = maxRounds,
            validator: Validators.maxRounds,
          ),
        ),
        UIHelper.verticalSpaceDefault,
        _buildColorSelectors(context),
        UIHelper.verticalSpaceDefault,
        Consumer<NewGameBloc>(
          builder: (BuildContext context, NewGameBloc bloc, Widget child) =>
              CheckboxListTile(
            value: bloc.allowDuplicateColors,
            onChanged: (allowDuplicateColors) {
              bloc.allowDuplicateColors = allowDuplicateColors;
            },
            title: Text('Eine Farbe darf mehrfach verwendet werden.'),
          ),
        ),
        Consumer<NewGameBloc>(
          builder: (BuildContext context, NewGameBloc bloc, Widget child) =>
              CheckboxListTile(
            value: bloc.allowEmptyFields,
            onChanged: (allowEmptyFields) {
              bloc.allowEmptyFields = allowEmptyFields;
            },
            title: Text('Felder dürfen leer gelassen werden.'),
          ),
        ),
        UIHelper.verticalSpaceDefault,
        Builder(
          builder: (context) => AppButton(
            color: Colors.red,
            borderColor: Colors.redAccent,
            icon: Icon(Icons.play_arrow),
            title: 'Starten',
            onPressed: () =>
                Provider.of<NewGameBloc>(context).startGame(context),
          ),
        ),
      ],
    );
  }

  Container _buildColorSelectors(BuildContext context) {
    return Container(
      height: 58.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: GameColor.availableColors.length,
        itemBuilder: (context, index) => _ColorSelector(
          gameColor: GameColor.availableColors[index],
        ),
      ),
    );
  }
}

class _ColorSelector extends StatelessWidget {
  final GameColor gameColor;

  _ColorSelector({
    this.gameColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, NewGameBloc bloc, Widget child) =>
          ColorIndicator(
        onTap: () => bloc.toggleGameColor(gameColor),
        color: gameColor.color,
        child: bloc.isGameColorChecked(gameColor)
            ? Icon(
                Icons.check,
                color: gameColor.color.brightness() == Brightness.light
                    ? Colors.black
                    : Colors.white,
              )
            : null,
      ),
    );
  }
}
