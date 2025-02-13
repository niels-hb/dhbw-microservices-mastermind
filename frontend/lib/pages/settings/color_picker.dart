import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AppColorPicker extends StatefulWidget {
  final Color pickerColor;

  AppColorPicker({
    @required this.pickerColor,
  });

  @override
  _AppColorPickerState createState() => _AppColorPickerState();
}

class _AppColorPickerState extends State<AppColorPicker> {
  Color _selectedColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Farbe wählen'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: widget.pickerColor,
          onColorChanged: (Color color) => _selectedColor = color,
          enableAlpha: false,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () => Navigator.of(context).pop(_selectedColor),
        ),
      ],
    );
  }
}
