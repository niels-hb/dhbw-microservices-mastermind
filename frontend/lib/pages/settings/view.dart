import 'package:dhbw_swe_mastermind_frontend/pages/settings/color_picker.dart';
import 'package:dhbw_swe_mastermind_frontend/services/settings.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/color_indicator.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingsService settingsService = Provider.of<SettingsService>(context);

    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Einstellungen'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => ConfirmationDialog.show(
                context: context,
                title: 'Einstellungen löschen?',
                onAccept: () => Provider.of<SettingsService>(context).reset(),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(32.0),
          children: <Widget>[
            Text(
              'Passe das Spielerlebnis ganz individuell an deine Vorlieben an.',
            ),
            Text(
              '(Achte darauf, dass alle Elemente für dich gut sichtbar sind.)',
              style: Theme.of(context).textTheme.caption,
            ),
            UIHelper.verticalSpaceLarge,
            _buildHeader(
              context: context,
              title: 'Global',
            ),
            UIHelper.verticalSpaceSmall,
            _buildColorListTile(
              context: context,
              title: 'Primärfarbe',
              pickerColor: settingsService.primaryColor,
              onChanged: (color) => settingsService.primaryColor = color,
            ),
            _buildColorListTile(
              context: context,
              title: 'Sekundärfarbe',
              pickerColor: settingsService.secondaryColor,
              onChanged: (color) => settingsService.secondaryColor = color,
            ),
            UIHelper.verticalSpaceLarge,
            _buildHeader(
              context: context,
              title: 'Spielfeld',
            ),
            UIHelper.verticalSpaceSmall,
            _buildColorListTile(
              context: context,
              title: 'Stelle korrekt',
              pickerColor: settingsService.exactMatchPinColor,
              onChanged: (color) => settingsService.exactMatchPinColor = color,
              shape: Provider.of<SettingsService>(context).pinShape,
            ),
            _buildColorListTile(
              context: context,
              title: 'Stelle fast korrekt',
              pickerColor: settingsService.partMatchPinColor,
              onChanged: (color) => settingsService.partMatchPinColor = color,
              shape: Provider.of<SettingsService>(context).pinShape,
            ),
            _buildSwitchListTile(
              title: 'Farbfelder',
              selectedShape: settingsService.colorIndicatorShape,
              onChanged: (value) => settingsService.colorIndicatorShape = value,
            ),
            _buildSwitchListTile(
              title: 'Stellenindikatoren',
              selectedShape: settingsService.pinShape,
              onChanged: (value) => settingsService.pinShape = value,
            ),
          ],
        ),
      ),
    );
  }

  Text _buildHeader({BuildContext context, String title}) => Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      );

  GestureDetector _buildColorListTile({
    BuildContext context,
    String title,
    Color pickerColor,
    void Function(Color) onChanged,
    BoxShape shape,
  }) =>
      GestureDetector(
        onTap: () async {
          Color result = await showDialog(
            context: context,
            builder: (_) => AppColorPicker(
              pickerColor: pickerColor,
            ),
          );

          if (result != null) {
            onChanged(result);
          }
        },
        child: Row(
          children: <Widget>[
            ColorIndicator(
              color: pickerColor,
              size: 30.0,
              padding: EdgeInsets.symmetric(vertical: 4.0),
              shape: shape,
            ),
            UIHelper.horizontalSpaceDefault,
            Text(title),
          ],
        ),
      );

  Row _buildSwitchListTile({
    String title,
    BoxShape selectedShape,
    void Function(BoxShape) onChanged,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: <Widget>[
              Text('eckig'),
              Switch(
                onChanged: (value) => onChanged(
                  value ? BoxShape.circle : BoxShape.rectangle,
                ),
                value: selectedShape.index == 0 ? false : true,
              ),
              Text('rund'),
            ],
          ),
        ],
      );
}
