import 'package:flutter/material.dart';
import 'package:houzi_package/widgets/custom_widgets/alert_dialog_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'generic_text_widget.dart';

Future ShowDialogBoxWidget(
  BuildContext context, {
  required String title,
  TextStyle? style,
  Widget? content,
  List<Widget>? actions,
  EdgeInsetsGeometry actionsPadding = const EdgeInsets.all(0.0),
  double elevation = 5.0,
  TextAlign textAlign = TextAlign.start,
  bool barrierDismissible = true,
}){
  return showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialogWidget(
          title: GenericTextWidget(
            title,
            textAlign: textAlign,
            style: style,
          ),
          content: content,
          actionsPadding: actionsPadding,
          elevation: elevation,
          actions: actions,
        );
      });
}

Future showDeleteDialogBoxWidget({
  required BuildContext context,
  String? dialogTitle,
  String? dialogContent,
  String? negativeButtonTitle,
  String? positiveButtonTitle,
  Widget? negativeButtonWidget,
  Widget? positiveButtonWidget,
  bool barrierDismissible = true,
  void Function()? onNegativeButtonPressed,
  void Function()? onPositiveButtonPressed,
}) {
  return ShowDialogBoxWidget(
    context,
    title: dialogTitle ?? "delete",
    barrierDismissible: barrierDismissible,
    content: GenericTextWidget(dialogContent ?? "delete_confirmation"),
    actions: <Widget>[
      negativeButtonWidget ?? TextButtonWidget(
        onPressed: () {
          if (onNegativeButtonPressed != null) {
            onNegativeButtonPressed();
          } else {
            Navigator.pop(context);
          }
        },
        child: GenericTextWidget(negativeButtonTitle ?? "cancel"),
      ),
      positiveButtonWidget ?? TextButtonWidget(
        onPressed: () {
          if (onPositiveButtonPressed != null) {
            onPositiveButtonPressed();
          } else {
            Navigator.pop(context);
          }
        },
        child: GenericTextWidget(positiveButtonTitle ?? "yes"),
      ),
    ],
  );
}

Future showWaitingDialogBoxWidget({
  required BuildContext context,
  bool barrierDismissible = true,
  double? width,
  double? height,
}) {
  return showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialogWidget(
          backgroundColor: Colors.transparent,
          content: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: width ?? 100,
              height: height ?? 100,
              child: const BallRotatingLoadingWidget(),
            ),
          ),
        );
      });
}