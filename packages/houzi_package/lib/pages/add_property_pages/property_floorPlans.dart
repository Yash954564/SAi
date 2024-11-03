import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/floor_plans.dart';
import 'package:houzi_package/widgets/add_property_widgets/floor_plan_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/light_button_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';


typedef PropertyFloorPlansPageListener = void Function(List<Map<String, dynamic>> floorPlansList);

class PropertyFloorPlansPage extends StatefulWidget{

  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic>? propertyInfoMap;
  final bool? isPropertyForUpdate;
  final PropertyFloorPlansPageListener? propertyFloorPlansPageListener;


  const PropertyFloorPlansPage({
    Key? key,
    this.formKey,
    this.propertyInfoMap,
    this.isPropertyForUpdate,
    this.propertyFloorPlansPageListener,
  }) : super(key: key);


  @override
  State<StatefulWidget> createState() => PropertyFloorPlansPageState();

}

class PropertyFloorPlansPageState extends State<PropertyFloorPlansPage> {

  final List<FloorPlanElement> _floorPlansList = [];
  FloorPlanElement? floorPlanElement;

  @override
  void initState() {
    if(widget.propertyInfoMap != null && widget.propertyInfoMap!.isNotEmpty){
      if(widget.propertyInfoMap!.containsKey(ADD_PROPERTY_FLOOR_PLANS) &&
          widget.propertyInfoMap![ADD_PROPERTY_FLOOR_PLANS] != null) {
        List<Map<String, dynamic>>? list = widget.propertyInfoMap![ADD_PROPERTY_FLOOR_PLANS];
        if(list != null && list.isNotEmpty){
          for(int i = 0; i < list.length; i++){
            var item = list[i];
            if(widget.isPropertyForUpdate != null && widget.isPropertyForUpdate!){
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

            _floorPlansList.add(
              FloorPlanElement(
                key: "Key$i",
                dataMap: item,
              ),
            );
          }
        }else{
          initializeData();
        }
      }
    }else{
      initializeData();
    }

    super.initState();
  }

  initializeData(){
    floorPlanElement = FloorPlanElement(
      key: "Key0",
      dataMap: {
        favePlanTitle : "",
        favePlanRooms : "",
        favePlanBathrooms : "",
        favePlanPrice : "",
        favePlanPricePostFix : "",
        favePlanSize : "",
        favePlanImage : "",
        favePlanPendingImage : "",
        favePlanDescription : "",
      },
    );

    if(mounted) {
      setState(() {
        _floorPlansList.add(floorPlanElement!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              floorPlansTextWidget(),
              GenericFloorPlanWidget(
                itemsList: _floorPlansList,
                listener: (updatedItemsList) {
                  List<Map<String, dynamic>> dataHolderList = [];
                  for (FloorPlanElement item in updatedItemsList) {
                    dataHolderList.add(item.dataMap!);
                  }

                  widget.propertyFloorPlansPageListener!(dataHolderList);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateDataMap(){
    List<Map<String, dynamic>> list = [];

    for(var item in _floorPlansList){
      list.add(item.dataMap!);
    }

    widget.propertyFloorPlansPageListener!(list);
  }

  Widget floorPlansTextWidget() {
    return HeaderWidget(
      text: UtilityMethods.getLocalizedString("floor_plans"),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
    );
  }

  Widget addNewElevatedButton(){
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: LightButtonWidget(
          text: UtilityMethods.getLocalizedString("add_new"),
          fontSize: AppThemePreferences.buttonFontSize,
          onPressed: (){
            if(mounted) {
              setState(() {
                _floorPlansList.add(FloorPlanElement(
                  key: _floorPlansList.isNotEmpty
                      ? "Key${_floorPlansList.length}"
                      : "Key0",
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
              });
            }
          }
      ),
    );
  }
}