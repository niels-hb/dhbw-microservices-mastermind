import 'package:dhbw_swe_mastermind_frontend/interfaces/rating.dart';
import 'package:dhbw_swe_mastermind_frontend/services/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoundStatus extends StatelessWidget {
  final Rating rating;

  final double size = 10.0;
  final double padding = 2.0;

  RoundStatus({
    @required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    SettingsService settingsService = Provider.of<SettingsService>(context);

    int exactMatch = rating.exactMatch;
    int partMatch = rating.partMatch;

    List<Widget> pins = [];

    for (int i = 0; i < rating.sum; i++) {
      Color color;

      if (exactMatch > 0) {
        exactMatch--;
        color = settingsService.exactMatchPinColor;
      } else if (partMatch > 0) {
        partMatch--;
        color = settingsService.partMatchPinColor;
      }

      pins.add(_buildPin(context, color, settingsService.pinShape));
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: (size + padding * 2) * (rating.sum / 2).ceil(),
      ),
      child: Wrap(
        direction: Axis.vertical,
        children: pins,
      ),
    );
  }

  Widget _buildPin(BuildContext context, Color color, BoxShape shape) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: shape,
          color: color,
          border: Border.all(color: Theme.of(context).iconTheme.color),
        ),
      ),
    );
  }
}
