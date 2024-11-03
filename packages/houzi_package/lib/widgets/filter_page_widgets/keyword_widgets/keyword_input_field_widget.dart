import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef KeywordPickerInputFieldListener = void Function(String keywordString);

class KeywordPickerInputField extends StatelessWidget {
  final String pickerTitle;
  final Icon pickerIcon;
  final String? hintText;
  final TextEditingController controller;
  final KeywordPickerInputFieldListener listener;

  const KeywordPickerInputField({
    Key? key,
    required this.pickerTitle,
    required this.pickerIcon,
    required this.controller,
    this.hintText,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Wrap(
          children:[
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: pickerIcon,
                    ),
                    Expanded(
                      flex: 8,
                      child: GenericTextWidget(
                        pickerTitle,
                        style: AppThemePreferences().appTheme.filterPageHeadingTitleTextStyle,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                  child: textFormFieldWidget(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget textFormFieldWidget(){
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        enabled: true,
        readOnly: false,
        controller: controller,
        decoration: AppThemePreferences.formFieldDecoration(
            hintText: hintText
                ?? UtilityMethods.getLocalizedString("please_enter_keyword")),
        onChanged: (keywordString) => listener(keywordString),
      ),
    );
  }
}