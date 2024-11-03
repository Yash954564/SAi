import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class HeaderWidget extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final Decoration? decoration;

  const HeaderWidget({
    Key? key,
    required this.text,
    this.padding = const EdgeInsets.all(0.0),
    this.alignment,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: alignment,
      decoration: decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: GenericTextWidget(
              UtilityMethods.getLocalizedString(text),
              strutStyle: const StrutStyle(height: 1.5),
              style: AppThemePreferences().appTheme.headingTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyDetailPageHeaderWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final Decoration? decoration;

  const PropertyDetailPageHeaderWidget({
    Key? key,
    required this.text,
    this.padding = const EdgeInsets.all(0.0),
    this.alignment,
    this.decoration,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: alignment,
      decoration: decoration,
      child: GenericTextWidget(
        text,
        strutStyle: StrutStyle(height: 1.5),
        style: textStyle ?? AppThemePreferences().appTheme.headingTextStyle,
      ),
    );
  }
}

class Home02HeaderWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final Decoration? decoration;

  const Home02HeaderWidget({
    Key? key,
    required this.text,
    this.padding = const EdgeInsets.all(0.0),
    this.alignment,
    this.decoration,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: alignment,
      decoration: decoration,
      child: GenericTextWidget(
        text,
        strutStyle: const StrutStyle(height: 1.5),
        style: textStyle ?? AppThemePreferences().appTheme.heading03TextStyle,
      ),
    );
  }
}