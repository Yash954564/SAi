import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class MessagePropertyTitleWidget extends StatelessWidget {
  final String? propertyTitle;
  final EdgeInsetsGeometry? padding;

  const MessagePropertyTitleWidget({
    super.key,
    required this.propertyTitle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (propertyTitle != null && propertyTitle!.isNotEmpty) {
      return Container(
        padding: padding ?? const EdgeInsets.only(top: 15),
        child: GenericTextWidget(
          propertyTitle!,
          style: AppThemePreferences().appTheme.crmHeadingTextStyle,
        ),
      );
    }
    return Container();
  }
}