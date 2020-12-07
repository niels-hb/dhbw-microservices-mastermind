import 'package:dhbw_swe_mastermind_frontend/interfaces/game_color.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_config.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/util/validators.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/scrollable_alert_dialog.dart';
import 'package:flutter/material.dart';

class ConfigFilterDialog extends StatefulWidget {
  final GameConfig _filter;

  ConfigFilterDialog(GameConfig filter)
      : _filter = filter ?? GameConfig(mode: null);

  @override
  _ConfigFilterDialogState createState() => _ConfigFilterDialogState();
}

class _ConfigFilterDialogState extends State<ConfigFilterDialog> {
  @override
  Widget build(BuildContext context) {
    return ScrollableAlertDialog(
      title: Text('Filter'),
      content: _buildContent(context),
      actions: _buildActions(context),
    );
  }

  ListView _buildContent(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        UIHelper.buildNumberTextField(
          label: 'Anzahl Stellen',
          initialValue: widget._filter.pins,
          onChanged: (int pins) => setState(() {
            widget._filter.pins = pins;
          }),
          validator: Validators.pins,
        ),
        UIHelper.verticalSpaceDefault,
        UIHelper.buildNumberTextField(
          label: 'Anzahl Versuche',
          initialValue: widget._filter.maxRounds,
          onChanged: (int maxRounds) => setState(() {
            widget._filter.maxRounds = maxRounds;
          }),
          validator: Validators.maxRounds,
        ),
        UIHelper.verticalSpaceDefault,
        UIHelper.buildNumberTextField(
          label: 'Anzahl Farben',
          initialValue: widget._filter.gameColors.length,
          onChanged: (int colorCount) => setState(() {
            widget._filter.gameColors = List.filled(
              colorCount ?? 0,
              GameColor.unselected,
            );
          }),
          validator: Validators.gameColorsCount,
        ),
        UIHelper.verticalSpaceDefault,
        CheckboxListTile(
          value: widget._filter.allowDuplicateColors,
          onChanged: (allowDuplicateColors) {
            setState(() {
              widget._filter.allowDuplicateColors = allowDuplicateColors;
            });
          },
          title: Text('Eine Farbe darf mehrfach verwendet werden.'),
        ),
        CheckboxListTile(
          value: widget._filter.allowEmptyFields,
          onChanged: (allowEmptyFields) {
            setState(() {
              widget._filter.allowEmptyFields = allowEmptyFields;
            });
          },
          title: Text('Felder dürfen leer gelassen werden.'),
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      IconButton(
        icon: Icon(Icons.check),
        onPressed: widget._filter.validate() == null
            ? () => Navigator.of(context).pop(widget._filter)
            : null,
      ),
    ];
  }
}
