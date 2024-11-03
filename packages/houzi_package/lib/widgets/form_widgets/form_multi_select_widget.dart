import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_multi_select_dialog.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef GenericMultiSelectFormWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericFormMultiSelectWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericMultiSelectFormWidgetListener listener;

  const GenericFormMultiSelectWidget({
    Key? key,
    required this.formItem,
    this.formItemPadding,
    this.infoDataMap,
    required this.listener,
  }) : super(key: key);

  @override
  State<GenericFormMultiSelectWidget> createState() => _GenericFormMultiSelectWidgetState();
}

class _GenericFormMultiSelectWidgetState extends State<GenericFormMultiSelectWidget> with ValidationMixin {

  bool loadingData = false;
  String? apiKey;
  String? termType;
  String? itemsNamesListKey;
  Map<String, dynamic>? infoDataMap;
  Map<String, dynamic> listenerDataMap = {};
  List<dynamic> _termDataItemsList = [];
  List<dynamic> _selectedItemsNamesList = [];
  List<dynamic> _selectedItemsIdsList = [];
  final TextEditingController controller = TextEditingController();
  final PropertyBloc _propertyBloc = PropertyBloc();

  @override
  void initState() {

    loadData(widget.formItem);

    apiKey = widget.formItem.apiKey;
    termType = widget.formItem.termType;
    infoDataMap = widget.infoDataMap;

    if (infoDataMap != null) {
      if (apiKey != null && apiKey!.isNotEmpty) {
        initializeSelectedItemsIdsList();
      }

      if (termType != null && termType!.isNotEmpty) {
        initializeSelectedItemsNamesList(termType!);
      }
    }
    
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _termDataItemsList = [];
    _selectedItemsNamesList = [];
    _selectedItemsIdsList = [];
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    if (_selectedItemsNamesList.isNotEmpty) {
      controller.text = UtilityMethods.getLocalizedString(getMultiSelectFieldValue(_selectedItemsNamesList));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return loadingData
        ? Container(padding: widget.formItemPadding, child: DataLoadingWidget())
        : _termDataItemsList.isEmpty
            ? Container()
            : Container(
                padding: widget.formItemPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.formItem.title != null &&
                        widget.formItem.title!.isNotEmpty)
                      GenericTextWidget(
                        "${UtilityMethods.getLocalizedString(widget.formItem.title!)}${widget.formItem.performValidation ? " *" : ""}",
                        style: AppThemePreferences().appTheme.labelTextStyle,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextFormFieldWidget(
                        padding: EdgeInsets.zero,
                        controller: controller,
                        hintText: widget.formItem.hint,
                        suffixIcon: Icon(AppThemePreferences.dropDownArrowIcon),
                        validator: (text) {
                          updateData(text);
                          if (widget.formItem.performValidation) {
                            return validateTextField(text);
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MultiSelectDialogWidget(
                                fromAddProperty: true,
                                title: UtilityMethods.getLocalizedString("select"),
                                dataItemsList: _termDataItemsList,
                                selectedItemsList: _selectedItemsNamesList,
                                selectedItemsSlugsList: _selectedItemsIdsList,
                                multiSelectDialogWidgetListener: (List<dynamic> selectedItemsNamesList, List<dynamic> selectedItemsIdsList) {
                                  _selectedItemsNamesList = selectedItemsNamesList;
                                  _selectedItemsIdsList = selectedItemsIdsList;
                                  controller.text = UtilityMethods.getLocalizedString(getMultiSelectFieldValue(selectedItemsNamesList));
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

  updateData(String? fieldValue) {
    if (fieldValue != null && fieldValue.isNotEmpty) {
      if (apiKey != null && apiKey!.isNotEmpty) {
        listenerDataMap[apiKey!] = _selectedItemsIdsList;
      }

      if (itemsNamesListKey != null && itemsNamesListKey!.isNotEmpty) {
        listenerDataMap[itemsNamesListKey!] = _selectedItemsNamesList;
      }

      if (listenerDataMap.isNotEmpty) {
        widget.listener(listenerDataMap);
      }
    }
  }

  initializeSelectedItemsIdsList() {
    if (infoDataMap!.containsKey(apiKey) && infoDataMap![apiKey] != null) {
      if(infoDataMap![apiKey] is List){
        _selectedItemsIdsList = infoDataMap![apiKey];
      }else if(infoDataMap![apiKey] is int){
        _selectedItemsIdsList = [infoDataMap![apiKey]];
      }
    }
  }

  initializeSelectedItemsNamesList(String termType) {
    itemsNamesListKey = getItemsNamesListKey(termType);
    if (itemsNamesListKey != null && infoDataMap!.containsKey(itemsNamesListKey) && infoDataMap![itemsNamesListKey] != null) {
      if(infoDataMap![itemsNamesListKey] is List){
        _selectedItemsNamesList = infoDataMap![itemsNamesListKey];
      }else if(infoDataMap![itemsNamesListKey] is String){
        _selectedItemsNamesList = [infoDataMap![itemsNamesListKey]];
      }
    }
  }

  String? getItemsNamesListKey(String termType) {
    switch(termType) {
      case propertyTypeDataType: {
        return ADD_PROPERTY_TYPE_NAMES_LIST;
      }

      case propertyStatusDataType: {
        return ADD_PROPERTY_STATUS_NAMES_LIST;
      }

      case propertyLabelDataType: {
        return ADD_PROPERTY_LABEL_NAMES_LIST;
      }

      default: {
        return null;
      }
    }
  }

  String getMultiSelectFieldValue(List<dynamic> itemsList){
    if(itemsList.isNotEmpty && itemsList.toSet().toList().length == 1){
      return UtilityMethods.getLocalizedString("${itemsList.toSet().toList().first}");
    }
    else if(itemsList.isNotEmpty && itemsList.toSet().toList().length > 1){
      return UtilityMethods.getLocalizedString("multi_select_drop_down_item_selected",
          inputWords: [(itemsList.toSet().toList().length.toString())]);
    }
    return "";
  }

  loadData (HouziFormItem formItem) {
    if (getTermDataFromStorage(formItem).isNotEmpty) {
      if (mounted) {
        setState(() {
          _termDataItemsList = getTermDataFromStorage(formItem);
        });
      }
    } else {
      getAndStoreTermData(formItem.termType);
    }
  }

  List<dynamic> getTermDataFromStorage (HouziFormItem formItem) {
    switch(formItem.termType) {
      case propertyTypeDataType: {
        return HiveStorageManager.readPropertyTypesMetaData() ?? [];
      }

      case propertyStatusDataType: {
        return HiveStorageManager.readPropertyStatusMetaData() ?? [];
      }

      case propertyLabelDataType: {
        return HiveStorageManager.readPropertyLabelsMetaData() ?? [];
      }

      case propertyAreaDataType: {
        return HiveStorageManager.readPropertyAreaMetaData() ?? [];
      }

      case propertyCityDataType: {
        return HiveStorageManager.readCitiesMetaData() ?? [];
      }

      case propertyStateDataType: {
        return HiveStorageManager.readPropertyStatesMetaData() ?? [];
      }

      case propertyCountryDataType: {
        return HiveStorageManager.readPropertyCountriesMetaData() ?? [];
      }

      case propertyFeatureDataType: {
        return HiveStorageManager.readPropertyFeaturesMetaData() ?? [];
      }

      default: {
        return [];
      }
    }
  }

  getAndStoreTermData(String? term) {
    if(term != null && term.isNotEmpty) {
      fetchTermData(term).then((value) {
        if(value.isNotEmpty){
          if(mounted){
            setState(() {
              List<dynamic> termsMetaData = value;
              if(termsMetaData.isNotEmpty) {
                _termDataItemsList = termsMetaData;
                UtilityMethods.storePropertyMetaDataList(
                  dataType: term,
                  metaDataList: termsMetaData,
                );
              }
            });
          }
        }
        return null;
      });
    }

  }

  Future<List<dynamic>> fetchTermData(String term) async {
    if(mounted){
      setState(() {
        loadingData = true;
      });
    }
    List<dynamic> termData = [];
    List<dynamic> tempTermData = await _propertyBloc.fetchTermData(term);
    if(tempTermData == null ||
        (tempTermData.isNotEmpty && tempTermData[0] == null) ||
        (tempTermData.isNotEmpty && tempTermData[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          loadingData = false;
        });
      }
      return termData;
    }else{
      if (mounted) {
        setState(() {
          loadingData = false;
        });
      }
      if(tempTermData.isNotEmpty){
        termData.addAll(tempTermData);
      }
    }

    return termData;
  }

}
