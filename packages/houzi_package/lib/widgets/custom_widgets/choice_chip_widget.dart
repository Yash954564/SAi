import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';

class ChoiceChipWidget extends StatelessWidget {
  final Widget? avatar;
  final Widget label;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final void Function(bool)? onSelected;
  final double? pressElevation;
  final bool selected;
  final Color? selectedColor;
  final Color? disabledColor;
  final String? tooltip;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;
  final MaterialStateProperty<Color?>? color;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final IconThemeData? iconTheme;
  final Color? selectedShadowColor;
  final bool? showCheckmark;
  final Color? checkmarkColor;
  final ShapeBorder avatarBorder;

  const ChoiceChipWidget({
    super.key,
    this.avatar,
    required this.label,
    this.labelStyle,
    this.labelPadding,
    this.onSelected,
    this.pressElevation,
    required this.selected,
    this.selectedColor,
    this.disabledColor,
    this.tooltip,
    this.side = const BorderSide(color: Colors.transparent),
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.color,
    this.backgroundColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor = Colors.transparent,
    this.iconTheme,
    this.selectedShadowColor,
    this.showCheckmark = false,
    this.checkmarkColor,
    this.avatarBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: label,
      selected: selected,
      avatarBorder: avatarBorder,
      surfaceTintColor: surfaceTintColor,
      backgroundColor: backgroundColor ?? AppThemePreferences().appTheme.choiceChipsBgColor,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      shadowColor: shadowColor,
      elevation: elevation,
      shape: shape,
      color: color,
      padding: padding,
      avatar: avatar,
      checkmarkColor: checkmarkColor,
      disabledColor: disabledColor,
      iconTheme: iconTheme,
      labelPadding: labelPadding,
      labelStyle: labelStyle,
      materialTapTargetSize: materialTapTargetSize,
      onSelected: onSelected,
      pressElevation: pressElevation,
      selectedColor: selectedColor,
      selectedShadowColor: selectedShadowColor,
      showCheckmark: showCheckmark,
      side: side,
      tooltip: tooltip,
      visualDensity: visualDensity,
    );
  }
}
