import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class NoInternetConnectionErrorWidget extends StatelessWidget {
  final void Function() onPressed;

  const NoInternetConnectionErrorWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(top: 50),
          color: AppThemePreferences().appTheme.backgroundColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  AppThemePreferences.noInternetIcon,
                  size: AppThemePreferences.genericErrorWidgetIconSize,
                  color: AppThemePreferences().appTheme.primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GenericTextWidget(
                    UtilityMethods.getLocalizedString("no_internet_connection_error_message_01"),
                    style: AppThemePreferences().appTheme.label02TextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
                  child: GenericTextWidget(
                    UtilityMethods.getLocalizedString("no_internet_connection_body_error_message"),
                    style: AppThemePreferences().appTheme.bodyTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                  child: ButtonWidget(
                    text: UtilityMethods.getLocalizedString("retry"),
                    onPressed: onPressed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}