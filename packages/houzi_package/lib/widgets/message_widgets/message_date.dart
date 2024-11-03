import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class MessageDateWidget extends StatelessWidget {
  final String date;

  const MessageDateWidget({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppThemePreferences().appTheme.messageTimeBgColor,
            borderRadius: BorderRadius.all(Radius.circular(
              AppThemePreferences.messageDateRoundedCornersRadius,
            )),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GenericTextWidget(
                date,
                strutStyle: const StrutStyle(height: 1.2),
                style: TextStyle(
                  fontSize: 12,
                  color: AppThemePreferences().appTheme.messageTimeTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}