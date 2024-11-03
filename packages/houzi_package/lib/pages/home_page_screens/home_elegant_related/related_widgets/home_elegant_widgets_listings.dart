import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/models/terms_with_icon.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/all_blogs.dart';
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/theme_service_files/theme_storage_manager.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/all_agency.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/all_agents.dart';
import 'package:houzi_package/pages/search_result.dart';
import 'package:houzi_package/widgets/blogs_related/blogs_listing_widget.dart';
import 'package:houzi_package/widgets/dynamic_widgets/terms_with_icons_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_properties_related_widgets/explore_properties_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_properties_related_widgets/latest_featured_properties_widget/properties_carousel_list_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_realtors_related_widgets/home_screen_realtors_list_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_recent_searches_widget/home_screen_recent_searches_widget.dart';
import 'package:houzi_package/widgets/partners_widget/partner_widget.dart';
import 'package:houzi_package/widgets/type_status_row_widget.dart';
import 'package:provider/provider.dart';


typedef HomeElegantListingsWidgetListener = void Function(bool errorWhileLoading, bool refreshData);

class HomeElegantListingsWidget extends StatefulWidget {
  final homeScreenData;
  final bool refresh;
  final HomeElegantListingsWidgetListener? homeScreen02ListingsWidgetListener;

  const HomeElegantListingsWidget({
    super.key,
    this.homeScreenData,
    this.refresh = false,
    this.homeScreen02ListingsWidgetListener,
  });

  @override
  State<HomeElegantListingsWidget> createState() => _HomeElegantListingsWidgetState();
}

class _HomeElegantListingsWidgetState extends State<HomeElegantListingsWidget> {

  int page = 1;

  String arrowDirection = " >";

  bool isDataLoaded = false;
  bool noDataReceived = false;
  bool _isNativeAdLoaded = false;
  bool permissionGranted = false;

  NativeAd? _nativeAd;

  List<dynamic> homeScreenList = [];

  Map homeConfigMap = {};
  Map<String, dynamic>setRouteRelatedDataMap = {};


  Future<List<dynamic>>? _futureHomeScreenList;

  VoidCallback? generalNotifierLister;

  final PropertyBloc _propertyBloc = PropertyBloc();

  Widget? _placeHolderWidget;

  List<TermsWithIcon> _termsWithIconList = [];


  @override
  void initState() {
    super.initState();

    generalNotifierLister = () {
      if (GeneralNotifier().change == GeneralNotifier.CITY_DATA_UPDATE) {
        //old listing
        if((homeConfigMap[sectionTypeKey] == allPropertyKey &&
            homeConfigMap[subTypeKey] == propertyCityDataType)){

            Map<String, dynamic> map = HiveStorageManager.readSelectedCityInfo();
            String cityId = UtilityMethods.valueForKeyOrEmpty(map, CITY_ID);
            String city = UtilityMethods.valueForKeyOrEmpty(map, CITY);
            if(homeConfigMap[subTypeValueCityKey] != cityId){
              setState(() {
              homeScreenList = [];
              isDataLoaded = false;
              noDataReceived = false;

              homeConfigMap[subTypeValueCityKey] = cityId;

              homeConfigMap[titleKey] = UtilityMethods.titleForSectionBasedOnCitySelection(homeConfigMap, city);
              });

              loadData();
            }
        }
        else if(homeConfigMap[sectionTypeKey] == propertyKey &&
            UtilityMethods.listDependsOnCitySelection(homeConfigMap)){

          Map<String, dynamic> map = HiveStorageManager.readSelectedCityInfo();
          String cityId = UtilityMethods.valueForKeyOrEmpty(map, CITY_ID);

          setState(() {
            if(homeConfigMap[subTypeValueCityKey] != cityId) {
              homeScreenList = [];
              isDataLoaded = false;
              noDataReceived = false;
              homeConfigMap[subTypeValueCityKey] = cityId;
              String city = UtilityMethods.valueForKeyOrEmpty(map, CITY);
              homeConfigMap[titleKey] =
                  UtilityMethods.titleForSectionBasedOnCitySelection(homeConfigMap, city);
            }
          });

          loadData();
        }

      } else if(GeneralNotifier().change == GeneralNotifier.RECENT_DATA_UPDATE &&
          homeConfigMap[sectionTypeKey] == recentSearchKey){
        setState(() {
          homeScreenList.clear();
          List tempList = HiveStorageManager.readRecentSearchesInfo() ?? [];
          if(tempList.isNotEmpty){
            homeScreenList.addAll(tempList);
          }

          isDataLoaded = true;

        });
      } else if(GeneralNotifier().change == GeneralNotifier.TOUCH_BASE_DATA_LOADED &&
          homeConfigMap[sectionTypeKey] != adKey
          && homeConfigMap[sectionTypeKey] != recentSearchKey
          && homeConfigMap[sectionTypeKey] != PLACE_HOLDER_SECTION_TYPE
      ){
        if(mounted){
          setState(() {
            loadData();
            widget.homeScreen02ListingsWidgetListener!(false, false);
          });
        }
      }
    };

    GeneralNotifier().addListener(generalNotifierLister!);
  }

  @override
  void dispose() {
    super.dispose();

    if(_nativeAd != null){
      _nativeAd!.dispose();
    }
    homeScreenList = [];
    homeConfigMap = {};
    if (generalNotifierLister != null) {
      GeneralNotifier().removeListener(generalNotifierLister!);
    }
  }

  setUpNativeAd() {
    print("CALLING ADS");
    String themeMode = ThemeStorageManager.readData(THEME_MODE_INFO) ?? LIGHT_THEME_MODE;
    bool isDarkMode = false;
    if (themeMode == DARK_THEME_MODE) {
      isDarkMode = true;
    }
    _nativeAd = NativeAd(
      customOptions: {"isDarkMode": isDarkMode},
      adUnitId: Platform.isAndroid ? ANDROID_NATIVE_AD_ID : IOS_NATIVE_AD_ID,
      factoryId: 'homeNativeAd',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isNativeAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (kDebugMode) {
            print(
              'Ad load failed (code=${error.code} message=${error.message})',
            );
          }
        },
      ),
    );

    _nativeAd!.load();
  }

  loadData() {
    _futureHomeScreenList = fetchRelatedList(context, page);
    _futureHomeScreenList!.then((value) {
      if (value == null || value.isEmpty) {
        noDataReceived = true;
      } else {
        if (value[0].runtimeType == Response) {
          // print("Generic Home Listing (Error Code): ${value[0].statusCode}");
          // print("Generic Home Listing (Error Msg): ${value[0].statusMessage}");
          noDataReceived = true;
          widget.homeScreen02ListingsWidgetListener!(true, false);
        } else {
          homeScreenList = value;
          isDataLoaded = true;
          noDataReceived = false;
        }
      }

      if (mounted) {
        setState(() {});
      }

      return null;
    });
  }

  Future<List<dynamic>> fetchRelatedList(BuildContext context, int page) async {
    List<dynamic> tempList = [];
    setRouteRelatedDataMap = {};

    if (homeConfigMap[showNearbyKey] ?? false) {
      permissionGranted = await UtilityMethods.locationPermissionsHandling(permissionGranted);
    }
    try {
      /// Fetch featured properties (no longer used, because it doesn't consider other query params)
      if (homeConfigMap[sectionTypeKey] == featuredPropertyKey) {
        tempList = await _propertyBloc.fetchFeaturedArticles(page);
      }

      /// Fetch All_properties (old)
      else if (homeConfigMap[sectionTypeKey] == allPropertyKey &&
          homeConfigMap[subTypeKey] != propertyCityDataType) {
        String key = UtilityMethods.getSearchKey(homeConfigMap[subTypeKey] ?? "");
        String value = homeConfigMap[subTypeValueKey] ?? "";
        Map<String, dynamic> dataMap = {};
        if(value.isNotEmpty && value != allString){
          dataMap = {key: value};
        }
        Map<String, dynamic> tempMap = await _propertyBloc.fetchFilteredArticles(dataMap);
        tempList.addAll(tempMap["result"]);
      }

      /// Fetch latest and city selected properties (old)
      else if (homeConfigMap[sectionTypeKey] == allPropertyKey &&
          homeConfigMap[subTypeKey] == propertyCityDataType) {
        Map<String, dynamic> map = HiveStorageManager.readSelectedCityInfo();
        String city = UtilityMethods.valueForKeyOrEmpty(map, CITY);
        String cityId = UtilityMethods.valueForKeyOrEmpty(map, CITY_ID);
        homeConfigMap[titleKey] = UtilityMethods.titleForSectionBasedOnCitySelection(homeConfigMap, city);
        if (city.isNotEmpty) {
          homeConfigMap[subTypeValueKey] = cityId;
        }
        if (homeConfigMap[subTypeValueKey] == userSelectedString || homeConfigMap[subTypeValueKey] == ""
            || homeConfigMap[subTypeValueKey] == allString) {
          tempList = await _propertyBloc.fetchLatestArticles(page);
        } else {
          int id = int.parse(homeConfigMap[subTypeValueKey]);
          tempList = await _propertyBloc.fetchPropertiesInCityList(id, page, 16);
        }
      }

      /// Fetch Properties
      else if (homeConfigMap[sectionTypeKey] == propertyKey) {
        Map<String, dynamic> dataMap = {};

        if (UtilityMethods.listDependsOnCitySelection(homeConfigMap)) {
          Map<String, dynamic> map = HiveStorageManager.readSelectedCityInfo();
          String city = UtilityMethods.valueForKeyOrEmpty(map, CITY);
          homeConfigMap[titleKey] = UtilityMethods.titleForSectionBasedOnCitySelection(homeConfigMap, city);

          if (map.isNotEmpty && city.isNotEmpty && city.toLowerCase() != 'all' && city != 'please_select') {
            String citySlug = UtilityMethods.valueForKeyOrEmpty(map, CITY_SLUG);
            if (citySlug.isNotEmpty) {
              dataMap[SEARCH_RESULTS_LOCATION] = citySlug;
              setRouteRelatedDataMap[CITY_SLUG] = citySlug;
              setRouteRelatedDataMap[CITY] = city;
            }
          } else {
            setRouteRelatedDataMap[CITY] = allCapString;
          }
        }

        if(homeConfigMap.containsKey(searchApiMapKey) && homeConfigMap.containsKey(searchRouteMapKey) &&
            (homeConfigMap[searchApiMapKey] != null) && (homeConfigMap[searchRouteMapKey] != null)){
          dataMap.addAll(homeConfigMap[searchApiMapKey]);
          setRouteRelatedDataMap.addAll(homeConfigMap[searchRouteMapKey]);
        }
        else if(homeConfigMap.containsKey(subTypeListKey) && homeConfigMap.containsKey(subTypeValueListKey) &&
            (homeConfigMap[subTypeListKey] != null && homeConfigMap[subTypeListKey].isNotEmpty) &&
            (homeConfigMap[subTypeValueListKey] != null && homeConfigMap[subTypeValueListKey].isNotEmpty)){
          List subTypeList = homeConfigMap[subTypeListKey];
          List subTypeValueList = homeConfigMap[subTypeValueListKey];
          for(var item in subTypeList){
            if(item != allString){
              String searchKey = UtilityMethods.getSearchKey(item);
              String searchItemNameFilterKey = UtilityMethods.getSearchItemNameFilterKey(item);
              String searchItemSlugFilterKey = UtilityMethods.getSearchItemSlugFilterKey(item);
              List value = UtilityMethods.getSubTypeItemRelatedList(item, subTypeValueList);
              if(value.isNotEmpty && value[0].isNotEmpty) {
                dataMap[searchKey] = value[0];
                setRouteRelatedDataMap[searchItemSlugFilterKey] = value[0];
                setRouteRelatedDataMap[searchItemNameFilterKey] = value[1];
              }
            }
          }
        }
        else{
          String key = UtilityMethods.getSearchKey(homeConfigMap[subTypeKey]);
          String searchItemNameFilterKey = UtilityMethods.getSearchItemNameFilterKey(homeConfigMap[subTypeKey]);
          String searchItemSlugFilterKey = UtilityMethods.getSearchItemSlugFilterKey(homeConfigMap[subTypeKey]);
          String value = homeConfigMap[subTypeValueKey] ?? "";
          if(value.isNotEmpty && value != allString && value != userSelectedString){
            dataMap = {key: [value]};
            String itemName = UtilityMethods.getPropertyMetaDataItemNameWithSlug(dataType: homeConfigMap[subTypeKey], slug: value);
            setRouteRelatedDataMap[searchItemSlugFilterKey] = [value];
            setRouteRelatedDataMap[searchItemNameFilterKey] = [itemName];
          }
        }

        if(homeConfigMap[showFeaturedKey] ?? false){
          dataMap[SEARCH_RESULTS_FEATURED] = 1;
          setRouteRelatedDataMap[showFeaturedKey] = true;
        }

        if (homeConfigMap[showNearbyKey] ?? false) {
          if (permissionGranted) {
            Map<String, dynamic> dataMapForNearby = {};
            dataMapForNearby = await UtilityMethods.getMapForNearByProperties();
            dataMap.addAll(dataMapForNearby);
            setRouteRelatedDataMap.addAll(dataMapForNearby);
          } else {
            return [];
          }
        }

        if (dataMap.isEmpty) {
          dataMap[PAGE_KEY] = page;
          dataMap[PER_PAGE_KEY] = PER_PAGE_VALUE;
        }
        //
        // print("setRouteRelatedDataMap: $setRouteRelatedDataMap");

        Map<String, dynamic> tempMap = await _propertyBloc.fetchFilteredArticles(dataMap);
        if(tempMap["result"] != null){
          tempList.addAll(tempMap["result"]);
        }
      }


      /// Fetch realtors list
      else if (homeConfigMap[sectionTypeKey] == agenciesKey ||
          homeConfigMap[sectionTypeKey] == agentsKey) {
        if (homeConfigMap[subTypeKey] == REST_API_AGENT_ROUTE) {
          tempList = await _propertyBloc.fetchAllAgentsInfoList(page, 16);
        } else {
          tempList = await _propertyBloc.fetchAllAgenciesInfoList(page, 16);
        }
      }


      /// Fetch Terms
      else if (homeConfigMap[sectionTypeKey] == termKey) {
        if(homeConfigMap.containsKey(subTypeListKey) &&
            (homeConfigMap[subTypeListKey] != null &&
                homeConfigMap[subTypeListKey].isNotEmpty)){
          List subTypeList = homeConfigMap[subTypeListKey];
          if(subTypeList.length == 1 && subTypeList[0] == allString){
            Map<String, dynamic> tempMap = {};
            tempMap = removeRedundantLocationTermsKeys(allTermsList);
            setRouteRelatedDataMap.addAll(tempMap);
            tempList = await _propertyBloc.fetchTermData(allTermsList);
          }else{
            if(subTypeList.contains(allString)){
              subTypeList.remove(allString);
            }
            Map<String, dynamic> tempMap = {};
            tempMap = removeRedundantLocationTermsKeys(subTypeList);
            setRouteRelatedDataMap.addAll(tempMap);
            tempList = await _propertyBloc.fetchTermData(subTypeList);
          }
        }else{
          if(homeConfigMap[subTypeKey] != null && homeConfigMap[subTypeKey].isNotEmpty){
            if(homeConfigMap[subTypeKey] == allString){
              Map<String, dynamic> tempMap = {};
              tempMap = removeRedundantLocationTermsKeys(allTermsList);
              setRouteRelatedDataMap.addAll(tempMap);
              tempList = await _propertyBloc.fetchTermData(allTermsList);
            }else{
              var item = homeConfigMap[subTypeKey] ?? "";
              String key = UtilityMethods.getSearchItemNameFilterKey(item);
              setRouteRelatedDataMap[key] = [allCapString];
              tempList = await _propertyBloc.fetchTermData(homeConfigMap[subTypeKey]);
            }
          }
        }
      }

      /// Fetch taxonomies
      else if (homeConfigMap[sectionTypeKey] == termWithIconsTermKey) {
        tempList = [1];
      }

      /// Fetch partners list
      else if (homeConfigMap[sectionTypeKey] == partnersKey) {
        tempList = await _propertyBloc.fetchPartnersList();
      }

      /// Fetch Blogs list
      else if (homeConfigMap[sectionTypeKey] == blogsKey) {
        var(success, internet, blogsData) = await _propertyBloc.fetchBlogArticles(
            {"page": "1", "per_page": "20"});
        if (success && blogsData != null) {
          tempList = blogsData.articlesList ?? [];
        }
      } else {
        tempList = [];
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return tempList;
  }

  Map<String, dynamic> removeRedundantLocationTermsKeys(List subTypeList){
    Map<String, dynamic> tempMap = {};
    for(var item in subTypeList){
      String key = UtilityMethods.getSearchItemNameFilterKey(item ?? "");
      tempMap[key] = [allCapString];
    }
    List<String> keysList = tempMap.keys.toList();
    if(keysList.isNotEmpty) {
      List<String> intersectionKeysList = locationRelatedList.toSet().intersection((keysList.toSet())).toList();
      if (intersectionKeysList.isNotEmpty && intersectionKeysList.length > 1) {
        for (int i = 1; i < intersectionKeysList.length; i++) {
          String key = intersectionKeysList[i];
          tempMap.remove(key);
        }
      }
    }

    return tempMap;
  }

  setRouteToNavigate() async {
    StatefulWidget Function(dynamic context)? route;

    if (homeConfigMap[sectionTypeKey] == featuredPropertyKey) {
      route = getSearchResultPath(onlyFeatured: true);
    }
    else if (homeConfigMap[sectionTypeKey] == allPropertyKey &&
        homeConfigMap[subTypeKey] != propertyCityDataType) {
      Map<String, dynamic> dataMap = {
        UtilityMethods.getSearchKey(homeConfigMap[subTypeKey]): "",
      };
      route = getSearchResultPath(map: dataMap);
    } else if (homeConfigMap[sectionTypeKey] == termKey) {
      route = getSearchResultPath(map: setRouteRelatedDataMap);
    } else if (homeConfigMap[subTypeKey] == agenciesKey) {
      route = (context) => AllAgency();
    } else if (homeConfigMap[subTypeKey] == agentsKey) {
      route = (context) => AllAgents();
    } else if (homeConfigMap[sectionTypeKey] == allPropertyKey) {
      Map<String, dynamic> dataMap = {};
      if (UtilityMethods.listDependsOnCitySelection(homeConfigMap)) {
        Map<String, dynamic> cityInfoMap = HiveStorageManager
            .readSelectedCityInfo() ?? {};
        String citySlug = UtilityMethods.valueForKeyOrEmpty(
            cityInfoMap, CITY_SLUG);
        String city = UtilityMethods.valueForKeyOrEmpty(cityInfoMap, CITY);
        if (city.isNotEmpty) {
          dataMap[CITY_SLUG] = citySlug;
          dataMap[CITY] = city;
        } else {
          dataMap[CITY] = allCapString;
        }
      }
      route = getSearchResultPath(map: dataMap);
    } else if (homeConfigMap[sectionTypeKey] == blogsKey) {
      route = (context) => AllBlogsPage(
        title: homeConfigMap[titleKey],
        blogDesign: UtilityMethods.getDesignValue(homeConfigMap[designKey]) ?? DESIGN_01);
    } else if (homeConfigMap[sectionTypeKey] == propertyKey) {
      Map<String, dynamic> dataMap = {};
      dataMap.addAll(setRouteRelatedDataMap);
      if(UtilityMethods.listDependsOnCitySelection(homeConfigMap)) {
        Map<String, dynamic> cityInfoMap = HiveStorageManager.readSelectedCityInfo() ?? {};
        String citySlug = UtilityMethods.valueForKeyOrEmpty(cityInfoMap, CITY_SLUG);
        String city = UtilityMethods.valueForKeyOrEmpty(cityInfoMap, CITY);
        if (city.isNotEmpty) {
          dataMap[CITY_SLUG] = citySlug;
          dataMap[CITY] = city;
        }else{
          dataMap[CITY] = allCapString;
        }
      }
      bool featured = dataMap[showFeaturedKey] != null && dataMap[showFeaturedKey] is bool && dataMap[showFeaturedKey] ? true : false;
      route = getSearchResultPath(
        onlyFeatured: featured,
        map: dataMap,
      );
    } else {
      route = null;
    }

    navigateToRoute(route);
  }

  getSearchResultPath({Map<String, dynamic>? map, bool onlyFeatured = false}){
    return (context) => SearchResult(
      dataInitializationMap:  map,
      searchPageListener: (Map<String, dynamic> map, String closeOption) {
        if(closeOption.isEmpty){
          GeneralNotifier().publishChange(GeneralNotifier.FILTER_DATA_LOADING_COMPLETE);
        }
        if (closeOption == CLOSE) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  navigateToRoute(WidgetBuilder? builder) {
    if (builder != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: builder,
        ),
      );
    }
  }

  bool needToLoadData(Map oldDataMap, Map newDataMap){
    if(oldDataMap[sectionTypeKey] != newDataMap[sectionTypeKey] ||
        oldDataMap[subTypeKey] != newDataMap[subTypeKey] ||
        oldDataMap[subTypeValueKey] != newDataMap[subTypeValueKey]){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.homeScreenData != homeConfigMap) {
      // Make sure new Home item is Map
      var newHomeConfigMap = widget.homeScreenData;
      if (newHomeConfigMap is! Map) {
        newHomeConfigMap = widget.homeScreenData.toJson();
      }

      if (!(mapEquals(newHomeConfigMap, homeConfigMap))) {

        if (homeConfigMap[sectionTypeKey] != newHomeConfigMap[sectionTypeKey]
            && newHomeConfigMap[sectionTypeKey] == recentSearchKey
        ) {
          homeScreenList.clear();
          List tempList = HiveStorageManager.readRecentSearchesInfo() ?? [];
          if(tempList.isNotEmpty) homeScreenList.addAll(tempList);
        } else if (newHomeConfigMap[sectionTypeKey] == adKey
            && SHOW_ADS_ON_HOME && !_isNativeAdLoaded
        ) {
          setUpNativeAd();
        } else if (newHomeConfigMap[sectionTypeKey] == PLACE_HOLDER_SECTION_TYPE) {
          _placeHolderWidget = HooksConfigurations.homeWidgetsHook(
              context,
              newHomeConfigMap[titleKey],
              widget.refresh);
        }

        if (needToLoadData(homeConfigMap, newHomeConfigMap)){
          // Update Home Item
          homeConfigMap.clear();
          homeConfigMap.addAll(newHomeConfigMap);

          loadData();
          // widget.refresh = true;
        }

        // // Update Home Item
        // homeConfigMap.clear();
        // homeConfigMap.addAll(newHomeConfigMap);


      }
    }


    if(widget.refresh
        && homeConfigMap[sectionTypeKey] != adKey
        && homeConfigMap[sectionTypeKey] != PLACE_HOLDER_SECTION_TYPE
        && homeConfigMap[sectionTypeKey] != recentSearchKey
    ){
      homeScreenList = [];
      isDataLoaded = false;
      noDataReceived = false;
      // loadData();
      // widget.refresh = false;
    }

    if (homeConfigMap[sectionTypeKey] == PLACE_HOLDER_SECTION_TYPE) {
      if (_placeHolderWidget != null) {
        noDataReceived = false;
       if (widget.refresh) {
         _placeHolderWidget = HooksConfigurations.homeWidgetsHook(
           context,
           homeConfigMap[titleKey],
           widget.refresh);
       }
      } else {
        noDataReceived = true;
      }
    }

    if (homeConfigMap[sectionTypeKey] == termWithIconsTermKey &&
        homeConfigMap[termsWithIconConfiguration] != null &&
        homeConfigMap[termsWithIconConfiguration] is List &&
        homeConfigMap[termsWithIconConfiguration].isNotEmpty) {
      _termsWithIconList =
          TermsWithIcon.decode(homeConfigMap[termsWithIconConfiguration]);
    } else {
      _termsWithIconList = [];
    }

    if (homeConfigMap[sectionTypeKey] == blogsKey &&
        homeConfigMap[designKey] is String &&
        homeConfigMap[designKey].isNotEmpty) {
      BLOGS_DESIGN = UtilityMethods.getDesignValue(homeConfigMap[designKey]) ?? DESIGN_01;
    }

    return Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          if ((homeConfigMap[sectionTypeKey] == allPropertyKey ||
              homeConfigMap[sectionTypeKey] == propertyKey) &&
              homeConfigMap[subTypeKey] == propertyCityDataType) {
            Map<String, dynamic> map = HiveStorageManager.readSelectedCityInfo();
            String cityId = UtilityMethods.valueForKeyOrEmpty(map, CITY_ID);
            String city = UtilityMethods.valueForKeyOrEmpty(map, CITY);
            homeConfigMap[titleKey] = UtilityMethods.titleForSectionBasedOnCitySelection(homeConfigMap, city);
            if (cityId.isNotEmpty) {
              homeConfigMap[subTypeValueCityKey] = cityId;
            }
          }

          if(homeConfigMap[sectionTypeKey] == recentSearchKey && homeScreenList.isNotEmpty){
            homeScreenList.removeWhere((element) => element is! Map);
          }

          return noDataReceived
              ? Container()
              : Column(
            children: [
              if (homeConfigMap[sectionTypeKey] != adKey
                  && homeScreenList.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Home02HeaderWidget(
                        text: UtilityMethods.getLocalizedString(homeConfigMap[titleKey]),
                        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
                      ),
                    ),

                    if(homeConfigMap[sectionTypeKey] != recentSearchKey
                        && homeConfigMap[sectionTypeKey] != partnersKey
                        && homeConfigMap[sectionTypeKey] != termWithIconsTermKey)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setRouteToNavigate(),
                          child: Padding(
                            padding: EdgeInsets.only(left : UtilityMethods.isRTL(context) ? 20 : 0,right: UtilityMethods.isRTL(context) ? 0 : 20,top: 5),
                            child: GenericTextWidget(
                              UtilityMethods.getLocalizedString("see_all") + arrowDirection,
                              style: AppThemePreferences().appTheme.readMoreTextStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              if (homeConfigMap[sectionTypeKey] == termWithIconsTermKey)
                  _termsWithIconList.isNotEmpty
                  ? DynamicTermsWithIconWidget(dataList: _termsWithIconList)
                  : TermWithIconsWidget(),
              if(homeConfigMap[sectionTypeKey] == recentSearchKey) HomeScreenRecentSearchesWidget(
                recentSearchesInfoList: HiveStorageManager.readRecentSearchesInfo() ?? [],
                listingView: homeConfigMap[sectionListingViewKey] ?? homeScreenWidgetsListingCarouselView,
              ),
              if(homeConfigMap[sectionTypeKey] == adKey && SHOW_ADS_ON_HOME && _isNativeAdLoaded) Container(
                padding: const EdgeInsets.only(left: 10,right: 10),
                height: 50,
                child: AdWidget(ad: _nativeAd!),
              ),
              if (homeConfigMap[sectionTypeKey] == allPropertyKey ||
                  homeConfigMap[sectionTypeKey] == propertyKey ||
                  homeConfigMap[sectionTypeKey] == featuredPropertyKey)
                if (isDataLoaded)
                  PropertiesListingGenericWidget(
                    propertiesList: homeScreenList,
                    design: UtilityMethods.getHomePropertyItemDesignName(homeConfigMap),
                    listingView: homeConfigMap[sectionListingViewKey] ?? homeScreenWidgetsListingCarouselView,
                  )
                else genericLoadingWidgetForCarousalWithShimmerEffect(context),
              if (homeConfigMap[sectionTypeKey] == termKey)
                if (isDataLoaded)
                  ExplorePropertiesWidget(
                    design: UtilityMethods.getDesignValue(homeConfigMap[designKey]),
                    propertiesData: homeScreenList,
                    listingView: homeConfigMap[sectionListingViewKey] ?? homeScreenWidgetsListingCarouselView,
                    explorePropertiesWidgetListener: ({filterDataMap}) {
                      if (filterDataMap != null && filterDataMap.isNotEmpty) {

                      }
                    },
                  )
                else genericLoadingWidgetForCarousalWithShimmerEffect(context),
              if (homeConfigMap[sectionTypeKey] == REST_API_AGENCY_ROUTE ||
                  homeConfigMap[sectionTypeKey] == REST_API_AGENT_ROUTE)
                if (isDataLoaded && homeScreenList.isNotEmpty && homeScreenList[0] is List) RealtorListingsWidget(
                  listingView: homeConfigMap[sectionListingViewKey] ?? homeScreenWidgetsListingCarouselView,
                  tag: homeConfigMap[subTypeKey] == REST_API_AGENT_ROUTE
                      ? AGENTS_TAG
                      : AGENCIES_TAG,
                  realtorInfoList: homeScreenList[0],
                )
                else genericLoadingWidgetForCarousalWithShimmerEffect(context),

              if (homeConfigMap[sectionTypeKey] == PLACE_HOLDER_SECTION_TYPE &&
                  _placeHolderWidget != null) _placeHolderWidget!,

              if (homeConfigMap[sectionTypeKey] == partnersKey)
                PartnerWidget(
                  partnersList: homeScreenList,
                  // listingView: LIST_VIEW,
                  // listingView: CAROUSEL_VIEW,
                  listingView: homeConfigMap[sectionListingViewKey] ?? CAROUSEL_VIEW,
                ),

              if (homeConfigMap[sectionTypeKey] == blogsKey)
                BlogsListingWidget(
                  view: homeConfigMap[sectionListingViewKey] ?? CAROUSEL_VIEW,
                  design: UtilityMethods.getDesignValue(homeConfigMap[designKey]) ?? DESIGN_01,
                  articlesList: List<BlogArticle>.from(homeScreenList),
                ),
            ],
          );
        });
  }
}