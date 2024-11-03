import 'package:flutter/material.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/models/radio_item.dart';
import 'package:houzi_package/widgets/radio_button_widget.dart';

typedef GenericFormRadioButtonWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericFormRadioButtonWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericFormRadioButtonWidgetListener listener;

  const GenericFormRadioButtonWidget({
    Key? key,
    required this.formItem,
    this.infoDataMap,
    this.formItemPadding,
    required this.listener,
  }) : super(key: key);

  @override
  State<GenericFormRadioButtonWidget> createState() => _GenericFormRadioButtonWidgetState();
}

class _GenericFormRadioButtonWidgetState extends State<GenericFormRadioButtonWidget> {

  String? apiKey;
  Map<String, dynamic>? infoDataMap;
  Map<String, dynamic>? listenerDataMap;

  dynamic _selectedValue;
  List<RadioItem> _optionsList = [];

  @override
  void initState() {
    apiKey = widget.formItem.apiKey;
    infoDataMap = widget.infoDataMap;
    _optionsList = getOptionsList(widget.formItem.fieldValues);

    if (infoDataMap != null && apiKey != null && apiKey!.isNotEmpty) {
      if (infoDataMap!.containsKey(apiKey)) {
        _selectedValue = infoDataMap![apiKey];
      }
    }

    if (_optionsList.isNotEmpty && _selectedValue == null) {
      _selectedValue ??= _optionsList[0].value;
    }

    super.initState();
  }

  @override
  void dispose() {
    apiKey = null;
    infoDataMap = null;
    listenerDataMap = null;
    _selectedValue = null;
    _optionsList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_optionsList.isNotEmpty) {
      return RadioButtonWidget(
        // padding: widget.formItemPadding,
        label: widget.formItem.title!,
        selectedValue: _selectedValue,
        itemsList: _optionsList,
        listener: (value) {
          _selectedValue = value;
          updateValue(_selectedValue);
        },
      );
    }

    return Container();
  }

  updateValue(String? text) {
    if (apiKey != null && apiKey!.isNotEmpty) {
      listenerDataMap = { apiKey! : text };
      widget.listener(listenerDataMap!);
    }
  }

  List<RadioItem> getOptionsList(FieldValues fieldValues) {
    Map<String, dynamic>? fieldsMap = fieldValues.fieldValuesMap;
    if (fieldsMap != null && fieldsMap.isNotEmpty) {
      List<RadioItem> radioItemsList = [];
      radioItemsList = fieldsMap.entries.map((mapItem) =>
          RadioItem(label: mapItem.key, value: mapItem.value)).toList();
      return radioItemsList;
    }

    return [];
  }
}
