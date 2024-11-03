import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Widget? icon;
  final Color? color;
  final double? fontSize;
  final void Function() onPressed;
  final double? buttonHeight;
  final double buttonWidth;
  final bool? iconOnRightSide;
  final bool? centeredContent;
  final ButtonStyle? buttonStyle;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? iconPadding;
  final TextAlign? textAlign;
  final int? maxLines;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.icon,
    this.color,
    this.fontSize = 18.0,
    this.buttonHeight = 50.0,
    this.buttonWidth = double.infinity,
    this.iconOnRightSide = false,
    this.centeredContent = false,
    this.buttonStyle,
    this.mainAxisAlignment,
    this.padding,
    this.iconPadding,
    this.textAlign,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,

        child: Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: [

            if (!iconOnRightSide! && (icon != null)) icon!,
            centeredContent!
                ? ButtonContent(
                    icon: icon,
                    text: text,
                    fontSize: fontSize!,
                    rightIcon: iconOnRightSide!,
                    textColor: textColor,
                    textAlign: textAlign,
                    iconPadding: iconPadding,
                    maxLines: maxLines,
                  )
                : Flexible(
                    child: ButtonContent(
                    icon: icon,
                    text: text,
                    fontSize: fontSize!,
                    rightIcon: iconOnRightSide!,
                    textColor: textColor,
                    textAlign: textAlign,
                    iconPadding: iconPadding,
                    maxLines: maxLines,
                  )),
            if (iconOnRightSide! && (icon != null)) icon!,

          ],
        ),

        style: buttonStyle ?? ElevatedButton.styleFrom(
          padding: padding,
          surfaceTintColor: Colors.transparent,
          elevation: 0.0, backgroundColor: color ?? AppThemePreferences.actionButtonBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          // primary: color != null ? color : AppThemePreferences().current.primaryColor,
        ),
      ),
    );
  }
}

class ButtonContent extends StatelessWidget {
  final Widget? icon;
  final String text;
  final double? fontSize;
  final bool? rightIcon;
  final Color? textColor;
  final EdgeInsetsGeometry? iconPadding;
  final TextAlign? textAlign;
  final int? maxLines;

  const ButtonContent({
    Key? key,
    required this.text,
    this.icon,
    this.fontSize,
    this.rightIcon = false,
    this.textColor,
    this.iconPadding,
    this.textAlign,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: iconPadding ?? (icon == null
          ? const EdgeInsets.only(left: 0.0)
          : rightIcon!
          ? const EdgeInsets.only(right: 10.0)
          : const EdgeInsets.only(left: 10.0)),
      child: GenericTextWidget(
        text,
        maxLines: maxLines,
        textAlign: textAlign ?? TextAlign.center,
        style: TextStyle(
          color: textColor ?? AppThemePreferences.filledButtonTextColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}