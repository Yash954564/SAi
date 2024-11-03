import 'dart:convert';
import 'dart:math';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/filter_utility_functions/fliter_utilites_functions.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/filter_page.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_full_screen.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_multi_select_dialog.dart';
import 'package:houzi_package/widgets/generic_animate_icon_widget.dart';
import 'package:houzi_package/widgets/generic_bottom_sheet_widget/generic_bottom_sheet_widget.dart';
import 'package:houzi_package/widgets/generic_popup_menu_widgets.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/search_result_widgets/featured_switch_widget.dart';
import 'package:houzi_package/widgets/search_result_widgets/search_choice_chip_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

typedef SearchResultsSearchBarWidgetListener = Function({
  bool? showPanel,
  bool? onRefresh,
  bool? canSave,
  Map<String, dynamic>? updatedSearchMap,
});

class SearchResultsSearchBarWidget extends StatefulWidget {
  final double opacity;
  final bool isLoggedIn;
  final bool canSaveSearch;
  final Map<String, dynamic> filteredDataMap;
  final Map<String, dynamic> chipsSearchDataMap;
  final List filterChipsRelatedList;
  final void Function()? onBackPressed;
  final AnimateIconController mapListAnimateIconController;
  final SearchResultsSearchBarWidgetListener listener;

  const SearchResultsSearchBarWidget({
    Key? key,
    required this.opacity,
    required this.isLoggedIn,
    required this.canSaveSearch,
    required this.filteredDataMap,
    required this.chipsSearchDataMap,
    required this.filterChipsRelatedList,
    required this.onBackPressed,
    required this.mapListAnimateIconController,
    required this.listener,
  }) : super(key: key);

  @override
  State<SearchResultsSearchBarWidget> createState() => _SearchResultsSearchBarWidgetState();
}

class _SearchResultsSearchBarWidgetState extends State<SearchResultsSearchBarWidget> {

  final PropertyBloc _propertyBloc = PropertyBloc();
  Map<String, dynamic> chipsSearchDataMap = {};
  List filterChipsRelatedList = [];

  AnimateIconController refreshIconController = AnimateIconController();
  AnimateIconController mapListAnimateIconController = AnimateIconController();

  String nonce = "";

  @override
  void initState() {
    super.initState();
    chipsSearchDataMap = {};
    chipsSearchDataMap.addAll(widget.chipsSearchDataMap);

    filterChipsRelatedList = [];
    filterChipsRelatedList.addAll(widget.filterChipsRelatedList);
    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchSaveSearchNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  @override
  void dispose() {

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    chipsSearchDataMap = {};
    chipsSearchDataMap.addAll(widget.chipsSearchDataMap);

    filterChipsRelatedList = [];
    filterChipsRelatedList.addAll(widget.filterChipsRelatedList);

    mapListAnimateIconController = widget.mapListAnimateIconController;

    return Positioned(
      width: MediaQuery.of(context).size.width,
      top: 40.0, // 15.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 0,
                    child: IconButton(
                      onPressed: widget.onBackPressed,
                      icon: Icon(
                        AppThemePreferences.arrowBackIcon,
                        color: AppThemePreferences().appTheme.iconsColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: GenericTextWidget(
                      UtilityMethods.getLocalizedString("search"),
                      style: AppThemePreferences().appTheme.searchBarTextStyle,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GenericAnimateIcons(
                      startIcon: Icons.refresh_outlined,
                      endIcon: Icons.refresh_outlined,
                      size: 24.0,
                      clockwise: true,
                      controller: refreshIconController,
                      onStartIconPress: onRefreshAnimatedButtonPressed,
                      onEndIconPress: onRefreshAnimatedButtonPressed,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GenericAnimateIcons(
                      startIcon: SHOW_MAP_INSTEAD_FILTER ? Icons.list_outlined : Icons.map_outlined,
                      endIcon: SHOW_MAP_INSTEAD_FILTER ? Icons.map_outlined : Icons.list_outlined,
                      size: 24.0,
                      clockwise: false,
                      controller: mapListAnimateIconController,
                      onStartIconPress: SHOW_MAP_INSTEAD_FILTER
                          ? onMapAnimatedButtonEndPressed
                          : onMapAnimatedButtonStartPressed,
                      onEndIconPress: SHOW_MAP_INSTEAD_FILTER
                          ? onMapAnimatedButtonStartPressed
                          : onMapAnimatedButtonEndPressed,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GenericPopupMenuButton(
                      offset: const Offset(0, 50),
                      elevation: AppThemePreferences.popupMenuElevation,
                      icon: Icon(
                        Icons.more_vert_outlined,
                        color: AppThemePreferences().appTheme.iconsColor,
                      ),
                      onSelected: (value) => onPopupOptionSelected(value),
                      itemBuilder: (context) => [
                        GenericPopupMenuItem(
                          value: OPTION_SAVE,
                          text: UtilityMethods.getLocalizedString(OPTION_SAVE),
                          iconData: Icons.bookmark_outline_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: widget.opacity < 0.6 ?  AppThemePreferences().appTheme.searchBarBackgroundColor :
                AppThemePreferences().appTheme.searchBar02BackgroundColor,
                borderRadius: BorderRadius.circular(12.0),//24.0
                // boxShadow: [opacity < 0.6 ? const BoxShadow(color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0) : const BoxShadow(color: Colors.transparent),],
              ),
            ),
          ),
          if(widget.opacity > 0) Opacity(
            opacity: widget.opacity,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SearchResultsChoiceChipsWidget(
                      label: "",
                      iconData: Icons.filter_alt_outlined,
                      onSelected: (value)=> navigateToFilterPage(),
                    ),

                    if(filterChipsRelatedList.isNotEmpty) Row(
                      children: filterChipsRelatedList.map((item) {
                        String key = item.keys.toList()[0];

                        String value = item[key] is List
                            ? handleChipValueForList(item[key])
                            : handleChipValueForString(item[key]);

                        Map<String, dynamic> searchDataMap = {};
                        searchDataMap.addAll(chipsSearchDataMap);

                        // String value = item[key] is List
                        //     ? handleChipValueForList(item[key])
                        //     : item[key];
                        return GenericFilterRelatedChipWidget(
                          iconData: getFilterChipIcon(key),
                          label: UtilityMethods.getLocalizedString(value),

                          // filterMap: widget.chipsSearchDataMap,
                          // onTap: ()=> navigateToFilterPage(dataMap: widget.chipsSearchDataMap,key: key),
                          filterMap: searchDataMap,
                          onTap: ()=> navigateToFilterPage(dataMap: searchDataMap, key: key),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // if (_isBannerAdReady)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 8.0),
          //     child: Container(
          //       height: _bannerAd.size.height.toDouble(),
          //       width: _bannerAd.size.width.toDouble(),
          //       child: AdWidget(ad: _bannerAd),
          //     ),
          //   ),
          // if (_isNativeAdLoaded)
          //   Container(
          //     height: 50,
          //
          //     child: AdWidget(ad: _nativeAd),
          //   ),
        ],
      ),
    );
  }

  bool onMapAnimatedButtonStartPressed(){
    mapListAnimateIconController.animateToEnd();
    widget.listener(showPanel: false);
    return true;
  }

  bool onMapAnimatedButtonEndPressed(){
    mapListAnimateIconController.animateToStart();
    widget.listener(showPanel: true);
    return true;
  }

  bool onRefreshAnimatedButtonPressed(){
    refreshIconController.animateToEnd();
    widget.listener(onRefresh: true);
    return true;
  }

  onPopupOptionSelected(dynamic value){
    if (value == OPTION_SAVE) {
      onSavedSearchTap();
    }
  }

  onSavedSearchTap() async {

    if( widget.isLoggedIn && widget.canSaveSearch ) {
      Map<String, dynamic> _queryDataMap = {};
      Map<String, dynamic> _filteredDataMap = widget.filteredDataMap;

      if ( _filteredDataMap[SEARCH_RESULTS_MIN_PRICE] != null
          && _filteredDataMap[SEARCH_RESULTS_MIN_PRICE] is String
          && _filteredDataMap[SEARCH_RESULTS_MIN_PRICE].isNotEmpty ) {
        _queryDataMap[SAVE_SEARCH_MIN_PRICE] = _filteredDataMap[SEARCH_RESULTS_MIN_PRICE];
      }

      if ( _filteredDataMap[SEARCH_RESULTS_MAX_PRICE] != null
          && _filteredDataMap[SEARCH_RESULTS_MAX_PRICE] is String
          && _filteredDataMap[SEARCH_RESULTS_MAX_PRICE].isNotEmpty ) {
        _queryDataMap[SAVE_SEARCH_MAX_PRICE] = _filteredDataMap[SEARCH_RESULTS_MAX_PRICE];
      }

      if ( _filteredDataMap[SEARCH_RESULTS_MIN_AREA] != null
          && _filteredDataMap[SEARCH_RESULTS_MIN_AREA] is String
          && _filteredDataMap[SEARCH_RESULTS_MIN_AREA].isNotEmpty ) {
        _queryDataMap[SAVE_SEARCH_MIN_AREA] = _filteredDataMap[SEARCH_RESULTS_MIN_AREA];
      }

      if ( _filteredDataMap[SEARCH_RESULTS_MAX_AREA] != null
          && _filteredDataMap[SEARCH_RESULTS_MAX_AREA] is String
          && _filteredDataMap[SEARCH_RESULTS_MAX_AREA].isNotEmpty ) {
        _queryDataMap[SAVE_SEARCH_MAX_AREA] = _filteredDataMap[SEARCH_RESULTS_MAX_AREA];
      }

      if ( _filteredDataMap[metaKeyFiltersKey] != null
          && _filteredDataMap[metaKeyFiltersKey] is String
          && _filteredDataMap[metaKeyFiltersKey].isNotEmpty ) {
        // metaKeyFiltersKey
        String _metaKeyFiltersJson = _filteredDataMap[metaKeyFiltersKey];

        // remove back-slashes
        _metaKeyFiltersJson = _metaKeyFiltersJson.replaceAll("\\", "");

        // decode json
        dynamic _decodedJson = jsonDecode(_metaKeyFiltersJson);

        // extract required data
        if (_decodedJson is Map) {
          Map<String, dynamic> _metaMap = Map<String, dynamic>.from(_decodedJson);

          if (_metaMap[metaKeyFiltersKey] is List
              && _metaMap[metaKeyFiltersKey].isNotEmpty) {

            List<Map> _metaMapsList = List<Map>.from(_metaMap[metaKeyFiltersKey]);

            for (Map metaQueryItem in _metaMapsList) {

              String apiKey = metaQueryItem[metaApiKey];
              String _pickerType = metaQueryItem[metaPickerTypeKey];
              String _value = metaQueryItem[metaValueKey] ?? "";
              String _minRange = metaQueryItem[metaMinValueKey] ?? "";
              String _maxRange = metaQueryItem[metaMaxValueKey] ?? "";

              switch (apiKey) {

                case (favPropertyBedroomsKey): {

                  _filteredDataMap.remove(SEARCH_RESULTS_BEDROOMS);

                  if ( _pickerType == stringPickerKey
                      || _pickerType == dropDownPicker
                      || _pickerType == textFieldKey ) {
                    _queryDataMap[SAVE_SEARCH_BEDROOMS] =
                        getMaxValueFromString(_value);
                  }
                  else if ( _pickerType == rangePickerKey ) {
                    _queryDataMap[SAVE_SEARCH_BEDROOMS] = _maxRange;
                  }

                  break;
                }

                case (favPropertyBathroomsKey): {

                  _filteredDataMap.remove(SEARCH_RESULTS_BATHROOMS);

                  if ( _pickerType == stringPickerKey
                      || _pickerType == dropDownPicker
                      || _pickerType == textFieldKey ) {
                    _queryDataMap[SAVE_SEARCH_BATHROOMS] =
                        getMaxValueFromString(_value);
                  }
                  else if ( _pickerType == rangePickerKey ) {
                    _queryDataMap[SAVE_SEARCH_BATHROOMS] = _maxRange;
                  }

                  break;
                }

                case (favPropertyPriceKey): {

                  _filteredDataMap.remove(SEARCH_RESULTS_MIN_PRICE);
                  _filteredDataMap.remove(SEARCH_RESULTS_MAX_PRICE);

                  if ( _pickerType == stringPickerKey
                      || _pickerType == dropDownPicker
                      || _pickerType == textFieldKey ) {
                    _queryDataMap[SAVE_SEARCH_MAX_PRICE] =
                        getMaxValueFromString(_value);
                  }
                  else if ( _pickerType == rangePickerKey ) {
                    _queryDataMap[SAVE_SEARCH_MIN_PRICE] = _minRange;
                    _queryDataMap[SAVE_SEARCH_MAX_PRICE] = _maxRange;
                  }

                  break;
                }

                case (favPropertySizeKey): {

                  _filteredDataMap.remove(SEARCH_RESULTS_MIN_AREA);
                  _filteredDataMap.remove(SEARCH_RESULTS_MAX_AREA);

                  if ( _pickerType == stringPickerKey
                      || _pickerType == dropDownPicker
                      || _pickerType == textFieldKey ) {
                    _queryDataMap[SAVE_SEARCH_MAX_AREA] =
                        getMaxValueFromString(_value);
                  }
                  else if ( _pickerType == rangePickerKey ) {
                    _queryDataMap[SAVE_SEARCH_MIN_AREA] = _minRange;
                    _queryDataMap[SAVE_SEARCH_MAX_AREA] = _maxRange;
                  }

                  break;
                }

                case (favPropertyGarageKey): {

                  if ( _pickerType == stringPickerKey
                      || _pickerType == dropDownPicker
                      || _pickerType == textFieldKey ) {
                    _queryDataMap[SAVE_SEARCH_GARAGE] =
                        getMaxValueFromString(_value);
                  }
                  else if ( _pickerType == rangePickerKey ) {
                    _queryDataMap[SAVE_SEARCH_GARAGE] = _maxRange;
                  }

                  break;
                }

                case (favPropertyYearKey): {

                  if ( _pickerType == stringPickerKey
                      || _pickerType == dropDownPicker
                      || _pickerType == textFieldKey ) {
                    _queryDataMap[SAVE_SEARCH_YAER_BUILT] =
                        getMaxValueFromString(_value);
                  }
                  else if ( _pickerType == rangePickerKey ) {
                    _queryDataMap[SAVE_SEARCH_YAER_BUILT] = _maxRange;
                  }

                  break;
                }

                default : {
                  break;
                }
              }
            }
          }
        }
      }


      _queryDataMap.addAll(_filteredDataMap);

      // print("save search query map: $_queryDataMap");

      // final response = await _propertyBloc.fetchAddSavedSearch(widget.filteredDataMap, nonce);
      final response = await _propertyBloc.fetchAddSavedSearch(_queryDataMap, nonce);

      String tempResponseString = response.toString().split("{")[1];
      Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");
      if (map["success"]) {
        _showToast(map['msg'], false);
        GeneralNotifier().publishChange(GeneralNotifier.NEW_SAVED_SEARCH_ADDED);
        widget.listener(canSave: false);
        // HiveStorageManager.storeLastSaveSearch(filteredDataMap);
      } else{
        if (map["msg"] != null) {
          _showToast(map["msg"], false);
        } else if (map["reason"] != null) {
          _showToast(map["reason"], false);
        } else {
          _showToast(UtilityMethods.getLocalizedString("error_occurred"), false);
        }

      }
    }
    else{
      _showToast(UtilityMethods.getLocalizedString("you_must_login") + UtilityMethods.getLocalizedString("before_saving_search"),true);
    }
  }

  String getMaxValueFromString(String input) {
    input = input.replaceAll(RegExp("[^\\d,]"), "");

    if ( input.contains(",") ) {
      List<String> _tempStrList = input.split(",");
      List<int> _tempIntList = _tempStrList.map((item) {
        return int.tryParse(item) ?? 1;
      }).toList();

      input = "${_tempIntList.reduce(max)}";
    }

    return input;
  }

  _showToast(String msg, bool forLogin) {
    !forLogin
        ? ShowToastWidget(
            buildContext: context,
            text: msg,
          )
        : ShowToastWidget(
            buildContext: context,
            showButton: true,
            buttonText: UtilityMethods.getLocalizedString("login"),
            text: msg,
            toastDuration: 4,
            onButtonPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserSignIn(
                    (String closeOption) {
                      if (closeOption == CLOSE) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              );
            },
          );
  }

  navigateToFilterPage({Map<String, dynamic>? dataMap, String key = ""}) {
    if (dataMap != null &&
        (key == propertyTypeDataType || key == propertyStatusDataType)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelectDialogWidget(
            title: UtilityMethods.getLocalizedString(key == propertyTypeDataType ? PROPERTY_DETAILS_PROPERTY_TYPE : PROPERTY_DETAILS_PROPERTY_STATUS),
            showSearchBar: false,
            addAllinData: true,
            objDataType: key,
            dataItemsList: FilterPageFunctions.getTermDataFromStorage(key),
            selectedItemsList: dataMap[key],
            selectedItemsSlugsList: dataMap[key + "_slug"],
            multiSelectDialogWidgetListener: (listOfSelectedItems, listOfSelectedItemsSlugs) {
              Map<String, dynamic> updatedMap = {
                key: listOfSelectedItems,
                key + "_slug": listOfSelectedItemsSlugs,
              };
              print("Before merging maps widget.chipsSearchDataMap: ${widget.chipsSearchDataMap}");



              Map<String, dynamic> mergedMap = UtilityMethods.mergeMapsWithPrecedence(dataMap, updatedMap);

              /// If want to remove "All" from the list.
              // mergedMap = UtilityMethods.removeElementFromLists(mergedMap);
              widget.listener(updatedSearchMap: mergedMap);
              resetSearchMaps();
            },
          );
        },
      );
    } else if (dataMap != null && key == CITY) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TermPickerFullScreen(
              title: "${UtilityMethods.getLocalizedString("select")} "
                  "${UtilityMethods.getLocalizedString("City")}",
              termType: key,
              termMetaDataList: FilterPageFunctions.getTermDataFromStorage(propertyCityDataType),
              termsDataMap: {},
              termPickerFullScreenListener: (String pickedTerm, int? pickedTermId, String pickedTermSlug) {
                Map<String, dynamic> updatedMap = {
                  CITY: [pickedTerm],
                  CITY_SLUG: [pickedTermSlug],
                  PROPERTY_AREA: "",
                  PROPERTY_AREA_SLUG: "",
                };
                Map<String, dynamic> mergedMap = UtilityMethods.mergeMapsWithPrecedence(dataMap, updatedMap);
                mergedMap = UtilityMethods.removeElementFromLists(mergedMap);
                widget.listener(updatedSearchMap: mergedMap);
                setState(() {
                  chipsSearchDataMap.clear();
                  chipsSearchDataMap.addAll(widget.chipsSearchDataMap);

                  filterChipsRelatedList.clear();
                  filterChipsRelatedList.addAll(widget.filterChipsRelatedList);
                });
              },
            ),
          ));
    }  else if (dataMap != null && key == FEATURED_CHIP_KEY) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FeaturedSwitchDialog(
            title: FEATURED_CHIP_VALUE,
            showFeatured: dataMap[showFeaturedKey] ?? false,
            listener: (switchValue) {
              Map<String, dynamic> updatedMap = {};
              updatedMap.addAll(dataMap);
              updatedMap[showFeaturedKey] = switchValue;
              widget.listener(updatedSearchMap: updatedMap);

              resetSearchMaps();
            },
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilterPage(
            mapInitializeData: dataMap != null && dataMap.isNotEmpty
                ? dataMap
                : HiveStorageManager.readFilterDataInfo() ?? {},
            filterPageListener: (Map<String, dynamic> map, String closeOption) {
              if (closeOption == DONE) {
                Navigator.of(context).pop();
                widget.listener(onRefresh: true);
              } else if (closeOption == CLOSE) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      );
    }
  }

  void resetSearchMaps() {
    if (mounted) {
      setState(() {
        chipsSearchDataMap.clear();
        chipsSearchDataMap.addAll(widget.chipsSearchDataMap);

        filterChipsRelatedList.clear();
        filterChipsRelatedList.addAll(widget.filterChipsRelatedList);
      });
    }
  }

  String handleChipValueForList(List inputList){
    String value = "";
    if (inputList.length == 1) {
      value = UtilityMethods.getLocalizedString(inputList[0]);
    } else if (inputList.length == 2) {
      for (int i = 0; i < inputList.length; i++) {
        inputList[i] = UtilityMethods.getLocalizedString(inputList[i]);
      }
      value = inputList.join(', ');
    }
    // If we have more than two items
    else if (inputList.length > 2) {
      List tempList = inputList.sublist(0, 2);
      // Localize the items
      for (int i = 0; i < tempList.length; i++) {
        tempList[i] = UtilityMethods.getLocalizedString(tempList[i]);
      }
      // Make a String of items
      value = tempList.join(', ') + " ...";
    }

    return value;
  }

  String handleChipValueForString(String inputString){
    String value = "";
    List<String> dataList = UtilityMethods.getListFromString(inputString);
    if (dataList.isNotEmpty) {
      value = handleChipValueForList(dataList);
    }

    return value;
  }

  IconData? getFilterChipIcon(String key){
    switch (key) {
      case (PROPERTY_TYPE): {
        return AppThemePreferences.locationCityIcon;
      }
      case (PROPERTY_STATUS): {
        return AppThemePreferences.checkCircleIcon;
      }
      case (PROPERTY_LABEL): {
        return AppThemePreferences.labelIcon;
      }
      case (PROPERTY_FEATURES): {
        return AppThemePreferences.featureChipIcon;
      }
      case (PROPERTY_KEYWORD): {
        return AppThemePreferences.keywordCupertinoIcon;
      }
      case (CITY): {
        return AppThemePreferences.locationIcon;
      }
      case (PROPERTY_COUNTRY): {
        return AppThemePreferences.locationCountryIcon;
      }
      case (PROPERTY_STATE): {
        return AppThemePreferences.locationStateIcon;
      }
      case (PROPERTY_AREA): {
        return AppThemePreferences.locationAreaIcon;
      }
      case (BEDROOMS): {
        return AppThemePreferences.bedIcon;
      }
      case (BATHROOMS): {
        return AppThemePreferences.bathtubIcon;
      }
      case (PRICE_MIN): {
        return AppThemePreferences.priceTagIcon;
      }
      case (PRICE_MAX): {
        return AppThemePreferences.priceTagIcon;
      }
      case (AREA_MIN): {
        return AppThemePreferences.areaSizeIcon;
      }
      case (AREA_MAX): {
        return AppThemePreferences.areaSizeIcon;
      }
      case (FEATURED_CHIP_KEY): {
        return AppThemePreferences.featureChipIcon;
      }
      case (favPropertyBedroomsKey): {
        return AppThemePreferences.bedIcon;
      }
      case (favPropertyBathroomsKey): {
        return AppThemePreferences.bathtubIcon;
      }
      case (favPropertyPriceKey): {
        return AppThemePreferences.priceTagIcon;
      }
      case (favPropertySizeKey): {
        return AppThemePreferences.areaSizeIcon;
      }
      case (favPropertyGarageKey): {
        return AppThemePreferences.garageIcon;
      }
      case (favPropertyYearKey): {
        return AppThemePreferences.dateRangeIcon;
      }
      default: {
        if (key.contains(KEYWORD_PREFIX)) {
          return AppThemePreferences.keywordCupertinoIcon;
        }
        return null;
      }
    }

  }
}

class GenericFilterRelatedChipWidget extends StatelessWidget {
  final IconData? iconData;
  final String label;
  final Map filterMap;
  final void Function()? onTap;

  const GenericFilterRelatedChipWidget({
    Key? key,
    this.iconData,
    this.label = "",
    required this.filterMap,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return label.isEmpty ? Container() : SearchResultsChoiceChipsWidget(
      label: label,
      iconData: iconData,
      onSelected: (value) => onTap!(),
    );
  }
}

