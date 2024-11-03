import 'package:flutter/material.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/widgets/add_property_widgets/multi_units_widgets/multi_units_listings_ids_widget.dart';

typedef GenericFormMultiUnitsIdsFieldWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericFormMultiUnitsIdsFieldWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericFormMultiUnitsIdsFieldWidgetListener listener;

  const GenericFormMultiUnitsIdsFieldWidget({
    Key? key,
    required this.formItem,
    this.infoDataMap,
    this.formItemPadding,
    required this.listener,
  }) : super(key: key);

  @override
  State<GenericFormMultiUnitsIdsFieldWidget> createState() => _GenericFormMultiUnitsIdsFieldWidgetState();
}

class _GenericFormMultiUnitsIdsFieldWidgetState extends State<GenericFormMultiUnitsIdsFieldWidget> {


  String? apiKey;
  String selectedIDsString = "";
  Map<String, dynamic>? infoDataMap;
  Map<String, dynamic> listenerDataMap = {};

  @override
  void initState() {
    apiKey = widget.formItem.apiKey;
    infoDataMap = widget.infoDataMap;

    if (infoDataMap != null && apiKey != null && apiKey!.isNotEmpty) {
      if (infoDataMap!.containsKey(apiKey)) {
        selectedIDsString = infoDataMap![apiKey];
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    apiKey = null;
    infoDataMap = null;
    listenerDataMap = {};
    selectedIDsString = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiUnitsListingsIdsWidget(
      selectedListingsIDs: selectedIDsString,
      listener: (selectedIDs) {
        listenerDataMap[apiKey!] = selectedIDs;
        widget.listener(listenerDataMap);
      },
    );
  }
}
