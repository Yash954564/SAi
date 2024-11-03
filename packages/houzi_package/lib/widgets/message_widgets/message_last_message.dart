import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';


class LastMessageWidget extends StatelessWidget {
  final String author;
  final String message;
  final bool showAllMessage;

  const LastMessageWidget({
    super.key,
    required this.author,
    required this.message,
    required this.showAllMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: GenericTextWidget(
        "$author: $message",
        maxLines: showAllMessage ? null : 3,
        overflow: showAllMessage ? null : TextOverflow.ellipsis,
        style: AppThemePreferences().appTheme.crmNormalTextStyle,
        strutStyle: const StrutStyle(height: 1),
      ),
    );
  }
}
