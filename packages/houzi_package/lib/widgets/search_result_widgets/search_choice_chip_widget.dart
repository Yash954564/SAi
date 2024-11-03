import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/custom_widgets/choice_chip_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class SearchResultsChoiceChipsWidget extends StatelessWidget {
  final String label;
  final IconData? iconData;
  final Widget? avatar;
  final void Function(bool) onSelected;

  const SearchResultsChoiceChipsWidget({
    Key? key,
    required this.label,
    required this.onSelected,
    this.iconData,
    this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChoiceChipWidget(
        avatar: iconData != null ? Icon(iconData, color: AppThemePreferences().appTheme.iconsColor) : avatar,
        labelPadding: const EdgeInsets.all(0),
        label: Padding(
          padding: label.isEmpty ? EdgeInsets.symmetric(vertical: 8) : EdgeInsets.all(8),//8
          child:
          GenericTextWidget(
            label,
            // GenericMethods.getLocalizedString(label),
            style: AppThemePreferences().appTheme.filterPageChoiceChipTextStyle,
          ),
        ),
        selected: false,
        onSelected: onSelected,
        backgroundColor: AppThemePreferences().appTheme.searchPageChoiceChipsBackgroundColor,
        shape: AppThemePreferences.roundedCorners(
          AppThemePreferences.searchPageChoiceChipsRoundedCornersRadius,
          // side: BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
