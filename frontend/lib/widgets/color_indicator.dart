import 'package:dhbw_swe_mastermind_frontend/services/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorIndicator extends StatelessWidget {
  final double size;
  final EdgeInsets padding;
  final Color color;
  final bool border;
  final Widget child;
  final VoidCallback onTap;
  final BoxShape shape;

  ColorIndicator({
    this.size = 50.0,
    this.padding = const EdgeInsets.all(4.0),
    this.color = Colors.transparent,
    this.border = false,
    this.child,
    this.onTap,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: shape ??
                Provider.of<SettingsService>(context).colorIndicatorShape,
            color: color,
            border: border
                ? Border.all(
                    color: Theme.of(context).iconTheme.color,
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
