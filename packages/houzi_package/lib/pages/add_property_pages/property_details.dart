import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/dynamic_item.dart';
import 'package:houzi_package/widgets/add_property_widgets/additional_details_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/generic_add_room_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/custom_fields.dart';
import 'package:houzi_package/widgets/add_property_widgets/custom_fields_widgets.dart';


typedef PropertyDetailsPageListener = void Function(Map<String, dynamic> _dataMap);

class PropertyDetails extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PropertyDetailsState();
  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic>? propertyInfoMap;
  final PropertyDetailsPageListener? propertyDetailsPageListener;

  PropertyDetails({
    this.formKey,
    this.propertyInfoMap,
    this.propertyDetailsPageListener,
  });
}

class PropertyDetailsState extends State<PropertyDetails> {

  int _beds = 0;
  int _baths = 0;

  Map<String, dynamic> dataMap = {};

  final List<DynamicItem> _additionalDetailsList = [];

  final _bedroomsTextController = TextEditingController();
  final _bathroomsTextController = TextEditingController();
  final _areaSizeTextController = TextEditingController();
  final _sizePostfixTextController = TextEditingController();
  final _landAreaTextController = TextEditingController();
  final _landAreaSizePostfixTextController = TextEditingController();
  final _garagesTextController = TextEditingController();
  final _garageSizeTextController = TextEditingController();
  final _propertyIDTextController = TextEditingController();
  final _yearBuiltTextController = TextEditingController();

  List<dynamic> customList = [];

  @override
  void dispose() {
    _bedroomsTextController.dispose();
    _bathroomsTextController.dispose();
    _areaSizeTextController.dispose();
    _sizePostfixTextController.dispose();
    _landAreaTextController.dispose();
    _landAreaSizePostfixTextController.dispose();
    _garagesTextController.dispose();
    _garageSizeTextController.dispose();
    _propertyIDTextController.dispose();
    _yearBuiltTextController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    Map? tempMap = widget.propertyInfoMap;
    if (tempMap != null) {
      if (tempMap.containsKey(ADD_PROPERTY_BEDROOMS)) {
        _bedroomsTextController.text = tempMap[ADD_PROPERTY_BEDROOMS] ?? "";
        _beds = int.tryParse(tempMap[ADD_PROPERTY_BEDROOMS]) ?? 0;
      }
      if (tempMap.containsKey(ADD_PROPERTY_BATHROOMS)) {
        _bathroomsTextController.text = tempMap[ADD_PROPERTY_BATHROOMS];
        _baths = int.tryParse(tempMap[ADD_PROPERTY_BATHROOMS]) ?? 0;
      }
      if (tempMap.containsKey(ADD_PROPERTY_SIZE)) {
        _areaSizeTextController.text = tempMap[ADD_PROPERTY_SIZE] ?? "";
      }
      if (tempMap.containsKey(ADD_PROPERTY_SIZE_PREFIX)) {
        _sizePostfixTextController.text = tempMap[ADD_PROPERTY_SIZE_PREFIX] ?? "";
      }
      if (tempMap.containsKey(ADD_PROPERTY_LAND_AREA)) {
        _landAreaTextController.text = tempMap[ADD_PROPERTY_LAND_AREA] ?? "";
      }
      if (tempMap.containsKey(ADD_PROPERTY_LAND_AREA_PREFIX)) {
        _landAreaSizePostfixTextController.text = tempMap[ADD_PROPERTY_LAND_AREA_PREFIX] ?? "";
      }
      if (tempMap.containsKey(ADD_PROPERTY_GARAGE)) {
        _garagesTextController.text = tempMap[ADD_PROPERTY_GARAGE] ?? "";
      }
      if (tempMap.containsKey(ADD_PROPERTY_GARAGE_SIZE)) {
        _garageSizeTextController.text = tempMap[ADD_PROPERTY_GARAGE_SIZE] ?? "";
      }
      if (tempMap.containsKey(ADD_PROPERTY_PROPERTY_ID)) {
        _propertyIDTextController.text = tempMap[ADD_PROPERTY_PROPERTY_ID] ?? "";
      }
      if (tempMap.containsKey(ADD_PROPERTY_YEAR_BUILT)) {
        _yearBuiltTextController.text = tempMap[ADD_PROPERTY_YEAR_BUILT] ?? "";
      }

      if(tempMap.containsKey(ADD_PROPERTY_ADDITIONAL_FEATURES)){
        List<dynamic>? list = tempMap[ADD_PROPERTY_ADDITIONAL_FEATURES];
        if(list != null && list.isNotEmpty){
          for(int i = 0; i < list.length; i++){
            var item = list[i];
            _additionalDetailsList.add(
              DynamicItem(
                key: "Key$i",
                dataMap: item,
              ),
            );
          }
        }
      }
    }

    var data = HiveStorageManager.readCustomFieldsDataMaps();
    if(data != null){
      final custom = customFromJson(data);
      customList = custom.customFields!;
    }

    super.initState();
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
              CardWidget(
                child: Column(
                  children: [
                    propertyAreaTextWidget(),
                    addRoomsInformation(),
                    addAreaInformation(),
                    addLandAreaInformation(),
                    addGarageInformation(),
                    addPropertyRelatedInformation(),
                    if(customList.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Column(
                          children: customList.map((fieldData) {
                            return CustomFieldsWidget(
                              customFieldData: fieldData,
                              propertyInfoMap: widget.propertyInfoMap,
                              customFieldsPageListener: (Map<String, dynamic> _dataMap){
                                dataMap.addAll(_dataMap);
                                widget.propertyDetailsPageListener!(dataMap);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
              CardWidget(
                child: Column(
                  children: [
                    additionalDetailsTextWidget(),
                    GenericAdditionalDetailsWidget(
                      itemsList: _additionalDetailsList,
                      listener: (updatedItemsList) {
                        List<Map<String, dynamic>> dataHolderList = [];
                        for (DynamicItem item in updatedItemsList) {
                          dataHolderList.add(item.dataMap!);
                        }

                        dataMap[ADD_PROPERTY_ADDITIONAL_FEATURES] = dataHolderList;
                        widget.propertyDetailsPageListener!(dataMap);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headingWidget({required String text}){
    return HeaderWidget(
      text: text,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
    );
  }

  Widget labelWidget(String text){
    return GenericTextWidget(
      text,
      style: AppThemePreferences().appTheme.labelTextStyle,
    );
  }

  Widget hintWidget(String text){
    return GenericTextWidget(
      text,
      style: AppThemePreferences().appTheme.hintTextStyle,
    );
  }

  InputDecoration formFieldDecoration({required String hintText}){
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(),
      ),
    );
  }

  Widget propertyAreaTextWidget() {
    return headingWidget(text: UtilityMethods.getLocalizedString("details"));
  }

  Widget additionalDetailsTextWidget() {
    return headingWidget(text: UtilityMethods.getLocalizedString("additional_details"));
  }

  Widget addRoomsInformation(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: addNumberOfBedrooms()),
        Expanded(flex: 5, child: addNumberOfBathrooms()),
      ],
    );
  }

  Widget addNumberOfBedrooms(){
    return GenericStepperWidget(
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("bedrooms"),
      controller: _bedroomsTextController,
      onRemovePressed: () {
        if (_beds > 0) {
          if (mounted) {
            setState(() {
              _beds -= 1;
              _bedroomsTextController.text = _beds.toString();
            });
          }
        }
      },
      onAddPressed: () {
        if (_beds >= 0) {
          if (mounted) {
            setState(() {
              _beds += 1;
              _bedroomsTextController.text = _beds.toString();
            });
          }
        }
      },
      onChanged: (value){
        if (mounted) {
          setState(() {
            _beds = int.parse(value);
          });
        }
      },
      validator: (String? value) {
        if(value != null && value.isNotEmpty) {
          if (mounted) {
            setState(() {
              dataMap[ADD_PROPERTY_BEDROOMS] = value;
            });
          }
          widget.propertyDetailsPageListener!(dataMap);
        }
        return null;
      },
    );
  }

  Widget addNumberOfBathrooms(){
    return GenericStepperWidget(
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("bathrooms"),
      controller: _bathroomsTextController,
      onRemovePressed: () {
        if(_baths > 0){
          if (mounted) {
            setState(() {
              _baths -= 1;
              _bathroomsTextController.text = _baths.toString();
            });
          }
        }
      },
      onAddPressed: () {
        if(_baths >= 0){
          if (mounted) {
            setState(() {
              _baths += 1;
              _bathroomsTextController.text = _baths.toString();
            });
          }
        }
      },
      onChanged: (value){
        if (mounted) {
          setState(() {
            _baths = int.parse(value);
          });
        }
      },
      validator: (String? value) {
        if(value != null && value.isNotEmpty) {
          if (mounted) {
            setState(() {
              dataMap[ADD_PROPERTY_BATHROOMS] = value;
            });
          }
          widget.propertyDetailsPageListener!(dataMap);
        }
        return null;
      },
    );
  }

  Widget addAreaInformation(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: addAreaSize()),
        Expanded(flex: 5, child: addSizePostfix()),
      ],
    );
  }

  Widget addAreaSize(){
    return TextFormFieldWidget(
      padding: const EdgeInsets.fromLTRB(20, 30, 10, 0),
      labelText: UtilityMethods.getLocalizedString("area_size"),
      hintText: UtilityMethods.getLocalizedString("enter_area_size"),
      additionalHintText: UtilityMethods.getLocalizedString("only_digits"),

      validator: (String? value) {
        if(value != null && value.isNotEmpty) {
          if (mounted) {
            setState(() {
              dataMap[ADD_PROPERTY_SIZE] = value;
            });
          }
          widget.propertyDetailsPageListener!(dataMap);
        }
        return null;
      },
      controller: _areaSizeTextController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  Widget addSizePostfix(){
    return Container(
      padding: const EdgeInsets.only(top: 30.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("size_postfix"),
        hintText: UtilityMethods.getLocalizedString("enter_size_postfix"),
        additionalHintText: UtilityMethods.getLocalizedString("for_example") + MEASUREMENT_UNIT_TEXT,
        controller: _sizePostfixTextController,
        validator: (String? value) {
          if(value != null && value.isNotEmpty) {
            if (mounted) {
              setState(() {
                dataMap[ADD_PROPERTY_SIZE_PREFIX] = value;
              });
            }
            widget.propertyDetailsPageListener!(dataMap);
          }
          return null;
        },
      ),
    );
  }

  Widget addLandAreaInformation(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: addLandArea()),
        Expanded(flex: 5, child: addLandAreaSizePostfix()),
      ],
    );
  }

  Widget addLandArea(){
    return TextFormFieldWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
      labelText: UtilityMethods.getLocalizedString("land_area"),
      hintText: UtilityMethods.getLocalizedString("enter_land_area"),
      additionalHintText: UtilityMethods.getLocalizedString("only_digits"),
      controller: _landAreaTextController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (String? value) {
        if(value != null && value.isNotEmpty) {
          if (mounted) {
            setState(() {
              dataMap[ADD_PROPERTY_LAND_AREA] = value;
            });
          }
          widget.propertyDetailsPageListener!(dataMap);
        }
        return null;
      },
    );
  }

  Widget addLandAreaSizePostfix(){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("size_postfix"),//AppLocalizations.of(context).size_postfix,
        hintText: UtilityMethods.getLocalizedString("enter_size_postfix"),//AppLocalizations.of(context).enter_size_postfix,
        additionalHintText: UtilityMethods.getLocalizedString("for_example") + MEASUREMENT_UNIT_TEXT,//AppLocalizations.of(context).for_example_Sq_Ft,
        controller: _landAreaSizePostfixTextController,
        validator: (String? value) {
          if(value != null && value.isNotEmpty) {
            if (mounted) {
              setState(() {
                dataMap[ADD_PROPERTY_LAND_AREA_PREFIX] = value;
              });
            }
            widget.propertyDetailsPageListener!(dataMap);
          }
          return null;
        },
      ),
    );
  }

  Widget addGarageInformation(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: addNumberOfGarages()),
        Expanded(flex: 5, child: addGarageSize()),
      ],
    );
  }

  Widget addNumberOfGarages(){
    return TextFormFieldWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
      labelText: UtilityMethods.getLocalizedString("garages"),
      hintText: UtilityMethods.getLocalizedString("number_of_garages"),
      additionalHintText: UtilityMethods.getLocalizedString("only_digits"),
      controller: _garagesTextController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (String? value) {
        if(value != null && value.isNotEmpty) {
          if (mounted) {
            setState(() {
              dataMap[ADD_PROPERTY_GARAGE] = value;
            });
          }
          widget.propertyDetailsPageListener!(dataMap);
        }
        return null;
      },
    );
  }

  Widget addGarageSize(){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        // ignorePadding: true,
        labelText: UtilityMethods.getLocalizedString("garage_size"),
        hintText: UtilityMethods.getLocalizedString("enter_garage_size"),
        additionalHintText: UtilityMethods.getLocalizedString("for_example") + "200 " + MEASUREMENT_UNIT_TEXT,
        controller: _garageSizeTextController,
        validator: (String? value) {
          if(value != null && value.isNotEmpty) {
            if (mounted) {
              setState(() {
                dataMap[ADD_PROPERTY_GARAGE_SIZE] = value;
              });
            }
            widget.propertyDetailsPageListener!(dataMap);
          }
          return null;
        },
      ),
    );
  }

  Widget addPropertyRelatedInformation(){
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Expanded(flex: 5, child: addPropertyID()),
          Expanded(flex: 5, child: addYearBuilt()),
          Expanded(flex: 5, child: Container()),
        ],
      ),
    );
  }

  Widget addPropertyID(){
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelWidget(UtilityMethods.getLocalizedString("property_id")),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: _propertyIDTextController,
              validator: (String? value) {
                if(value != null && value.isNotEmpty) {
                  if (mounted) {
                    setState(() {
                      dataMap[ADD_PROPERTY_PROPERTY_ID] = value;
                    });
                  }
                  widget.propertyDetailsPageListener!(dataMap);
                }
                return null;
              },
              decoration: formFieldDecoration(hintText: UtilityMethods.getLocalizedString("enter_property_id")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: hintWidget(UtilityMethods.getLocalizedString("for_example_hz_01")),
          ),
        ],
      ),
    );
  }

  Widget addYearBuilt(){
    return TextFormFieldWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
      labelText: UtilityMethods.getLocalizedString("year_built"),
      hintText:UtilityMethods.getLocalizedString("enter_year_built"),
      additionalHintText: UtilityMethods.getLocalizedString("only_digits"),
      controller: _yearBuiltTextController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (String? value) {
        if(value != null && value.isNotEmpty) {
          if (mounted) {
            setState(() {
              dataMap[ADD_PROPERTY_YEAR_BUILT] = value;
            });
          }
          widget.propertyDetailsPageListener!(dataMap);
          
        }
        return null;
      },
    );
  }

}