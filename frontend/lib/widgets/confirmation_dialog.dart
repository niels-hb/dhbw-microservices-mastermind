import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;

  final String description;

  final VoidCallback onAccept;

  ConfirmationDialog({
    @required this.title,
    this.description,
    @required this.onAccept,
  });

  static void show({
    @required BuildContext context,
    @required String title,
    String description,
    @required VoidCallback onAccept,
  }) =>
      showDialog(
        context: context,
        builder: (_) => ConfirmationDialog(
          title: title,
          description: description,
          onAccept: onAccept,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: description != null ? Text(description) : null,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            Navigator.of(context).pop();

            onAccept();
          },
        ),
      ],
    );
  }
}
