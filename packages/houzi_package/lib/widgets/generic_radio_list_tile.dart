import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class GenericRadioListTile extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final Widget? subtitleWidget;
  final dynamic value;
  final dynamic groupValue;
  final void Function(dynamic) onChanged;
  final ListTileControlAffinity controlAffinity;
  final EdgeInsetsGeometry contentPadding;

  const GenericRadioListTile({
    Key? key,
    this.title,
    this.subtitle,
    this.titleWidget,
    this.subtitleWidget,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.controlAffinity = ListTileControlAffinity.trailing,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      controlAffinity: controlAffinity,
      contentPadding: contentPadding,
      value: value,
      groupValue: groupValue,
      activeColor: AppThemePreferences().appTheme.primaryColor,
      onChanged: onChanged,
      title: getTextWidget(title, titleWidget),
      subtitle: getTextWidget(subtitle, subtitleWidget),
    );
  }

  Widget? getTextWidget(String? text, Widget? textWidget){
    if(text != null && text.isNotEmpty){
      return GenericTextWidget(
          text,
          strutStyle: StrutStyle(
            height: AppThemePreferences.genericTextHeight,
          ));
    }else if(textWidget != null){
      return textWidget;
    }

    return null;
  }
}