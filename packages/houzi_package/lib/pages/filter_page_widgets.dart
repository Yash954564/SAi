import 'package:flutter/material.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/custom_fields.dart';
import 'package:houzi_package/models/filter_page_config.dart';
import 'package:houzi_package/widgets/add_property_widgets/custom_fields_widgets.dart';
import 'package:houzi_package/widgets/filter_page_widgets/keyword_widgets/custom_keyword_picker_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/keyword_widgets/keyword_custom_query_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/keyword_widgets/keyword_picker_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/location_widget.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/widgets/filter_page_widgets/meta_key_filter_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/range_slider_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/sequential_location_picker.dart';
import 'package:houzi_package/widgets/filter_page_widgets/string_picker.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker.dart';

typedef FilterPageWidgetsListener = void Function(
  Map<String, dynamic> filterPageWidgetsListener,
  String closeOption,
);

class FilterPageWidgets extends StatefulWidget {

  final FilterPageElement filterPageConfigData;
  final Map<String,dynamic> mapInitializeData;
  final FilterPageWidgetsListener filterPageWidgetsListener;

  const FilterPageWidgets({
    Key? key,
    required this.filterPageConfigData,
    required this.mapInitializeData,
    required this.filterPageWidgetsListener,
  }) : super(key: key);

  @override
  State<FilterPageWidgets> createState() => _FilterPageWidgetsState();
}

class _FilterPageWidgetsState extends State<FilterPageWidgets> {

  bool forReset = false;

  String _currency = '';
  String _areaType = '';
  String _selectedMinPrice = MIN_PRICE;
  String _selectedMaxPrice = MAX_PRICE;
  String _selectedMinArea = MIN_AREA;
  String _selectedMaxArea = MAX_AREA;
  String _keywordString = "";
  String _selectedAreaSymbol = MEASUREMENT_UNIT_TEXT;
  String _selectedCurrencySymbol = HiveStorageManager.readDefaultCurrencyInfoData() ?? "\$";

  String? filterPageElementTitle;
  String? filterPageElementDataType;
  String? filterPageElementPickerType;

  Map filterPageConfigElementMap = {};
  Map<String, dynamic> _dataInitializationMap = {};

  List<dynamic> _selectedBedroomsList = [];
  List<dynamic> _selectedBathroomsList = [];

  List<String> _bathroomsDataList = ["1", "2", "3", "4", "5", "6+"];
  List<String> _bedroomsDataList = ["1", "2", "3", "4", "5", "6+"];

  List<dynamic> _selectedPropertyTypesList = [];
  List<dynamic> _selectedPropertyStatusList = [];
  List<dynamic> _selectedPropertyLabelsList = [];
  List<dynamic> _selectedPropertyAreasList = [];
  List<dynamic> _selectedPropertyStatesList = [];
  List<dynamic> _selectedPropertyCountriesList = [];
  List<dynamic> _selectedPropertyFeaturesList = [];
  List<dynamic> _selectedPropertyCitiesList = [];

  List<dynamic> _selectedPropertyTypesSlugsList = [];
  List<dynamic> _selectedPropertyStatusSlugsList = [];
  List<dynamic> _selectedPropertyLabelsSlugsList = [];
  List<dynamic> _selectedPropertyAreasSlugsList = [];
  List<dynamic> _selectedPropertyStatesSlugsList = [];
  List<dynamic> _selectedPropertyCountriesSlugsList = [];
  List<dynamic> _selectedPropertyFeaturesSlugsList = [];
  List<dynamic> _selectedPropertyCitySlugsList = [];

  List<dynamic> _customFieldsList = [];
  List<String> _customFieldsSectionTypeList = [];

  VoidCallback? generalNotifierLister;

  TextEditingController keywordTextController = TextEditingController();
  Map<String,dynamic> _keywordFiltersDataMap = {};
  Map<String, dynamic> _tempMapHolder = {};


  @override
  void initState() {

    filterPageConfigElementMap = FilterPageElement.toMap(widget.filterPageConfigData);

    var data = HiveStorageManager.readCustomFieldsDataMaps();
    if(data != null){
      final custom = customFromJson(data);
      _customFieldsList = custom.customFields!;
      if(_customFieldsList.isNotEmpty){
        for(var customFieldItem in _customFieldsList){
          _customFieldsSectionTypeList.add(CUSTOM_FIELDS_SECTION_TYPE_TEMPLATE_KEY + customFieldItem.label);
        }
      }
    }

    generalNotifierLister = () {
      if (GeneralNotifier().change == GeneralNotifier.RESET_FILTER_DATA) {
        ResetFilterData();
      }

      if (isSectionTypePropertyLocation() || isWidgetTypeTermPropertyCity()) {
        if(GeneralNotifier().change == GeneralNotifier.CITY_DATA_UPDATE){
          Map cityData = HiveStorageManager.readSelectedCityInfo();
          if(cityData.isNotEmpty && cityData[CITY] != null && cityData[CITY].isNotEmpty) {
            Map<String, dynamic> map = HiveStorageManager.readFilterDataInfo();
            _dataInitializationMap.addAll(map);
            loadData();
            if(mounted) setState(() {});
          }
        }
      }
    };
    GeneralNotifier().addListener(generalNotifierLister!);

    _dataInitializationMap = widget.mapInitializeData;
    loadData();

    super.initState();
  }


  bool isSectionTypePropertyLocation() {
    if (filterPageConfigElementMap[sectionTypeKey] == locationPickerKey) {
      return true;
    }
    return false;
  }

  bool isWidgetTypeTermPropertyStatus() {
    if (filterPageConfigElementMap[sectionTypeKey] == termPickerKey &&
        filterPageConfigElementMap[dataTypeKey] == propertyStatusDataType) {
      return true;
    }
    return false;
  }
  bool isWidgetTypeTermPropertyType() {
    if (filterPageConfigElementMap[sectionTypeKey] == termPickerKey &&
        filterPageConfigElementMap[dataTypeKey] == propertyTypeDataType) {
      return true;
    }
    return false;
  }
  bool isWidgetTypeTermPropertyLabel() {
    if (filterPageConfigElementMap[sectionTypeKey] == termPickerKey &&
        filterPageConfigElementMap[dataTypeKey] == propertyLabelDataType) {
      return true;
    }
    return false;
  }
  bool isWidgetTypeTermPropertyArea() {
    if (filterPageConfigElementMap[sectionTypeKey] == termPickerKey &&
        filterPageConfigElementMap[dataTypeKey] == propertyAreaDataType) {
      return true;
    }
    return false;
  }
  bool isWidgetTypeTermPropertyState() {
    if (filterPageConfigElementMap[sectionTypeKey] == termPickerKey &&
        filterPageConfigElementMap[dataTypeKey] == propertyStateDataType) {
      return true;
    }
    return false;
  }
  bool isWidgetTypeTermPropertyCountry() {
    if (filterPageConfigElementMap[sectionTypeKey] == termPickerKey &&
        filterPageConfigElementMap[dataTypeKey] == propertyCountryDataType) {
      return true;
    }
    return false;
  }
  bool isWidgetTypeTermPropertyFeature() {
    if (filterPageConfigElementMap[sectionTypeKey] == termPickerKey &&
        filterPageConfigElementMap[dataTypeKey] == propertyFeatureDataType) {
      return true;
    }
    return false;
  }
  bool isWidgetTypeTermPropertyCity() {
    if (filterPageConfigElementMap[sectionTypeKey] == termPickerKey &&
        filterPageConfigElementMap[dataTypeKey] == propertyCityDataType) {
      return true;
    }
    return false;
  }

  bool isWidgetTypePriceRangePicker() {
    if (filterPageConfigElementMap[sectionTypeKey] == rangePickerKey &&
        filterPageConfigElementMap[dataTypeKey] == rangePickerPriceKey) {
      return true;
    }
    return false;
  }
  bool isWidgetTypeAreaRangePicker() {
    if (filterPageConfigElementMap[sectionTypeKey] == rangePickerKey &&
        filterPageConfigElementMap[dataTypeKey] == rangePickerAreaKey) {
      return true;
    }
    return false;
  }

  bool isWidgetTypeBedroomsStringPicker() {
    if (filterPageConfigElementMap[sectionTypeKey] == stringPickerKey &&
        filterPageConfigElementMap[dataTypeKey] == stringPickerBedroomsKey) {
      return true;
    }
    return false;
  }
  bool isWidgetTypeBathroomsStringPicker() {
    if (filterPageConfigElementMap[sectionTypeKey] == stringPickerKey &&
        filterPageConfigElementMap[dataTypeKey] == stringPickerBathroomsKey) {
      return true;
    }
    return false;
  }

  bool isSectionTypeKeyword() {
    if (filterPageConfigElementMap[sectionTypeKey] == keywordPickerKey) {
      return true;
    }
    return false;
  }

  bool isSectionTypeCustomKeywordPicker() {
    if (filterPageConfigElementMap[sectionTypeKey] == customKeywordPickerKey) {
      return true;
    }
    return false;
  }

  bool isSectionTypeMetaKeyPicker() {
    if (filterPageConfigElementMap[sectionTypeKey] == metaKeyPickerKey) {
      return true;
    }
    return false;
  }

  void loadData() {
    if (isWidgetTypePriceRangePicker()) {
      // Updating MAX_PRICE
      if (widget.filterPageConfigData.maxValue != null &&
          widget.filterPageConfigData.maxValue is String &&
          widget.filterPageConfigData.maxValue!.isNotEmpty) {
        MAX_PRICE = widget.filterPageConfigData.maxValue!;
        _selectedMaxPrice = MAX_PRICE;
      }

      // Updating MIN_PRICE
      if (widget.filterPageConfigData.minValue != null &&
          widget.filterPageConfigData.minValue is String &&
          widget.filterPageConfigData.minValue!.isNotEmpty) {
        MIN_PRICE = widget.filterPageConfigData.minValue!;
        _selectedMinPrice = MIN_PRICE;
      }
    }

    if (isSectionTypePropertyLocation()) {
      // Updating DEFAULT_RADIUS
      if (widget.filterPageConfigData.defaultRadius != null &&
          widget.filterPageConfigData.defaultRadius is String &&
          widget.filterPageConfigData.defaultRadius!.isNotEmpty) {
        DEFAULT_RADIUS = widget.filterPageConfigData.defaultRadius!;
      }
    }

    if (isWidgetTypeAreaRangePicker()) {
      // Updating MAX_AREA
      if (widget.filterPageConfigData.maxValue != null &&
          widget.filterPageConfigData.maxValue is String &&
          widget.filterPageConfigData.maxValue!.isNotEmpty) {
        MAX_AREA = widget.filterPageConfigData.maxValue!;
        _selectedMaxArea = MAX_AREA;
      }

      // Updating MIN_AREA
      if (widget.filterPageConfigData.minValue != null &&
          widget.filterPageConfigData.minValue is String &&
          widget.filterPageConfigData.minValue!.isNotEmpty) {
        MIN_AREA = widget.filterPageConfigData.minValue!;
        _selectedMinArea = MIN_AREA;
      }
    }

    if (_dataInitializationMap.isNotEmpty) {
      if (isWidgetTypeTermPropertyType()) {
        if (_dataInitializationMap.containsKey(PROPERTY_TYPE_SLUG) &&
            _dataInitializationMap[PROPERTY_TYPE_SLUG] != null &&
            _dataInitializationMap[PROPERTY_TYPE_SLUG].isNotEmpty) {
          var tempSlugList = _dataInitializationMap[PROPERTY_TYPE_SLUG];
          if (tempSlugList is String) {
            _selectedPropertyTypesSlugsList = [tempSlugList];
          } else if (tempSlugList is List) {
            _selectedPropertyTypesSlugsList = tempSlugList;
          }
        }

        if (_dataInitializationMap.containsKey(PROPERTY_TYPE) &&
            _dataInitializationMap[PROPERTY_TYPE] != null &&
            _dataInitializationMap[PROPERTY_TYPE].isNotEmpty) {
          var tempList = _dataInitializationMap[PROPERTY_TYPE];
          if (tempList is String) {
            _selectedPropertyTypesList = [tempList];
          } else if (tempList is List) {
            _selectedPropertyTypesList = tempList;
          }
        }
      }

      if (isWidgetTypeTermPropertyStatus()) {
        if (_dataInitializationMap.containsKey(PROPERTY_STATUS_SLUG) &&
            _dataInitializationMap[PROPERTY_STATUS_SLUG] != null &&
            _dataInitializationMap[PROPERTY_STATUS_SLUG].isNotEmpty) {
          var tempSlugList = _dataInitializationMap[PROPERTY_STATUS_SLUG];
          if (tempSlugList is String) {
            _selectedPropertyStatusSlugsList = [tempSlugList];
          } else if (tempSlugList is List) {
            _selectedPropertyStatusSlugsList = tempSlugList;
          }
        }

        if (_dataInitializationMap.containsKey(PROPERTY_STATUS) &&
            _dataInitializationMap[PROPERTY_STATUS] != null &&
            _dataInitializationMap[PROPERTY_STATUS].isNotEmpty) {
          var tempStatusList = _dataInitializationMap[PROPERTY_STATUS];
          if (tempStatusList is String) {
            _selectedPropertyStatusList = [tempStatusList];
          } else if (tempStatusList is List) {
            _selectedPropertyStatusList = tempStatusList;
          }
        }
      }

      if (isWidgetTypeTermPropertyLabel()) {
        if (_dataInitializationMap.containsKey(PROPERTY_LABEL_SLUG) &&
            _dataInitializationMap[PROPERTY_LABEL_SLUG] != null &&
            _dataInitializationMap[PROPERTY_LABEL_SLUG].isNotEmpty) {
          var tempList = _dataInitializationMap[PROPERTY_LABEL_SLUG];
          if (tempList is String) {
            _selectedPropertyLabelsSlugsList = [tempList];
          } else if (tempList is List) {
            _selectedPropertyLabelsSlugsList = tempList;
          }
        }

        if (_dataInitializationMap.containsKey(PROPERTY_LABEL) &&
            _dataInitializationMap[PROPERTY_LABEL] != null &&
            _dataInitializationMap[PROPERTY_LABEL].isNotEmpty) {
          var tempList = _dataInitializationMap[PROPERTY_LABEL];
          if (tempList is String) {
            _selectedPropertyLabelsList = [tempList];
          } else if (tempList is List) {
            _selectedPropertyLabelsList = tempList;
          }
        }
      }

      if (isWidgetTypeTermPropertyArea()) {
        if (_dataInitializationMap.containsKey(PROPERTY_AREA_SLUG) &&
            _dataInitializationMap[PROPERTY_AREA_SLUG] != null &&
            _dataInitializationMap[PROPERTY_AREA_SLUG].isNotEmpty) {
          if(mounted){
            setState(() {
              var tempList = _dataInitializationMap[PROPERTY_AREA_SLUG];
              if (tempList is String) {
                _selectedPropertyAreasSlugsList = [tempList];
              } else if (tempList is List) {
                _selectedPropertyAreasSlugsList = tempList;
              }
            });
          }
        }

        if (_dataInitializationMap.containsKey(PROPERTY_AREA) &&
            _dataInitializationMap[PROPERTY_AREA] != null &&
            _dataInitializationMap[PROPERTY_AREA].isNotEmpty) {
          var tempList = _dataInitializationMap[PROPERTY_AREA];
          if (tempList is String) {
            _selectedPropertyAreasList = [tempList];
          } else if (tempList is List) {
            _selectedPropertyAreasList = tempList;
          }
        }
      }

      if (isWidgetTypeTermPropertyState()) {
        if (_dataInitializationMap.containsKey(PROPERTY_STATE_SLUG) &&
            _dataInitializationMap[PROPERTY_STATE_SLUG] != null &&
            _dataInitializationMap[PROPERTY_STATE_SLUG].isNotEmpty) {
          var tempList = _dataInitializationMap[PROPERTY_STATE_SLUG];
          if (tempList is String) {
            _selectedPropertyStatesSlugsList = [tempList];
          } else if (tempList is List) {
            _selectedPropertyStatesSlugsList = tempList;
          }
        }

        if (_dataInitializationMap.containsKey(PROPERTY_STATE) &&
            _dataInitializationMap[PROPERTY_STATE] != null &&
            _dataInitializationMap[PROPERTY_STATE].isNotEmpty) {
          var tempList = _dataInitializationMap[PROPERTY_STATE];
          if (tempList is String) {
            _selectedPropertyStatesList = [tempList];
          } else if (tempList is List) {
            _selectedPropertyStatesList = tempList;
          }
        }
      }

      if (isWidgetTypeTermPropertyCountry()) {
        if (_dataInitializationMap.containsKey(PROPERTY_COUNTRY_SLUG) &&
            _dataInitializationMap[PROPERTY_COUNTRY_SLUG] != null &&
            _dataInitializationMap[PROPERTY_COUNTRY_SLUG].isNotEmpty) {
          var tempList = _dataInitializationMap[PROPERTY_COUNTRY_SLUG];
          if (tempList is String) {
            _selectedPropertyCountriesSlugsList = [tempList];
          } else if (tempList is List) {
            _selectedPropertyCountriesSlugsList = tempList;
          }
        }

        if (_dataInitializationMap.containsKey(PROPERTY_COUNTRY) &&
            _dataInitializationMap[PROPERTY_COUNTRY] != null &&
            _dataInitializationMap[PROPERTY_COUNTRY].isNotEmpty) {
          var tempList = _dataInitializationMap[PROPERTY_COUNTRY];
          if (tempList is String) {
            _selectedPropertyCountriesList = [tempList];
          } else if (tempList is List) {
            _selectedPropertyCountriesList = tempList;
          }
        }
      }

      if (isWidgetTypeTermPropertyFeature()) {
        if (_dataInitializationMap.containsKey(PROPERTY_FEATURES_SLUG) &&
            _dataInitializationMap[PROPERTY_FEATURES_SLUG] != null &&
            _dataInitializationMap[PROPERTY_FEATURES_SLUG].isNotEmpty) {
          var tempList = _dataInitializationMap[PROPERTY_FEATURES_SLUG];
          if (tempList is String) {
            _selectedPropertyFeaturesSlugsList = [tempList];
          } else if (tempList is List) {
            _selectedPropertyFeaturesSlugsList = tempList;
          }
        }

        if (_dataInitializationMap.containsKey(PROPERTY_FEATURES) &&
            _dataInitializationMap[PROPERTY_FEATURES] != null &&
            _dataInitializationMap[PROPERTY_FEATURES].isNotEmpty) {
          var tempList = _dataInitializationMap[PROPERTY_FEATURES];
          if (tempList is String) {
            _selectedPropertyFeaturesList = [tempList];
          } else if (tempList is List) {
            _selectedPropertyFeaturesList = tempList;
          }
        }
      }

      if (isSectionTypePropertyLocation() || isWidgetTypeTermPropertyCity()) {
        if (_dataInitializationMap.containsKey(CITY_SLUG) &&
            _dataInitializationMap[CITY_SLUG] != null &&
            _dataInitializationMap[CITY_SLUG].isNotEmpty) {
          var tempList = _dataInitializationMap[CITY_SLUG];
          if (tempList is String) {
            _selectedPropertyCitySlugsList = [tempList];
          } else if (tempList is List) {
            _selectedPropertyCitySlugsList = tempList;
          }
        }

        if (_dataInitializationMap.containsKey(CITY) &&
            _dataInitializationMap[CITY] != null &&
            _dataInitializationMap[CITY].isNotEmpty) {
          var tempList = _dataInitializationMap[CITY];
          if (tempList is String) {
            _selectedPropertyCitiesList = [tempList];
          } else if (tempList is List) {
            _selectedPropertyCitiesList = tempList;
          }
        }
      }

      if (isWidgetTypePriceRangePicker()) {
        if (_dataInitializationMap.containsKey(PRICE_MIN) &&
            _dataInitializationMap[PRICE_MIN] != null &&
            _dataInitializationMap[PRICE_MIN].isNotEmpty) {
          _selectedMinPrice = _dataInitializationMap[PRICE_MIN];
        } else {
          _selectedMinPrice = MIN_PRICE;
        }

        if (_dataInitializationMap.containsKey(PRICE_MAX) &&
            _dataInitializationMap[PRICE_MAX] != null &&
            _dataInitializationMap[PRICE_MAX].isNotEmpty) {
          _selectedMaxPrice = _dataInitializationMap[PRICE_MAX];
        } else {
          _selectedMaxPrice = MAX_PRICE;
        }
      }

      if (isWidgetTypeAreaRangePicker()) {
        if (_dataInitializationMap.containsKey(AREA_MIN) &&
            _dataInitializationMap[AREA_MIN] != null &&
            _dataInitializationMap[AREA_MIN].isNotEmpty) {
          _selectedMinArea = _dataInitializationMap[AREA_MIN];
        } else {
          _selectedMinArea = MIN_AREA;
        }

        if (_dataInitializationMap.containsKey(AREA_MAX) &&
            _dataInitializationMap[AREA_MAX] != null &&
            _dataInitializationMap[AREA_MAX].isNotEmpty) {
          _selectedMaxArea = _dataInitializationMap[AREA_MAX];
        } else {
          _selectedMaxArea = MAX_AREA;
        }
      }

      if (isWidgetTypeBedroomsStringPicker()) {
        if (_dataInitializationMap.containsKey(BEDROOMS) &&
            _dataInitializationMap[BEDROOMS] != null &&
            _dataInitializationMap[BEDROOMS].isNotEmpty) {
          if(_dataInitializationMap[BEDROOMS] is List) {
            _selectedBedroomsList = _dataInitializationMap[BEDROOMS];
          } else {
            _selectedBedroomsList = [_dataInitializationMap[BEDROOMS]];
          }

        } else {
          _selectedBedroomsList = [];
        }
      }

      if (isWidgetTypeBathroomsStringPicker()) {
        if (_dataInitializationMap.containsKey(BATHROOMS) &&
            _dataInitializationMap[BATHROOMS] != null &&
            _dataInitializationMap[BATHROOMS].isNotEmpty) {
          if(_dataInitializationMap[BATHROOMS] is List) {
            _selectedBathroomsList = _dataInitializationMap[BATHROOMS];
          } else {
            _selectedBathroomsList = [_dataInitializationMap[BATHROOMS]];
          }
        } else {
          _selectedBathroomsList = [];
        }
      }

      if (isSectionTypeKeyword()) {
        if (_dataInitializationMap.containsKey(PROPERTY_KEYWORD) &&
            _dataInitializationMap[PROPERTY_KEYWORD] != null &&
            _dataInitializationMap[PROPERTY_KEYWORD].isNotEmpty &&
            _dataInitializationMap[PROPERTY_KEYWORD] is String) {
          _keywordString = _dataInitializationMap[PROPERTY_KEYWORD];
          keywordTextController.text = UtilityMethods.getLocalizedString(_keywordString);
        } else {
          _keywordString = "";
          keywordTextController.text = UtilityMethods.getLocalizedString(_keywordString);
        }
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    if (generalNotifierLister != null) {
      GeneralNotifier().removeListener(generalNotifierLister!);
    }

    _tempMapHolder = {};

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    switch(filterPageConfigElementMap[sectionTypeKey]) {
      case (locationPickerKey): {
        return LocationWidget(
          showSearchBar: true,
          pickerType: widget.filterPageConfigData.pickerType!,
          fromFilterPage: true,
          filterPageConfigData: widget.filterPageConfigData,
          filterDataMap: widget.mapInitializeData,
          selectedPropertyCitiesList: getSelectedTermDataList(propertyCityDataType),
          selectedPropertyCitySlugsList: getSelectedTermSlugsList(propertyCityDataType),
          locationWidgetListener: ({closeOption, filterDataMap, selectedTermsList, selectedTermsSlugsList}) {

            if(filterDataMap != null && closeOption != null){
              widget.filterPageWidgetsListener(filterDataMap, closeOption);
            }

            if(selectedTermsList != null && selectedTermsSlugsList != null){
              updateTermPickerData(
                termDataType: propertyCityDataType,
                selectedTermsList: selectedTermsList,
                selectedTermSlugsList: selectedTermsSlugsList,
              );
            }
          },
        );
      }

      case (termPickerKey): {
        return genericTermPickerWidget(
            filterPageElement: widget.filterPageConfigData);
      }

      case (rangePickerKey): {
        return genericRangePickerWidget(
            filterPageElement: widget.filterPageConfigData);
      }

      case (stringPickerKey): {
        return genericStringPickerWidget(
            filterPageElement: widget.filterPageConfigData);
      }

      case (keywordPickerKey): {
        return genericKeywordWidget(filterPageElement: widget.filterPageConfigData);
      }

      case (customKeywordPickerKey): {
        return genericCustomKeywordWidget(
            filterPageElement: widget.filterPageConfigData);
      }

      case (metaKeyPickerKey): {
        return MetaKeyPickerWidget(
          configItem: widget.filterPageConfigData,
          initializeDataMap: widget.mapInitializeData,
          listener: (dataMap) {
            if (mounted) {
              setState(() {
                if (_dataInitializationMap[metaKeyFiltersKey] != null) {
                  _tempMapHolder = Map<String, dynamic>.from(_dataInitializationMap[metaKeyFiltersKey]);
                } else {
                  _tempMapHolder = {};
                }

                _tempMapHolder.addAll(dataMap);
                _dataInitializationMap[metaKeyFiltersKey] = _tempMapHolder;
                widget.filterPageWidgetsListener(_dataInitializationMap, "");
              });
            }
          },
        );
      }

      case (keywordCustomQueryPickerKey): {
        return genericKeywordCustomQueryWidget(
            filterPageElement: widget.filterPageConfigData);
      }

      case (sequentialLocationPickerTypeKey): {
        return FilterSequentialLocationPickerWidget(
          item: widget.filterPageConfigData,
          listener: (map) => updateSequentialLocationPickerData(map),
        );
      }

      default: {
        String tempSectionTypeKey =
            filterPageConfigElementMap[sectionTypeKey] ?? "";
        if (_customFieldsSectionTypeList.isNotEmpty &&
            _customFieldsSectionTypeList.contains(tempSectionTypeKey)) {
          return genericCustomFieldWidget(
              filterPageElement: widget.filterPageConfigData);
        }

        return Container();
      }
    }
  }

  Widget genericCustomFieldWidget({
    required FilterPageElement filterPageElement,
  }){
    String _tempSectionType = filterPageElement.sectionType!;
    String _tempCustomFieldLabel = _tempSectionType.replaceAll(CUSTOM_FIELDS_SECTION_TYPE_TEMPLATE_KEY, "");
    if(_customFieldsList.isNotEmpty) {
      for (var customFieldItem in _customFieldsList) {
        if(customFieldItem.label == _tempCustomFieldLabel){
          return CustomFieldsWidget(
            fromFilterPage: true,
            customFieldData: customFieldItem,
            propertyInfoMap: _dataInitializationMap.containsKey(PROPERTY_CUSTOM_FIELDS) ?
            _dataInitializationMap[PROPERTY_CUSTOM_FIELDS] : {},
            customFieldsPageListener: (Map<String, dynamic> dataMap){
              if(dataMap.isNotEmpty){
                Map tempDataMap = {};
                // _dataInitializationMap.addAll(dataMap);
                if(_dataInitializationMap.containsKey(PROPERTY_CUSTOM_FIELDS)){
                  tempDataMap.addAll(_dataInitializationMap[PROPERTY_CUSTOM_FIELDS]);
                  tempDataMap.addAll(dataMap);
                }else{
                  tempDataMap.addAll(dataMap);
                }

                if(tempDataMap.containsKey("selectedRadioButton")){
                  tempDataMap.remove("selectedRadioButton");
                }

                _dataInitializationMap[PROPERTY_CUSTOM_FIELDS] = tempDataMap;
                widget.filterPageWidgetsListener(_dataInitializationMap, "");
                if(mounted) setState(() {});
              }
            },
          );
        }
      }
    }

    return Container();

    // return CustomFieldsWidget(
    //   customFieldData: e,
    //   // propertyInfoMap: widget.propertyInfoMap,
    //   customFieldsPageListener: (Map<String, dynamic> _dataMap){
    //     // dataMap.addAll(_dataMap);
    //   },
    // );
  }


  Widget genericTermPickerWidget({
  required FilterPageElement filterPageElement,
}){
    // IconData iconData = GenericMethods.fromJsonToIconData(filterPageElement.iconData);
    String title = filterPageElement.title!;
    String dataType = filterPageElement.dataType!;
    String pickerType = filterPageElement.pickerType!;

    return TermPicker(
      objDataType: dataType,
      pickerTitle: UtilityMethods.getLocalizedString(title),
      pickerType: pickerType,
      showSearchBar: true,
      pickerIcon: Icon(
        // iconData,
        getTermPickerIconData(dataType),
        size: AppThemePreferences.filterPageTermPickerIconSize,
        color: AppThemePreferences().appTheme.filterPageIconsColor,
      ),
      selectedTermsList: getSelectedTermDataList(dataType),
      selectedTermsSlugsList: getSelectedTermSlugsList(dataType),
      filterDataMap: widget.mapInitializeData,
      termPickerListener: (List<dynamic> selectedTermSlugs, List<dynamic> selectedTerms) {
        updateTermPickerData(
           termDataType: dataType,
           selectedTermsList: selectedTerms,
           selectedTermSlugsList: selectedTermSlugs,
        );
      },
    );
  }

  Widget genericStringPickerWidget({
    required FilterPageElement filterPageElement,
  }){
    // IconData iconData = GenericMethods.fromJsonToIconData(filterPageElement.iconData);
    String title = filterPageElement.title!;
    String dataType = filterPageElement.dataType!;
    String pickerType = filterPageElement.pickerType!;
    String? options = filterPageElement.options;

    return StringPicker(
      pickerTitle: UtilityMethods.getLocalizedString(title),
      pickerType: pickerType,
      pickerIcon: Icon(
        // iconData,
        getStringPickerIconData(dataType),
        size: AppThemePreferences.filterPageStringPickerIconSize,
        color: AppThemePreferences().appTheme.filterPageIconsColor,
      ),
      pickerDataList: getStringPickerDataList(dataType, options: options),
      selectedItemsList: getStringPickerSelectedItemsDataList(dataType),
      stringPickerListener: (List<dynamic> _selectedItemsList){
        updateStringPickerData(
          dataType: dataType,
          selectedItemsList: _selectedItemsList,
        );
      }
    );
  }

  Widget genericRangePickerWidget({
    required FilterPageElement filterPageElement,
  }){
    // IconData iconData = GenericMethods.fromJsonToIconData(filterPageElement.iconData);
    String title = filterPageElement.title!;
    String dataType = filterPageElement.dataType!;
    String pickerType = filterPageElement.pickerType!;
    String rangeMinValue = filterPageElement.minValue!;
    String rangeMaxValue = filterPageElement.maxValue!;

    return RangePickerWidget(
      pickerTitle: UtilityMethods.getLocalizedString(title),
      pickerType: pickerType,
      pickerIcon: Icon(
        // iconData,
        getRangePickerIconData(dataType),
        size: AppThemePreferences.filterPageRangePickerIconSize,
        color: AppThemePreferences().appTheme.filterPageIconsColor,
      ),
      minRange: double.parse(rangeMinValue),
      maxRange: double.parse(rangeMaxValue),
      selectedMinRange: getSelectedMinRange(dataType, rangeMinValue),
      selectedMaxRange: getSelectedMaxRange(dataType, rangeMaxValue),
      pickerSelectedSymbol: getSelectedSymbol(dataType)!,
      // bottomSheetMenuTitle: getBottomSheetMenuTitle(dataType),
      // mapOfBottomSheetMenu: getBottomSheetMenu(dataType),
      rangePickerListener: (String _selectedSymbol, String _minSelectedRange, String _maxSelectedRange){
        updateRangePickerData(
          dataType: dataType,
          selectedSymbol: _selectedSymbol,
          selectedMinRange: _minSelectedRange,
          selectedMaxRange: _maxSelectedRange,
        );
      },
    );
  }

  Widget genericKeywordWidget({
    required FilterPageElement filterPageElement,
  }){
    // IconData iconData = GenericMethods.fromJsonToIconData(filterPageElement.iconData);
    String title = filterPageElement.title!;
    String pickerType = filterPageElement.pickerType!;

    return KeywordPickerWidget(
      pickerTitle: UtilityMethods.getLocalizedString(title),
      pickerType: pickerType,
      pickerIcon: Icon(
        // AppThemePreferences.keywordIcon,
        AppThemePreferences.keywordCupertinoIcon,
        size: AppThemePreferences.filterPageRangePickerIconSize,
        color: AppThemePreferences().appTheme.filterPageIconsColor,
      ),
      textEditingController: keywordTextController,
      filterObj: filterPageElement,
      dataMap: _dataInitializationMap,
      listener: (String keyword) {
        _keywordString = keyword;
        _dataInitializationMap[PROPERTY_KEYWORD] = _keywordString;
        widget.filterPageWidgetsListener(_dataInitializationMap, "");
        if (mounted) setState(() {});
      }
    );
  }

  Widget genericCustomKeywordWidget({
    required FilterPageElement filterPageElement,
  }){
    // IconData iconData = GenericMethods.fromJsonToIconData(filterPageElement.iconData);
    String title = filterPageElement.title!;
    String pickerType = filterPageElement.pickerType!;
    String? uniqueKey = filterPageElement.uniqueKey;
    String? queryType = filterPageElement.queryType;

    if (uniqueKey == null) {
      filterPageElement.uniqueKey = KEYWORD_DEFAULT_KEY;
      uniqueKey = KEYWORD_DEFAULT_KEY;
    }

    if (queryType == null) {
      filterPageElement.queryType = KEYWORD_DEFAULT_QUERY_TYPE;
      queryType = KEYWORD_DEFAULT_QUERY_TYPE;
    }

    return CustomKeywordPickerWidget(
        pickerTitle: UtilityMethods.getLocalizedString(title),
        pickerType: pickerType,
        pickerIcon: Icon(
          // AppThemePreferences.keywordIcon,
          AppThemePreferences.keywordCupertinoIcon,
          size: AppThemePreferences.filterPageRangePickerIconSize,
          color: AppThemePreferences().appTheme.filterPageIconsColor,
        ),
        // textEditingController: keywordTextController,
        filterObj: filterPageElement,
        dataMap: _dataInitializationMap,
        listener: (String keyword) {
          _keywordString = keyword;

          if (uniqueKey != null && uniqueKey!.isNotEmpty) {

            if (!uniqueKey!.contains(KEYWORD_PREFIX)) {
              uniqueKey = KEYWORD_PREFIX + uniqueKey!;
            }

            _keywordFiltersDataMap[uniqueKey!] = {
              keywordFiltersUniqueIdKey : uniqueKey!,
              keywordFiltersValueKey : _keywordString,
              keywordFiltersQueryTypeKey : queryType,
            };

            if (_dataInitializationMap[keywordFiltersKey] != null) {
              _tempMapHolder = Map<String, dynamic>.from(
                  _dataInitializationMap[keywordFiltersKey]);
            } else {
              _tempMapHolder = {};
            }

            _tempMapHolder.addAll(_keywordFiltersDataMap);
            _dataInitializationMap[keywordFiltersKey] = _tempMapHolder;
          }

          widget.filterPageWidgetsListener(_dataInitializationMap, "");
          if (mounted) setState(() {});
        }
    );
  }

  Widget genericKeywordCustomQueryWidget({
    required FilterPageElement filterPageElement,
  }){
    // IconData iconData = GenericMethods.fromJsonToIconData(filterPageElement.iconData);
    String? uniqueKey = filterPageElement.uniqueKey;
    String? queryType = filterPageElement.queryType;

    if (uniqueKey == null) {
      filterPageElement.uniqueKey = KEYWORD_DEFAULT_KEY;
      uniqueKey = KEYWORD_DEFAULT_KEY;
    }

    if (queryType == null) {
      filterPageElement.queryType = KEYWORD_DEFAULT_QUERY_TYPE;
      queryType = KEYWORD_DEFAULT_QUERY_TYPE;
    }

    return KeywordCustomQueryWidget(
        pickerIcon: Icon(
          // AppThemePreferences.keywordIcon,
          AppThemePreferences.keywordCupertinoIcon,
          size: AppThemePreferences.filterPageRangePickerIconSize,
          color: AppThemePreferences().appTheme.filterPageIconsColor,
        ),
        filterObj: filterPageElement,
        filterDataMap: _dataInitializationMap,
        listener: (String keyword) {
          _keywordString = keyword;

          if (uniqueKey != null && uniqueKey!.isNotEmpty) {

            if (!uniqueKey!.contains(KEYWORD_PREFIX)) {
              uniqueKey = KEYWORD_PREFIX + uniqueKey!;
            }

            if (_keywordString.isNotEmpty) {
              _keywordFiltersDataMap[uniqueKey!] = {
                keywordFiltersUniqueIdKey : uniqueKey!,
                keywordFiltersValueKey : _keywordString,
                keywordFiltersQueryTypeKey : queryType,
                keywordFiltersCustomQueryTitleKey : filterPageElement.title,
              };
            } else {
              _keywordFiltersDataMap.remove(uniqueKey!);
            }

            if (_dataInitializationMap[keywordFiltersKey] != null) {
              _tempMapHolder = Map<String, dynamic>.from(
                  _dataInitializationMap[keywordFiltersKey]);
            } else {
              _tempMapHolder = {};
            }

            if (!_keywordFiltersDataMap.containsKey(uniqueKey!)){
              _tempMapHolder.remove(uniqueKey!);
            } else {
              _tempMapHolder.addAll(_keywordFiltersDataMap);
            }

            _dataInitializationMap[keywordFiltersKey] = _tempMapHolder;
          }

          widget.filterPageWidgetsListener(_dataInitializationMap, "");
          if (mounted) setState(() {});
        }
    );
  }

  ResetFilterData(){
    if (mounted) {
      setState(() {
        _dataInitializationMap.clear();
        if(isWidgetTypeTermPropertyStatus()){
          _dataInitializationMap[PROPERTY_STATUS] = _selectedPropertyStatusList = [];
          _dataInitializationMap[PROPERTY_STATUS_SLUG] = _selectedPropertyStatusSlugsList = [];
        }
        if(isWidgetTypeTermPropertyType()){
          _dataInitializationMap[PROPERTY_TYPE] = _selectedPropertyTypesList =  [];
          _dataInitializationMap[PROPERTY_TYPE_SLUG] = _selectedPropertyTypesSlugsList =  [];
        }
        if(isWidgetTypeTermPropertyLabel()){
          _dataInitializationMap[PROPERTY_LABEL] = _selectedPropertyLabelsList = [];
          _dataInitializationMap[PROPERTY_LABEL_SLUG] = _selectedPropertyLabelsSlugsList = [];
        }
        if(isWidgetTypeTermPropertyArea()){
          _dataInitializationMap[PROPERTY_AREA] = _selectedPropertyAreasList = [];
          _dataInitializationMap[PROPERTY_AREA_SLUG] = _selectedPropertyAreasSlugsList = [];
        }
        if(isWidgetTypeTermPropertyState()){
          _dataInitializationMap[PROPERTY_STATE] = _selectedPropertyStatesList = [];
          _dataInitializationMap[PROPERTY_STATE_SLUG] = _selectedPropertyStatesSlugsList = [];
        }
        if(isWidgetTypeTermPropertyCountry()){
          _dataInitializationMap[PROPERTY_COUNTRY] = _selectedPropertyCountriesList = [];
          _dataInitializationMap[PROPERTY_COUNTRY_SLUG] = _selectedPropertyCountriesSlugsList = [];
        }
        if(isWidgetTypeTermPropertyFeature()){
          _dataInitializationMap[PROPERTY_FEATURES] = _selectedPropertyFeaturesList = [];
          _dataInitializationMap[PROPERTY_FEATURES_SLUG] = _selectedPropertyFeaturesSlugsList = [];
        }
        if(isWidgetTypeTermPropertyCity()){
          _dataInitializationMap[CITY_ID] = null;
          _dataInitializationMap[CITY] = _selectedPropertyCitiesList = [];
          _dataInitializationMap[CITY_SLUG] = _selectedPropertyCitySlugsList = [];
        }

        if(isSectionTypePropertyLocation()){
          _dataInitializationMap[CITY] = "";
          _dataInitializationMap[CITY_ID] = null;
          _dataInitializationMap[CITY_SLUG] = "";
          _dataInitializationMap[LATITUDE] = "";
          _dataInitializationMap[LONGITUDE] = "";
          _dataInitializationMap[SELECTED_LOCATION] = PLEASE_SELECT;
          _dataInitializationMap[RADIUS] = "50.0";
          _dataInitializationMap[USE_RADIUS] = "off";
          _dataInitializationMap[SEARCH_LOCATION] = "false";
        }

        if(isWidgetTypePriceRangePicker()){
          _dataInitializationMap.remove(PRICE_MIN);
          _dataInitializationMap.remove(PRICE_MAX);
          _selectedMinPrice = MIN_PRICE;
          _selectedMaxPrice = MAX_PRICE;
        }

        if(isWidgetTypeAreaRangePicker()){
          _dataInitializationMap.remove(AREA_MIN);
          _dataInitializationMap.remove(AREA_MAX);
          _selectedMaxArea = MAX_AREA;
          _selectedMinArea = MIN_AREA;
        }

        if(isWidgetTypeBedroomsStringPicker()){
          _selectedBedroomsList = [];
          _dataInitializationMap.remove(BEDROOMS);
        }
        if(isWidgetTypeBathroomsStringPicker()){
          _selectedBathroomsList = [];
          _dataInitializationMap.remove(BATHROOMS);
        }

        if(isSectionTypeKeyword()){
          _keywordString = "";
          keywordTextController.text = "";
          _dataInitializationMap.remove(PROPERTY_KEYWORD);
        }

        if (isSectionTypeCustomKeywordPicker()) {
          _dataInitializationMap.remove(keywordFiltersKey);
        }

        if(isSectionTypeMetaKeyPicker()){
          _dataInitializationMap.remove(metaKeyFiltersKey);
        }
      });
    }


    HiveStorageManager.storeFilterDataInfo(map: _dataInitializationMap);
    HiveStorageManager.storeSelectedCityInfo(data: {});
    widget.filterPageWidgetsListener(_dataInitializationMap, RESET);
  }

  IconData getTermPickerIconData(String dataType) {
    if(dataType == propertyStatusDataType){
      return AppThemePreferences.checkCircleIcon;
    }
    if(dataType == propertyCityDataType){
      return AppThemePreferences.locationIcon;
    }
    if(dataType == propertyLabelDataType){
      return AppThemePreferences.labelIcon;
    }
    if(dataType == propertyTypeDataType){
      return AppThemePreferences.locationCityIcon;
    }
    if(dataType == propertyFeatureDataType){
      return AppThemePreferences.featureChipIcon;
    }
    if(dataType == propertyCountryDataType){
      return AppThemePreferences.locationCountryIcon;
    }
    if(dataType == propertyStateDataType){
      return AppThemePreferences.locationStateIcon;
    }
    if(dataType == propertyAreaDataType) {
      return AppThemePreferences.locationAreaIcon;
    }

    return AppThemePreferences.locationCityIcon;
  }

  List<dynamic> getSelectedTermDataList(String termDataType){
    if(termDataType == propertyStatusDataType){
      return _selectedPropertyStatusList;
    }
    else if(termDataType == propertyTypeDataType){
      return _selectedPropertyTypesList;
    }
    else if(termDataType == propertyLabelDataType){
      return _selectedPropertyLabelsList;
    }
    else if(termDataType == propertyAreaDataType){
      return _selectedPropertyAreasList;
    }
    else if(termDataType == propertyStateDataType){
      return _selectedPropertyStatesList;
    }
    else if(termDataType == propertyCountryDataType){
      return _selectedPropertyCountriesList;
    }
    else if(termDataType == propertyFeatureDataType){
      return _selectedPropertyFeaturesList;
    }
    else if(termDataType == propertyCityDataType){
      return _selectedPropertyCitiesList;
    }
    return [];
  }

  List<dynamic> getSelectedTermSlugsList(String termDataType){
    if(termDataType == propertyStatusDataType){
      return _selectedPropertyStatusSlugsList;
    }
    else if(termDataType == propertyTypeDataType){
      return _selectedPropertyTypesSlugsList;
    }
    else if(termDataType == propertyLabelDataType){
      return _selectedPropertyLabelsSlugsList;
    }
    else if(termDataType == propertyAreaDataType){
      return _selectedPropertyAreasSlugsList;
    }
    else if(termDataType == propertyStateDataType){
      return _selectedPropertyStatesSlugsList;
    }
    else if(termDataType == propertyCountryDataType){
      return _selectedPropertyCountriesSlugsList;
    }
    else if(termDataType == propertyFeatureDataType){
      return _selectedPropertyFeaturesSlugsList;
    }
    else if(termDataType == propertyCityDataType){
      return _selectedPropertyCitySlugsList;
    }
    return [];
  }

  updateTermPickerData({
    required String termDataType,
    required List<dynamic> selectedTermsList,
    required List<dynamic> selectedTermSlugsList,
}){
   if(termDataType == propertyStatusDataType){
     _selectedPropertyStatusList = selectedTermsList;
     _selectedPropertyStatusSlugsList = selectedTermSlugsList;
     _dataInitializationMap[PROPERTY_STATUS] = _selectedPropertyStatusList.toSet().toList();
     _dataInitializationMap[PROPERTY_STATUS_SLUG] = _selectedPropertyStatusSlugsList.toSet().toList();
     _dataInitializationMap[PROPERTY_STATUS_QUERY_TYPE] = widget.filterPageConfigData.queryType;
   }
   else if(termDataType == propertyTypeDataType){
     _selectedPropertyTypesList = selectedTermsList;
     _selectedPropertyTypesSlugsList = selectedTermSlugsList;
     _dataInitializationMap[PROPERTY_TYPE] = _selectedPropertyTypesList.toSet().toList();
     _dataInitializationMap[PROPERTY_TYPE_SLUG] = _selectedPropertyTypesSlugsList.toSet().toList();
     _dataInitializationMap[PROPERTY_TYPE_QUERY_TYPE] = widget.filterPageConfigData.queryType;
     _dataInitializationMap[termPickerTypeKey] = widget.filterPageConfigData.pickerType;
   }
   else if(termDataType == propertyLabelDataType){
     _selectedPropertyLabelsList = selectedTermsList;
     _selectedPropertyLabelsSlugsList = selectedTermSlugsList;
     _dataInitializationMap[PROPERTY_LABEL] = _selectedPropertyLabelsList.toSet().toList();
     _dataInitializationMap[PROPERTY_LABEL_SLUG] = _selectedPropertyLabelsSlugsList.toSet().toList();
     _dataInitializationMap[PROPERTY_LABEL_QUERY_TYPE] = widget.filterPageConfigData.queryType;
   }
   else if(termDataType == propertyAreaDataType){
     _selectedPropertyAreasList = selectedTermsList;
     _selectedPropertyAreasSlugsList = selectedTermSlugsList;
     if (_selectedPropertyAreasList.isNotEmpty) {
       _dataInitializationMap[PROPERTY_AREA] = _selectedPropertyAreasList.toSet().toList();
     }
     if (_selectedPropertyAreasSlugsList.isNotEmpty) {
       _dataInitializationMap[PROPERTY_AREA_SLUG] = _selectedPropertyAreasSlugsList.toSet().toList();
     }
     _dataInitializationMap[PROPERTY_AREA_QUERY_TYPE] = widget.filterPageConfigData.queryType;
     HiveStorageManager.storeFilterDataInfo(map: _dataInitializationMap);
     GeneralNotifier().publishChange(GeneralNotifier.AREA_DATA_UPDATE);
   }
   else if(termDataType == propertyStateDataType){
     _selectedPropertyStatesList = selectedTermsList;
     _selectedPropertyStatesSlugsList = selectedTermSlugsList;
     _dataInitializationMap[PROPERTY_STATE] = _selectedPropertyStatesList.toSet().toList();
     _dataInitializationMap[PROPERTY_STATE_SLUG] = _selectedPropertyStatesSlugsList.toSet().toList();
     _dataInitializationMap[PROPERTY_STATE_QUERY_TYPE] = widget.filterPageConfigData.queryType;
     HiveStorageManager.storeFilterDataInfo(map: _dataInitializationMap);
     GeneralNotifier().publishChange(GeneralNotifier.STATE_DATA_UPDATE);
   }
   else if(termDataType == propertyCountryDataType){
     _selectedPropertyCountriesList = selectedTermsList;
     _selectedPropertyCountriesSlugsList = selectedTermSlugsList;
     _dataInitializationMap[PROPERTY_COUNTRY] = _selectedPropertyCountriesList.toSet().toList();
     _dataInitializationMap[PROPERTY_COUNTRY_SLUG] = _selectedPropertyCountriesSlugsList.toSet().toList();
     _dataInitializationMap[PROPERTY_COUNTRY_QUERY_TYPE] = widget.filterPageConfigData.queryType;
     HiveStorageManager.storeFilterDataInfo(map: _dataInitializationMap);
     GeneralNotifier().publishChange(GeneralNotifier.COUNTRY_DATA_UPDATE);
   }
   else if(termDataType == propertyFeatureDataType){
     _selectedPropertyFeaturesList = selectedTermsList;
     _selectedPropertyFeaturesSlugsList = selectedTermSlugsList;
     _dataInitializationMap[PROPERTY_FEATURES] = _selectedPropertyFeaturesList.toSet().toList();
     _dataInitializationMap[PROPERTY_FEATURES_SLUG] = _selectedPropertyFeaturesSlugsList.toSet().toList();
     _dataInitializationMap[PROPERTY_FEATURES_QUERY_TYPE] = widget.filterPageConfigData.queryType;
   }
   else if(termDataType == propertyCityDataType){
     _selectedPropertyCitiesList = selectedTermsList;
     _selectedPropertyCitySlugsList = selectedTermSlugsList;

     if(_selectedPropertyCitiesList.isNotEmpty){
       _dataInitializationMap[CITY] = _selectedPropertyCitiesList.toSet().toList();
     }

     if(_selectedPropertyCitySlugsList.isNotEmpty){
       _dataInitializationMap[CITY_SLUG] = _selectedPropertyCitySlugsList.toSet().toList();
     }

     // For the multiple cities selection, get the data of 1st city and set it
     // as selected city across app.
     updateSelectedCityInfo();
   }

   widget.filterPageWidgetsListener(_dataInitializationMap, "");
   if(mounted) setState(() {});
  }

  void updateSelectedCityInfo() {
    if (_selectedPropertyCitySlugsList.isNotEmpty) {
      var tempObj = UtilityMethods.getPropertyMetaDataObjectWithSlug(
          dataType: propertyCityDataType, slug: _selectedPropertyCitySlugsList[0]);
      if (tempObj != null && tempObj.id != null) {
        _dataInitializationMap[CITY_ID] = tempObj.id;

        Map<String, dynamic> map = HiveStorageManager.readFilterDataInfo();
        map[CITY] = _dataInitializationMap[CITY];
        map[CITY_ID] = _dataInitializationMap[CITY_ID];
        map[CITY_SLUG] = _dataInitializationMap[CITY_SLUG];
        HiveStorageManager.storeFilterDataInfo(map: map);


        saveSelectedCityInfo(
          _dataInitializationMap[CITY_ID],
          _dataInitializationMap[CITY][0],
          _dataInitializationMap[CITY_SLUG][0],
        );
      } else {
        saveSelectedCityInfo(null, "", "");
      }
    } else {
      saveSelectedCityInfo(null, "", "");
    }
  }

  void updateSequentialLocationPickerData(Map<String, dynamic> map) {
    _dataInitializationMap.addAll(map);
    if (filterLocationPickerHierarchyList.contains(propertyCountryDataType)) {
      _selectedPropertyCountriesList = _dataInitializationMap[PROPERTY_COUNTRY] ?? [];
      _selectedPropertyCountriesSlugsList = _dataInitializationMap[PROPERTY_COUNTRY_SLUG] ?? [];
      GeneralNotifier().publishChange(GeneralNotifier.COUNTRY_DATA_UPDATE);
    }
    if (filterLocationPickerHierarchyList.contains(propertyStateDataType)) {
      _selectedPropertyStatesList = _dataInitializationMap[PROPERTY_STATE] ?? [];
      _selectedPropertyStatesSlugsList = _dataInitializationMap[PROPERTY_STATE_SLUG] ?? [];
      GeneralNotifier().publishChange(GeneralNotifier.STATE_DATA_UPDATE);
    }
    if (filterLocationPickerHierarchyList.contains(propertyAreaDataType)) {
      _selectedPropertyAreasList = _dataInitializationMap[PROPERTY_AREA] ?? [];
      _selectedPropertyAreasSlugsList = _dataInitializationMap[PROPERTY_AREA_SLUG] ?? [];
      GeneralNotifier().publishChange(GeneralNotifier.AREA_DATA_UPDATE);
    }
    if (filterLocationPickerHierarchyList.contains(propertyCityDataType)) {
      _selectedPropertyCitiesList = _dataInitializationMap[CITY] ?? [];
      _selectedPropertyCitySlugsList = _dataInitializationMap[CITY_SLUG] ?? [];
      // For the multiple cities selection, get the data of 1st city and set it
      // as selected city across app.
      updateSelectedCityInfo();
      GeneralNotifier().publishChange(GeneralNotifier.CITY_DATA_UPDATE);
    }

    widget.filterPageWidgetsListener(_dataInitializationMap, "");
    if(mounted) setState(() {});
  }

  IconData getStringPickerIconData(String dataType) {
    if(dataType == stringPickerBedroomsKey){
      return AppThemePreferences.bedIcon;
    }
    else if(dataType == stringPickerBathroomsKey){
      return AppThemePreferences.bathtubIcon;
    }
    return AppThemePreferences.errorIcon;
  }

  List<String> getStringPickerDataList(String dataType, {String? options}) {
    if (options != null && options.isNotEmpty) {
      return UtilityMethods.getListFromString(options);
    } else if (dataType == stringPickerBedroomsKey) {
      return _bedroomsDataList;
    } else if (dataType == stringPickerBathroomsKey) {
      return _bathroomsDataList;
    }
    return [];
  }

  List<dynamic> getStringPickerSelectedItemsDataList(String dataType) {
    if(dataType == stringPickerBedroomsKey){
      return _selectedBedroomsList;
    }
    else if(dataType == stringPickerBathroomsKey){
      return _selectedBathroomsList;
    }
    return [];
  }

  updateStringPickerData({
    required String dataType,
    required List<dynamic> selectedItemsList,
  }){
    if(dataType == stringPickerBedroomsKey){
      _selectedBedroomsList = selectedItemsList;
      _dataInitializationMap[BEDROOMS] = _selectedBedroomsList;
    }
    else if(dataType == stringPickerBathroomsKey){
      _selectedBathroomsList = selectedItemsList;
      _dataInitializationMap[BATHROOMS] = _selectedBathroomsList;
    }

    setState(() {});
    widget.filterPageWidgetsListener(_dataInitializationMap, "");
  }

  IconData getRangePickerIconData(String dataType) {
    if(dataType == rangePickerPriceKey){
      return AppThemePreferences.priceTagIcon;
    }
    else if(dataType == rangePickerAreaKey){
      return AppThemePreferences.areaSizeIcon;
    }
    return AppThemePreferences.errorIcon;
  }

  double getSelectedMinRange(String dataType, String rangeMinValue) {
    if(dataType == rangePickerPriceKey){
      return double.parse(_selectedMinPrice);
    }
    // else if(dataType == rangePickerAreaKey){
    //   return double.parse(_selectedMinArea);
    // }
    else {
      return double.parse(_selectedMinArea);
    }
    // return null;
  }

  double getSelectedMaxRange(String dataType, String rangeMaxValue) {
    if (dataType == rangePickerPriceKey) {
      if (double.parse(_selectedMaxPrice) > double.parse(rangeMaxValue)) {
        _selectedMaxPrice = rangeMaxValue;
        return double.parse(rangeMaxValue);
      }

      return double.parse(_selectedMaxPrice);
    }
    // else if(dataType == rangePickerAreaKey){
    //   if(double.parse(_selectedMaxArea) > double.parse(rangeMaxValue)){
    //     _selectedMaxArea = rangeMaxValue;
    //     return double.parse(rangeMaxValue);
    //   }
    //   return double.parse(_selectedMaxArea);
    // }
    else {
      if(double.parse(_selectedMaxArea) > double.parse(rangeMaxValue)){
        _selectedMaxArea = rangeMaxValue;
        return double.parse(rangeMaxValue);
      }
      return double.parse(_selectedMaxArea);
    }
    // return null;
  }

  String? getSelectedSymbol(String dataType) {
    if(dataType == rangePickerPriceKey){
      return _selectedCurrencySymbol;
    }
    else if(dataType == rangePickerAreaKey){
      return _selectedAreaSymbol;
    }
    return null;
  }

  updateRangePickerData({
    required String dataType,
    required String selectedSymbol,
    required String selectedMinRange,
    required String selectedMaxRange,
  }){
    if(dataType == rangePickerPriceKey){
      _currency = selectedSymbol;

      if(selectedMinRange.contains(",")){
        _selectedMinPrice = selectedMinRange.replaceAll(",", "");
      }else{
        _selectedMinPrice = selectedMinRange;
      }

      if(selectedMaxRange.contains(",")){
        _selectedMaxPrice = selectedMaxRange.replaceAll(",", "");
      }else{
        _selectedMaxPrice = selectedMaxRange;
      }

      _dataInitializationMap[CURRENCY_SYMBOL] = _currency;
      _dataInitializationMap[PRICE_MIN] = _selectedMinPrice;
      _dataInitializationMap[PRICE_MAX] = _selectedMaxPrice;
    }
    else if(dataType == rangePickerAreaKey){
      _areaType = selectedSymbol;

      if(selectedMinRange.contains(",")){
        _selectedMinArea = selectedMinRange.replaceAll(",", "");
      }else{
        _selectedMinArea = selectedMinRange;
      }

      if(selectedMaxRange.contains(",")){
        _selectedMaxArea = selectedMaxRange.replaceAll(",", "");
      }else{
        _selectedMaxArea = selectedMaxRange;
      }

      _dataInitializationMap[AREA_MAX] = _selectedMaxArea;
      _dataInitializationMap[AREA_MIN] = _selectedMinArea;
      _dataInitializationMap[AREA_TYPE] = _areaType;
    }

    setState(() {});
    widget.filterPageWidgetsListener(_dataInitializationMap, "");
  }

  // String getBottomSheetMenuTitle(String dataType) {
  //   if(dataType == rangePickerAreaKey){
  //     return AppLocalizations.of(context).change_area_unit;
  //   }
  //
  //   return null;
  // }
  //
  // Map<String, String> getBottomSheetMenu(String dataType) {
  //   if(dataType == rangePickerAreaKey){
  //     return _mapOfPropertyAreaRange;
  //   }
  //
  //   return null;
  // }

  void saveSelectedCityInfo(int? cityId, String cityName, String citySlug){
    Map dataMap = {};

    if(cityId == null && cityName.isEmpty && citySlug.isEmpty){
      dataMap = {};
    } else {
      dataMap = {
        CITY : cityName,
        CITY_ID : cityId,
        CITY_SLUG : citySlug,
      };
    }

    HiveStorageManager.storeSelectedCityInfo(data: dataMap);
    GeneralNotifier().publishChange(GeneralNotifier.CITY_DATA_UPDATE);
  }
}