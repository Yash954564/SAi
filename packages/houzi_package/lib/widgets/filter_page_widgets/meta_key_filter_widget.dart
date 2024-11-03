import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/filter_page_config.dart';
import 'package:houzi_package/widgets/filter_page_widgets/drop_down_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/keyword_widgets/keyword_picker_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/range_slider_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/string_picker.dart';

typedef MetaKeyPickerWidgetListener = void Function(Map<String, dynamic> dataMap);

class MetaKeyPickerWidget extends StatefulWidget {
  final FilterPageElement configItem;
  final Map<String,dynamic> initializeDataMap;
  final MetaKeyPickerWidgetListener listener;

  const MetaKeyPickerWidget({
    Key? key,
    required this.configItem,
    required this.initializeDataMap,
    required this.listener,
  }) : super(key: key);

  @override
  State<MetaKeyPickerWidget> createState() => _MetaKeyPickerWidgetState();
}

class _MetaKeyPickerWidgetState extends State<MetaKeyPickerWidget> {

  late FilterPageElement _configItem;
  Map<String,dynamic> _metaKeyFiltersDataMap = {};
  
  String? _apiKey;
  String? _dataType;
  String? _options;
  String? _title;
  String? _pickerType;
  String? _pickerSubType;
  String? _divisions;
  String? _minRange;
  String? _maxRange;

  List<String> _optionsList = [];
  List<String> _selectedOptionsList = [];

  String _selectedMinRange = rangeSliderMinValue;
  String _selectedMaxRange = rangeSliderMaxValue;

  int _halfRangeValue = 500000;

  VoidCallback? _generalNotifierLister;

  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    switch (_pickerType) {
      case (rangePickerKey):
        {
          return RangePickerWidget(
            pickerTitle: UtilityMethods.getLocalizedString(_title!),
            pickerType: _pickerType!,
            pickerIcon: getIconWidget(_dataType, _pickerType),
            minRange: double.tryParse(_minRange!)!,
            maxRange: double.tryParse(_maxRange!)!,
            divisions: int.tryParse(_divisions!),
            pickerSelectedSymbol: getRangePickerSymbol(_dataType),
            selectedMinRange: double.tryParse(_selectedMinRange)!,
            selectedMaxRange: double.tryParse(_selectedMaxRange)!,
            rangePickerListener: (symbol, minValue, maxValue) {
              if (mounted) {
                setState(() {
                  _selectedMinRange = minValue;
                  _selectedMaxRange = maxValue;

                  if (_apiKey != null && _apiKey!.isNotEmpty) {
                    _metaKeyFiltersDataMap[_apiKey!] = {
                      metaApiKey : _apiKey,
                      metaPickerTypeKey : _pickerType,
                      metaMinValueKey : _selectedMinRange,
                      metaMaxValueKey : _selectedMaxRange,
                    };
                    widget.listener(_metaKeyFiltersDataMap);
                  }
                });
              }
            },
          );
        }
      case(stringPickerKey):
        {
          if (_optionsList.isNotEmpty) {
            return StringPicker(
                pickerTitle: UtilityMethods.getLocalizedString(_title!),
                pickerType: _pickerSubType!,
                pickerIcon: getIconWidget(_dataType, _pickerType),
                pickerDataList: _optionsList,
                selectedItemsList: _selectedOptionsList,
                stringPickerListener: (itemsList) {
                  if (mounted) {
                    setState(() {
                      _selectedOptionsList = List<String>.from(itemsList);

                      if (_apiKey != null && _apiKey!.isNotEmpty) {
                        _metaKeyFiltersDataMap[_apiKey!] = {
                          metaApiKey : _apiKey,
                          metaPickerTypeKey : _pickerType,
                          metaValueKey : _selectedOptionsList,
                        };
                        widget.listener(_metaKeyFiltersDataMap);
                      }
                    });
                  }
                }
            );
          }
          return Container();
        }
      case(textFieldKey):
        {
          return KeywordPickerWidget(
            pickerTitle: UtilityMethods.getLocalizedString(_title!),
            pickerType: _pickerType!,
            pickerIcon: getIconWidget(_dataType, _pickerType),
            hintText: UtilityMethods.getLocalizedString(_title!),
            textEditingController: _textFieldController,
            filterObj: _configItem,
            listener: (text){
              if (mounted) {
                setState(() {
                  if (_apiKey != null && _apiKey!.isNotEmpty) {
                    _metaKeyFiltersDataMap[_apiKey!] = {
                      metaApiKey : _apiKey,
                      metaPickerTypeKey : _pickerType,
                      metaValueKey : text,
                    };
                    widget.listener(_metaKeyFiltersDataMap);
                  }
                });
              }
            },
          );
        }
      case(dropDownPicker):
        {
          return FilterStringMultiSelectWidget(
            pickerTitle: UtilityMethods.getLocalizedString(_title!),
            pickerIcon: getIconWidget(_dataType, _pickerType),
            dataList: _optionsList,
            selectedDataList: _selectedOptionsList,
            listener: (selectedItems) {
              if (mounted) {
                setState(() {
                  _selectedOptionsList = selectedItems;

                  if (_apiKey != null && _apiKey!.isNotEmpty) {
                    _metaKeyFiltersDataMap[_apiKey!] = {
                      metaApiKey : _apiKey,
                      metaPickerTypeKey : _pickerType,
                      metaValueKey : _selectedOptionsList,
                    };
                    widget.listener(_metaKeyFiltersDataMap);
                  }
                });
              }
            },
          );
        }

      default:
        {
          return Container();
        }
    }
  }

  @override
  void initState() {
    _configItem = widget.configItem;

    if (widget.initializeDataMap[metaKeyFiltersKey] != null
        && widget.initializeDataMap[metaKeyFiltersKey] is Map
        && widget.initializeDataMap[metaKeyFiltersKey].isNotEmpty) {
      _metaKeyFiltersDataMap = Map<String, dynamic>.from(widget.initializeDataMap[metaKeyFiltersKey]);
    }
    
    _apiKey = _configItem.apiValue;
    _dataType = _configItem.dataType;
    _options = _configItem.options;
    _title = _configItem.title;
    _minRange = _configItem.minValue ?? rangeSliderMinValue;
    _maxRange = _configItem.maxValue ?? rangeSliderMaxValue;
    _divisions = _configItem.divisions ?? rangeSliderDivisions;
    _pickerType = _configItem.pickerType;
    _pickerSubType = _configItem.pickerSubType;

    if (_options != null && _options!.isNotEmpty) {
      _optionsList = UtilityMethods.getListFromString(_options);
    }

    _selectedMinRange = getSelectedMinRange(_dataType);
    _selectedMaxRange = getSelectedMaxRange(_dataType);
    _selectedOptionsList = getSelectedOptionsList(_dataType);
    _textFieldController.text = getTextFieldInitialValue(_dataType);

    _generalNotifierLister = () {

      if ( GeneralNotifier().change == GeneralNotifier.RESET_FILTER_DATA ) {
        if (mounted) {
          setState(() {
            _selectedMinRange = rangeSliderMinValue;
            _selectedMaxRange = rangeSliderMaxValue;
            _selectedOptionsList = [];
            _textFieldController.text = "";
          });
        }
      }
    };

    GeneralNotifier().addListener(_generalNotifierLister!);

    super.initState();
  }

  @override
  void dispose() {
    _metaKeyFiltersDataMap = {};

    _apiKey = null;
    _dataType = null;
    _options = null;
    _title = null;
    _minRange = null;
    _maxRange = null;
    _divisions = null;
    _pickerType = null;
    _pickerSubType = null;

    if (_generalNotifierLister != null) {
      GeneralNotifier().removeListener(_generalNotifierLister!);
    }
    
    super.dispose();
  }

  Icon getIconWidget(String? dataType, String? pickerType) {
    return Icon(
      getIconWidgetData(dataType, pickerType),
      size: AppThemePreferences.filterPageStringPickerIconSize,
      color: AppThemePreferences().appTheme.filterPageIconsColor,
    );
  }

  IconData getIconWidgetData(String? dataType, String? pickerType) {
    switch (dataType) {
      case (favPropertyPriceKey):
        {
          return AppThemePreferences.priceTagIcon;
        }
      case (favPropertySizeKey):
        {
          return AppThemePreferences.areaSizeIcon;
        }
      case (favPropertyBedroomsKey):
        {
          return AppThemePreferences.bedIcon;
        }
      case (favPropertyBathroomsKey):
        {
          return AppThemePreferences.bathtubIcon;
        }
      case (favPropertyYearKey):
        {
          return AppThemePreferences.dateRangeIcon;
        }
      case (favPropertyGarageKey):
        {
          return AppThemePreferences.garageIcon;
        }

      default:
        {
          if (pickerType == textFieldKey) {
            return AppThemePreferences.keywordCupertinoIcon;
          }
          return AppThemePreferences.locationCityIcon;
        }
    }
  }

  String getRangePickerSymbol(String? dataType) {
    switch (dataType) {
      case (favPropertyPriceKey):
        {
          return HiveStorageManager.readDefaultCurrencyInfoData() ?? "\$";
        }
      case (favPropertySizeKey):
        {
          return MEASUREMENT_UNIT_TEXT;
        }

      default:
        {
          return "";
        }
    }
  }

  String getSelectedMinRange(String? dataType) {
    if (dataType != null && _metaKeyFiltersDataMap.containsKey(dataType)
        && _metaKeyFiltersDataMap[dataType] is Map
        && _metaKeyFiltersDataMap[dataType].containsKey(minRangeKey)
        && _metaKeyFiltersDataMap[dataType][minRangeKey] is String) {
      return _metaKeyFiltersDataMap[dataType][minRangeKey] ?? rangeSliderMinValue;
    }
    return rangeSliderMinValue;
  }

  String getSelectedMaxRange(String? dataType) {
    if (dataType != null && _metaKeyFiltersDataMap.containsKey(dataType)
        && _metaKeyFiltersDataMap[dataType] is Map
        && _metaKeyFiltersDataMap[dataType].containsKey(maxRangeKey)
        && _metaKeyFiltersDataMap[dataType][maxRangeKey] is String) {
      return _metaKeyFiltersDataMap[dataType][maxRangeKey] ?? rangeSliderMaxValue;
    }
    return rangeSliderMaxValue;
  }

  List<String> getSelectedOptionsList(String? dataType) {
    if (dataType != null && _metaKeyFiltersDataMap.containsKey(dataType)
        && _metaKeyFiltersDataMap[dataType] is Map
        && _metaKeyFiltersDataMap[dataType].containsKey(metaValueKey)) {
        if (_metaKeyFiltersDataMap[dataType][metaValueKey] is List) {
          return _metaKeyFiltersDataMap[dataType][metaValueKey] ?? [];
        } else if (_metaKeyFiltersDataMap[dataType][metaValueKey] is String) {
          String _valueHolder = _metaKeyFiltersDataMap[dataType][metaValueKey];
          List<String> _listHolder = UtilityMethods.getListFromString(_valueHolder);
          return _listHolder;
        }
      }
    return [];
  }

  String getTextFieldInitialValue(String? dataType) {
    if (dataType != null && _metaKeyFiltersDataMap.containsKey(dataType)
        && _metaKeyFiltersDataMap[dataType] is Map
        && _metaKeyFiltersDataMap[dataType].containsKey(metaValueKey)
        && _metaKeyFiltersDataMap[dataType][metaValueKey] is String) {
      return _metaKeyFiltersDataMap[dataType][metaValueKey] ?? "";
    }
    return "";
  }
}


