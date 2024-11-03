import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef GenericFormPricePlaceholderWidgetListener = Function(Map<String, dynamic> dataMap);

class GenericFormPricePlaceholderWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericFormPricePlaceholderWidgetListener listener;

  const GenericFormPricePlaceholderWidget({
    super.key,
    required this.formItem,
    this.infoDataMap,
    this.formItemPadding,
    required this.listener,
  });

  @override
  State<GenericFormPricePlaceholderWidget> createState() => _GenericFormPricePlaceholderWidgetState();
}

class _GenericFormPricePlaceholderWidgetState extends State<GenericFormPricePlaceholderWidget> {

  bool enablePricePlaceHolder = false;
  Map<String, dynamic> dataMap = {};
  final TextEditingController _pricePlaceHolderTextController = TextEditingController();

  @override
  void initState() {
    Map? tempMap = widget.infoDataMap;

    if (tempMap != null) {
      if (tempMap.containsKey(ADD_PROPERTY_PRICE_PLACEHOLDER) &&
          tempMap[ADD_PROPERTY_PRICE_PLACEHOLDER] != null &&
          tempMap[ADD_PROPERTY_PRICE_PLACEHOLDER] is String) {
        _pricePlaceHolderTextController.text = tempMap[ADD_PROPERTY_PRICE_PLACEHOLDER];
      }

      if (tempMap.containsKey(ADD_PROPERTY_SHOW_PRICE_PLACEHOLDER) &&
          tempMap[ADD_PROPERTY_SHOW_PRICE_PLACEHOLDER] != null &&
          tempMap[ADD_PROPERTY_SHOW_PRICE_PLACEHOLDER] is String) {
        String enable = tempMap[ADD_PROPERTY_SHOW_PRICE_PLACEHOLDER];
        if (enable == 'on') {
          enablePricePlaceHolder = true;
        } else {
          enablePricePlaceHolder = false;
        }
      }
    } else {
      enablePricePlaceHolder = false;
      _pricePlaceHolderTextController.text = "";
    }
    super.initState();
  }

  @override
  void dispose() {
    dataMap = {};
    _pricePlaceHolderTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EnablePriceHolderCheckbox(
          value: enablePricePlaceHolder,
          listener: (value) {
            if (mounted) {
              setState(() {
                enablePricePlaceHolder = !enablePricePlaceHolder;
              });
            }
            if (enablePricePlaceHolder) {
              dataMap[ADD_PROPERTY_SHOW_PRICE_PLACEHOLDER] = 'on';
            } else {
              dataMap[ADD_PROPERTY_SHOW_PRICE_PLACEHOLDER] = '0';
            }

            widget.listener(dataMap);
          },
        ),
        if (enablePricePlaceHolder) PricePlaceholderTextField(
          controller: _pricePlaceHolderTextController,
          listener: (val) {
            dataMap[ADD_PROPERTY_PRICE_PLACEHOLDER]  = val;
            widget.listener(dataMap);
          },
        ),
      ],
    );
  }
}

typedef PricePlaceholderTextFieldListener = void Function(String? val);
class PricePlaceholderTextField extends StatelessWidget {
  final TextEditingController controller;
  final PricePlaceholderTextFieldListener listener;

  const PricePlaceholderTextField({
    super.key,
    required this.controller,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("Price Placeholder"),
        hintText: UtilityMethods.getLocalizedString("Price on Request"),
        controller: controller,
        validator: (String? value) {
          if (value != null) {
            listener(value);
          }
          return null;
        },
        onChanged: (value) => listener(value),
      ),
    );
  }
}

typedef EnablePriceHolderCheckboxListener = void Function(bool? value);
class EnablePriceHolderCheckbox extends StatelessWidget {
  final bool value;
  final EnablePriceHolderCheckboxListener listener;

  const EnablePriceHolderCheckbox({
    super.key,
    required this.value,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: GenericTextWidget(
          UtilityMethods.getLocalizedString("Enable Price Placeholder"),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        activeColor: Theme.of(context).primaryColor,
        value: value,
        onChanged: (bool? value) => listener(value),
      ),
    );
  }
}


