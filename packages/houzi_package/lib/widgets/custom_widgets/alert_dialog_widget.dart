import 'package:flutter/material.dart';

const EdgeInsets _defaultInsetPadding = EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0);

class AlertDialogWidget extends StatelessWidget {
  final Widget? icon;
  final EdgeInsetsGeometry? iconPadding;
  final Color? iconColor;
  final Widget? title;
  final EdgeInsetsGeometry? titlePadding;
  final TextStyle? titleTextStyle;
  final Widget? content;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? contentTextStyle;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? actionsPadding;
  final MainAxisAlignment? actionsAlignment;
  final OverflowBarAlignment? actionsOverflowAlignment;
  final VerticalDirection? actionsOverflowDirection;
  final double? actionsOverflowButtonSpacing;
  final EdgeInsetsGeometry? buttonPadding;
  final Color? backgroundColor;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final String? semanticLabel;
  final EdgeInsets insetPadding;
  final Clip clipBehavior;
  final ShapeBorder? shape;
  final AlignmentGeometry? alignment;
  final bool scrollable;


  const AlertDialogWidget({
    super.key,
    this.icon,
    this.iconPadding,
    this.iconColor,
    this.title,
    this.titlePadding,
    this.titleTextStyle,
    this.content,
    this.contentPadding,
    this.contentTextStyle,
    this.actions,
    this.actionsPadding,
    this.actionsAlignment,
    this.actionsOverflowAlignment,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor = Colors.transparent,
    this.semanticLabel,
    this.insetPadding = _defaultInsetPadding,
    this.clipBehavior = Clip.none,
    this.shape,
    this.alignment,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: surfaceTintColor,
      clipBehavior: clipBehavior,
      shape: shape,
      elevation: elevation,
      shadowColor: shadowColor,
      icon: icon,
      backgroundColor: backgroundColor,
      title: title,
      alignment: alignment,
      content: content,
      iconPadding: iconPadding,
      insetPadding: insetPadding,
      actions: actions,
      actionsAlignment: actionsAlignment,
      actionsOverflowAlignment: actionsOverflowAlignment,
      actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
      actionsOverflowDirection: actionsOverflowDirection,
      actionsPadding: actionsPadding,
      buttonPadding: buttonPadding,
      contentPadding: contentPadding,
      contentTextStyle: contentTextStyle,
      iconColor: iconColor,
      scrollable: scrollable,
      semanticLabel: semanticLabel,
      titlePadding: titlePadding,
      titleTextStyle: titleTextStyle,
    );
  }
}
