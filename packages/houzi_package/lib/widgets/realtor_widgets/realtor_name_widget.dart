import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class RealtorNameWidget extends StatelessWidget {
  final String title;
  final String tag;

  const RealtorNameWidget({
    required this.title,
    required this.tag,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: tag == AGENTS_TAG ? const EdgeInsets.only(top: 10) : const EdgeInsets.only(top: 15),
      child: GenericTextWidget(
        title,
        textAlign: TextAlign.left,
        maxLines: 1,
        strutStyle: const StrutStyle(forceStrutHeight: true),
        overflow: TextOverflow.ellipsis,
        style: AppThemePreferences().appTheme.homeScreenRealtorTitleTextStyle,
      ),
    );
  }
}
