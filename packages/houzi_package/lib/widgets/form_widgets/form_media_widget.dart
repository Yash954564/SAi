import 'package:flutter/material.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/pages/add_property_pages/property_media.dart';

typedef GenericFormMediaWidgetListener = Function(Map<String, dynamic> dataMap);

class GenericFormMediaWidget extends StatelessWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? propertyInfoMap;
  final bool isPropertyForUpdate;
  final GenericFormMediaWidgetListener listener;

  const GenericFormMediaWidget({
    Key? key,
    required this.formItem,
    this.formItemPadding,
    this.propertyInfoMap,
    this.isPropertyForUpdate = false,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AddPropertyMediaWidget(
      padding: formItemPadding,
      propertyInfoMap: propertyInfoMap,
      isPropertyForUpdate: isPropertyForUpdate,
      performValidation: formItem.performValidation,
      listener: listener,
    );
  }
}
