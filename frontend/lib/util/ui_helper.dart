import 'package:flutter/material.dart';

class UIHelper {
  static BoxDecoration scaffoldBackground(BuildContext context) =>
      BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).accentColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );

  static final SizedBox verticalSpaceSmall = SizedBox(
    height: 8.0,
  );
  static final SizedBox verticalSpaceDefault = SizedBox(
    height: 16.0,
  );
  static final SizedBox verticalSpaceLarge = SizedBox(
    height: 32.0,
  );

  static final SizedBox horizontalSpaceSmall = SizedBox(
    width: 8.0,
  );
  static final SizedBox horizontalSpaceDefault = SizedBox(
    width: 16.0,
  );
  static final SizedBox horizontalSpaceLarge = SizedBox(
    width: 32.0,
  );

  static final Center centeredProgressIndicator = Center(
    child: CircularProgressIndicator(),
  );

  static TextFormField buildNumberTextField({
    @required String label,
    @required int initialValue,
    @required void Function(int) onChanged,
    @required String Function(String) validator,
  }) =>
      _buildTextField(
        label: label,
        keyboardType: TextInputType.number,
        initialValue: initialValue.toString(),
        onChanged: (String valueString) {
          onChanged(int.tryParse(valueString));
        },
        validator: validator,
      );

  static TextFormField buildTextField({
    @required String label,
    String initialValue,
    @required void Function(String) onChanged,
    @required String Function(String) validator,
    TextInputType keyboardType,
  }) =>
      _buildTextField(
        label: label,
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
      );

  static TextFormField _buildTextField({
    @required String label,
    @required String initialValue,
    @required void Function(String) onChanged,
    @required String Function(String) validator,
    TextInputType keyboardType,
  }) =>
      TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
        autovalidate: true,
        obscureText: keyboardType == TextInputType.visiblePassword,
      );
}
