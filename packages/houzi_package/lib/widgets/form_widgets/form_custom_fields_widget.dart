import 'package:flutter/material.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/custom_fields.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/widgets/add_property_widgets/custom_fields_widgets.dart';

typedef GenericFormCustomFieldWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericFormCustomFieldWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericFormCustomFieldWidgetListener listener;
  final int? formItemIndex;
  
  const GenericFormCustomFieldWidget({
    Key? key,
    required this.formItem,
    this.infoDataMap,
    this.formItemPadding,
    required this.listener,
    this.formItemIndex,
  }) : super(key: key);

  @override
  State<GenericFormCustomFieldWidget> createState() => _GenericFormCustomFieldWidgetState();
}

class _GenericFormCustomFieldWidgetState extends State<GenericFormCustomFieldWidget> {
  
  Map<String, dynamic>? infoDataMap;
  Map<String, dynamic>? listenerDataMap;
  List<dynamic> customFieldsList = [];

  @override
  void initState() {
    infoDataMap = widget.infoDataMap;

    var data = HiveStorageManager.readCustomFieldsDataMaps();
    if(data != null){
      final custom = customFromJson(data);
      customFieldsList = custom.customFields!;
    }

    super.initState();
  }

  @override
  void dispose() {
    infoDataMap = null;
    listenerDataMap = null;
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (customFieldsList.isNotEmpty) {
      return Column(
        children: customFieldsList.map((fieldData) {
          return CustomFieldsWidget(
            padding: widget.formItemPadding,
            customFieldData: fieldData,
            propertyInfoMap: infoDataMap,
            formItemIndex: widget.formItemIndex,
            customFieldsPageListener: (Map<String, dynamic> dataMap){
              infoDataMap!.addAll(dataMap);
              widget.listener(infoDataMap!);
            },
          );
        }).toList(),
      );
    }
    
    return Container();
  }
}
