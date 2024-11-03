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
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/theme_service_files/theme_notifier.dart';
import 'package:houzi_package/files/theme_service_files/theme_storage_manager.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_properties_related_widgets/explore_properties_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_properties_related_widgets/latest_featured_properties_widget/properties_carousel_list_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_realtors_related_widgets/home_screen_realtors_list_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_recent_searches_widget/home_screen_recent_searches_widget.dart';
import 'package:houzi_package/widgets/blogs_related/blogs_listing_widget.dart';
import 'package:houzi_package/widgets/dynamic_widgets/terms_with_icons_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/partners_widget/partner_widget.dart';
import 'package:houzi_package/widgets/type_status_row_widget.dart';
import 'package:provider/provider.dart';


typedef HomeScreenListingsWidgetListener = void Function(bool errorWhileLoading, bool refreshData);

class HomeScreenListingsWidget extends StatefulWidget {
  final homeScreenData;
  final bool refresh;
  final HomeScreenListingsWidgetListener homeScreenListingsWidgetListener;

  HomeScreenListingsWidget({
    required this.homeScreenData,
    this.refresh = false,
    required this.homeScreenListingsWidgetListener,
  });

  @override
  State<HomeScreenListingsWidget> createState() => _HomeScreenListingsWidgetState();
}

class _HomeScreenListingsWidgetState extends State<HomeScreenListingsWidget>  with AutomaticKeepAliveClientMixin<HomeScreenListingsWidget>  {

  int page = 1;

  NativeAd? _nativeAd;

  bool isDataLoaded = false;
  bool noDataReceived = false;
  bool _isNativeAdLoaded = false;
  bool permissionGranted = false;

  Map homeConfigMap = {};

  List<dynamic> homeScreenList = [];

  Future<List<dynamic>>? _futureHomeScreenList;

  final PropertyBloc _propertyBloc = PropertyBloc();

  VoidCallback? generalNotifierLister;

  Widget? _placeHolderWidget;

  List<TermsWithIcon> _termsWithIconList = [];


  @override
  void initState() {
    super.initState();

    generalNotifierLister = () {
      if (GeneralNotifier().change == GeneralNotifier.CITY_DATA_UPDATE) {

        if (homeConfigMap[sectionTypeKey] == allPropertyKey
            && homeConfigMap[subTypeKey] == propertyCityDataType) {

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

      }

      else if(GeneralNotifier().change == GeneralNotifier.RECENT_DATA_UPDATE
          && homeConfigMap[sectionTypeKey] == recentSearchKey){
        if (mounted) {
          setState(() {
            homeScreenList.clear();
            List tempList = HiveStorageManager.readRecentSearchesInfo() ?? [];
            homeScreenList.addAll(tempList);
            setState(() {
              isDataLoaded = true;
            });
          });
        }
      }

      else if (GeneralNotifier().change == GeneralNotifier.TOUCH_BASE_DATA_LOADED
          && homeConfigMap[sectionTypeKey] != adKey
          && homeConfigMap[sectionTypeKey] != recentSearchKey
          && homeConfigMap[sectionTypeKey] != PLACE_HOLDER_SECTION_TYPE) {
        if(mounted){
          setState(() {
            loadData();
            widget.homeScreenListingsWidgetListener(false, false);
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
          widget.homeScreenListingsWidgetListener(true, false);
        } else {
          homeScreenList = value;
          isDataLoaded = true;
          noDataReceived = false;
        }
      }

      if(mounted){
        setState(() {});
      }

      return null;
    });
  }

  Future<List<dynamic>> fetchRelatedList(BuildContext context, int page) async {
    List<dynamic> tempList = [];
    if (homeConfigMap[showNearbyKey]) {
      permissionGranted = await UtilityMethods.locationPermissionsHandling(permissionGranted);
    }
    try {
      /// Fetch featured properties
      if (homeConfigMap[sectionTypeKey] == featuredPropertyKey) {
        tempList = await _propertyBloc.fetchFeaturedArticles(page);
      }

      /// Fetch All_properties (old)
      else if (homeConfigMap[sectionTypeKey] == allPropertyKey
          && homeConfigMap[subTypeKey] != propertyCityDataType) {
        String key = UtilityMethods.getSearchKey(homeConfigMap[subTypeKey]);
        String value = homeConfigMap[subTypeValueKey];
        Map<String, dynamic> dataMap = {};
        if(value != allString && value.isNotEmpty){
          dataMap = {key: value};
        }
        Map<String, dynamic> tempMap = await _propertyBloc.fetchFilteredArticles(dataMap);
        tempList.addAll(tempMap["result"]);
      }

      /// Fetch latest and city selected properties (old)
      else if (homeConfigMap[sectionTypeKey] == allPropertyKey
          && homeConfigMap[subTypeKey] == propertyCityDataType) {
        Map<String, dynamic> map = HiveStorageManager.readSelectedCityInfo();
        String cityId = UtilityMethods.valueForKeyOrEmpty(map, CITY_ID);
        String city = UtilityMethods.valueForKeyOrEmpty(map, CITY);
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
            }
          }
        }

        if(homeConfigMap.containsKey(searchApiMapKey) && homeConfigMap.containsKey(searchRouteMapKey) &&
            (homeConfigMap[searchApiMapKey] != null) && (homeConfigMap[searchRouteMapKey] != null)){
          dataMap.addAll(homeConfigMap[searchApiMapKey]);
        }
        else if(homeConfigMap.containsKey(subTypeListKey) && homeConfigMap.containsKey(subTypeValueListKey) &&
            (homeConfigMap[subTypeListKey] != null && homeConfigMap[subTypeListKey].isNotEmpty) &&
            (homeConfigMap[subTypeValueListKey] != null && homeConfigMap[subTypeValueListKey].isNotEmpty)){
          List subTypeList = homeConfigMap[subTypeListKey];
          List subTypeValueList = homeConfigMap[subTypeValueListKey];
          List tempList = [];
          String searchKey = "";
          for(var item in subTypeList){
            if(item != allString){
              searchKey = UtilityMethods.getSearchKey(item);
              tempList = UtilityMethods.getSubTypeItemRelatedList(item, subTypeValueList);
              if(tempList.isNotEmpty && tempList[0].isNotEmpty) {
                dataMap[searchKey] = tempList[0];
              }
            }
          }
          // dis-allocating the variables
          subTypeList = [];
          subTypeValueList = [];
          tempList = [];
          searchKey = "";
        }

        else{
          String key = UtilityMethods.getSearchKey(homeConfigMap[subTypeKey] ?? "");
          String value = homeConfigMap[subTypeValueKey] ?? "";
          if(value.isNotEmpty && value != allString && value != userSelectedString){
            dataMap = {key: [value]};
          }
        }

        if(homeConfigMap[showFeaturedKey] ?? false){
          dataMap[SEARCH_RESULTS_FEATURED] = 1;
        }

        if (homeConfigMap[showNearbyKey] ?? false) {
          if (permissionGranted) {
            Map<String, dynamic> dataMapForNearby = {};
            dataMapForNearby = await UtilityMethods.getMapForNearByProperties();
            dataMap.addAll(dataMapForNearby);
          } else {
            return [];
          }
        }
        //
        // print("dataMap: $dataMap");

        Map<String, dynamic> tempMap = await _propertyBloc.fetchFilteredArticles(dataMap);
        tempList.addAll(tempMap["result"]);
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
            tempList = await _propertyBloc.fetchTermData(allTermsList);
          }else{
            if(subTypeList.contains(allString)){
              subTypeList.remove(allString);
            }
            tempList = await _propertyBloc.fetchTermData(subTypeList);
          }
        }else{
          if(homeConfigMap[subTypeKey] != null && homeConfigMap[subTypeKey].isNotEmpty){
            if(homeConfigMap[subTypeKey] == allString){
              tempList = await _propertyBloc.fetchTermData(allTermsList);
            }else{
              tempList = await _propertyBloc.fetchTermData(homeConfigMap[subTypeKey]);
            }
          }
        }
      }

      /// Fetch taxonomies
      else if (homeConfigMap[sectionTypeKey] == termWithIconsTermKey) {
        tempList = [1]; // list must not be empty
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
      }

      else {
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
      String key = UtilityMethods.getSearchItemNameFilterKey(item);
      tempMap[key] = [allCapString];
    }
    if(tempMap.isNotEmpty){
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
    }

    return tempMap;
  }

  bool needToLoadData(Map oldDataMap, Map newDataMap){
    if((oldDataMap[sectionTypeKey] != newDataMap[sectionTypeKey]) ||
        (oldDataMap[subTypeKey] != newDataMap[subTypeKey]) ||
        (oldDataMap[subTypeValueKey] != newDataMap[subTypeValueKey])){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.homeScreenData != homeConfigMap) {
      // Make sure new Home item is Map
      var newHomeConfigMap = widget.homeScreenData;
      if (newHomeConfigMap is! Map) {
        newHomeConfigMap = widget.homeScreenData.toJson();
      }

      if (!(mapEquals(newHomeConfigMap, homeConfigMap))) {
        if (homeConfigMap[sectionTypeKey] != newHomeConfigMap[sectionTypeKey]
            && newHomeConfigMap[sectionTypeKey] == recentSearchKey) {
          homeScreenList.clear();
          List tempList = HiveStorageManager.readRecentSearchesInfo() ?? [];
          homeScreenList.addAll(tempList);
        } else if (newHomeConfigMap[sectionTypeKey] == adKey) {
          if (SHOW_ADS_ON_HOME) {
            if(!_isNativeAdLoaded){
              setUpNativeAd();
            }
          }
        } else if (newHomeConfigMap[sectionTypeKey] == PLACE_HOLDER_SECTION_TYPE){
          _placeHolderWidget = HooksConfigurations.homeWidgetsHook(
            context,
            newHomeConfigMap[titleKey],
            widget.refresh);
        } else if (needToLoadData(homeConfigMap, newHomeConfigMap)){
          // Update Home Item
          homeConfigMap = newHomeConfigMap;
          loadData();
        }

        // Update Home Item
        homeConfigMap = newHomeConfigMap;
      }
    }

    if(widget.refresh
        && homeConfigMap[sectionTypeKey] != adKey
        && homeConfigMap[sectionTypeKey] != PLACE_HOLDER_SECTION_TYPE
        && homeConfigMap[sectionTypeKey] != recentSearchKey ) {
      homeScreenList = [];
      isDataLoaded = false;
      noDataReceived = false;
      // loadData();
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

    // print("homeScreenItem: ${homeConfigMap}");

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

    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) {
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

        if (homeConfigMap[sectionTypeKey] == recentSearchKey
              && homeScreenList.isNotEmpty) {
            homeScreenList.removeWhere((element) => element is! Map);
          }

          return noDataReceived
              ? Container()
              : Column(
                  children: [
                    // header widget
                    if (homeConfigMap[sectionTypeKey] != adKey
                        && homeConfigMap[sectionTypeKey] != PLACE_HOLDER_SECTION_TYPE
                        && homeScreenList.isNotEmpty
                        && homeConfigMap[titleKey] is String
                        && homeConfigMap[titleKey].isNotEmpty)
                      HeaderWidget(
                        text: UtilityMethods.getLocalizedString(homeConfigMap[titleKey]),
                        padding: homeConfigMap[sectionTypeKey] == termWithIconsTermKey ?
                        const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0) :
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                      ),

                    if (homeConfigMap[sectionTypeKey] == recentSearchKey)
                      HomeScreenRecentSearchesWidget(
                        recentSearchesInfoList: HiveStorageManager.readRecentSearchesInfo() ?? [],
                        listingView: homeConfigMap[sectionListingViewKey] ?? homeScreenWidgetsListingCarouselView,
                      ),

                    if(homeConfigMap[sectionTypeKey] == adKey
                        && SHOW_ADS_ON_HOME && _isNativeAdLoaded)
                      Container(
                        padding: const EdgeInsets.only(left: 0,right: 0),
                        height: 50,
                        child: AdWidget(ad: _nativeAd!),
                      ),

                    if (homeConfigMap[sectionTypeKey] == termWithIconsTermKey)
                      _termsWithIconList.isNotEmpty
                          ? DynamicTermsWithIconWidget(dataList: _termsWithIconList)
                          : TermWithIconsWidget(),

                    if (homeConfigMap[sectionTypeKey] == allPropertyKey ||
                        homeConfigMap[sectionTypeKey] == propertyKey ||
                        homeConfigMap[sectionTypeKey] == featuredPropertyKey)
                      if (isDataLoaded) PropertiesListingGenericWidget(
                          propertiesList: homeScreenList,
                          design: UtilityMethods.getHomePropertyItemDesignName(homeConfigMap),
                          listingView: homeConfigMap[sectionListingViewKey] ?? homeScreenWidgetsListingCarouselView,
                        )
                      else genericLoadingWidgetForCarousalWithShimmerEffect(context),

                    if (homeConfigMap[sectionTypeKey] == termKey)
                      if (isDataLoaded) ExplorePropertiesWidget(
                          design: UtilityMethods.getDesignValue(homeConfigMap[designKey]),
                          propertiesData: homeScreenList,
                          listingView: homeConfigMap[sectionListingViewKey] ?? homeScreenWidgetsListingCarouselView,
                          explorePropertiesWidgetListener: ({filterDataMap}) {
                            if (filterDataMap != null && filterDataMap.isNotEmpty) {
                              // do something
                            }
                          },
                        )
                      else genericLoadingWidgetForCarousalWithShimmerEffect(context),

                    if (homeConfigMap[sectionTypeKey] == REST_API_AGENCY_ROUTE
                        || homeConfigMap[sectionTypeKey] == REST_API_AGENT_ROUTE)
                      if (isDataLoaded && homeScreenList.isNotEmpty && homeScreenList[0] is List)
                        RealtorListingsWidget(
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
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
