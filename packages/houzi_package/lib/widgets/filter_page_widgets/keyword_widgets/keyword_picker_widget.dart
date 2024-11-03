import 'package:flutter/material.dart';
import 'package:houzi_package/models/filter_page_config.dart';
import 'package:houzi_package/widgets/filter_page_widgets/keyword_widgets/keyword_input_field_widget.dart';


typedef  KeywordPickerWidgetListener = void Function(String keywordString);

class KeywordPickerWidget extends StatelessWidget {
  final String pickerTitle;
  final String pickerType;
  final Icon pickerIcon;
  final String? hintText;
  final TextEditingController textEditingController;
  final FilterPageElement filterObj;
  final KeywordPickerWidgetListener listener;
  final Map<String, dynamic>? dataMap;

  const KeywordPickerWidget({
    Key? key,
    required this.filterObj,
    required this.pickerTitle,
    required this.pickerType,
    required this.pickerIcon,
    this.hintText,
    required this.textEditingController,
    this.dataMap,
    required this.listener,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeywordPickerInputField(
      pickerTitle: pickerTitle,
      pickerIcon: pickerIcon,
      controller: textEditingController,
      hintText: hintText,
      listener: (keywordString) => listener(keywordString),
    );
  }
}