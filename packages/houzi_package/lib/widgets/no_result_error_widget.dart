import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class NoResultErrorWidget extends StatelessWidget {
  final String? headerErrorText;
  final String? bodyErrorText;
  final String? buttonText;
  final bool showBackNavigationIcon;
  final bool hideGoBackButton;
  final void Function()? onPressed;
  final void Function()? onButtonPressed;
  final Color? backgroundColor;
  final bool hideErrorIcon;

  const NoResultErrorWidget({
    Key? key,
    this.headerErrorText,
    this.bodyErrorText,
    this.buttonText,
    this.showBackNavigationIcon = false,
    this.hideGoBackButton = false,
    this.onPressed,
    this.onButtonPressed,
    this.backgroundColor,
    this.hideErrorIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            color: backgroundColor ?? AppThemePreferences().appTheme.backgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!hideErrorIcon) Icon(
                    AppThemePreferences.errorIcon,
                    size: AppThemePreferences.genericErrorWidgetIconSize,
                    color: AppThemePreferences().appTheme.selectedItemBackgroundColor,
                  ),
                  if (headerErrorText != null && headerErrorText!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: GenericTextWidget(
                        headerErrorText!,
                        strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
                        style: AppThemePreferences().appTheme.label02TextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if(bodyErrorText != null && bodyErrorText!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      child: GenericTextWidget(
                        bodyErrorText!,
                        strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
                        style: AppThemePreferences().appTheme.bodyTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  hideGoBackButton
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                          child: ButtonWidget(
                            text: buttonText != null && buttonText!.isNotEmpty
                                ? buttonText!
                                : UtilityMethods.getLocalizedString("go_back"),
                            onPressed: onButtonPressed ?? onPressed ?? () => onBackPressed(context),
                          ),
                        ),
                ],
              ),
            ),
          ),
          showBackNavigationIcon
              ? Positioned(
                  top: MediaQuery.of(context).padding.top,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: CircleAvatar(
                      backgroundColor: AppThemePreferences()
                          .appTheme
                          .propertyDetailsPageTopBarIconsBackgroundColor,
                      child: IconButton(
                        icon: Icon(AppThemePreferences.arrowBackIcon),
                        color: AppThemePreferences()
                            .appTheme
                            .propertyDetailsPageTopBarIconsColor,
                        onPressed: onPressed ?? () => onBackPressed(context),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}

