import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

import 'package:houzi_package/widgets/generic_text_widget.dart';

class GenericStepperWidget extends StatelessWidget {
  final String? labelText;
  final TextStyle? labelTextStyle;
  final void Function() onRemovePressed;
  final void Function() onAddPressed;
  final void Function(String) onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final EdgeInsetsGeometry? padding;
  final double? givenWidth;
  final double? givenHeight;
  final bool ignoreHeight;
  final TextAlign textAlign;
  final EdgeInsetsGeometry labelTextPadding;
  final bool isCompulsory;

  const GenericStepperWidget({
    Key? key,
    this.labelText,
    this.labelTextStyle,
    required this.onRemovePressed,
    required this.onAddPressed,
    required this.onChanged,
    this.onSaved,
    required this.validator,
    required this.controller,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 0),
    this.givenWidth,
    this.givenHeight = 50,
    this.ignoreHeight = false,
    this.textAlign = TextAlign.start,
    this.isCompulsory = false,
    this.labelTextPadding = const EdgeInsets.only(left: 35.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null && labelText!.isNotEmpty) Padding(
            padding: labelTextPadding,
            child: GenericTextWidget(
              "${UtilityMethods.getLocalizedString(labelText!)}${isCompulsory ? " *" : ""}",
              // UtilityMethods.getLocalizedString(labelText!),
              style: labelTextStyle ?? AppThemePreferences().appTheme.labelTextStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: AppThemePreferences.addPropertyDetailsIconButtonSize,
                  icon: Icon(
                    AppThemePreferences.removeCircleOutlinedIcon,
                  ),
                  onPressed: onRemovePressed,
                ),
                SizedBox(
                  width: givenWidth ?? 55,
                  height: ignoreHeight ? null : givenHeight,
                  child: TextFormField(
                    textAlign: textAlign,
                    decoration: AppThemePreferences.formFieldDecoration(),
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    onChanged: onChanged,
                    validator: validator,
                    onSaved: onSaved,
                  ),
                ),
                IconButton(
                  iconSize: AppThemePreferences.addPropertyDetailsIconButtonSize,
                  icon: Icon(
                    AppThemePreferences.addCircleOutlinedIcon,
                  ),
                  onPressed: onAddPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
