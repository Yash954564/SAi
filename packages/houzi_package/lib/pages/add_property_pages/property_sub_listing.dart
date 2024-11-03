import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/dynamic_item.dart';
import 'package:houzi_package/widgets/add_property_widgets/multi_units_widgets/multi_units_listings_ids_widget.dart';
import 'package:houzi_package/widgets/add_property_widgets/multi_units_widgets/multi_units_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';

typedef PropertySubListingPageListener = void Function(
  List<Map<String, dynamic>> multiUnitsList,
  String ListingIDs,
);

class PropertySubListingPage extends StatefulWidget{

  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic>? propertyInfoMap;
  final PropertySubListingPageListener? propertySubListingPageListener;

  const PropertySubListingPage({
    Key? key,
    this.formKey,
    this.propertyInfoMap,
    this.propertySubListingPageListener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PropertySubListingPageState();

}

class PropertySubListingPageState extends State<PropertySubListingPage> {

  String userRole = "";
  String selectedListingsIDs = "";
  List<DynamicItem> _multiUnitsList = [];
  List<Map<String, dynamic>> _multiUnitsDataHolderList = [];
  final _listingIDsTextController = TextEditingController();


  @override
  void initState() {
    super.initState();

    userRole = HiveStorageManager.getUserRole();

    if (widget.propertyInfoMap != null && widget.propertyInfoMap!.isNotEmpty) {
      if (widget.propertyInfoMap!.containsKey(ADD_PROPERTY_FAVE_MULTI_UNITS_IDS) &&
          widget.propertyInfoMap![ADD_PROPERTY_FAVE_MULTI_UNITS_IDS] != null &&
          widget.propertyInfoMap![ADD_PROPERTY_FAVE_MULTI_UNITS_IDS].isNotEmpty) {
        _listingIDsTextController.text = widget.propertyInfoMap![ADD_PROPERTY_FAVE_MULTI_UNITS_IDS];
        selectedListingsIDs = widget.propertyInfoMap![ADD_PROPERTY_FAVE_MULTI_UNITS_IDS];
      }

      if (widget.propertyInfoMap!.containsKey(ADD_PROPERTY_FAVE_MULTI_UNITS) &&
          widget.propertyInfoMap![ADD_PROPERTY_FAVE_MULTI_UNITS] != null &&
          widget.propertyInfoMap![ADD_PROPERTY_FAVE_MULTI_UNITS] is List &&
          widget.propertyInfoMap![ADD_PROPERTY_FAVE_MULTI_UNITS].isNotEmpty) {
        List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(widget.propertyInfoMap![ADD_PROPERTY_FAVE_MULTI_UNITS]);
        if(list.isNotEmpty){
          for(int i = 0; i < list.length; i++){
            var item = list[i];
            _multiUnitsList.add(
              DynamicItem(
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
  }

  initializeData(){
    if(mounted) {
      setState(() {
        _multiUnitsList.add(DynamicItem(
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
      });
    }
  }

  @override
  void dispose() {
    userRole = "";
    selectedListingsIDs = "";
    _multiUnitsList = [];
    _multiUnitsDataHolderList = [];
    _listingIDsTextController.dispose();
    super.dispose();
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
              subListingsTextWidget(),
              if (userRole == ROLE_ADMINISTRATOR) MultiUnitsListingsIdsWidget(
                selectedListingsIDs: selectedListingsIDs,
                listener: (selectedIDs) {
                  selectedListingsIDs = selectedIDs;
                  widget.propertySubListingPageListener!(_multiUnitsDataHolderList, selectedListingsIDs);
                },
              ),
              GenericMultiUnitsWidget(
                itemsList: _multiUnitsList,
                listener: (updatedItemsList) {
                  for (DynamicItem item in updatedItemsList) {
                    _multiUnitsDataHolderList.add(item.dataMap!);
                  }

                  widget.propertySubListingPageListener!(_multiUnitsDataHolderList, selectedListingsIDs);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget subListingsTextWidget() {
    return HeaderWidget(
      text: UtilityMethods.getLocalizedString("sub_listings"),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
    );
  }
}