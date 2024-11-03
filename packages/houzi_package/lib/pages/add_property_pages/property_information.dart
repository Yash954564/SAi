import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_multi_select_dialog.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';

typedef DropDownViewWidgetListener = void Function(
  List<dynamic> listOfSelectedItems,
  List<dynamic> listOfSelectedIdsSlugs,
);

typedef PropertyInformationPageListener = void Function(Map<String, dynamic> _dataMap);

class PropertyInformationPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => PropertyInformationPageState();

  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic>? propertyInfoMap;
  final PropertyInformationPageListener? propertyInformationPageListener;

  PropertyInformationPage({
    this.formKey,
    this.propertyInfoMap,
    this.propertyInformationPageListener,
  });
}

class PropertyInformationPageState extends State<PropertyInformationPage> with ValidationMixin{

  List<dynamic> _propertyTypeMetaDataList = [];
  List<dynamic> _propertyLabelMetaDataList = [];
  List<dynamic> _propertyStatusMetaDataList = [];

  List<dynamic> _selectedPropertyTypeList = [];
  List<dynamic> _selectedPropertyStatusList = [];
  List<dynamic> _selectedPropertyLabelList = [];

  List<dynamic> _selectedPropertyTypeIdsList = [];
  List<dynamic> _selectedPropertyStatusIdsList = [];
  List<dynamic> _selectedPropertyLabelIdsList = [];

  Map<String, dynamic> dataMap = {};

  final _propertyTitleTextController = TextEditingController();
  final _propertyDescriptionTextController = TextEditingController();
  final _propertyPriceTextController = TextEditingController();
  final _propertyPricePrefixTextController = TextEditingController();
  final _propertyPricePostfixTextController = TextEditingController();
  final _propertySecondPriceTextController = TextEditingController();
  final _propertyPropertyTypeTextController = TextEditingController();
  final _propertyPropertyStatusTextController = TextEditingController();
  final _propertyPropertyLabelTextController = TextEditingController();


  @override
  void dispose() {
    _propertyTitleTextController.dispose();
    _propertyDescriptionTextController.dispose();
    _propertyPriceTextController.dispose();
    _propertyPricePrefixTextController.dispose();
    _propertyPricePostfixTextController.dispose();
    _propertySecondPriceTextController.dispose();
    _propertyPropertyTypeTextController.dispose();
    _propertyPropertyStatusTextController.dispose();
    _propertyPropertyLabelTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _propertyTypeMetaDataList = HiveStorageManager.readPropertyTypesMetaData() ?? [];
    _propertyLabelMetaDataList = HiveStorageManager.readPropertyLabelsMetaData() ?? [];
    _propertyStatusMetaDataList = HiveStorageManager.readPropertyStatusMetaData() ?? [];
    
    Map? tempMap = widget.propertyInfoMap;

    if(tempMap != null){
      if(tempMap.containsKey(ADD_PROPERTY_TITLE)){
        _propertyTitleTextController.text = tempMap[ADD_PROPERTY_TITLE] ?? "";
      }
      if(tempMap.containsKey(ADD_PROPERTY_DESCRIPTION)){
        _propertyDescriptionTextController.text = tempMap[ADD_PROPERTY_DESCRIPTION] ?? "";
      }
      if(tempMap.containsKey(ADD_PROPERTY_PRICE)){
        _propertyPriceTextController.text = tempMap[ADD_PROPERTY_PRICE] ?? "";
      }
      if(tempMap.containsKey(ADD_PROPERTY_PRICE_PREFIX)){
        _propertyPricePrefixTextController.text = tempMap[ADD_PROPERTY_PRICE_PREFIX] ?? "";
      }
      if(tempMap.containsKey(ADD_PROPERTY_PRICE_POSTFIX)){
        _propertyPricePostfixTextController.text = tempMap[ADD_PROPERTY_PRICE_POSTFIX] ?? "";
      }
      if(tempMap.containsKey(ADD_PROPERTY_SECOND_PRICE)){
        _propertySecondPriceTextController.text = tempMap[ADD_PROPERTY_SECOND_PRICE] ?? "";
      }
      if(tempMap.containsKey(ADD_PROPERTY_TYPE_NAMES_LIST)
          && tempMap[ADD_PROPERTY_TYPE_NAMES_LIST] != null){
        if(tempMap[ADD_PROPERTY_TYPE_NAMES_LIST] is List){
          _selectedPropertyTypeList = tempMap[ADD_PROPERTY_TYPE_NAMES_LIST];
        }else if(tempMap[ADD_PROPERTY_TYPE_NAMES_LIST] is String){
          _selectedPropertyTypeList = [tempMap[ADD_PROPERTY_TYPE_NAMES_LIST]];
        }
      }
      if(tempMap.containsKey(ADD_PROPERTY_TYPE) && tempMap[ADD_PROPERTY_TYPE] != null){
        if(tempMap[ADD_PROPERTY_TYPE] is List){
          _selectedPropertyTypeIdsList = tempMap[ADD_PROPERTY_TYPE];
        }else if(tempMap[ADD_PROPERTY_TYPE] is int){
          _selectedPropertyTypeIdsList = [tempMap[ADD_PROPERTY_TYPE]];
        }
      }
      if(tempMap.containsKey(ADD_PROPERTY_LABEL_NAMES_LIST) && tempMap[ADD_PROPERTY_LABEL_NAMES_LIST] != null){
        if(tempMap[ADD_PROPERTY_LABEL_NAMES_LIST] is List){
          _selectedPropertyLabelList = tempMap[ADD_PROPERTY_LABEL_NAMES_LIST];
        }else if(tempMap[ADD_PROPERTY_LABEL_NAMES_LIST] is String){
          _selectedPropertyLabelList = [tempMap[ADD_PROPERTY_LABEL_NAMES_LIST]];
        }
      }
      if(tempMap.containsKey(ADD_PROPERTY_LABELS) && tempMap[ADD_PROPERTY_LABELS] != null){
        if(tempMap[ADD_PROPERTY_LABELS] is List){
          _selectedPropertyLabelIdsList = tempMap[ADD_PROPERTY_LABELS];
        }else if(tempMap[ADD_PROPERTY_LABELS] is int){
          _selectedPropertyLabelIdsList = [tempMap[ADD_PROPERTY_LABELS]];
        }
      }
      if(tempMap.containsKey(ADD_PROPERTY_STATUS_NAMES_LIST) && tempMap[ADD_PROPERTY_STATUS_NAMES_LIST] != null){
        if(tempMap[ADD_PROPERTY_STATUS_NAMES_LIST] is List){
          _selectedPropertyStatusList = tempMap[ADD_PROPERTY_STATUS_NAMES_LIST];
        }else if(tempMap[ADD_PROPERTY_STATUS_NAMES_LIST] is String){
          _selectedPropertyStatusList = [tempMap[ADD_PROPERTY_STATUS_NAMES_LIST]];
        }
      }
      if(tempMap.containsKey(ADD_PROPERTY_STATUS) && tempMap[ADD_PROPERTY_STATUS] != null){
        if(tempMap[ADD_PROPERTY_STATUS] is List){
          _selectedPropertyStatusIdsList = tempMap[ADD_PROPERTY_STATUS];
        }else if(tempMap[ADD_PROPERTY_STATUS] is int){
          _selectedPropertyStatusIdsList = [tempMap[ADD_PROPERTY_STATUS]];
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(_selectedPropertyTypeList.isNotEmpty) {
      _propertyPropertyTypeTextController.text = getMultiSelectFieldValue(_selectedPropertyTypeList);
    }
    
    if(_selectedPropertyStatusList.isNotEmpty) {
      _propertyPropertyStatusTextController.text = getMultiSelectFieldValue(_selectedPropertyStatusList);
    }
    
    if(_selectedPropertyLabelList.isNotEmpty) {
      _propertyPropertyLabelTextController.text = getMultiSelectFieldValue(_selectedPropertyLabelList);
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
              CardWidget(
                child: Column(
                  children: [
                    aboutPropertyTextWidget(),
                    addPropertyTitle(),
                    addDescription(),
                    addType(),
                    addStatus(),
                    addLabel(),
                  ],
                ),
              ),
              CardWidget(
                child: Column(
                  children: [
                    propertyPriceTextWidget(),
                    addPrice(),
                    addPricePrefix(),
                    addAfterThePrice(),
                    addSecondPrice(),
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

  Widget aboutPropertyTextWidget() {
    return headingWidget(text: UtilityMethods.getLocalizedString("description"));
  }

  Widget propertyPriceTextWidget() {
    return headingWidget(text: UtilityMethods.getLocalizedString("price"));
  }

  Widget addPropertyTitle(){
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
      labelText: UtilityMethods.getLocalizedString("property_title")+" *",
      hintText: UtilityMethods.getLocalizedString("enter_your_property_title"),
      controller: _propertyTitleTextController,
      keyboardType: TextInputType.text,
      validator: (String? value) {
        /// isEmpty checks for an empty String, but if route info is null you can't call isEmpty on null, so we check for null with
        /// ?. safe navigation operator which will only call isEmpty when the object is not null and produce null otherwise. So we just need to check for null with
        /// ?? null coalescing operator
        if (value!.isEmpty) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
        }
        if(mounted) setState(() {
          dataMap[ADD_PROPERTY_TITLE]  = value;
        });
        widget.propertyInformationPageListener!(dataMap);
        return null;
      },
    );
  }

  Widget addDescription(){
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
      labelText: UtilityMethods.getLocalizedString("content"),
      hintText: UtilityMethods.getLocalizedString("description"),
      controller: _propertyDescriptionTextController,
      keyboardType: TextInputType.multiline,
      maxLines: 6,
      validator: (String? value) {
        if(value != null && value.isNotEmpty){
          if(mounted) setState(() {
            dataMap[ADD_PROPERTY_DESCRIPTION]  = value;
          });
          widget.propertyInformationPageListener!(dataMap);
        }
        return null;
      },
    );
  }

  Widget dropDownViewWidget({
  required String labelText,
  required TextEditingController controller,
  required List<dynamic> dataItemsList,
  required List<dynamic> selectedItemsList,
  required List<dynamic> selectedItemsIdsList,
    String? Function(String? val)? validator,
  DropDownViewWidgetListener? dropDownViewWidgetListener,
  EdgeInsetsGeometry padding = const EdgeInsets.only(top: 20.0, left: 20, right: 20),
}){
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericTextWidget(
            labelText,
            style: AppThemePreferences().appTheme.labelTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextFormField(
              controller: controller,
              decoration: AppThemePreferences.formFieldDecoration(
                hintText: UtilityMethods.getLocalizedString("select"),
                suffixIcon: Icon(AppThemePreferences.dropDownArrowIcon),
              ),
              validator: validator,
              readOnly: true,
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MultiSelectDialogWidget(
                      fromAddProperty: true,
                      title: UtilityMethods.getLocalizedString("select"),
                      dataItemsList: dataItemsList,
                      selectedItemsList: selectedItemsList,
                      selectedItemsSlugsList: selectedItemsIdsList,
                      multiSelectDialogWidgetListener: (List<dynamic> _selectedItemsList, List<dynamic> _listOfSelectedItemsIds){
                        dropDownViewWidgetListener!(_selectedItemsList, _listOfSelectedItemsIds);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String getMultiSelectFieldValue(List<dynamic> itemsList){
    if(itemsList.isNotEmpty && itemsList.toSet().toList().length == 1){
      return "${itemsList.toSet().toList().first}";
    }
    else if(itemsList.isNotEmpty && itemsList.toSet().toList().length > 1){
      return UtilityMethods.getLocalizedString("multi_select_drop_down_item_selected",
          inputWords: [(itemsList.toSet().toList().length.toString())]);
    }
    return "";
  }

  Widget addType() {
    return _propertyTypeMetaDataList.isEmpty
        ? Container()
        : dropDownViewWidget(
            labelText: UtilityMethods.getLocalizedString("type"),
            controller: _propertyPropertyTypeTextController,
            dataItemsList: _propertyTypeMetaDataList,
            selectedItemsList: _selectedPropertyTypeList,
            selectedItemsIdsList: _selectedPropertyTypeIdsList,
            validator: (String? value) {
              if (value != null && value.isNotEmpty) {
                if (mounted) {
                  setState(() {
                    dataMap[ADD_PROPERTY_TYPE_NAMES_LIST] =
                        _selectedPropertyTypeList;
                    dataMap[ADD_PROPERTY_TYPE] = _selectedPropertyTypeIdsList;
                  });
                }
                widget.propertyInformationPageListener!(dataMap);
              }
              // else{
              //   return "This Field can not be Empty";
              // }

              return null;
            },
            dropDownViewWidgetListener: (List<dynamic> _selectedItemsList,
                List<dynamic> _listOfSelectedItemsIds) {
              if (mounted) {
                setState(() {
                  _selectedPropertyTypeList = _selectedItemsList;
                  _selectedPropertyTypeIdsList = _listOfSelectedItemsIds;
                  _propertyPropertyTypeTextController.text =
                      getMultiSelectFieldValue(_selectedPropertyTypeList);
                });
              }
            });
  }

  Widget addStatus() {
    return _propertyStatusMetaDataList.isEmpty
        ? Container()
        : dropDownViewWidget(
            labelText: UtilityMethods.getLocalizedString("status"),
            controller: _propertyPropertyStatusTextController,
            dataItemsList: _propertyStatusMetaDataList,
            selectedItemsList: _selectedPropertyStatusList,
            selectedItemsIdsList: _selectedPropertyStatusIdsList,
            validator: (String? value) {
              if (value != null && value.isNotEmpty) {
                if (mounted) {
                  setState(() {
                    dataMap[ADD_PROPERTY_STATUS_NAMES_LIST] =
                        _selectedPropertyStatusList;
                    dataMap[ADD_PROPERTY_STATUS] =
                        _selectedPropertyStatusIdsList;
                  });
                }
                widget.propertyInformationPageListener!(dataMap);
              }
              // else{
              //   return "This Field can not be Empty";
              // }

              return null;
            },
            dropDownViewWidgetListener: (List<dynamic> _selectedItemsList,
                List<dynamic> _listOfSelectedItemsIds) {
              if (mounted) {
                setState(() {
                  _selectedPropertyStatusList = _selectedItemsList;
                  _selectedPropertyStatusIdsList = _listOfSelectedItemsIds;
                  _propertyPropertyStatusTextController.text =
                      getMultiSelectFieldValue(_selectedPropertyStatusList)!;
                });
              }
            });
  }

  Widget addLabel() {
    return _propertyLabelMetaDataList.isEmpty
        ? Container()
        : dropDownViewWidget(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            labelText: UtilityMethods.getLocalizedString("label"),
            controller: _propertyPropertyLabelTextController,
            dataItemsList: _propertyLabelMetaDataList,
            selectedItemsList: _selectedPropertyLabelList,
            selectedItemsIdsList: _selectedPropertyLabelIdsList,
            validator: (String? value) {
              if (value != null && value.isNotEmpty) {
                if (mounted) {
                  setState(() {
                    dataMap[ADD_PROPERTY_LABEL_NAMES_LIST] =
                        _selectedPropertyLabelList;
                    dataMap[ADD_PROPERTY_LABELS] =
                        _selectedPropertyLabelIdsList;
                  });
                }
                widget.propertyInformationPageListener!(dataMap);
              }
              // else{
              //   return "This Field can not be Empty";
              // }

              return null;
            },
            dropDownViewWidgetListener: (List<dynamic> _selectedItemsList,
                List<dynamic> _listOfSelectedItemsIds) {
              if (mounted) {
                setState(() {
                  _selectedPropertyLabelList = _selectedItemsList;
                  _selectedPropertyLabelIdsList = _listOfSelectedItemsIds;
                  _propertyPropertyLabelTextController.text =
                      getMultiSelectFieldValue(_selectedPropertyLabelList);
                });
              }
            });
  }

  Widget addPrice(){
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
      labelText: UtilityMethods.getLocalizedString("sale_or_rent_price")+" *",
      hintText: UtilityMethods.getLocalizedString("enter_the_price"),
      controller: _propertyPriceTextController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,],
      validator: (String? value) {
        if (value!.isEmpty) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
        }
        if(mounted) setState(() {
          dataMap[ADD_PROPERTY_PRICE]  = value;
        });
        widget.propertyInformationPageListener!(dataMap);
        return null;
      },
    );
  }

  Widget addPricePrefix(){
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
      labelText: UtilityMethods.getLocalizedString("price_prefix"),
      hintText: UtilityMethods.getLocalizedString("enter_the_price_prefix"),
      additionalHintText: UtilityMethods.getLocalizedString("for_example_start_from"),
      controller: _propertyPricePrefixTextController,
      validator: (String? value) {
        if(value != null && value.isNotEmpty){
          if(mounted) setState(() {
            dataMap[ADD_PROPERTY_PRICE_PREFIX]  = value;
          });
          widget.propertyInformationPageListener!(dataMap);
        }

        return null;
      },
    );
  }

  Widget addAfterThePrice(){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("after_the_price"),
        hintText: UtilityMethods.getLocalizedString("enter_the_after_price"),
        additionalHintText: UtilityMethods.getLocalizedString("for_example_monthly"),
        controller: _propertyPricePostfixTextController,
        validator: (String? value) {
          if(value != null && value.isNotEmpty){
            if(mounted) setState(() {
              dataMap[ADD_PROPERTY_PRICE_POSTFIX]  = value;
            });
            widget.propertyInformationPageListener!(dataMap);
          }

          return null;
        },
      ),
    );
  }

  Widget addSecondPrice(){
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 20),
      labelText: UtilityMethods.getLocalizedString("second_price_optional"),
      hintText: UtilityMethods.getLocalizedString("enter_the_second_price"),
      controller: _propertySecondPriceTextController,
      validator: (String? value) {
        if(value != null && value.isNotEmpty){
          if(mounted) setState(() {
            dataMap[ADD_PROPERTY_SECOND_PRICE]  = value;
          });
          widget.propertyInformationPageListener!(dataMap);
        }
        return null;
      },
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}