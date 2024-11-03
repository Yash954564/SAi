import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/property_meta_data.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_full_screen.dart';

typedef SequentialLocationPickerListener = void Function(Map<String, dynamic> map);

class SequentialLocationPickerWidget extends StatefulWidget {
  final List<String> locationHierarchyList;
  final SequentialLocationPickerListener listener;

  const SequentialLocationPickerWidget({
    super.key,
    required this.listener,
    required this.locationHierarchyList,
  });

  @override
  _SequentialLocationPickerWidgetState createState() => _SequentialLocationPickerWidgetState();
}

class _SequentialLocationPickerWidgetState extends State<SequentialLocationPickerWidget> {
  final PropertyBloc _propertyBloc = PropertyBloc();
  bool isInternetConnected = true;
  bool isDataLoadError = false;
  bool isSubmitButtonError = false;
  List<dynamic> _locationsList = [];
  List<dynamic> _countryList = [];
  List<dynamic> _statesList = [];
  List<dynamic> _areaList = [];
  List<dynamic> listToShow = [];

  Map<String, dynamic> sequentialLocationMap = {};
  String? _country;
  String? _state;
  String? _city;
  String? _area;
  String currentTermType = "";
  bool dataIsLoading = true;
  String _slpLastKey = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    if (widget.locationHierarchyList.isNotEmpty) {
      _slpLastKey = widget.locationHierarchyList.last;
    }
    if (widget.locationHierarchyList.contains(propertyCountryDataType)) {
      var countryData = HiveStorageManager.readPropertyCountriesMetaData();

      if (countryData == null || countryData.isEmpty) {
        countryData = await fetchTermData(propertyCountryDataType);
      }

      if (countryData != null && countryData.isNotEmpty) {
        _countryList = countryData;
      }
    }


    if (widget.locationHierarchyList.contains(propertyStateDataType)) {
      var statusData = HiveStorageManager.readPropertyStatesMetaData();
      if (statusData != null && statusData.isNotEmpty) {
        _statesList = statusData;
      } else {
        statusData = await fetchTermData(propertyStateDataType);
        if (statusData != null && statusData.isNotEmpty) {
          _statesList = statusData;
        }
      }
    }

    if (widget.locationHierarchyList.contains(propertyCityDataType)) {
      var cityData = HiveStorageManager.readCitiesMetaData();
      if (cityData != null && cityData.isNotEmpty) {
        _locationsList = cityData;
      } else {
        cityData = await fetchTermData(propertyCityDataType);
        if (cityData != null && cityData.isNotEmpty) {
          _locationsList = cityData;
        }
      }
    }

    if (widget.locationHierarchyList.contains(propertyAreaDataType)) {
       final areaList = await fetchTermData(propertyAreaDataType);
       if (areaList.isNotEmpty) {
         _areaList = areaList;
       }
    }

    if (_countryList.isNotEmpty) {
      listToShow = _countryList;
      currentTermType = propertyCountryDataType;
    } else if (_statesList.isNotEmpty) {
      listToShow = _statesList;
      currentTermType = propertyStateDataType;
    } else if (_locationsList.isNotEmpty) {
      listToShow = _locationsList;
      currentTermType = propertyCityDataType;
    } else {
      listToShow = _areaList;
      currentTermType = propertyAreaDataType;
    }
    setState(() {dataIsLoading = false;});
  }

  Future<List<dynamic>> fetchTermData(String term) async {
    List<dynamic> termData = [];
    termData = await _propertyBloc.fetchTermData(term);
    if (termData.isNotEmpty && termData[0].runtimeType == Response) {
      if (mounted) {
        setState(() {
          isInternetConnected = false;
          isDataLoadError = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isInternetConnected = true;
          isDataLoadError = false;
        });
      }
    }

    return termData;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TermPickerFullScreen(
      showLoadingWidget: dataIsLoading,
      title: getTitle(),
      termType: currentTermType,
      termMetaDataList: listToShow,
      termsDataMap: const {},
      fromSequential: true,
      termPickerFullScreenListener: (pickedTerm, pickedTermId, pickedTermSlug) {
        updateAddressRelatedFields(
            currentTermType, pickedTerm, pickedTermSlug, pickedTermId);
      },
    );
  }

  String getTitle() {
    if (currentTermType == propertyCountryDataType) {
      return "Select property_country";
    } else if (currentTermType == propertyStateDataType) {
      return "Select property_state";
    } else if (currentTermType == propertyCityDataType) {
      return "Select property_city";
    } else if (currentTermType == propertyAreaDataType) {
      return "Select property_area";
    }
    // return currentTermType;
    return "select";
  }

  void sendMapAndClosePicker() {
    widget.listener(sequentialLocationMap);
    Navigator.pop(context);
  }

  updateAddressRelatedFields(String key, String? value, String pickedTermSlug, int? pickedTermId) {
    // if (key == propertyCountryDataType && sequentialLocationMap[key] != value) {
    if (key == propertyCountryDataType) {
      _country = value;
      sequentialLocationMap[key] = [value];
      sequentialLocationMap[PROPERTY_COUNTRY_SLUG] = [pickedTermSlug];
      // Reset sub fields
      _state = "";
      _city = "";
      _area = "";
      if (key != _slpLastKey) {
        resetStatesList(_country);
      }
    // } else if (key == propertyStateDataType && sequentialLocationMap[key] != value) {
    } else if (key == propertyStateDataType) {
      _state = value;
      sequentialLocationMap[key] = [value];
      sequentialLocationMap[PROPERTY_STATE_SLUG] = [pickedTermSlug];
      // Reset sub fields
      _city = "";
      _area = "";
      if (key != _slpLastKey) {
        resetCitiesList(_state);
      }
    // } else if (key == propertyCityDataType && sequentialLocationMap[key] != value) {
    } else if (key == propertyCityDataType) {
      _city = value;
      sequentialLocationMap[CITY] = [value];
      sequentialLocationMap[CITY_SLUG] = [pickedTermSlug];
      sequentialLocationMap[CITY_ID] = [pickedTermId];
      // Reset sub field
      _area = "";
      if (key != _slpLastKey) {
        resetAreasList(_city);
      }
    }
    // else if (key == propertyAreaDataType && sequentialLocationMap[key] != value) {
    else if (key == propertyAreaDataType) {
      _area = value;
      sequentialLocationMap[key] = [value];
      sequentialLocationMap[PROPERTY_AREA_SLUG] = [pickedTermSlug];
    } else {
      sequentialLocationMap[key] = [value];
    }

    setState(() {});

    // Close the Location Picker only if all the Other fields are selected
    if (key == _slpLastKey) {
      if (_country != null && _country!.isNotEmpty) {
        GeneralNotifier().publishChange(GeneralNotifier.COUNTRY_DATA_UPDATE);
      }
      if (_state != null && _state!.isNotEmpty) {
        GeneralNotifier().publishChange(GeneralNotifier.STATE_DATA_UPDATE);
      }
      if (_city != null && _city!.isNotEmpty) {
        HiveStorageManager.storeSelectedCityInfo(
          data: {
            CITY: sequentialLocationMap[CITY],
            CITY_ID: sequentialLocationMap[CITY_ID],
            CITY_SLUG: sequentialLocationMap[CITY_SLUG],
          },
        );
        GeneralNotifier().publishChange(GeneralNotifier.CITY_DATA_UPDATE);
      }
      if (_area != null && _area!.isNotEmpty) {
        GeneralNotifier().publishChange(GeneralNotifier.AREA_DATA_UPDATE);
      }
      sendMapAndClosePicker();
    }
  }

  resetStatesList(String? country) {
    // print("resetting states List...");
    if (country != null && country.isNotEmpty) {
      _statesList = [];

      var statesData = HiveStorageManager.readPropertyStatesMetaData();

      Term? countryItem = UtilityMethods.getPropertyMetaDataObjectWithItemName(
          dataType: propertyCountryDataType, name: country);

      if (countryItem == null && statesData is List) {
        _statesList = statesData;
      } else if (statesData != null && statesData.isNotEmpty && statesData is List) {
        for (var state in statesData) {
          if (state.parentTerm.toLowerCase() == countryItem!.slug!.toLowerCase() || state.parentTerm.toLowerCase() == countryItem.name!.toLowerCase()) {
            _statesList.add(state);
          }
        }
        if (_statesList.isEmpty) {
          _locationsList = [];
          _areaList = [];
        }
      } else {
        _statesList = statesData ?? [];
      }
    }
    setState(() {
      listToShow = [];
      listToShow = _statesList;
      currentTermType = propertyStateDataType;
    });

  }

  resetCitiesList(String? state) {
    // print("resetting cities List...");
    if (state != null && state.isNotEmpty) {
      _locationsList = [];
      var cityData = HiveStorageManager.readCitiesMetaData();

      Term? stateItem = UtilityMethods.getPropertyMetaDataObjectWithItemName(
          dataType: propertyStateDataType, name: state);
      if (stateItem == null && cityData is List) {
        _locationsList = cityData;
      } else if (cityData != null && cityData.isNotEmpty && cityData is List) {
        for (var city in cityData) {
          if (city.parentTerm.toLowerCase() == stateItem!.slug!.toLowerCase() || city.parentTerm.toLowerCase() == stateItem.name!.toLowerCase()) {
            _locationsList.add(city);
          }
        }
        if (_locationsList.isEmpty) {
          _areaList = [];
        }
      } else {
        _locationsList = cityData ?? [];
      }
    }
    setState(() {
      listToShow = [];
      listToShow = _locationsList;
      currentTermType = propertyCityDataType;
    });

  }

  resetAreasList(String? city) {
    // print("resetting areas List...");
    if (city != null && city.isNotEmpty) {
      _areaList = [];
      var areaData = HiveStorageManager.readPropertyAreaMetaData();

      Term? cityItem = UtilityMethods.getPropertyMetaDataObjectWithItemName(
          dataType: propertyCityDataType, name: city);
      if (cityItem == null && areaData is List) {
        _areaList = areaData;
      } else if (areaData != null && areaData.isNotEmpty && areaData is List) {
        for (var city in areaData) {
          if (city.parentTerm.toLowerCase() == cityItem!.slug!.toLowerCase() || city.parentTerm.toLowerCase() == cityItem.name!.toLowerCase()) {
            _areaList.add(city);
          }
        }
      } else {
        _areaList = areaData ?? [];
      }
    }

    setState(() {
      listToShow = [];
      listToShow = _areaList;
      currentTermType = propertyAreaDataType;
    });

  }
}

