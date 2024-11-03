import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/term_checkbox_list_widget.dart';

typedef PropertyFeaturesPageListener = void Function(Map<String, dynamic> _dataMap);

class PropertyFeatures extends StatefulWidget{
  final Map<String, dynamic>? propertyInfoMap;
  final PropertyFeaturesPageListener? propertyFeaturesPageListener;

  PropertyFeatures({
    this.propertyInfoMap,
    this.propertyFeaturesPageListener,
  });

  @override
  State<StatefulWidget> createState() => PropertyFeaturesState();
}

class PropertyFeaturesState extends State<PropertyFeatures> {

  Map<String, dynamic> dataMap = {};
  List<dynamic> _propertyFeaturesMetaDataList = [];
  List<dynamic> _selectedPropertyFeaturesList = [];

  @override
  void initState() {

    Map? tempMap = widget.propertyInfoMap;
    if(tempMap != null){
      if(tempMap.containsKey(ADD_PROPERTY_FEATURES_LIST)){
        _selectedPropertyFeaturesList = tempMap[ADD_PROPERTY_FEATURES_LIST] ?? [];
      }
    }

    _propertyFeaturesMetaDataList = HiveStorageManager.readPropertyFeaturesMetaData() ?? [];

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: CardWidget(
        color: AppThemePreferences().appTheme.backgroundColor,
        child: Column(
          children: [
            featuresTextWidget(),
            TermCheckBoxListWidget(
              comparisonOnTheBasisOf: TERM_ID,
              termDataList: _propertyFeaturesMetaDataList,
              selectedDataList: _selectedPropertyFeaturesList,
              listener: (selectedDataList) {
                _selectedPropertyFeaturesList = selectedDataList;
                dataMap[ADD_PROPERTY_FEATURES_LIST] = _selectedPropertyFeaturesList;
                widget.propertyFeaturesPageListener!(dataMap);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget featuresTextWidget() {
    return HeaderWidget(
      text: UtilityMethods.getLocalizedString("features"),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      alignment: UtilityMethods.isRTL(context) ? Alignment.topRight : Alignment.topLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
    );
  }
}


