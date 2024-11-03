import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

PopupMenuButton GenericPopupMenuButton({
  Key? key,
  required List<PopupMenuEntry<dynamic>> Function(BuildContext) itemBuilder,
  dynamic initialValue,
  void Function()? onOpened,
  void Function(dynamic)? onSelected,
  void Function()? onCanceled,
  String? tooltip,
  double? elevation,
  Color? shadowColor,
  Color? surfaceTintColor = Colors.transparent,
  EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
  Widget? child,
  double? splashRadius,
  Widget? icon,
  double? iconSize,
  Offset offset = Offset.zero,
  bool enabled = true,
  ShapeBorder? shape,
  Color? color,
  bool? enableFeedback,
  BoxConstraints? constraints,
  PopupMenuPosition? position,
  Clip clipBehavior = Clip.none,
}){
  return PopupMenuButton(
    itemBuilder: itemBuilder,
    initialValue: initialValue,
    onOpened: onOpened,
    onSelected: onSelected,
    onCanceled: onCanceled,
    tooltip: tooltip,
    elevation: elevation,
    shadowColor: shadowColor,
    surfaceTintColor: surfaceTintColor,
    padding: padding,
    child: child,
    splashRadius: splashRadius,
    icon: icon,
    iconSize: iconSize,
    offset: offset,
    enabled: enabled,
    shape: shape,
    color: color ?? AppThemePreferences().appTheme.popUpMenuBgColor,
    enableFeedback: enableFeedback,
    constraints: constraints,
    position: position,
    clipBehavior: clipBehavior,
  );
}

PopupMenuEntry GenericPopupMenuItem({
  required dynamic value,
  void Function()? onTap,
  bool enabled = true,
  double height = kMinInteractiveDimension,
  EdgeInsets? padding,
  TextStyle? textStyle,
  MaterialStateProperty<TextStyle?>? labelTextStyle,
  MouseCursor? mouseCursor,
  Widget? child,
  String? text,
  IconData? iconData,
}){
  return PopupMenuItem(
    value: value,
    child: child ?? ChildWidget(text: text, iconData: iconData),
    enabled: enabled,
    padding: padding,
    height: height,
    labelTextStyle:labelTextStyle ,
    mouseCursor: mouseCursor,
    onTap: onTap,
    textStyle: textStyle,
  );
}

class ChildWidget extends StatelessWidget {
  final String? text;
  final IconData? iconData;

  const ChildWidget({
    Key? key,
    this.text,
    this.iconData,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(text != null && text!.isNotEmpty) return Row(
      children: [
        if(iconData != null) Icon(
          iconData,
          color: AppThemePreferences().appTheme.iconsColor,
        ),
        if(iconData != null) SizedBox(width: 10),
        GenericTextWidget(text!),
      ],
    );

    return Container();
  }
}
