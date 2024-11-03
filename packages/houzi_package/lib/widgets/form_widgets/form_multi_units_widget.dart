import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/dynamic_item.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/widgets/add_property_widgets/multi_units_widgets/multi_units_widget.dart';

typedef GenericFormFloorPlansFieldWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericFormMultiUnitsFieldWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericFormFloorPlansFieldWidgetListener listener;

  const GenericFormMultiUnitsFieldWidget({
    Key? key,
    required this.formItem,
    this.infoDataMap,
    this.formItemPadding,
    required this.listener,
  }) : super(key: key);

  @override
  State<GenericFormMultiUnitsFieldWidget> createState() => _GenericFormMultiUnitsFieldWidgetState();
}

class _GenericFormMultiUnitsFieldWidgetState extends State<GenericFormMultiUnitsFieldWidget> {

  String? apiKey;
  List<DynamicItem> dataItemsList = [];
  Map<String, dynamic>? infoDataMap;
  Map<String, dynamic> listenerDataMap = {};

  @override
  void initState() {
    apiKey = widget.formItem.apiKey;
    infoDataMap = widget.infoDataMap;

    if (infoDataMap != null && apiKey != null && apiKey!.isNotEmpty) {
      if (infoDataMap!.containsKey(apiKey)) {
        List<Map<String, dynamic>>? list = infoDataMap![apiKey];
        if (list != null && list.isNotEmpty) {
          for (int i = 0; i < list.length; i++) {
            var item = list[i];

            dataItemsList.add(
              DynamicItem(
                key: "Key$i",
                dataMap: item,
              ),
            );
          }
        } else {
          initializeDataItemsList();
        }
      }
    } else {
      initializeDataItemsList();
    }

    super.initState();
  }

  @override
  void dispose() {
    apiKey = null;
    infoDataMap = null;
    listenerDataMap = {};
    dataItemsList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GenericMultiUnitsWidget(
      itemsList: dataItemsList,
      buttonPadding: widget.formItemPadding,
      listener: (updatedItemsList) {
        List<Map<String, dynamic>> dataHolderList = [];
        for (DynamicItem item in updatedItemsList) {
          dataHolderList.add(item.dataMap!);
        }

        if (dataHolderList.isEmpty) {
          listenerDataMap[ADD_PROPERTY_MULTI_UNITS] = "0";
        } else {
          listenerDataMap[ADD_PROPERTY_MULTI_UNITS] = "1";
        }

        listenerDataMap[apiKey!] = dataHolderList;
        widget.listener(listenerDataMap);
      },
    );
  }

  initializeDataItemsList(){
    dataItemsList.add(DynamicItem(
      key: "Key0",
      dataMap: {
        faveMUTitle: "",
        faveMUPrice: "",
        faveMUPricePostfix: "",
        faveMUBeds: "",
        faveMUBaths: "",
        faveMUSize: "",
        faveMUSizePostfix: "",
        faveMUType: "",
        faveMUAvailabilityDate: "",
      },
    ));
  }
}
