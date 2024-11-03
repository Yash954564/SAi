import 'package:flutter/material.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/widgets/add_property_widgets/contact_info_widget.dart';

typedef GenericRealtorContactInformationWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericRealtorContactInformationWidget extends StatelessWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericRealtorContactInformationWidgetListener listener;

  const GenericRealtorContactInformationWidget({
    Key? key,
    required this.formItem,
    this.infoDataMap,
    this.formItemPadding,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContactInformationWidget(
      propertyInfoMap: infoDataMap,
      padding: formItemPadding,
      listener: ({showWaitingWidget, updatedDataMap}) {
        if(updatedDataMap != null) {
          listener(updatedDataMap);
        }
      },
    );
  }
}
