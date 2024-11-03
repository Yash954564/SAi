import 'package:flutter/material.dart';
import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';

typedef GenericTextFormFieldWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericFormTextFieldWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericTextFormFieldWidgetListener listener;

  const GenericFormTextFieldWidget({
    Key? key,
    required this.formItem,
    this.infoDataMap,
    this.formItemPadding,
    required this.listener,
  }) : super(key: key);

  @override
  State<GenericFormTextFieldWidget> createState() => _GenericFormTextFieldWidgetState();
}

class _GenericFormTextFieldWidgetState extends State<GenericFormTextFieldWidget> with ValidationMixin {

  String? apiKey;
  Map<String, dynamic>? infoDataMap;
  Map<String, dynamic>? listenerDataMap;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    apiKey = widget.formItem.apiKey;
    infoDataMap = widget.infoDataMap;
    
    if (infoDataMap != null && apiKey != null && apiKey!.isNotEmpty) {
      if (infoDataMap!.containsKey(apiKey)) {
        controller.text = infoDataMap![apiKey] ?? "";
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    apiKey = null;
    infoDataMap = null;
    listenerDataMap = null;
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      labelText: widget.formItem.title,
      hintText: widget.formItem.hint,
      additionalHintText: widget.formItem.additionalHint,
      padding: widget.formItemPadding,
      controller: controller,
      keyboardType: widget.formItem.keyboardType ?? TextInputType.text,
      maxLines: widget.formItem.maxLines,
      onSaved: (text)=> updateValue(text),
      onChanged: (text)=> updateValue(text),
      isCompulsory: widget.formItem.performValidation,
      validator: (text) {
        updateValue(text);
        if(widget.formItem.performValidation) {
          return validationFunc(text, widget.formItem.validationType);
        }
        return null;
      },
    );
  }

  updateValue(String? text) {
    if (apiKey != null && apiKey!.isNotEmpty) {
      listenerDataMap = { apiKey! : text };
      widget.listener(listenerDataMap!);
    }
  }
  
  String? validationFunc(String? text, String? type) {
    if (type == stringValidation) {
      return validateTextField(text);
    } else if (type == emailValidation) {
      return validateEmail(text);
    } else if (type == passwordValidation) {
      return validatePassword(text);
    } else if (type == phoneNumberValidation) {
      return validatePhoneNumber(text);
    } else if (type == userNameValidation) {
      return validateUserName(text);
    }

    return null;
  }
}