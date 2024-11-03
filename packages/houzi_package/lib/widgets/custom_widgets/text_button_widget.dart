import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';

class TextButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final MaterialStatesController? statesController;
  final bool? isSemanticButton;
  final Widget child;

  const TextButtonWidget({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.statesController,
    this.isSemanticButton,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      clipBehavior: clipBehavior,
      onHover: onHover,
      autofocus: autofocus,
      focusNode: focusNode,
      isSemanticButton: isSemanticButton,
      onFocusChange: onFocusChange,
      onLongPress: onLongPress,
      statesController: statesController,
      style: style ?? TextButton.styleFrom(
        foregroundColor: AppThemePreferences().appTheme.primaryColor,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
