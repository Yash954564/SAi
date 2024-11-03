import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';


void ShowToastWidget({
  required BuildContext buildContext,
  int toastDuration = 2, // in seconds
  required String text,
  bool showButton = false,
  String buttonText = 'Button',
  Function()? onButtonPressed,
  toastGravity = ToastGravity.BOTTOM,

}){
  FToast _fToast = FToast();

  _fToast.init(buildContext);
  _fToast.showToast(
    gravity: toastGravity,
    toastDuration: Duration(seconds: toastDuration),
    child: ToastWidget(
      text: text,
      showButton: showButton,
      buttonLabel: buttonText,
      onButtonPressed: onButtonPressed,
    ),
  );
}

class ToastWidget extends StatelessWidget {
  final String text;
  final bool? showButton;
  final String? buttonLabel;
  final Function()? onButtonPressed;

  const ToastWidget({
    Key? key,
    required this.text,
    this.showButton = false,
    this.buttonLabel = "Button",
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),//25
        color: AppThemePreferences.toastBackgroundColor,
      ),
      child: showButton! ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 2,
            child: GenericTextWidget(
              text,
              style: AppThemePreferences().appTheme.toastTextTextStyle,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                child: GenericTextWidget(buttonLabel!, style: AppThemePreferences().appTheme.toastTextTextStyle),
                onPressed: onButtonPressed ?? (){},
                style: ElevatedButton.styleFrom(
                  elevation: 0.0, backgroundColor: AppThemePreferences.toastButtonBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    side: BorderSide(width: 2, color: Colors.white.withOpacity(0.4)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ) : Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GenericTextWidget(
              text,
              style: AppThemePreferences().appTheme.toastTextTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
