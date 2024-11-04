import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';

TextSpan GenericNormalTextSpanWidget({
  required String text,
  List<InlineSpan>? children,
  TextStyle? textStyle,
  Function()? onTap,
}){
  return TextSpan(
    text: text,
    style: textStyle ?? AppThemePreferences().appTheme.bodyTextStyle,
    recognizer: TapGestureRecognizer()..onTap = onTap,
  );
}

TextSpan GenericLinkTextSpanWidget({
  required String text,
  TextStyle? textStyle,
  Function()? onTap,
  List<InlineSpan>? children,
}){
  return TextSpan(
    text: text,
    style: textStyle ?? AppThemePreferences().appTheme.linkTextStyle,
    recognizer: TapGestureRecognizer()..onTap = onTap,
    children: children,
  );
}