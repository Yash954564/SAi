import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

Widget textHeadingWidget({
  required String text,
  Widget? widget,
  EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(20, 10, 20, 10),
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: PropertyDetailPageHeaderWidget(
          text: text,
          padding: padding,
          textStyle: AppThemePreferences().appTheme.headingTextStyle!,
          // padding: const EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 5.0),
        ),
      ),
      widget ?? Container(),
    ],
  );
}

Widget getRowWidget({
  required String text,
  required Function() onTap,
}) {
  return Container(
    decoration: AppThemePreferences.dividerDecoration(bottom: true,),
    child: InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PropertyDetailPageHeaderWidget(
            text: text,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            textStyle: AppThemePreferences().appTheme.body01TextStyle!,
            // padding: const EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 5.0),
          ),
          PropertyDetailPageHeaderWidget(
            text: ">",
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            textStyle: AppThemePreferences().appTheme.body01TextStyle!,
            // padding: const EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 5.0),
          ),
        ],
      ),
    ),
  );
}

showToastWhileDataLoading(BuildContext context, String msg, bool forLogin) {
  !forLogin
      ? ShowToastWidget(
    buildContext: context,
    text: msg,
  )
      : ShowToastWidget(
    buildContext: context,
    showButton: true,
    buttonText: UtilityMethods.getLocalizedString("login"),
    text: msg,
    toastDuration: 4,
    onButtonPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserSignIn(
                (String closeOption) {
              if (closeOption == CLOSE) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      );
    },
  );
}