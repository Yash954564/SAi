import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/dynamic_item.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/widgets/add_property_widgets/additional_details_widget.dart';

typedef GenericFormAdditionalDetailsFieldWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericFormAdditionalDetailsFieldWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericFormAdditionalDetailsFieldWidgetListener listener;

  const GenericFormAdditionalDetailsFieldWidget({
    Key? key,
    required this.formItem,
    this.infoDataMap,
    this.formItemPadding,
    required this.listener,
  }) : super(key: key);

  @override
  State<GenericFormAdditionalDetailsFieldWidget> createState() => _GenericFormAdditionalDetailsFieldWidgetState();
}

class _GenericFormAdditionalDetailsFieldWidgetState extends State<GenericFormAdditionalDetailsFieldWidget> {

  String? apiKey;
  List<DynamicItem> dataItemsList = [];
  Map<String, dynamic>? infoDataMap;
  Map<String, dynamic>? listenerDataMap;

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
        }
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    apiKey = null;
    infoDataMap = null;
    listenerDataMap = null;
    dataItemsList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GenericAdditionalDetailsWidget(
      itemsList: dataItemsList,
      buttonPadding: widget.formItemPadding,
      listener: (updatedItemsList) {
        List<Map<String, dynamic>> dataHolderList = [];
        for (DynamicItem item in updatedItemsList) {
          dataHolderList.add(item.dataMap!);
        }

        listenerDataMap = {apiKey! : dataHolderList};
        widget.listener(listenerDataMap!);
      },
    );
  }
}
