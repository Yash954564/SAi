import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/floor_plans.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/widgets/add_property_widgets/floor_plan_widget.dart';

typedef GenericFormFloorPlansFieldWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericFormFloorPlansFieldWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final bool isPropertyForUpdate;
  final GenericFormFloorPlansFieldWidgetListener listener;

  const GenericFormFloorPlansFieldWidget({
    Key? key,
    required this.formItem,
    this.infoDataMap,
    this.formItemPadding,
    this.isPropertyForUpdate = false,
    required this.listener,
  }) : super(key: key);

  @override
  State<GenericFormFloorPlansFieldWidget> createState() => _GenericFormFloorPlansFieldWidgetState();
}

class _GenericFormFloorPlansFieldWidgetState extends State<GenericFormFloorPlansFieldWidget> {
  String? apiKey;
  List<FloorPlanElement> dataItemsList = [];
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
            if (widget.isPropertyForUpdate) {
              String? imageUrl = item[favePlanImage];
              if(imageUrl != null && imageUrl.isNotEmpty) {
                Map<String, dynamic> imageMap = {
                  PROPERTY_MEDIA_IMAGE_NAME: "",
                  PROPERTY_MEDIA_IMAGE_PATH: imageUrl,
                  PROPERTY_MEDIA_IMAGE_STATUS: UPLOADED,
                  PROPERTY_MEDIA_IMAGE_ID: '${DateTime.now().millisecondsSinceEpoch}',
                };
                item[favePlanPendingImage] = imageMap;
              }
            }

            dataItemsList.add(
              FloorPlanElement(
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
    return GenericFloorPlanWidget(
      itemsList: dataItemsList,
      buttonPadding: widget.formItemPadding,
      listener: (updatedItemsList) {
        List<Map<String, dynamic>> dataHolderList = [];

        for (FloorPlanElement item in updatedItemsList) {
          dataHolderList.add(item.dataMap!);
        }

        if (dataHolderList.isEmpty) {
          listenerDataMap[ADD_PROPERTY_FLOOR_PLANS_ENABLE] = "0";
        } else {
          listenerDataMap[ADD_PROPERTY_FLOOR_PLANS_ENABLE] = "1";
        }

        listenerDataMap[apiKey!] = dataHolderList;
        widget.listener(listenerDataMap);
      },
    );
  }

  initializeDataItemsList(){
    dataItemsList.add(FloorPlanElement(
      key: "Key0",
      dataMap: {
        favePlanTitle: "",
        favePlanRooms: "",
        favePlanBathrooms: "",
        favePlanPrice: "",
        favePlanPricePostFix: "",
        favePlanSize: "",
        favePlanImage: "",
        favePlanPendingImage: "",
        favePlanDescription: "",
      },
    ));
  }
}
