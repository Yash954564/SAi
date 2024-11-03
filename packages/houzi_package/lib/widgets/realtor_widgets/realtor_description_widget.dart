import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class RealtorDescriptionWidget extends StatelessWidget {
  final String description;

  const RealtorDescriptionWidget({
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return description.isEmpty?  Container() : Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: GenericTextWidget(
        description.trim(),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppThemePreferences().appTheme.subBodyTextStyle,
        textAlign: TextAlign.justify,
      ),
    );
  }
}
