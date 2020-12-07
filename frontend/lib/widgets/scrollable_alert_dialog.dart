import 'package:flutter/material.dart';

class ScrollableAlertDialog extends StatelessWidget {
  const ScrollableAlertDialog({
    Key key,
    this.title,
    this.titlePadding,
    this.titleTextStyle,
    this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.contentTextStyle,
    this.actions,
    this.actionsPadding = EdgeInsets.zero,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.backgroundColor,
    this.elevation,
    this.semanticLabel,
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: 40.0,
      vertical: 24.0,
    ),
    this.clipBehavior = Clip.none,
    this.shape,
  })  : assert(contentPadding != null),
        assert(clipBehavior != null),
        super(key: key);

  final Widget title;

  final EdgeInsetsGeometry titlePadding;

  final TextStyle titleTextStyle;

  final Widget content;

  final EdgeInsetsGeometry contentPadding;

  final TextStyle contentTextStyle;

  final List<Widget> actions;

  final EdgeInsetsGeometry actionsPadding;

  final VerticalDirection actionsOverflowDirection;

  final double actionsOverflowButtonSpacing;

  final EdgeInsetsGeometry buttonPadding;

  final Color backgroundColor;

  final double elevation;

  final String semanticLabel;

  final EdgeInsets insetPadding;

  final Clip clipBehavior;

  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);
    final DialogTheme dialogTheme = DialogTheme.of(context);

    String label = semanticLabel;
    if (title == null) {
      switch (theme.platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          label = semanticLabel;
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          label = semanticLabel ??
              MaterialLocalizations.of(context)?.alertDialogLabel;
      }
    }

    Widget titleWidget;
    Widget contentWidget;
    Widget actionsWidget;
    if (title != null)
      titleWidget = Padding(
        padding: titlePadding ??
            EdgeInsets.fromLTRB(24.0, 24.0, 24.0, content == null ? 20.0 : 0.0),
        child: DefaultTextStyle(
          style: titleTextStyle ??
              dialogTheme.titleTextStyle ??
              theme.textTheme.headline6,
          child: Semantics(
            child: title,
            namesRoute: true,
            container: true,
          ),
        ),
      );

    if (content != null)
      contentWidget = Padding(
        padding: contentPadding,
        child: DefaultTextStyle(
          style: contentTextStyle ??
              dialogTheme.contentTextStyle ??
              theme.textTheme.subtitle1,
          child: content,
        ),
      );

    if (actions != null)
      actionsWidget = Padding(
        padding: actionsPadding,
        child: ButtonBar(
          buttonPadding: buttonPadding,
          overflowDirection: actionsOverflowDirection,
          overflowButtonSpacing: actionsOverflowButtonSpacing,
          children: actions,
        ),
      );

    List<Widget> columnChildren = <Widget>[
      if (title != null) titleWidget,
      if (content != null) Flexible(child: contentWidget),
      if (actions != null) actionsWidget,
    ];

    Widget dialogChild = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );

    if (label != null)
      dialogChild = Semantics(
        namesRoute: true,
        label: label,
        child: dialogChild,
      );

    return Dialog(
      backgroundColor: backgroundColor,
      elevation: elevation,
      insetPadding: insetPadding,
      clipBehavior: clipBehavior,
      shape: shape,
      child: dialogChild,
    );
  }
}
