import 'package:flutter/material.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/models/form_related/houzi_form_page.dart';
import 'package:houzi_package/widgets/form_widgets/generic_form_widget.dart';

typedef AddPropertyFormWidgetListener = void Function(Map<String, dynamic> dataMap);

class AddPropertyFormWidget extends StatelessWidget {
  final bool isPropertyForUpdate;
  final Map<String, dynamic>? infoDataMap;
  final GlobalKey<FormState>? formStateKey;
  final List<HouziFormItem>? formItemsFieldsList;
  final List<HouziFormSectionFields> formSectionFieldsList;
  final AddPropertyFormWidgetListener listener;

  const AddPropertyFormWidget({
    this.infoDataMap,
    this.formStateKey,
    this.isPropertyForUpdate = false,
    required this.formSectionFieldsList,
    this.formItemsFieldsList,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return GenericFormWidget(
      infoDataMap: infoDataMap,
      formStateKey: formStateKey,
      isPropertyForUpdate: isPropertyForUpdate,
      formSectionFieldsList: formSectionFieldsList,
      formItemsFieldsList: formItemsFieldsList,
      listener: listener,
    );
  }
}
