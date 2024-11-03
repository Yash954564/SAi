import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

class MessageContentWidget extends StatelessWidget {
  final String message;
  final String time;
  final bool? isCurrentUser;


  const MessageContentWidget({
    super.key,
    required this.message,
    required this.time,
    this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: getLeftPadding(context),
        right: getRightPadding(context),
      ),
      child: GestureDetector(
        onLongPress: (){
          Clipboard.setData(ClipboardData(text: message));
          ShowToastWidget(
            buildContext: context,
            text: TEXT_COPIED_STRING,
          );
        },
        child: Row(
          mainAxisAlignment: isCurrentUser == true
              ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
                child: Row(
                  mainAxisAlignment: isCurrentUser == true
                      ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: isCurrentUser == true
                      ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                          color: getBgColor(),
                          borderRadius: BorderRadius.all(Radius.circular(
                            AppThemePreferences.messageContentRoundedCornersRadius
                          )),
                        ),
                        child: Column(
                          crossAxisAlignment: isCurrentUser == true
                              ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            GenericTextWidget(
                              message,
                              strutStyle: const StrutStyle(height: 1),
                              style: TextStyle(
                                fontSize: 15,
                                color: AppThemePreferences().appTheme.messagesTextColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 3),
                              child: GenericTextWidget(
                                time,
                                strutStyle: const StrutStyle(height: 1),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppThemePreferences().appTheme.messageTimeTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // CustomPaint(painter: Triangle(bgColor: bgColor!)),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Color? getBgColor() {
    if (isCurrentUser == true) {
      return AppThemePreferences.messageSenderBgColor;
    }
    return AppThemePreferences().appTheme.messageReceiverBgColor;
  }

  double getLeftPadding(BuildContext context) {
    double padding = 0;
    if (UtilityMethods.isRTL(context)) {
      if (isCurrentUser == true) {
        padding = 0;
      } else {
        padding = 50;
      }
    } else {
      if (isCurrentUser == true) {
        padding = 50;
      } else {
        padding = 0;
      }
    }

    return padding;
  }
  double getRightPadding(BuildContext context) {
    double padding = 0;
    if (UtilityMethods.isRTL(context)) {
      if (isCurrentUser == true) {
        padding = 50;
      } else {
        padding = 0;
      }
    } else {
      if (isCurrentUser == true) {
        padding = 0;
      } else {
        padding = 50;
      }
    }

    return padding;
  }
}

class Triangle extends CustomPainter {
  final Color bgColor;

  Triangle({required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
