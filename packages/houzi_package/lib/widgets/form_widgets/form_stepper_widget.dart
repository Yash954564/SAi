import 'package:flutter/material.dart';
import 'package:houzi_package/mixins/validation_mixins.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/generic_add_room_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';


typedef GenericStepperFormFieldWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericFormStepperFieldWidget extends StatefulWidget{

  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericStepperFormFieldWidgetListener listener;

  const GenericFormStepperFieldWidget({
    Key? key,
    required this.formItem,
    this.formItemPadding,
    this.infoDataMap,
    required this.listener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => GenericFormStepperFieldWidgetState();

}

class GenericFormStepperFieldWidgetState extends State<GenericFormStepperFieldWidget> with ValidationMixin {

  int numberIntValue = 0;
  String? apiKey;
  Map<String, dynamic>? infoDataMap;
  Map<String, dynamic>? listenerDataMap;
  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    apiKey = widget.formItem.apiKey;
    infoDataMap = widget.infoDataMap;

    if (infoDataMap != null && apiKey != null && apiKey!.isNotEmpty) {
      if (infoDataMap!.containsKey(apiKey)) {
        numberIntValue = int.tryParse(infoDataMap![apiKey]) ?? 0;
        numberController.text = infoDataMap![apiKey] ?? numberIntValue.toString();
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    if(mounted) {
      apiKey = null;
      infoDataMap = null;
      listenerDataMap = null;
      numberController.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GenericStepperWidget(
          padding: widget.formItemPadding,
          labelTextPadding: EdgeInsets.zero,
          givenWidth: 230,
          ignoreHeight: true,
          textAlign: TextAlign.center,
          labelText: widget.formItem.title,
          controller: numberController,
          onRemovePressed: () => subtractFromNumValue(),
          onAddPressed: () => addToNumValue(),
          isCompulsory: widget.formItem.performValidation,
          validator: (String? text) {
            if(widget.formItem.performValidation) {
              return validateTextField(text);
            }
            return null;
          },
          onChanged: (value) {
            if (mounted) {
              setState(() {
                numberIntValue = int.parse(value);
                numberController.text = numberIntValue.toString();
                updateDataMap(numberController.text);
              });
            }
          },
        ),
        if (widget.formItem.additionalHint != null &&
            widget.formItem.additionalHint!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: AdditionalHintWidget(widget.formItem.additionalHint!),
          ),
      ],
    );
  }

  void addToNumValue(){
    if (numberIntValue >= 0) {
      if (mounted) {
        setState(() {
          numberIntValue += 1;
          numberController.text = numberIntValue.toString();
          updateDataMap(numberController.text);
        });
      }
    }
  }

  void subtractFromNumValue(){
    if (numberIntValue > 0) {
      if (mounted) {
        setState(() {
          numberIntValue -= 1;
          numberController.text = numberIntValue.toString();
          updateDataMap(numberController.text);
        });
      }
    }
  }
  
  void updateDataMap(String value) {
    if (apiKey != null && apiKey!.isNotEmpty) {
      listenerDataMap = { apiKey! : value };
      widget.listener(listenerDataMap!);
    }
  }
}