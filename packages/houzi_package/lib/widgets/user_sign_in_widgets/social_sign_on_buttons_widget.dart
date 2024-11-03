import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class SocialSignOnButtonWidget extends StatelessWidget {
  final bool shortButtonWidget;
  final String label;
  final String iconImagePath;
  final void Function() onPressed;
  final double width;
  final double height;
  final Color? bgColor;
  final TextStyle style;
  final double? iconImageWidth;
  final double? iconImageHeight;
  final EdgeInsetsGeometry padding;

  const SocialSignOnButtonWidget({
    Key? key,
    this.shortButtonWidget = false,
    required this.label,
    required this.iconImagePath,
    required this.onPressed,
    required this.style,
    this.height = 50.0,
    this.width = double.infinity,
    this.bgColor,
    this.iconImageWidth = 30.0,
    this.iconImageHeight = 30.0,
    this.padding = const EdgeInsets.only(top: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(shortButtonWidget) return ShortSocialLoginButtonWidget(
      padding: padding,
      iconImagePath: iconImagePath,
      onPressed: onPressed,
      width: width,
      height: height,
      bgColor: bgColor,
      iconImageWidth: iconImageWidth,
      iconImageHeight: iconImageHeight,
    );

    return LongSocialLoginButtonWidget(
      padding: padding,
      label: label,
      iconImagePath: iconImagePath,
      onPressed: onPressed,
      style: style,
      width: width,
      height: height,
      bgColor: bgColor,
    );
  }
}


class LongSocialLoginButtonWidget extends StatelessWidget {
  final String label;
  final String iconImagePath;
  final void Function() onPressed;
  final double width;
  final double height;
  final Color? bgColor;
  final TextStyle style;
  final EdgeInsetsGeometry padding;

  const LongSocialLoginButtonWidget({
    Key? key,
    required this.label,
    required this.iconImagePath,
    required this.onPressed,
    required this.style,
    this.height = 50.0,
    this.width = double.infinity,
    this.bgColor,
    this.padding = const EdgeInsets.only(top: 0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
        // child: OutlinedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(iconImagePath, width: 30.0, height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: GenericTextWidget(
                  label,
                  style: style,
                ),
              ),
            ],
          ),

          style: ElevatedButton.styleFrom(
            side: BorderSide(color: Colors.grey[300]!),
            elevation: 1.0,
            backgroundColor: bgColor ?? AppThemePreferences().appTheme.primaryColor,
            surfaceTintColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5),
              ),
            ),
            // primary: bgColor != null ? bgColor : AppThemePreferences().appTheme.cardColor,
          ),
        ),
      ),
    );
  }
}

class ShortSocialLoginButtonWidget extends StatelessWidget {
  final String iconImagePath;
  final void Function() onPressed;
  final double width;
  final double height;
  final Color? bgColor;
  final double? iconImageWidth;
  final double? iconImageHeight;
  final EdgeInsetsGeometry padding;

  const ShortSocialLoginButtonWidget({
    Key? key,
    required this.iconImagePath,
    required this.onPressed,
    this.height = 50.0,
    this.width = double.infinity,
    this.bgColor,
    this.iconImageWidth = 30.0,
    this.iconImageHeight = 30.0,
    this.padding = const EdgeInsets.only(top: 0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconImagePath, width: iconImageWidth, height: iconImageHeight),
            ],
          ),

          style: ElevatedButton.styleFrom(
            side: BorderSide(color: Colors.grey[300]!),
            surfaceTintColor: Colors.transparent,
            elevation: 1.0,
            backgroundColor: bgColor ?? AppThemePreferences().appTheme.primaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
      ),
    );
  }
}