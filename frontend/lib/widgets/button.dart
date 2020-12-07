import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final Icon icon;
  final String title;
  final Function onPressed;

  AppButton({
    @required this.color,
    this.icon,
    @required this.borderColor,
    @required this.title,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          border: Border.all(
            color: borderColor,
            width: 4.0,
          ),
          color: color,
        ),
        child: _buildContent(),
      ),
    );
  }

  Row _buildContent() {
    return Row(
      children: <Widget>[
        _buildIcon(),
        _buildTitle(),
      ],
    );
  }

  Center _buildTitle() {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: icon,
    );
  }
}
