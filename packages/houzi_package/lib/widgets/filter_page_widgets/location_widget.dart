import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/api_providers/place_api_provider.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/address_search.dart';
import 'package:houzi_package/models/filter_page_config.dart';
import 'package:houzi_package/pages/city_picker.dart';

import 'package:houzi_package/widgets/custom_segment_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_multi_select_dialog.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:uuid/uuid.dart';


typedef LocationWidgetListener = void Function({
  Map<String, dynamic>? filterDataMap,
  String? closeOption,
  List<dynamic>? selectedTermsList,
  List<dynamic>? selectedTermsSlugsList,
});

class LocationWidget extends StatefulWidget{

  final FilterPageElement filterPageConfigData;
  final Map<String, dynamic> filterDataMap;
  final LocationWidgetListener locationWidgetListener;
  final bool fromFilterPage;
  final String pickerType;
  final List<dynamic> selectedPropertyCitiesList;
  final List<dynamic> selectedPropertyCitySlugsList;
  final bool? showSearchBar;

  const LocationWidget({
    Key? key,
    required this.filterPageConfigData,
    required this.filterDataMap,
    required this.pickerType,
    this.fromFilterPage = false,
    required this.locationWidgetListener,
    required this.selectedPropertyCitiesList,
    required this.selectedPropertyCitySlugsList,
    this.showSearchBar = false,
  }) : super(key: key);

  
  @override
  State<StatefulWidget> createState() => LocationWidgetState();
  
}

class LocationWidgetState extends State<LocationWidget> {

  bool showSearchByCity = true;
  bool showSearchByLocation = true;
  FilterPageElement? _filterPageElement;

  int _currentSelection = 0;

  String _selectedRadius = DEFAULT_RADIUS;
  String _selectedCity = '';
  String _selectedLocation = '';
  String _latitude = "";
  String _longitude = "";

  List<dynamic> _locationWidgetTabBarList = [];
  List<dynamic> citiesMetaDataList = [];
  List<dynamic> _selectedCityIdList = [];
  List<dynamic> _selectedCitySlugList = [];
  List<dynamic> _selectedCityList = [];

  Map<String, dynamic> _filterDataMap = {};
  VoidCallback? generalNotifierLister;

  @override
  void initState() {
    super.initState();

    _locationWidgetTabBarList = [
      UtilityMethods.getLocalizedString("city"),
      UtilityMethods.getLocalizedString("location")
    ];

    generalNotifierLister = () {
      if (GeneralNotifier().change == GeneralNotifier.RESET_FILTER_DATA) {
        // _selectedCity = UtilityMethods.getLocalizedString("please_select");
        // _selectedLocation = UtilityMethods.getLocalizedString("please_select");
        _selectedCity = "please_select";
        _selectedLocation = "please_select";
        if (mounted) {
          setState(() {});
        }
        HiveStorageManager.storeSelectedCityInfo(data: {});
      }
    };
    GeneralNotifier().addListener(generalNotifierLister!);

    // _selectedCity = UtilityMethods.getLocalizedString("please_select");
    // _selectedLocation =UtilityMethods.getLocalizedString("please_select");
    _selectedCity = "please_select";
    _selectedLocation = "please_select";

    _filterPageElement = widget.filterPageConfigData;
    // locationIconData = GenericMethods.fromJsonToIconData(_filterPageElement.iconData);
    showSearchByCity = _filterPageElement!.showSearchByCity!;
    showSearchByLocation = _filterPageElement!.showSearchByLocation!;

    if(mounted) setState(() {
      SHOW_SEARCH_BY_CITY = showSearchByCity;
      SHOW_SEARCH_BY_LOCATION = showSearchByLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!mapEquals(widget.filterDataMap, _filterDataMap)) {
      loadData();
    }
    citiesMetaDataList = HiveStorageManager.readCitiesMetaData() ?? [];

    return GenericLocationWidget(
      filterPageElement: _filterPageElement!,
      filterDataMap: _filterDataMap,
      selectedPropertyCitiesList: widget.selectedPropertyCitiesList,
      selectedPropertyCitySlugsList: widget.selectedPropertyCitySlugsList,
      selectedCity: _selectedCity,
      selectedRadius: _selectedRadius,
      selectedLocation: _selectedLocation,
      fromFilterPage: widget.fromFilterPage,
      currentSelection: _currentSelection,
      locationWidgetTabBarList: _locationWidgetTabBarList,
      citiesMetaDataList: citiesMetaDataList,
      showSearchBar: widget.showSearchBar,
      onCitySelectionTap: () {
        widget.pickerType == dropDownPicker
            ? onMultiSelectCityPicker()
            : onCityPickerPressed();
      },
      listener: ({latitude, longitude, selectedLocation, selectedRadius, selectedTabIndex, selectedTermSlugs, selectedTerms}) {
        if(mounted) setState(() {

          // onSegmentSelection
          if(selectedTabIndex != null){
            _currentSelection = selectedTabIndex;
            _filterDataMap[SELECTED_INDEX_FOR_TAB] = _currentSelection;
            widget.locationWidgetListener(filterDataMap: _filterDataMap, closeOption: UPDATE_DATA);
          }

          // onLocationSelection
          if(selectedLocation != null && latitude != null && longitude != null){

            _selectedLocation = selectedLocation;
            _latitude = latitude;
            _longitude = longitude;

            _filterDataMap[SELECTED_LOCATION] = _selectedLocation;
            _filterDataMap[LATITUDE] = _latitude;
            _filterDataMap[LONGITUDE] = _longitude;
            widget.locationWidgetListener(filterDataMap: _filterDataMap, closeOption: UPDATE_DATA);
          }

          // onRadiusSelection
          if(selectedRadius != null){
            _selectedRadius = selectedRadius.round().toString();
            _filterDataMap[RADIUS] = _selectedRadius;
            widget.locationWidgetListener(filterDataMap: _filterDataMap, closeOption: "");
          }

          // onCitySelection
          if(selectedTerms != null && selectedTermSlugs != null) {
            widget.locationWidgetListener(
              selectedTermsList: selectedTerms,
              selectedTermsSlugsList: selectedTermSlugs,
            );
          }
        });
      },
    );
  }

  loadData(){
    _filterDataMap = widget.filterDataMap;
    if (_filterDataMap.isNotEmpty) {
      if (_filterDataMap.containsKey(SELECTED_INDEX_FOR_TAB) &&
          _filterDataMap[SELECTED_INDEX_FOR_TAB] != null &&
          _filterDataMap[SELECTED_INDEX_FOR_TAB] is int) {
        _currentSelection = _filterDataMap[SELECTED_INDEX_FOR_TAB];
      }

      if (_filterDataMap.containsKey(CITY_SLUG) && _filterDataMap[CITY_SLUG] != null
          && _filterDataMap[CITY_SLUG].isNotEmpty) {
        if (_filterDataMap[CITY_SLUG] is List) {
          _selectedCitySlugList = _filterDataMap[CITY_SLUG];
        } else if (_filterDataMap[CITY_SLUG] is String) {
          _selectedCitySlugList = [_filterDataMap[CITY_SLUG]];
        }
      }

      if (_filterDataMap.containsKey(CITY) && _filterDataMap[CITY] != null
          && _filterDataMap[CITY].isNotEmpty) {
        if(_filterDataMap[CITY] is List) {
          _selectedCity = getMultiSelectFieldValue(context, _filterDataMap[CITY]) ?? "";
          _selectedCityList = _filterDataMap[CITY];
        } else {
          _selectedCity = _filterDataMap[CITY];
          _selectedCityList = [_filterDataMap[CITY]];
        }
      } else {
        _selectedCity = "please_select";
        // _selectedCity = UtilityMethods.getLocalizedString("please_select");
      }

      if (_filterDataMap.containsKey(CITY_ID) && _filterDataMap[CITY_ID] != null) {
        if (_filterDataMap[CITY_ID] is List) {
          _selectedCityIdList = _filterDataMap[CITY_ID];
        } else if (_filterDataMap[CITY_ID] is int) {
          _selectedCityIdList = [_filterDataMap[CITY_ID]];
        }
      }

      if (_filterDataMap.containsKey(SELECTED_LOCATION) &&
          _filterDataMap[SELECTED_LOCATION] != null &&
          _filterDataMap[SELECTED_LOCATION].isNotEmpty) {
        _selectedLocation = _filterDataMap[SELECTED_LOCATION];
      } else {
        _selectedLocation = "please_select";
        // _selectedLocation =UtilityMethods.getLocalizedString("please_select");
      }

      if (_filterDataMap.containsKey(LATITUDE) &&
          _filterDataMap[LATITUDE] != null &&
          _filterDataMap[LATITUDE].isNotEmpty) {
        _latitude = _filterDataMap[LATITUDE];
        _currentSelection = 1;
      } else {
        _latitude = "";
      }

      if (_filterDataMap.containsKey(LONGITUDE) &&
          _filterDataMap[LONGITUDE] != null &&
          _filterDataMap[LONGITUDE].isNotEmpty) {
        _longitude = _filterDataMap[LONGITUDE];
        _currentSelection = 1;
      } else {
        _longitude = "";
      }

      if (_filterDataMap.containsKey(RADIUS) &&
          _filterDataMap[RADIUS] != null &&
          _filterDataMap[RADIUS].isNotEmpty) {
        _selectedRadius = _filterDataMap[RADIUS];
      } else {
        _selectedRadius = DEFAULT_RADIUS;
      }
    }else {
      // _selectedCity = UtilityMethods.getLocalizedString("please_select");
      // _selectedLocation = UtilityMethods.getLocalizedString("please_select");
      _selectedCity = "please_select";
      _selectedLocation = "please_select";
      _currentSelection = 0;
    }
  }

  onCityPickerPressed(){
    if(citiesMetaDataList.isNotEmpty){
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => CityPicker(
          citiesMetaDataList: citiesMetaDataList,
          cityPickerListener: (String pickedCity, int? pickedCityId, String pickedCitySlug){
            if(mounted) setState(() {
              _selectedCity = pickedCity;
              _selectedCityIdList = [pickedCityId];
              _selectedCitySlugList = [pickedCitySlug];
              _filterDataMap[CITY] = [pickedCity];
              _filterDataMap[CITY_ID] = [pickedCityId];
              _filterDataMap[CITY_SLUG] = [pickedCitySlug];

            });

            saveSelectedCityInfo(pickedCityId, pickedCity, pickedCitySlug);
            widget.locationWidgetListener(filterDataMap: _filterDataMap, closeOption: UPDATE_DATA);
            // widget.locationWidgetListener(_filterDataMap, UPDATE_DATA);
          },
        ),
      ),
      );
    }
  }

   onMultiSelectCityPicker() {
    if(citiesMetaDataList.isNotEmpty){
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return MultiSelectDialogWidget(
                showSearchBar: widget.showSearchBar ?? false,
                title: UtilityMethods.getLocalizedString("select"),
                dataItemsList: citiesMetaDataList,
                selectedItemsList: _selectedCityList,
                selectedItemsSlugsList: _selectedCitySlugList,
                multiSelectDialogWidgetListener: (List<dynamic> listOfSelectedItems, List<dynamic> listOfSelectedItemsSlugs){
                  if(listOfSelectedItems.isNotEmpty){
                    List listOfSelectedItemsIds = [];
                    listOfSelectedItemsIds = UtilityMethods.getIdsForFeatures(citiesMetaDataList,listOfSelectedItems);

                    if(mounted) setState(() {
                      _selectedCity = getMultiSelectFieldValue(context, listOfSelectedItems) ?? "";
                      _selectedCityList = listOfSelectedItems;
                      _selectedCitySlugList = listOfSelectedItemsSlugs;
                      _filterDataMap[CITY] = listOfSelectedItems;
                      _filterDataMap[CITY_ID] = listOfSelectedItemsIds;
                      _filterDataMap[CITY_SLUG] = listOfSelectedItemsSlugs;

                    });

                    saveSelectedCityInfo(listOfSelectedItemsIds[0], listOfSelectedItems[0], listOfSelectedItemsSlugs[0]);
                    // widget.locationWidgetListener(_filterDataMap, UPDATE_DATA);
                    widget.locationWidgetListener(filterDataMap: _filterDataMap, closeOption: UPDATE_DATA);
                  }else{
                    if(mounted) setState(() {
                      _selectedCity = PLEASE_SELECT;
                      _selectedCityList = [];
                      _selectedCitySlugList = [];
                      _filterDataMap[CITY] = "";
                      _filterDataMap[CITY_ID] = null;
                      _filterDataMap[CITY_SLUG] = "";

                    });

                    saveSelectedCityInfo(_filterDataMap[CITY_ID], _filterDataMap[CITY], _filterDataMap[CITY_SLUG]);
                    // widget.locationWidgetListener(_filterDataMap, UPDATE_DATA);
                    widget.locationWidgetListener(filterDataMap: _filterDataMap, closeOption: UPDATE_DATA);
                  }
                }
            );
          });

    }
  }

  String? getMultiSelectFieldValue(BuildContext context, List<dynamic> itemsList) {
    if (itemsList.isNotEmpty && itemsList.toSet().toList().length == 1) {
      return "${itemsList.toSet().toList().first}";
    } else if (itemsList.isNotEmpty && itemsList.toSet().toList().length > 1) {
      return UtilityMethods.getLocalizedString(
          "multi_select_drop_down_city_selected",
          inputWords: [(itemsList.toSet().toList().length.toString())]);
    }
    return null;
  }

  void saveSelectedCityInfo(int? cityId, String cityName, String citySlug){
    HiveStorageManager.storeSelectedCityInfo(data:
    {
      CITY : cityName,
      CITY_ID : cityId,
      CITY_SLUG : citySlug,
    }
    );
    GeneralNotifier().publishChange(GeneralNotifier.CITY_DATA_UPDATE);
  }
}

typedef GenericLocationWidgetListener = Function({
  String? selectedLocation,
  String? latitude,
  String? longitude,
  double? selectedRadius,
  int? selectedTabIndex,
  List<dynamic>? selectedTerms,
  List<dynamic>? selectedTermSlugs,
});

class GenericLocationWidget extends StatefulWidget {
  final FilterPageElement filterPageElement;
  final int currentSelection;
  final bool fromFilterPage;
  final String selectedLocation;
  final String selectedRadius;
  final String selectedCity;
  final List<dynamic> locationWidgetTabBarList;
  final List<dynamic> citiesMetaDataList;
  final Function()? onCitySelectionTap;
  final GenericLocationWidgetListener listener;
  final Map<String, dynamic> filterDataMap;
  final List<dynamic> selectedPropertyCitiesList;
  final List<dynamic> selectedPropertyCitySlugsList;
  final bool? showSearchBar;

  const GenericLocationWidget({
    Key? key,
    required this.filterPageElement,
    required this.filterDataMap,
    required this.selectedPropertyCitiesList,
    required this.selectedPropertyCitySlugsList,
    required this.currentSelection,
    required this.locationWidgetTabBarList,
    required this.citiesMetaDataList,
    required this.selectedCity,
    required this.fromFilterPage,
    this.onCitySelectionTap,
    required this.selectedLocation,
    required this.selectedRadius,
    required this.listener,
    this.showSearchBar = false,
  }) : super(key: key);

  @override
  State<GenericLocationWidget> createState() => _GenericLocationWidgetState();
}

class _GenericLocationWidgetState extends State<GenericLocationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: AppThemePreferences().appTheme.filterPageBorderSide!,
        ),
      ),
      child: SHOW_SEARCH_BY_CITY && SHOW_SEARCH_BY_LOCATION
          ? TabBarWidget(
              showSearchBar: widget.showSearchBar,
              filterPageElement: widget.filterPageElement,
              filterDataMap: widget.filterDataMap,
              selectedPropertyCitiesList: widget.selectedPropertyCitiesList,
              selectedPropertyCitySlugsList: widget.selectedPropertyCitySlugsList,
              currentSelection: widget.currentSelection,
              locationWidgetTabBarList: widget.locationWidgetTabBarList,
              citiesMetaDataList: widget.citiesMetaDataList,
              selectedCity: widget.selectedCity,
              fromFilterPage: widget.fromFilterPage,
              onCitySelectionTap: widget.onCitySelectionTap,
              selectedLocation: widget.selectedLocation,
              selectedRadius: widget.selectedRadius,
              listener: ({lat, lng, location, rad, selectedTermSlugs, selectedTerms, tabIndex}) {
                widget.listener(
                  selectedTabIndex: tabIndex,
                  selectedLocation: location,
                  latitude: lat,
                  longitude: lng,
                  selectedRadius: rad,
                  selectedTerms: selectedTerms,
                  selectedTermSlugs: selectedTermSlugs,
                );
              },
            )
          : SHOW_SEARCH_BY_CITY && !SHOW_SEARCH_BY_LOCATION
              ? TermPicker(
                      showSearchBar: widget.showSearchBar,
                      showDivider: false,
                      objDataType: propertyCityDataType,
                      pickerTitle: UtilityMethods.getLocalizedString(widget.filterPageElement.title!),
                      pickerType: widget.filterPageElement.pickerType!,
                      pickerIcon: AppThemePreferences().appTheme.filterPageLocationIcon!,
                      selectedTermsList: widget.selectedPropertyCitiesList,
                      selectedTermsSlugsList: widget.selectedPropertyCitySlugsList,
                      filterDataMap: widget.filterDataMap,
                      termPickerListener: (List<dynamic> _selectedTermSlugs, List<dynamic> _selectedTerms) {
                        widget.listener(
                          selectedTerms: _selectedTerms,
                          selectedTermSlugs: _selectedTermSlugs,
                        );
                      },
                    )
                  // ? CitySelectionWidget(
                  //     citiesMetaDataList: citiesMetaDataList,
                  //     selectedCity: selectedCity,
                  //     fromFilterPage: fromFilterPage,
                  //     onCitySelectionTap: onCitySelectionTap,
                  //   )
              : !SHOW_SEARCH_BY_CITY && SHOW_SEARCH_BY_LOCATION
                      ? LocationSelectionWidget(
                          fromFilterPage: widget.fromFilterPage,
                          selectedRadius: widget.selectedRadius,
                          selectedLocation: widget.selectedLocation,
                          listener: ({latitude, longitude, radius, selectedLocation}) {
                            widget.listener(
                              selectedLocation: selectedLocation,
                              latitude: latitude,
                              longitude: longitude,
                              selectedRadius: radius,
                            );
                          },
                        )
                      : Container(),
    );
  }
}

typedef TabBarWidgetListener = Function({
  String? location,
  String? lat,
  String? lng,
  double? rad,
  int? tabIndex,
  List<dynamic>? selectedTerms,
  List<dynamic>? selectedTermSlugs,
});

class TabBarWidget extends StatefulWidget {
  final FilterPageElement filterPageElement;
  final Map<String, dynamic> filterDataMap;
  final List<dynamic> selectedPropertyCitiesList;
  final List<dynamic> selectedPropertyCitySlugsList;
  final int currentSelection;
  final List<dynamic> locationWidgetTabBarList;
  final List<dynamic> citiesMetaDataList;
  final String selectedCity;
  final bool fromFilterPage;
  final Function()? onCitySelectionTap;
  final String selectedLocation;
  final String selectedRadius;
  final TabBarWidgetListener listener;
  final bool? showSearchBar;

  const TabBarWidget({
    Key? key,
    required this.filterPageElement,
    required this.filterDataMap,
    required this.selectedPropertyCitiesList,
    required this.selectedPropertyCitySlugsList,
    required this.currentSelection,
    required this.locationWidgetTabBarList,
    required this.citiesMetaDataList,
    required this.selectedCity,
    required this.fromFilterPage,
    this.onCitySelectionTap,
    required this.selectedLocation,
    required this.selectedRadius,
    required this.listener,
    this.showSearchBar = false,
  }) : super(key: key);

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.locationWidgetTabBarList.isNotEmpty
            ? Container(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                child: SegmentedControlWidget(
                  itemList: widget.locationWidgetTabBarList,
                  selectionIndex: widget.currentSelection,
                  onSegmentChosen: (int selectedIndex) {
                    widget.listener(tabIndex: selectedIndex);
                  },
                ))
            : Container(),
        widget.currentSelection == 0
            ? TermPicker(
                showSearchBar: widget.showSearchBar,
                showDivider: false,
                objDataType: propertyCityDataType,
                pickerTitle:
                    UtilityMethods.getLocalizedString(widget.filterPageElement.title!),
                pickerType: widget.filterPageElement.pickerType!,
                pickerIcon:
                    AppThemePreferences().appTheme.filterPageLocationIcon!,
                selectedTermsList: widget.selectedPropertyCitiesList,
                selectedTermsSlugsList: widget.selectedPropertyCitySlugsList,
                filterDataMap: widget.filterDataMap,
                termPickerListener: (List<dynamic> _selectedTermSlugs,
                    List<dynamic> _selectedTerms) {
                  widget.listener(
                    selectedTerms: _selectedTerms,
                    selectedTermSlugs: _selectedTermSlugs,
                  );
                },
              )
            // CitySelectionWidget(
        //         citiesMetaDataList: citiesMetaDataList,
        //         selectedCity: selectedCity,
        //         fromFilterPage: fromFilterPage,
        //         onCitySelectionTap: onCitySelectionTap,
        //       )
            : LocationSelectionWidget(
                fromFilterPage: widget.fromFilterPage,
                selectedRadius: widget.selectedRadius,
                selectedLocation: widget.selectedLocation,
                listener: ({latitude, longitude, radius, selectedLocation}) {
                  widget.listener(
                    location: selectedLocation,
                    lat: latitude,
                    lng: longitude,
                    rad: radius,
                  );
                },
              ),
      ],
    );
  }
}

class CitySelectionWidget extends StatelessWidget {
  final List<dynamic> citiesMetaDataList;
  final String selectedCity;
  final bool fromFilterPage;
  final Function()? onCitySelectionTap;

  const CitySelectionWidget({
    Key? key,
    required this.citiesMetaDataList,
    required this.selectedCity,
    required this.fromFilterPage,
    this.onCitySelectionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return citiesMetaDataList.isEmpty
        ? Container()
        : InkWell(
            onTap: onCitySelectionTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child:
                        AppThemePreferences().appTheme.filterPageLocationIcon!,
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GenericTextWidget(
                                UtilityMethods.getLocalizedString("city"),
                                style: AppThemePreferences()
                                    .appTheme
                                    .filterPageHeadingTitleTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: GenericTextWidget(
                                  selectedCity == PLEASE_SELECT
                                      ? UtilityMethods.getLocalizedString(
                                          "please_select")
                                      : UtilityMethods.getLocalizedString(
                                          selectedCity),
                                  style: fromFilterPage
                                      ? AppThemePreferences()
                                          .appTheme
                                          .filterPageTempTextPlaceHolderTextStyle
                                      : AppThemePreferences()
                                          .appTheme
                                          .locationWidgetTextStyle,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AppThemePreferences()
                                .appTheme
                                .filterPageArrowForwardIcon!,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

typedef LocationSelectionWidgetListener = Function({
  String? selectedLocation,
  String? latitude,
  String? longitude,
  double? radius,
});

class LocationSelectionWidget extends StatelessWidget {
  final LocationSelectionWidgetListener listener;
  final String selectedLocation;
  final bool fromFilterPage;
  final String selectedRadius;

  LocationSelectionWidget({
    Key? key,
    required this.listener,
    required this.selectedLocation,
    required this.fromFilterPage,
    required this.selectedRadius,
  }) : super(key: key);

  String location = "";
  String latitude = "";
  String longitude = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final sessionToken = const Uuid().v4();
            final Suggestion? result = await showSearch(
              context: context,
              delegate: AddressSearch(sessionToken),
            );
            if (result != null) {
              var response = await PlaceApiProvider.getPlaceDetailFromPlaceId(result.placeId!);
              Map? addressMap = response.data;
              try {
                if(addressMap != null && addressMap.isNotEmpty){
                  location = addressMap["result"]["formatted_address"] ?? "";
                  latitude = addressMap["result"]["geometry"]["location"]["lat"].toString();
                  longitude = addressMap["result"]["geometry"]["location"]["lng"].toString();

                  listener(
                    selectedLocation: location,
                    latitude: latitude,
                    longitude: longitude,
                  );
                }
              } catch (e) {
                e.toString();
              }

            }
          },
          child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child:
                      AppThemePreferences().appTheme.filterPageGpsLocationIcon!,
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenericTextWidget(
                        UtilityMethods.getLocalizedString("location"),
                        style: AppThemePreferences()
                            .appTheme
                            .filterPageHeadingTitleTextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: GenericTextWidget(
                          selectedLocation == PLEASE_SELECT
                              ? UtilityMethods.getLocalizedString(
                                  "please_select")
                              : selectedLocation,
                          style: fromFilterPage
                              ? AppThemePreferences()
                                  .appTheme
                                  .filterPageTempTextPlaceHolderTextStyle
                              : AppThemePreferences()
                                  .appTheme
                                  .locationWidgetTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AppThemePreferences()
                      .appTheme
                      .filterPageArrowForwardIcon!,
                ),
              ],
            ),
          ),
        ),
        RadiusSliderWidget(
          selectedRadius: selectedRadius,
          listener: (double radiusValue)=> listener(radius: radiusValue),
        ),
      ],
    );
  }
}

typedef RadiusSliderWidgetListener = Function(double radius);

class RadiusSliderWidget extends StatelessWidget {

  final String selectedRadius;
  final RadiusSliderWidgetListener listener;

  const RadiusSliderWidget({
    Key? key,
    required this.selectedRadius,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child:
            AppThemePreferences().appTheme.filterPageRadiusLocationIcon!,
          ),
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GenericTextWidget(
                  UtilityMethods.getLocalizedString("Radius",
                      inputWords: [double.parse(selectedRadius).round().toString(), RADIUS_UNIT]),
                  // "Radius ${double.parse(selectedRadius).round()} $RADIUS_UNIT",
                  style: AppThemePreferences().appTheme.filterPageHeadingTitleTextStyle,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      UtilityMethods.isRTL(context) ? 20 : 0,
                      20,
                      UtilityMethods.isRTL(context) ? 0 : 20,
                      5),
                  // color: Colors.red,
                  child: SliderTheme(
                    data: SliderThemeData(
                        trackHeight: 5.0,
                        activeTrackColor: AppThemePreferences.sliderTintColor,
                        inactiveTrackColor: AppThemePreferences.sliderTintColor.withOpacity(0.3),
                        activeTickMarkColor: Colors.transparent,
                        inactiveTickMarkColor: Colors.transparent,
                        thumbColor: AppThemePreferences.sliderTintColor,
                        overlayColor: AppThemePreferences.sliderTintColor.withOpacity(0.3),
                        // overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0), //28
                        valueIndicatorColor: AppThemePreferences.sliderTintColor.withOpacity(0.3),
                        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                        valueIndicatorTextStyle: TextStyle(
                          color: AppThemePreferences.sliderTintColor,
                        ),
                        overlayShape: SliderComponentShape.noOverlay
                    ),
                    child: Slider(
                      value: double.parse(selectedRadius),
                      max: 100,
                      min: 1,
                      label: null,
                      onChanged: listener,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}