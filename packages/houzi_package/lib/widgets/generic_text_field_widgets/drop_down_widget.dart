import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';

import 'package:houzi_package/widgets/generic_text_widget.dart';

class GenericStringDropDownWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String? value;
  final String? Function(String? val)? validator;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final List<DropdownMenuItem<String>>? items;
  final bool isExpanded;
  final EdgeInsetsGeometry padding;

  const GenericStringDropDownWidget({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.value,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.items,
    this.isExpanded = true,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(labelText.isNotEmpty)
            GenericTextWidget(
              labelText,
              style: AppThemePreferences().appTheme.labelTextStyle,
            ),
          Padding(
            padding: EdgeInsets.only(top: labelText.isNotEmpty ? 10 : 0),
            child: DropdownButtonFormField(
                dropdownColor: AppThemePreferences().appTheme.dropdownMenuBgColor,
                value: value,
                isExpanded: isExpanded,
                decoration: AppThemePreferences.formFieldDecoration(
                    hintText: hintText),
                validator: validator,
                items: items,
                onChanged: onChanged,
                onSaved: onSaved,
                icon: Icon(AppThemePreferences.dropDownArrowIcon)
            ),
          ),
        ],
      ),
    );
  }
}