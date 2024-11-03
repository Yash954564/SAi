import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class AppInfoWidget extends StatelessWidget {
  final String appName;
  final String appVersion;

  const AppInfoWidget({
    Key? key,
    required this.appName,
    required this.appVersion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppInfoTextWidget(text: appName), //padding: const EdgeInsets.only(top: 5.0),
          if(appVersion.isNotEmpty)
            AppInfoTextWidget(
              padding: const EdgeInsets.only(top: 5.0),
              text: "${UtilityMethods.getLocalizedString("version_text")} $appVersion",
            ),
        ],
      ),
    );
  }
}

class AppInfoTextWidget extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry padding;

  const AppInfoTextWidget({
    Key? key,
    required this.text,
    this.padding = const EdgeInsets.all(0.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GenericTextWidget(
        text,
        textAlign: TextAlign.center,
        style: AppThemePreferences().appTheme.appInfoTextStyle,
      ),
    );
  }
}

