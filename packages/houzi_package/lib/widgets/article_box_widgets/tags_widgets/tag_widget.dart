import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class TagWidget extends StatelessWidget {
  final String label;
  const TagWidget({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5,3,5,5),
      child: GenericTextWidget(
        UtilityMethods.getLocalizedString(label),
        strutStyle: const StrutStyle(forceStrutHeight: true),
        style: AppThemePreferences().appTheme.tagTextStyle,
      ),
      decoration: BoxDecoration(
        color: AppThemePreferences().appTheme.tagBackgroundColor,
        border: Border.all(color: AppThemePreferences().appTheme.tagBorderColor!),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
    );
  }
}
