import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_full_screen.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';


typedef GenericFormDropDownWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericFormDropDownWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericFormDropDownWidgetListener listener;

  const GenericFormDropDownWidget({
    Key? key,
    required this.formItem,
    this.formItemPadding,
    this.infoDataMap,
    required this.listener,
  }) : super(key: key);

  @override
  State<GenericFormDropDownWidget> createState() => _GenericFormDropDownWidgetState();
}

class _GenericFormDropDownWidgetState extends State<GenericFormDropDownWidget> {

  dynamic _selectedDataItem;
  dynamic _selectedItemId;
  bool loadingData = false;
  String? apiKey;
  String? termType;
  String? itemsNamesListKey;
  Map<String, dynamic>? infoDataMap;
  Map<String, dynamic> listenerDataMap = {};
  List<dynamic> _termDataItemsList = [];
  final PropertyBloc _propertyBloc = PropertyBloc();
  final TextEditingController _controller = TextEditingController();

  String? _country;
  String? _state;
  String? _city;
  String? _countrySlug;
  String? _stateSlug;
  String? _citySlug;
  List<dynamic> _itemMetaDataList = [];
  List<dynamic> _dataHolderList = [];

  @override
  void initState() {

    loadData(widget.formItem);

    apiKey = widget.formItem.apiKey;
    termType = widget.formItem.termType;
    infoDataMap = widget.infoDataMap;

    if (infoDataMap != null) {
      if (shouldHandleTermIdsData(termType)) {
        if (apiKey != null && apiKey!.isNotEmpty) {
          initializeSelectedItemId();
        }

        if (termType != null && termType!.isNotEmpty) {
          initializeSelectedItemName(termType!);
        }
      }

      else {
        if (apiKey != null && apiKey!.isNotEmpty) {
          _selectedDataItem = infoDataMap![apiKey!];
          if (_selectedDataItem != null) {
            _controller.text = UtilityMethods.getLocalizedString(_selectedDataItem.toString());
          } else {
            _controller.text = "";
          }
        }

        // initializing address related variables
        if (apiKey == ADD_PROPERTY_STATE_OR_COUNTY || apiKey == ADD_PROPERTY_CITY
            || apiKey == ADD_PROPERTY_AREA) {
          _country = infoDataMap![ADD_PROPERTY_COUNTRY];
          _state = infoDataMap![ADD_PROPERTY_STATE_OR_COUNTY];
          _city = infoDataMap![ADD_PROPERTY_CITY];
          _countrySlug = infoDataMap!["$ADD_PROPERTY_COUNTRY slug"];
          _stateSlug = infoDataMap!["$ADD_PROPERTY_STATE_OR_COUNTY slug"];
          _citySlug = infoDataMap!["$ADD_PROPERTY_CITY slug"];
        }

        // initializing address related data lists
        if (apiKey == ADD_PROPERTY_STATE_OR_COUNTY) {
          filterMetaData(_country, _countrySlug ?? "");
        } else if (apiKey == ADD_PROPERTY_CITY) {
          filterMetaData(_state, _stateSlug ?? "");
        } else if (apiKey == ADD_PROPERTY_AREA) {
          filterMetaData(_city, _citySlug ?? "");
        }
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    apiKey = null;
    termType = null;
    _country = null;
    _state = null;
    _city = null;
    _selectedDataItem = null;
    _selectedItemId = null;
    infoDataMap = null;
    _termDataItemsList = [];
    _itemMetaDataList = [];
    _dataHolderList = [];
    listenerDataMap = {};
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateAddressRelatedFields();
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
                        hintText: widget.formItem.hint,
                        suffixIcon: Icon(AppThemePreferences.dropDownArrowIcon),
                        controller: _controller,
                        readOnly: true,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => TermPickerFullScreen(
                              title: "${UtilityMethods.getLocalizedString("select")} "
                                  "${UtilityMethods.getLocalizedString(widget.formItem.title!)}",
                              termType: widget.formItem.termType!,
                              termMetaDataList: _termDataItemsList,
                              termsDataMap: {},
                              addAllinData: false,
                              termPickerFullScreenListener: (String pickedTerm, int? pickedTermId, String pickedTermSlug){
                                if(mounted) {
                                  setState(() {
                                    if (pickedTerm.isNotEmpty) {
                                      _controller.text = UtilityMethods.getLocalizedString(pickedTerm);
                                      updateValue(pickedTerm, pickedTermId, termType, pickedTermSlug);
                                    }
                                  });
                                }
                              },
                            ),
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              );
  }

  updateValue(dynamic value, int? termId, String? termType, String pickedTermSlug) {
    if (shouldHandleTermIdsData(termType)) {
      if (apiKey != null && apiKey!.isNotEmpty && termId != null) {
        _selectedItemId = termId;
        listenerDataMap[apiKey!] = [_selectedItemId];
      }

      if (itemsNamesListKey != null && itemsNamesListKey!.isNotEmpty) {
        _selectedDataItem = value;
        listenerDataMap[itemsNamesListKey!] = [_selectedDataItem];
      }

      if (listenerDataMap.isNotEmpty) {
        widget.listener(listenerDataMap);
      }
    } else if (apiKey != null && apiKey!.isNotEmpty) {
      listenerDataMap = {apiKey! : value, "$apiKey slug" : pickedTermSlug};
      widget.listener(listenerDataMap);
    }
  }

  filterMetaData(String? termName, String termSlug) {
    if (termName != null && termName.isNotEmpty) {
      _dataHolderList = [];
      for (Term item in _itemMetaDataList) {
        if (item.parentTerm!.toLowerCase() == termName.toLowerCase() ||
            item.parentTerm!.toLowerCase() == termSlug.toLowerCase()) {
          _dataHolderList.add(item);
        }
      }
      _termDataItemsList = _dataHolderList;
    }
  }

  updateAddressRelatedFields() {
    if (infoDataMap != null && infoDataMap!.isNotEmpty) {
      if (apiKey == ADD_PROPERTY_STATE_OR_COUNTY) {
        if (shouldUpdateFieldData(ADD_PROPERTY_COUNTRY, _country)) {
          // update local variable of country
          _country = infoDataMap![ADD_PROPERTY_COUNTRY];
          _countrySlug = infoDataMap!["$ADD_PROPERTY_COUNTRY slug"];
          updateFieldData(_country,_countrySlug ?? "");
        }
      } else if (apiKey == ADD_PROPERTY_CITY) {
        if (shouldUpdateFieldData(ADD_PROPERTY_STATE_OR_COUNTY, _state)) {
          // update local variable of state
          _state = infoDataMap![ADD_PROPERTY_STATE_OR_COUNTY];
          _stateSlug = infoDataMap!["$ADD_PROPERTY_STATE_OR_COUNTY slug"];
          updateFieldData(_state,_stateSlug?? "");
        }
      } else if (apiKey == ADD_PROPERTY_AREA) {
        if (shouldUpdateFieldData(ADD_PROPERTY_CITY, _city)) {
          // update local variable of city
          _city = infoDataMap![ADD_PROPERTY_CITY];
          _citySlug = infoDataMap!["$ADD_PROPERTY_CITY slug"];
          updateFieldData(_city,_citySlug ?? "");
        } else if (shouldUpdateFieldData(ADD_PROPERTY_STATE_OR_COUNTY, _state)) {
          // update local variable of state
          _state = infoDataMap![ADD_PROPERTY_STATE_OR_COUNTY];
          _stateSlug = infoDataMap!["$ADD_PROPERTY_STATE_OR_COUNTY slug"];
          updateAreaFieldData(_state,_stateSlug ?? "");
        } else if (shouldUpdateFieldData(ADD_PROPERTY_COUNTRY, _country)) {
          // update local variable of country
          _country = infoDataMap![ADD_PROPERTY_COUNTRY];
          _countrySlug = infoDataMap!["$ADD_PROPERTY_COUNTRY slug"];
          updateAreaFieldData(_country,_countrySlug ?? "");
        }
      }
    }
  }

  bool shouldUpdateFieldData(String key, String? checkValue) {
    if (infoDataMap!.containsKey(key)
        && infoDataMap![key] != null
        && infoDataMap![key] is String
        && infoDataMap![key].isNotEmpty
        && infoDataMap![key] != checkValue) {
      return true;
    }
    return false;
  }

  updateFieldData(String? checkValue, String slug) {
    // 1. if bigger region changes, then reset smaller region
    _selectedDataItem = null;
    _controller.text = "";
    // 2. if bigger region is updated, then show related smaller regions
    filterMetaData(checkValue,slug);
  }

  updateAreaFieldData(String? checkValue, String s) {
    // 1. if bigger region changes, then reset smaller region
    _selectedDataItem = null;
    _controller.text = "";
    // 2. if bigger region (country/state) is updated, then show all areas
    _termDataItemsList = _itemMetaDataList;
  }

  loadData (HouziFormItem formItem) {
    if (getTermDataFromStorage(formItem).isNotEmpty) {
      if (mounted) {
        setState(() {
          _termDataItemsList = getTermDataFromStorage(formItem);
          _itemMetaDataList = _termDataItemsList;
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
                _itemMetaDataList = termsMetaData;
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

  bool shouldHandleTermIdsData(String? termType) {
    if (termType != null &&
        termType.isNotEmpty &&
        (termType == propertyTypeDataType ||
            termType == propertyStatusDataType ||
            termType == propertyLabelDataType ||
            termType == propertyFeatureDataType)) {
      return true;
    }
    return false;
  }

  initializeSelectedItemId() {
    if (infoDataMap!.containsKey(apiKey) && infoDataMap![apiKey] != null) {
      if (infoDataMap![apiKey] is List) {
        _selectedItemId = infoDataMap![apiKey][0];
      } else if (infoDataMap![apiKey] is int) {
        _selectedItemId = infoDataMap![apiKey];
      }
    }
  }

  initializeSelectedItemName(String termType) {
    itemsNamesListKey = getItemsNamesListKey(termType);
    if (itemsNamesListKey != null &&
        infoDataMap!.containsKey(itemsNamesListKey) &&
        infoDataMap![itemsNamesListKey] != null) {
      if (infoDataMap![itemsNamesListKey] is List) {
        _selectedDataItem = infoDataMap![itemsNamesListKey][0];
      } else if (infoDataMap![itemsNamesListKey] is String) {
        _selectedDataItem = infoDataMap![itemsNamesListKey];
      }

      if (_selectedDataItem != null) {
        _controller.text =
            UtilityMethods.getLocalizedString(_selectedDataItem.toString());
      } else {
        _controller.text = "";
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
}
