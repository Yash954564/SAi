import 'dart:io';

import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/user_sign_in_widgets/social_sign_on_buttons_widget.dart';

class SocialSignOnButtonsWidget extends StatelessWidget {
  final void Function() onFaceBookButtonPressed;
  final void Function() onGoogleButtonPressed;
  final void Function() onAppleButtonPressed;
  final void Function() onPhoneButtonPressed;
  final bool isiOSConditionsFulfilled;

  const SocialSignOnButtonsWidget({
    Key? key,
    required this.onFaceBookButtonPressed,
    required this.onGoogleButtonPressed,
    required this.onAppleButtonPressed,
    required this.onPhoneButtonPressed,
    required this.isiOSConditionsFulfilled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !SHOW_SOCIAL_LOGIN
        ? Container()
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Column(
              children: [
                SHOW_LOGIN_WITH_PHONE
                    ? PhoneSignOnButtonWidget(onPressed: onPhoneButtonPressed)
                    : Container(),

                isiOSConditionsFulfilled
                    ? AppleSignOnButtonWidget(onPressed: onAppleButtonPressed)
                    : Container(),

                if (SHOW_LOGIN_WITH_GOOGLE && SHOW_LOGIN_WITH_FACEBOOK)
                  Row(
                    children: [
                      Expanded(
                          flex: 9,
                          child: SHOW_LOGIN_WITH_GOOGLE
                              ? GoogleSignOnButtonWidget(
                                  shortButtonWidget: true,
                                  onPressed: onGoogleButtonPressed,
                                )
                              : Container(),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 9,
                        child: SHOW_LOGIN_WITH_FACEBOOK
                            ? FaceBookSignOnButtonWidget(
                                shortButtonWidget: true,
                                onPressed: onFaceBookButtonPressed,
                              )
                            : Container(),
                      ),
                    ],
                  )
                else if (SHOW_LOGIN_WITH_GOOGLE)
                  GoogleSignOnButtonWidget(onPressed: onGoogleButtonPressed)
                else if (SHOW_LOGIN_WITH_FACEBOOK)
                    FaceBookSignOnButtonWidget(onPressed: onFaceBookButtonPressed),
              ],
            ),
    );
  }
}

class FaceBookSignOnButtonWidget extends StatelessWidget {
  final bool shortButtonWidget;
  final void Function() onPressed;
  final EdgeInsetsGeometry padding;

  const FaceBookSignOnButtonWidget({
    Key? key,
    this.shortButtonWidget = false,
    required this.onPressed,
    this.padding = const EdgeInsets.only(top: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SocialSignOnButtonWidget(
      padding: padding,
      shortButtonWidget: shortButtonWidget,
      label: UtilityMethods.getLocalizedString("log_in_facebook"),
      style: AppThemePreferences().appTheme.facebookSignInButtonTextStyle!,
      iconImagePath: AppThemePreferences.facebookIconImagePath,
      bgColor: AppThemePreferences().appTheme.googleSignInButtonColor!,
      onPressed: onPressed,
    );
  }
}

class GoogleSignOnButtonWidget extends StatelessWidget {
  final bool shortButtonWidget;
  final void Function() onPressed;
  final EdgeInsetsGeometry padding;

  const GoogleSignOnButtonWidget({
    Key? key,
    this.shortButtonWidget = false,
    required this.onPressed,
    this.padding = const EdgeInsets.only(top: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SocialSignOnButtonWidget(
      padding: padding,
      shortButtonWidget: shortButtonWidget,
      label: UtilityMethods.getLocalizedString("log_in_google"),
      iconImagePath: AppThemePreferences.googleIconImagePath,
      bgColor: AppThemePreferences().appTheme.googleSignInButtonColor,
      style: AppThemePreferences().appTheme.googleSignInButtonTextStyle!,
      onPressed: onPressed,
    );
  }
}

class AppleSignOnButtonWidget extends StatelessWidget {
  final bool shortButtonWidget;
  final void Function() onPressed;
  final EdgeInsetsGeometry padding;

  const AppleSignOnButtonWidget({
    Key? key,
    this.shortButtonWidget = false,
    required this.onPressed,
    this.padding = const EdgeInsets.only(top: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SocialSignOnButtonWidget(
      padding: padding,
      shortButtonWidget: shortButtonWidget,
      label: UtilityMethods.getLocalizedString("log_in_apple"),
      iconImagePath: AppThemePreferences.appleLightIconImagePath,
      bgColor: AppThemePreferences().appTheme.googleSignInButtonColor!,
      style: AppThemePreferences().appTheme.googleSignInButtonTextStyle!,
      onPressed: onPressed,
    );
  }
}

class PhoneSignOnButtonWidget extends StatelessWidget {
  final bool shortButtonWidget;
  final void Function() onPressed;
  final EdgeInsetsGeometry padding;

  const PhoneSignOnButtonWidget({
    Key? key,
    this.shortButtonWidget = false,
    required this.onPressed,
    this.padding = const EdgeInsets.only(top: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SocialSignOnButtonWidget(
      padding: padding,
      shortButtonWidget: shortButtonWidget,
      label: UtilityMethods.getLocalizedString("log_in_phone"),
      iconImagePath: AppThemePreferences.phoneIconImagePath,
      bgColor: AppThemePreferences().appTheme.googleSignInButtonColor!,
      style: AppThemePreferences().appTheme.googleSignInButtonTextStyle!,
      onPressed: onPressed,
    );
  }
}
