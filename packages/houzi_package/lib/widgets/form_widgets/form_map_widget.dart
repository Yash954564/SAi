import 'package:flutter/material.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/pages/add_Property_Pages/property_address.dart';

typedef GenericFormMapLocationWidgetListener = Function(Map<String, dynamic> dataMap);

class GenericFormMapLocationWidget extends StatelessWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericFormMapLocationWidgetListener listener;

  const GenericFormMapLocationWidget({
    Key? key,
    required this.formItem,
    this.infoDataMap,
    this.formItemPadding,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LocationFromMapWidget(
      propertyInfoMap: infoDataMap,
      listener: ({currentPosition, dataInfoMap}) {
        if (dataInfoMap != null) {
          listener(dataInfoMap);
        }
      },
    );
  }
}
