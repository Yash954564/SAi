import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class LightButtonWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Icon? icon;
  final Color? color;
  final Function() onPressed;
  final double? fontSize;
  final double? buttonHeight;
  final double? buttonWidth;
  final bool iconOnRightSide;
  final bool centeredContent;
  final ButtonStyle? buttonStyle;

  const LightButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.icon,
    this.color,
    this.fontSize = 14.0,
    this.buttonHeight = 50.0,
    this.buttonWidth = double.infinity,
    this.iconOnRightSide = false,
    this.centeredContent = false,
    this.buttonStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconOnRightSide ? Container() : showIconWithMargin(icon),
            centeredContent ? content(icon, text, fontSize!, iconOnRightSide, textColor) :
            Expanded(child: content(icon, text, fontSize!, iconOnRightSide, textColor)),
            iconOnRightSide ? showIcon(icon) : Container(),
          ],
        ),

        style: buttonStyle ?? ElevatedButton.styleFrom(
          elevation: 0.0, backgroundColor: color ?? AppThemePreferences().appTheme.selectedItemBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          // primary: color != null ? color : AppThemePreferences().current.primaryColor,
        ),
      ),
    );
  }
  Widget showIconWithMargin(Icon? icon){
    if(icon == null){
      return Container();
    }
    return Container(margin: const EdgeInsets.only(left: 5), child: showIcon(icon));
  }
  Widget showIcon(Icon? icon){
    if(icon == null){
      return Container();
    }
    return icon;
  }

  Widget content(Icon? icon, String text, double fontSize, bool rightIcon, Color? textColor){
    return Padding(
      padding: icon == null ? const EdgeInsets.only(left: 0.0) : rightIcon ? const EdgeInsets.only(right: 10.0) :
      const EdgeInsets.only(left: 10.0),
      child: GenericTextWidget(
        text,
        textAlign: TextAlign.center,
        softWrap: false,
        style:
        TextStyle(
          color: textColor ?? AppThemePreferences().appTheme.selectedItemTextColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}