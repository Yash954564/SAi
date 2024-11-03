import 'dart:convert';
import 'dart:io';

import 'package:animate_icons/animate_icons.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/item_design_files/item_design_notifier.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/search_result_widgets/map_prop_list_widget.dart';
import 'package:houzi_package/widgets/search_result_widgets/search_results_builder_widget.dart';
import 'package:houzi_package/widgets/search_result_widgets/search_bar_widget.dart';
import 'package:houzi_package/widgets/search_result_widgets/sliding_panel_widget.dart';
import 'package:houzi_package/widgets/search_result_widgets/top_container_widget.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:houzi_package/files/theme_service_files/theme_storage_manager.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';



typedef SearchPageListener = void Function(Map<String, dynamic> filterDataMap, String closeOption);

class SearchResult extends StatefulWidget {
  final SearchPageListener? searchPageListener;
  final Map<String, dynamic>? dataInitializationMap;
  final Map<String, dynamic>? searchRelatedData;
  final bool hasBottomNavigationBar;
  final bool fetchSubListing;
  final String subListingIds;

  const SearchResult({
    Key? key,
    this.searchPageListener,
    this.dataInitializationMap,
    this.searchRelatedData,
    this.hasBottomNavigationBar = false,
    this.fetchSubListing = false,
    this.subListingIds = "",
  }) : super(key: key);

  @override
  State<SearchResult> createState() => SearchResultState();
}

class SearchResultState extends State<SearchResult> {

  int selectedMarkerId = -1;

  int? _totalResults;
  int page = 1;
  int perPage = 20;

  double _opacity = SHOW_MAP_INSTEAD_FILTER ? 0.0 : 1.0;
  double _mapPropertiesOpacity = SHOW_MAP_INSTEAD_FILTER ? 1.0 : 0.0;

  bool _zoomToAllLocations = false;
  bool _snapCameraToSelectedIndex = false;
  bool _isAtBottom = false;
  bool refreshing = true;

  bool showMapWidget = true;

  bool isAuthor = false;
  bool isLoggedIn = false;

  bool hasInternet = true;
  bool canSaveSearch = true;

  var realtorId;
  String realtorName = "";

  Map<String, dynamic> mapFromFilterScreen = {};
  Map<String, dynamic> filteredMapForSearch = {}; // chips data display map
  Map<String, dynamic> chipsSearchDataMap = {}; // Used this map to navigate to Filter Screen

  bool _infiniteStop = false;
  bool _isPaginationFree = true;
  bool _showMapWaitingWidget = false;

  bool _isNativeAdLoaded = false;
  List nativeAdList = [];

  List filterChipsRelatedList = [];

  PageController? carouselPageController;
  PanelController? _panelController;
  AnimateIconController mapListAnimateIconController = AnimateIconController();

  final PropertyBloc _propertyBloc = PropertyBloc();
  final List<dynamic> _filteredArticlesList = [];
  //List<dynamic> _mapArticlesList = [];
  Future<List<dynamic>>? _futureFilteredArticles;

  bool carouselPageAnimateInProgress = false;


  @override
  void initState() {
    super.initState();

    _panelController = PanelController();
    mapListAnimateIconController = AnimateIconController();
    carouselPageController = PageController(
        viewportFraction: (UtilityMethods.showTabletView) ? 0.45 : 0.9
    );

    //setUpBannerAd();
    if(SHOW_ADS_ON_LISTINGS){
      setUpNativeAd();
    }

    if(Provider.of<UserLoggedProvider>(context,listen: false).isLoggedIn!){
      if(mounted){
        setState(() {
          isLoggedIn = true;
        });
      }
    }

    if (widget.searchRelatedData != null && widget.searchRelatedData!.isNotEmpty) {
      if (widget.searchRelatedData!.containsKey(REALTOR_SEARCH_TYPE)) {
        if(mounted) {
          setState(() {
            if (widget.searchRelatedData![REALTOR_SEARCH_TYPE] == REALTOR_SEARCH_TYPE_AUTHOR) {
              isAuthor = true;
            }
            realtorId = widget.searchRelatedData![REALTOR_SEARCH_ID];
            realtorName = widget.searchRelatedData![REALTOR_SEARCH_NAME] ?? "";
          });
        }
      }
      // if (widget.searchRelatedData.containsKey(AGENT_ID) ||
      //     widget.searchRelatedData.containsKey(AGENCY_ID) ||
      //     widget.searchRelatedData.containsKey(AUTHOR_ID)) {
      //   if (widget.searchRelatedData.containsKey(AGENT_ID)) {
      //     if(mounted){
      //       setState(() {
      //         isAgent = true;
      //         realtorId = widget.searchRelatedData[AGENT_ID];
      //       });
      //     }
      //   }
      //   if (widget.searchRelatedData.containsKey(AGENCY_ID)) {
      //     if(mounted){
      //       setState(() {
      //         isAgency = true;
      //         realtorId = widget.searchRelatedData[AGENCY_ID];
      //       });
      //     }
      //   }
      //   if (widget.searchRelatedData.containsKey(AUTHOR_ID)) {
      //     if(mounted){
      //       setState(() {
      //         isAuthor = true;
      //         realtorId = widget.searchRelatedData[AUTHOR_ID];
      //       });
      //     }
      //   }
      // }
      else {
        if (widget.searchRelatedData != null) {
          mapFromFilterScreen = {};
          mapFromFilterScreen.addAll(widget.searchRelatedData!);
        } else {
          mapFromFilterScreen = {};
        }
      }
    } else {
      if (widget.dataInitializationMap != null) {
        mapFromFilterScreen = {};
        mapFromFilterScreen.addAll(widget.dataInitializationMap!);
      } else {
        mapFromFilterScreen = {};
      }
    }

    doSearch();
  }

  @override
  void dispose() {
    // _nativeAd.dispose();
    // _bannerAd.dispose();

    for (NativeAd ad in nativeAdList) {
      ad.dispose();
    }
    super.dispose();
    // _controller.removeListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {

    _filteredArticlesList.removeWhere((element) => element is AdWidget);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: AppThemePreferences().appTheme.statusBarIconBrightness,
      ),
      child: WillPopScope(
        onWillPop: () {
          widget.searchPageListener!(HiveStorageManager.readFilterDataInfo(), CLOSE);
          return Future.value(true);
        },
        child: Consumer<ItemDesignNotifier>(
          builder: (context, itemDesignNotifier, child){
            return Scaffold(
              body: hasInternet == false
                  ? Center(child: NoInternetConnectionErrorWidget(onPressed: () => checkInternetAndSearch()))
                  : Stack(alignment: Alignment.topCenter, children: <Widget>[
                      SlidingPanelWidget(
                        zoomToAllLocations: _zoomToAllLocations,
                        panelController: _panelController,
                        filteredArticlesList: _filteredArticlesList,
                        showWaitingWidget: _showMapWaitingWidget,
                        selectedArticleIndex: selectedMarkerId,
                        showMapWidget: showMapWidget,
                        snapCameraToSelectedIndex: _snapCameraToSelectedIndex,
                        listener: ({
                          zoomToAllLocations, opacity, mapPropListOpacity,
                          coordinatesMap, selectedMarkerPropertyId,
                          showWaitingWidget, sliderPosition,
                          snapCameraToSelectedIndex, someActivityOnMap}) {
                          if(mounted) {
                            setState(() {
                              if(zoomToAllLocations != null){
                                _zoomToAllLocations = zoomToAllLocations;
                              }

                              if(mapPropListOpacity != null){
                                _mapPropertiesOpacity = mapPropListOpacity;
                              }

                              if(opacity != null){
                                _opacity = opacity;
                              }

                              if (sliderPosition != null && sliderPosition <= 0.5) {
                                SHOW_MAP_INSTEAD_FILTER
                                    ? mapListAnimateIconController.animateToStart()
                                    : mapListAnimateIconController.animateToEnd();
                              }

                              if (sliderPosition != null && sliderPosition > 0.8) {
                                SHOW_MAP_INSTEAD_FILTER
                                    ? mapListAnimateIconController.animateToEnd()
                                    : mapListAnimateIconController.animateToStart();
                              }

                              if(showWaitingWidget != null){
                                _showMapWaitingWidget = showWaitingWidget;
                              }

                              if(coordinatesMap != null && coordinatesMap.isNotEmpty){
                                if(mounted) {
                                  setState(() {
                                    //MAP_IMPROVES_BY_ADIL - when it was from search in this area, we should zoom to all locations.
                                    _zoomToAllLocations = true;
                                    page = 1;
                                    _totalResults = null;
                                    _infiniteStop = false;
                                    _isAtBottom = false;
                                    filteredMapForSearch.clear();
                                    mapFromFilterScreen = {};
                                    mapFromFilterScreen = HiveStorageManager.readFilterDataInfo() ?? {};
                                    // Remove any pre-selected Country, State, City or Area
                                    mapFromFilterScreen.remove(PROPERTY_COUNTRY);
                                    mapFromFilterScreen.remove(PROPERTY_STATE);
                                    mapFromFilterScreen.remove(PROPERTY_CITY);
                                    mapFromFilterScreen.remove(PROPERTY_AREA);
                                    mapFromFilterScreen.remove(PROPERTY_COUNTRY_SLUG);
                                    mapFromFilterScreen.remove(PROPERTY_STATE_SLUG);
                                    mapFromFilterScreen.remove(CITY);
                                    mapFromFilterScreen.remove(CITY_ID);
                                    mapFromFilterScreen.remove(CITY_SLUG);
                                    mapFromFilterScreen.remove(PROPERTY_AREA_SLUG);

                                    filteredMapForSearch[SEARCH_LOCATION] = "true";
                                    filteredMapForSearch[USE_RADIUS] = "on";
                                    filteredMapForSearch.addAll(coordinatesMap);
                                    chipsSearchDataMap.addAll(coordinatesMap);

                                    HiveStorageManager.deleteSelectedCityInfo();
                                    HiveStorageManager.storeFilterDataInfo(map: mapFromFilterScreen);

                                    refreshing = true;
                                    doSearch();
                                  });
                                }

                                // fetchFilteredArticles(
                                //   page,
                                //   perPage,
                                //   filteredMapForSearch,
                                // );


                              }


                              if(selectedMarkerPropertyId != null) {

                                if (selectedMarkerPropertyId != -1) {
                                  _filteredArticlesList.removeWhere((element) => element is AdWidget);
                                  int index = _filteredArticlesList.indexWhere((element) {
                                    int tempId = element.id;
                                    return selectedMarkerPropertyId == tempId;
                                  });


                          if (index != -1 && index != selectedMarkerId) {
                            selectedMarkerId = index;
                            //_mapArticlesList = [_filteredArticlesList[index]];

                            int currentPage = carouselPageController!
                                .page!.toInt();
                            if (currentPage != index) {
                              this.carouselPageAnimateInProgress = true;
                              carouselPageController!.animateToPage(
                                index,
                                duration: const Duration(
                                    milliseconds: 500),
                                curve: Curves.ease,
                              ).then((value) {
                                this.carouselPageAnimateInProgress = false;
                              });
                              // carouselPageController!.jumpToPage(index);
                            }
                          }
                        } else {
                          selectedMarkerId = -1;
                          //_mapArticlesList = [];
                        }
                      } else {
                        if((someActivityOnMap ?? false) &&
                            selectedMarkerPropertyId == null) {
                          selectedMarkerId = -1;
                          //_mapArticlesList = [];
                        }
                      }

                              if(snapCameraToSelectedIndex != null) {
                                _snapCameraToSelectedIndex = snapCameraToSelectedIndex;
                              }
                            });
                          }
                        },
                        panelBuilder: (panelScrollController) {
                          panelScrollController.addListener(() {
                            if(panelScrollController.position.pixels == panelScrollController.position.maxScrollExtent){
                              // print("Reached at bottom........");
                              if(!_isAtBottom){
                                _isAtBottom = true;
                                if(!_infiniteStop && _isPaginationFree){
                                  // print("Reached at bottom........");
                                  setState(() {
                                    _isPaginationFree = false;
                                    page += 1;
                                    filteredMapForSearch[SEARCH_RESULTS_CURRENT_PAGE] = '$page';
                                    _futureFilteredArticles =
                                        fetchFilteredArticles(page, perPage, filteredMapForSearch, fetchSubListing: widget.fetchSubListing);
                                  });
                                  // print("Page: $page........");
                                  _isAtBottom = false;
                                }
                              }
                            }
                          });

                          return SearchResultBuilderWidget(
                            futureFilteredArticles: _futureFilteredArticles,
                            totalResults: _totalResults,
                            panelScrollController: panelScrollController,
                            isNativeAdLoaded: _isNativeAdLoaded,
                            nativeAdList: nativeAdList,
                            itemDesignNotifier: itemDesignNotifier,
                            onPropArticleTap: _onPropertyArticleTap,
                            hasBottomNavigationBar: widget.hasBottomNavigationBar,
                            refreshing: refreshing,
                            isAtBottom: _isAtBottom,
                            infiniteStop: _infiniteStop,
                            listener: ({performSearch, totalResults}) {
                              if(mounted) {
                                setState(() {
                                  if(totalResults != null){
                                    _totalResults = totalResults;
                                  }

                                  if(performSearch != null && performSearch){
                                    loadSearchProperties();
                                  }
                                });
                              }
                            },
                          );
                        },
                      ),
                      TopContainerWidget(opacity: _opacity),
                      SearchResultsSearchBarWidget(
                        opacity: _opacity,
                        isLoggedIn: isLoggedIn,
                        canSaveSearch: canSaveSearch,
                        filteredDataMap: filteredMapForSearch,
                        chipsSearchDataMap: chipsSearchDataMap,
                        filterChipsRelatedList: filterChipsRelatedList,
                        mapListAnimateIconController: mapListAnimateIconController,
                        onBackPressed: onBackPressed,
                        listener: ({showPanel, onRefresh, canSave, updatedSearchMap}) {
                          if(mounted) {
                            setState(() {
                              if(showPanel != null){
                                if(showPanel){
                                  _panelController!.animatePanelToPosition(1.0);
                                  _opacity = 1.0;
                                }else{
                                  _panelController!.animatePanelToPosition(0.0);
                                  _opacity = 0.0;
                                }
                              }
                              if(onRefresh != null && onRefresh){
                                loadSearchProperties();
                              }
                              if(canSave != null){
                                canSaveSearch = canSave;
                              }
                              if (updatedSearchMap != null) {
                                HiveStorageManager.storeFilterDataInfo(map: updatedSearchMap);
                                loadSearchProperties();
                              }
                    });
                  }
                },
              ),
                      MapPropertiesWidget(
                opacity: _opacity,
                carouselOpacity: _mapPropertiesOpacity,
                carouselPageController: carouselPageController!,
                itemDesignNotifier: itemDesignNotifier,
                onPropArticleTap: _onPropertyArticleTap,
                propArticlesList: _filteredArticlesList,
                listener: ({currentPage}) {
                  if (mounted && currentPage != null && !carouselPageAnimateInProgress) {

                    setState(() {
                      if (selectedMarkerId != currentPage) {
                        // print("MapPropertiesWidget():: changing from $selectedMarkerId to $currentPage");

                        selectedMarkerId = currentPage;
                        // enableCameraMovement = true;
                        _snapCameraToSelectedIndex = true;
                      }
                    });

                  }
                },
              ),
                    ],
              ),
            );
          },
        ),
      ),

    );
  }

  void loadSearchProperties(){
    page = 1;
    _totalResults = null;
    _infiniteStop = false;
    _isAtBottom = false;
    filteredMapForSearch.clear();
    mapFromFilterScreen = {};
    mapFromFilterScreen = HiveStorageManager.readFilterDataInfo() ?? {};
    refreshing = true;
    doSearch();
  }

  void onBackPressed(){
    if (!widget.hasBottomNavigationBar) {
      setState(() {
        showMapWidget = false;
      });
    }

    widget.searchPageListener!(HiveStorageManager.readFilterDataInfo() ?? {}, CLOSE);
  }

  void _onPropertyArticleTap(Article item, int propId, String heroId){
    if (item.propertyInfo!.requiredLogin) {
      isLoggedIn
          ? UtilityMethods.navigateToPropertyDetailPage(
        context: context,
        article: item,
        propertyID: propId,
        heroId: heroId,
      )
          : UtilityMethods.navigateToLoginPage(context, false);
    } else {
      UtilityMethods.navigateToPropertyDetailPage(
        context: context,
        article: item,
        propertyID: propId,
        heroId: heroId,
      );
    }
  }

  checkInternetAndSearch(){
    if(mounted){
      setState(() {
        refreshing = true;
      });
    }
    doSearch();
  }



  void doSearch() {
    filterChipsRelatedList.clear();
    chipsSearchDataMap.clear();

    if(mounted) {
      setState(() {
        canSaveSearch = true;
      });
    }

    // if (widget.fetchFeatured) {
    //   mapFromFilterScreen[showFeaturedKey] = true;
    //   filteredMapForSearch[SEARCH_RESULTS_FEATURED] = 1;
    //   filterChipsRelatedList.add({
    //     FEATURED_CHIP_KEY:
    //         UtilityMethods.getLocalizedString(FEATURED_CHIP_VALUE),
    //   });
    //
    //   filterChipsRelatedList = [
    //     {PROPERTY_TYPE : ["All"]},
    //     {PROPERTY_STATUS : ["All"]},
    //     {FEATURED_CHIP_KEY : UtilityMethods.getLocalizedString(FEATURED_CHIP_VALUE)},
    //   ];
    //   chipsSearchDataMap = {
    //     PROPERTY_TYPE : ["All"],
    //     PROPERTY_TYPE_SLUG : ["all"],
    //     PROPERTY_STATUS : ["All"],
    //     PROPERTY_STATUS_SLUG : ["all"],
    //   };
    // }else
    if (isAuthor) {
      filterChipsRelatedList = [
        { PROPERTY_TYPE : ["All"] },
        { PROPERTY_STATUS : ["All"] },
        {
          REALTOR_CHIP_KEY : "${UtilityMethods.getLocalizedString(widget.searchRelatedData![REALTOR_SEARCH_TYPE])} : $realtorName",
        },
      ];

    }
    else {

      if (mapFromFilterScreen.isNotEmpty) {

        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, BEDROOMS)) {
          String tempBedroomString = '';
          List<String> tempBedroomStringList = List<String>.from(
              mapFromFilterScreen[BEDROOMS]);
          if (tempBedroomStringList.isNotEmpty) {
            tempBedroomStringList = UtilityMethods.getSanitizedStringPickerList(
                tempBedroomStringList);
            tempBedroomString = tempBedroomStringList.join(',');
          }
          filteredMapForSearch[SEARCH_RESULTS_BEDROOMS] = tempBedroomString;
          filterChipsRelatedList.add({
            BEDROOMS: tempBedroomString,
          });
          // chipsSearchDataMap[BEDROOMS] = tempBedroomString.split(",");
          List<String> chipsSearchDataList = tempBedroomString.split(",");
          // if (chipsSearchDataList.contains("6")) {
          //   int index =
          //       chipsSearchDataList.indexWhere((element) => element == "6");
          //   if (index != -1) {
          //     chipsSearchDataList[index] = "6+";
          //   }
          // }
          chipsSearchDataMap[BEDROOMS] = chipsSearchDataList;
        }

        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, BATHROOMS)) {
          String tempBathroomString = '';
          List<String> tempBathroomStringList = List<String>.from(
              mapFromFilterScreen[BATHROOMS]);
          if (tempBathroomStringList.isNotEmpty) {
            // if (tempBathroomStringList.contains("6+")) {
            //   tempBathroomStringList.remove("6+");
            //   tempBathroomStringList.add("6");
            // }
            tempBathroomStringList = UtilityMethods.getSanitizedStringPickerList(
                tempBathroomStringList);
            tempBathroomString = tempBathroomStringList.join(',');
          }
          filteredMapForSearch[SEARCH_RESULTS_BATHROOMS] = tempBathroomString;
          filterChipsRelatedList.add({
            BATHROOMS: tempBathroomString,
          });
          // chipsSearchDataMap[BATHROOMS] = tempBathroomString.split(",");
          List<String> chipsSearchDataList = tempBathroomString.split(",");
          // if(chipsSearchDataList.contains("6")){
          //   int index = chipsSearchDataList.indexWhere((element) => element == "6");
          //   if(index != -1) {
          //     chipsSearchDataList[index] = "6+";
          //   }
          // }
          chipsSearchDataMap[BATHROOMS] = chipsSearchDataList;
        }

        if (filteredMapForSearch.containsKey(SEARCH_RESULTS_BEDROOMS) ||
            filteredMapForSearch.containsKey(SEARCH_RESULTS_BATHROOMS)) {
          filteredMapForSearch[SEARCH_RESULTS_BEDS_BATHS_CRITERIA] = "IN";
        }

        filteredMapForSearch.remove(SEARCH_RESULTS_STATUS);
        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_STATUS_SLUG)) {
          var status = List<String>.from(mapFromFilterScreen[PROPERTY_STATUS_SLUG]);
          var nonEmpty = status.where((element) =>
          element.isNotEmpty && element != "all").toList();
          filteredMapForSearch[SEARCH_RESULTS_STATUS] = nonEmpty;
          chipsSearchDataMap[PROPERTY_STATUS_SLUG] = nonEmpty;
        }
        else {
          chipsSearchDataMap[PROPERTY_STATUS_SLUG] = ["all"];
        }

        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_STATUS)) {
          var status = List<String>.from(mapFromFilterScreen[PROPERTY_STATUS]);
          var nonEmpty = status.where((element) => element.isNotEmpty).toList();
          // var nonEmpty = status.where((element) => element.isNotEmpty && element != "All").toList();
          filterChipsRelatedList.add({
            PROPERTY_STATUS: nonEmpty,
          });
          chipsSearchDataMap[PROPERTY_STATUS] = nonEmpty;
        }
        else {
          filterChipsRelatedList.add({
            PROPERTY_STATUS: ["All"],
          });
          chipsSearchDataMap[PROPERTY_STATUS] = ["All"];
        }

        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_TYPE)) {
          /// For SearchFilterChips
          List tempPropertyTypeList = [];
          List tempPropertyTypeSlugsList = [];
          tempPropertyTypeList = mapFromFilterScreen[PROPERTY_TYPE] ?? [];
          tempPropertyTypeSlugsList = mapFromFilterScreen[PROPERTY_TYPE_SLUG] ?? [];
          if (tempPropertyTypeSlugsList.isNotEmpty && mapFromFilterScreen[termPickerTypeKey] != boxTermPicker) {
            String itemSlug = tempPropertyTypeSlugsList[0];
            Term? obj = UtilityMethods.getPropertyMetaDataObjectWithSlug(dataType: PROPERTY_TYPE, slug: itemSlug);
            if(obj != null && obj.parent != 0){
              Term? parentObj = UtilityMethods.getPropertyMetaDataObjectWithId(dataType: PROPERTY_TYPE, id: obj.parent!);
              tempPropertyTypeList.insert(0, parentObj!.name);
              tempPropertyTypeSlugsList.insert(0, parentObj.slug);
            }
          }

          // print("tempPropertyTypeSlugsList: $tempPropertyTypeSlugsList");
          chipsSearchDataMap[PROPERTY_TYPE] = tempPropertyTypeList;
          chipsSearchDataMap[PROPERTY_TYPE_SLUG] = tempPropertyTypeSlugsList;

          filterChipsRelatedList.add({
            PROPERTY_TYPE: tempPropertyTypeList,
          });
        }
        else {
          filterChipsRelatedList.add({
            PROPERTY_TYPE: ["All"],
          });
          chipsSearchDataMap[PROPERTY_TYPE] = ["All"];
        }

        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_LABEL)) {
          var type = List<String>.from(mapFromFilterScreen[PROPERTY_LABEL]);
          var nonEmpty = type.where((element) => element.isNotEmpty).toList();
          // var nonEmpty = type.where((element) => element.isNotEmpty && element != "All").toList();
          filterChipsRelatedList.add({
            PROPERTY_LABEL: nonEmpty,
          });
          chipsSearchDataMap[PROPERTY_LABEL] = nonEmpty;
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_FEATURES)) {
          var type = List<String>.from(mapFromFilterScreen[PROPERTY_FEATURES]);
          var nonEmpty = type.where((element) => element.isNotEmpty).toList();
          // var nonEmpty = type.where((element) => element.isNotEmpty && element != "All").toList();
          filterChipsRelatedList.add({
            PROPERTY_FEATURES: nonEmpty,
          });
          chipsSearchDataMap[PROPERTY_FEATURES] = nonEmpty;
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_TYPE_SLUG)) {
          var propertyTypeSlug = mapFromFilterScreen[PROPERTY_TYPE_SLUG];

          var type = propertyTypeSlug is String ? [propertyTypeSlug] : List<String>.from(propertyTypeSlug);
          var nonEmpty = type.where((element) =>
          element.isNotEmpty && element != "all").toList();

          //If a sub-type is selected we need to remove its parent type from slugs.
          //that's because if we're looking for 'home' which is sub-type of 'residential'
          //we don't want to fetch home + residential (villas, apartment, etc)
          //instead we only want to fetch home.
          //if only residential is selected, then we want to fetch all (depend on server logic)

          if (nonEmpty.isNotEmpty && nonEmpty.length > 1) {
            List<dynamic> propertyTypeList = mapFromFilterScreen[PROPERTY_TYPE];
            Map<String, dynamic>? propertyDataMap = HiveStorageManager.readPropertyTypesMapData();
            if (propertyDataMap != null && propertyDataMap.isNotEmpty) {
              List<String> keys = propertyDataMap.keys.toList();

              //Find the index of parent category in property type list.
              //and then remove the item at same index from slug list.
              for(var item in propertyTypeList){
                if(keys.contains(item)){
                  Term? obj = UtilityMethods.getPropertyMetaDataObjectWithItemName(dataType: PROPERTY_TYPE, name: item);
                  if(obj != null){
                    nonEmpty.removeWhere((element) => element == obj.slug);
                  }
                }
              }
            }
          }
          // debugPrint("slugs List: $nonEmpty");
          filteredMapForSearch[SEARCH_RESULTS_TYPE] = nonEmpty;
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_LABEL_SLUG)) {

          var label = List<String>.from(mapFromFilterScreen[PROPERTY_LABEL_SLUG]);
          var nonEmpty = label.where((element) => element.isNotEmpty && element != "all").toList();

          filteredMapForSearch[SEARCH_RESULTS_LABEL] = nonEmpty;
          chipsSearchDataMap[PROPERTY_LABEL_SLUG] = mapFromFilterScreen[PROPERTY_LABEL_SLUG];

        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, CITY_SLUG)) {

          var temp = mapFromFilterScreen[CITY_SLUG];
          var tempSlugList = [];

          chipsSearchDataMap[CITY_SLUG] = mapFromFilterScreen[CITY_SLUG];

          if (temp is List) {
            tempSlugList = List<String>.from(temp);
          } else if (temp is String) {
            tempSlugList = [temp];
          }
          var nonEmpty = tempSlugList.where((element) => element != "all").toList();
          if (nonEmpty.isNotEmpty) {
            filteredMapForSearch[SEARCH_RESULTS_LOCATION] = nonEmpty;
          }

        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_AREA_SLUG)) {
          var areas = List<String>.from(mapFromFilterScreen[PROPERTY_AREA_SLUG]);
          var nonEmpty = areas.where((element) =>
          element.isNotEmpty && element != "all").toList();
          if (nonEmpty.isNotEmpty) {
            filteredMapForSearch[SEARCH_RESULTS_AREA] = nonEmpty;
          }
          chipsSearchDataMap[PROPERTY_AREA_SLUG] = nonEmpty;
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_KEYWORD)) {
          filteredMapForSearch[SEARCH_RESULTS_KEYWORD] = mapFromFilterScreen[PROPERTY_KEYWORD];
          filterChipsRelatedList.add({
            PROPERTY_KEYWORD: mapFromFilterScreen[PROPERTY_KEYWORD],
          });

          chipsSearchDataMap[PROPERTY_KEYWORD] = mapFromFilterScreen[PROPERTY_KEYWORD];
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_COUNTRY_SLUG)) {
          var countries = List<String>.from(mapFromFilterScreen[PROPERTY_COUNTRY_SLUG]);
          var nonEmpty = countries.where((element) =>
          element.isNotEmpty && element != "all").toList();
          if (nonEmpty.isNotEmpty) {
            filteredMapForSearch[SEARCH_RESULTS_COUNTRY] = nonEmpty;
          }
          chipsSearchDataMap[PROPERTY_COUNTRY_SLUG] = nonEmpty;
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_STATE_SLUG)) {
          var states = List<String>.from(mapFromFilterScreen[PROPERTY_STATE_SLUG]);
          var nonEmpty = states.where((element) =>
          element.isNotEmpty && element != "all").toList();
          if (nonEmpty.isNotEmpty) {
            filteredMapForSearch[SEARCH_RESULTS_STATE] = nonEmpty;
          }
          chipsSearchDataMap[PROPERTY_STATE_SLUG] = nonEmpty;
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_FEATURES_SLUG)) {
          var features = List<String>.from(mapFromFilterScreen[PROPERTY_FEATURES_SLUG]);
          var nonEmpty = features.where((element) =>
          element.isNotEmpty && element != "all").toList();
          filteredMapForSearch[SEARCH_RESULTS_FEATURES] = nonEmpty;
          chipsSearchDataMap[PROPERTY_FEATURES_SLUG] = nonEmpty;
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, AREA_MAX)) {
          filteredMapForSearch[SEARCH_RESULTS_MAX_AREA] = mapFromFilterScreen[AREA_MAX];
          chipsSearchDataMap[AREA_MAX] = mapFromFilterScreen[AREA_MAX];
          // filterChipsRelatedList.add({
          //   AREA_MAX : mapFromFilterScreen[AREA_MAX],
          // });
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, AREA_MIN)) {
          filteredMapForSearch[SEARCH_RESULTS_MIN_AREA] =
          mapFromFilterScreen[AREA_MIN];
          chipsSearchDataMap[AREA_MIN] = mapFromFilterScreen[AREA_MIN];
          // filterChipsRelatedList.add({
          //   AREA_MIN : mapFromFilterScreen[AREA_MIN],
          // });
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PRICE_MIN)) {
          filteredMapForSearch[SEARCH_RESULTS_MIN_PRICE] =
          mapFromFilterScreen[PRICE_MIN];
          chipsSearchDataMap[PRICE_MIN] = mapFromFilterScreen[PRICE_MIN];
          // filterChipsRelatedList.add({
          //   PRICE_MIN : mapFromFilterScreen[PRICE_MIN],
          // });
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PRICE_MAX)) {
          filteredMapForSearch[SEARCH_RESULTS_MAX_PRICE] =
          mapFromFilterScreen[PRICE_MAX];
          chipsSearchDataMap[PRICE_MAX] = mapFromFilterScreen[PRICE_MAX];
          // filterChipsRelatedList.add({
          //   PRICE_MAX : mapFromFilterScreen[PRICE_MAX],
          // });
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, LATITUDE)) {
          chipsSearchDataMap[LATITUDE] = mapFromFilterScreen[LATITUDE];
          filteredMapForSearch[LATITUDE] = mapFromFilterScreen[LATITUDE];
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, RADIUS)) {
          chipsSearchDataMap[RADIUS] = mapFromFilterScreen[RADIUS];
          filteredMapForSearch[RADIUS] = mapFromFilterScreen[RADIUS];
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, LONGITUDE)) {
          chipsSearchDataMap[LONGITUDE] = mapFromFilterScreen[LONGITUDE];
          filteredMapForSearch[LONGITUDE] = mapFromFilterScreen[LONGITUDE];
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, USE_RADIUS)) {
          chipsSearchDataMap[USE_RADIUS] = mapFromFilterScreen[USE_RADIUS];
          chipsSearchDataMap[SEARCH_LOCATION] = mapFromFilterScreen[SEARCH_LOCATION];
          var temp = mapFromFilterScreen[USE_RADIUS];
          if (temp == "on") {
            filteredMapForSearch[USE_RADIUS] = mapFromFilterScreen[USE_RADIUS];
            filteredMapForSearch[SEARCH_LOCATION] = mapFromFilterScreen[SEARCH_LOCATION];
          }
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_CUSTOM_FIELDS)) {
          Map tempMap = mapFromFilterScreen[PROPERTY_CUSTOM_FIELDS];

          chipsSearchDataMap[PROPERTY_CUSTOM_FIELDS] = mapFromFilterScreen[PROPERTY_CUSTOM_FIELDS];

          tempMap.forEach((key, value) {
            String dataKey = "$SEARCH_RESULTS_CUSTOM_FIELDS[$key]";
            if (value is Map) {
              List tempList = [];
              value.forEach((key, value) {
                tempList.add(key);
              });
              String tempDataKey = "$dataKey[]";
              filteredMapForSearch[tempDataKey] = tempList;
              filterChipsRelatedList.add({
                tempDataKey: tempList,
              });
            } else {
              filteredMapForSearch[dataKey] = value;
              filterChipsRelatedList.add({
                dataKey: value,
              });
            }
          });
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, AREA_MIN)
            && UtilityMethods.isMapItemPopulated(mapFromFilterScreen, AREA_MAX)) {
          filterChipsRelatedList.add({
            AREA_MAX: "${mapFromFilterScreen[AREA_MIN]} - ${mapFromFilterScreen[AREA_MAX]}",
          });
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PRICE_MIN)
            && UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PRICE_MAX)) {
          filterChipsRelatedList.add({
            PRICE_MAX: "${mapFromFilterScreen[PRICE_MIN]} - ${mapFromFilterScreen[PRICE_MAX]}",
          });
        }


        if (UtilityMethods.getBooleanItemValueFromMap(inputMap: mapFromFilterScreen, key: showFeaturedKey)) {
          filteredMapForSearch[SEARCH_RESULTS_FEATURED] = "1";
          filterChipsRelatedList.add({
            FEATURED_CHIP_KEY : UtilityMethods.getLocalizedString(FEATURED_CHIP_VALUE),
          });

          chipsSearchDataMap[showFeaturedKey] = true;
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_AREA)) {
          var type = List<String>.from(mapFromFilterScreen[PROPERTY_AREA]);
          var nonEmpty = type.where((element) => element.isNotEmpty).toList();
          // var nonEmpty = type.where((element) => element.isNotEmpty && element != "All").toList();
          filterChipsRelatedList.add({
            PROPERTY_AREA: nonEmpty,
          });
          chipsSearchDataMap[PROPERTY_AREA] = nonEmpty;
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, CITY)) {
          var temp = mapFromFilterScreen[CITY];

          chipsSearchDataMap[CITY] = mapFromFilterScreen[CITY];

          if (temp != null && temp.isNotEmpty) {
            // if (temp != null && temp.isNotEmpty && temp != "All") {
            filterChipsRelatedList.add({
              CITY: mapFromFilterScreen[CITY],
            });
          }
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_STATE)) {
          var type = List<String>.from(mapFromFilterScreen[PROPERTY_STATE]);
          var nonEmpty = type.where((element) => element.isNotEmpty).toList();
          // var nonEmpty = type.where((element) => element.isNotEmpty && element != "All").toList();
          filterChipsRelatedList.add({
            PROPERTY_STATE: nonEmpty,
          });
          chipsSearchDataMap[PROPERTY_STATE] = nonEmpty;
        }


        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, PROPERTY_COUNTRY)) {
          var type = List<String>.from(mapFromFilterScreen[PROPERTY_COUNTRY]);
          var nonEmpty = type.where((element) => element.isNotEmpty).toList();
          // var nonEmpty = type.where((element) => element.isNotEmpty && element != "All").toList();
          filterChipsRelatedList.add({
            PROPERTY_COUNTRY: nonEmpty,
          });
          chipsSearchDataMap[PROPERTY_COUNTRY] = nonEmpty;
        }
        //if we've area in the map, the upper hierarchy doesn't matter,
        //same goes for city, ie if we've city, then state or country
        //don't matter. so remove higher key, if lower is available.
        if (filteredMapForSearch.containsKey(SEARCH_RESULTS_AREA)) {
          //remove city, state and country
          filteredMapForSearch.remove(SEARCH_RESULTS_LOCATION);
          filteredMapForSearch.remove(SEARCH_RESULTS_STATE);
          filteredMapForSearch.remove(SEARCH_RESULTS_COUNTRY);
        }

        if (filteredMapForSearch.containsKey(SEARCH_RESULTS_LOCATION)) {
          //remove state and country
          filteredMapForSearch.remove(SEARCH_RESULTS_STATE);
          filteredMapForSearch.remove(SEARCH_RESULTS_COUNTRY);
        }

        if (filteredMapForSearch.containsKey(SEARCH_RESULTS_STATE)) {
          //remove country
          filteredMapForSearch.remove(SEARCH_RESULTS_COUNTRY);
        }

        if(mapFromFilterScreen.containsKey(REALTOR_SEARCH_TYPE)) {
          filterChipsRelatedList.add({
            REALTOR_CHIP_KEY : "${UtilityMethods.getLocalizedString(mapFromFilterScreen[REALTOR_SEARCH_TYPE])} : ${mapFromFilterScreen[REALTOR_SEARCH_NAME]}",
          });

          if (mapFromFilterScreen[REALTOR_SEARCH_TYPE] == REALTOR_SEARCH_TYPE_AGENT) {
            filteredMapForSearch[REALTOR_SEARCH_AGENT] = mapFromFilterScreen[REALTOR_SEARCH_ID];
          } else if (mapFromFilterScreen[REALTOR_SEARCH_TYPE] == REALTOR_SEARCH_TYPE_AGENCY) {
            filteredMapForSearch[REALTOR_SEARCH_AGENCY] = mapFromFilterScreen[REALTOR_SEARCH_ID];
          }
        }


        // Handle Meta_Key_Filters:
        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, metaKeyFiltersKey)) {

          List<Map> _metaMapsList = [];
          Map<String, dynamic> _metaKeyFiltersQueryMap = {};
          String _metaKeyFiltersQueryMapJson = "";

          // Get meta_key_filters map in variable:
          Map<String, dynamic> _metaKeyFiltersMap =
          Map<String, dynamic>.from(mapFromFilterScreen[metaKeyFiltersKey]);

          // print("Raw map: $_metaKeyFiltersMap");

          // set onChipSelect() Filter data initialization Map
          chipsSearchDataMap[metaKeyFiltersKey] = _metaKeyFiltersMap;

          // Get keys of the meta_key_filters map
          List<String> _mapKeys = _metaKeyFiltersMap.keys.toList();

          // Add meta_key query maps to the List
          for (String key in _mapKeys) {

            Map _queryMap = {};
            _queryMap.addAll(_metaKeyFiltersMap[key]);
            String _pickerType = _queryMap[metaPickerTypeKey];

            if ( _pickerType == stringPickerKey
                || _pickerType == dropDownPicker ) {

              String _valueJson = "";

              if ( _queryMap[metaValueKey] is List ) {
                List _valueList = _queryMap[metaValueKey];
                _valueJson = _valueList.join(", ");

              } else if ( _queryMap[metaValueKey] is String ) {
                _valueJson = _queryMap[metaValueKey];
              }

              filterChipsRelatedList.add({key : _valueJson});

              _valueJson = _valueJson.replaceAll("+", "");
              _queryMap[metaValueKey] = _valueJson;

            } else if ( _pickerType == textFieldKey ) {
              String _valueStr = _queryMap[metaValueKey];

              filterChipsRelatedList.add({key : _valueStr});

            } else if ( _pickerType == rangePickerKey ) {
              String _minRangeStr = _queryMap[metaMinValueKey];
              String _maxRangeStr = _queryMap[metaMaxValueKey];

              filterChipsRelatedList.add({
                key : "$_minRangeStr - $_maxRangeStr",
              });
            }

            _metaMapsList.add(_queryMap);
          }

          _metaKeyFiltersQueryMap[metaKeyFiltersKey] = _metaMapsList;
          _metaKeyFiltersQueryMapJson = jsonEncode(_metaKeyFiltersQueryMap);
          filteredMapForSearch[metaKeyFiltersKey] = _metaKeyFiltersQueryMapJson;
        }

        // Handle Keyword_Filters:
        if (UtilityMethods.isMapItemPopulated(mapFromFilterScreen, keywordFiltersKey)) {

          List<Map> _keywordMapsList = [];
          Map<String, dynamic> _keywordFiltersQueryMap = {};
          String _keywordFiltersQueryMapJson = "";

          // Get keyword_filters map in variable:
          Map<String, dynamic> _keywordFiltersMap =
          Map<String, dynamic>.from(mapFromFilterScreen[keywordFiltersKey]);

          chipsSearchDataMap[keywordFiltersKey] = _keywordFiltersMap;

          // Get keys of the keyword_filters map
          List<String> _mapKeys = _keywordFiltersMap.keys.toList();

          // Add keyword_filters query maps to the List
          for (String key in _mapKeys) {
            Map _queryMap = {};
            _queryMap.addAll(_keywordFiltersMap[key]);

            String _valueStr = _queryMap[keywordFiltersValueKey];

            String? _queryTitle = _queryMap[keywordFiltersCustomQueryTitleKey];

            if (_queryTitle != null && _queryTitle.isNotEmpty) {
              _valueStr = _queryTitle;
            }

            filterChipsRelatedList.add({key : _valueStr});

            _keywordMapsList.add(_queryMap);
          }

          _keywordFiltersQueryMap[keywordFiltersKey] = _keywordMapsList;
          _keywordFiltersQueryMapJson = jsonEncode(_keywordFiltersQueryMap);
          filteredMapForSearch[keywordFiltersKey] = _keywordFiltersQueryMapJson;
        }


        // // Handle Dynamic Keywords:
        // String _keywordsString = "";
        // List<String> _keywordsStringsList = [];
        //
        // List<String> _mapKeys = mapFromFilterScreen.keys.toList();
        // for (String key in _mapKeys) {
        //
        //   if (key.contains(KEYWORD_PREFIX)
        //       && UtilityMethods.isMapItemPopulated(mapFromFilterScreen, key)) {
        //     _keywordsStringsList.add(mapFromFilterScreen[key]);
        //     chipsSearchDataMap[key] = mapFromFilterScreen[key];
        //     filteredMapForSearch[key] = mapFromFilterScreen[key];
        //   }
        // }
        //
        // if (_keywordsStringsList.isNotEmpty) {
        //   // remove duplicates
        //   _keywordsString = _keywordsStringsList.join(",");
        //   _keywordsString = _keywordsString.split(",").toSet().toList().join(" ");
        //
        //   filteredMapForSearch[SEARCH_RESULTS_KEYWORD] = _keywordsString;
        //   filterChipsRelatedList.add({ PROPERTY_KEYWORD: _keywordsString });
        //   chipsSearchDataMap[PROPERTY_KEYWORD] = _keywordsString;
        // }

        // Handle Query Types
        if (UtilityMethods.isMapItemPopulated(
            mapFromFilterScreen, PROPERTY_COUNTRY_QUERY_TYPE)) {
          filteredMapForSearch[PROPERTY_COUNTRY_QUERY_TYPE] =
              mapFromFilterScreen[PROPERTY_COUNTRY_QUERY_TYPE];
        }

        if (UtilityMethods.isMapItemPopulated(
            mapFromFilterScreen, PROPERTY_STATE_QUERY_TYPE)) {
          filteredMapForSearch[PROPERTY_STATE_QUERY_TYPE] =
          mapFromFilterScreen[PROPERTY_STATE_QUERY_TYPE];
        }

        if (UtilityMethods.isMapItemPopulated(
            mapFromFilterScreen, PROPERTY_AREA_QUERY_TYPE)) {
          filteredMapForSearch[PROPERTY_AREA_QUERY_TYPE] =
          mapFromFilterScreen[PROPERTY_AREA_QUERY_TYPE];
        }

        if (UtilityMethods.isMapItemPopulated(
            mapFromFilterScreen, PROPERTY_STATUS_QUERY_TYPE)) {
          filteredMapForSearch[PROPERTY_STATUS_QUERY_TYPE] =
          mapFromFilterScreen[PROPERTY_STATUS_QUERY_TYPE];
        }

        if (UtilityMethods.isMapItemPopulated(
            mapFromFilterScreen, PROPERTY_TYPE_QUERY_TYPE)) {
          filteredMapForSearch[PROPERTY_TYPE_QUERY_TYPE] =
          mapFromFilterScreen[PROPERTY_TYPE_QUERY_TYPE];
        }

        if (UtilityMethods.isMapItemPopulated(
            mapFromFilterScreen, PROPERTY_LABEL_QUERY_TYPE)) {
          filteredMapForSearch[PROPERTY_LABEL_QUERY_TYPE] =
          mapFromFilterScreen[PROPERTY_LABEL_QUERY_TYPE];
        }

        if (UtilityMethods.isMapItemPopulated(
            mapFromFilterScreen, PROPERTY_FEATURES_QUERY_TYPE)) {
          filteredMapForSearch[PROPERTY_FEATURES_QUERY_TYPE] =
          mapFromFilterScreen[PROPERTY_FEATURES_QUERY_TYPE];
        }

        filteredMapForSearch[SEARCH_RESULTS_CURRENT_PAGE] = '$page';

        filteredMapForSearch[SEARCH_RESULTS_PER_PAGE] = '${perPage}';
      }

      else if (mapFromFilterScreen.isEmpty) {
        filterChipsRelatedList = [
          { PROPERTY_STATUS : ["All"] },
          { PROPERTY_TYPE : ["All"] },
        ];
        chipsSearchDataMap = {
          PROPERTY_STATUS : ["All"],
          PROPERTY_STATUS_SLUG : ["all"],
          PROPERTY_TYPE : ["All"],
          PROPERTY_TYPE_SLUG : ["all"],
        };
      }
    }


    // print("SearchResults[Keyword]: ${filteredMapForSearch[PROPERTY_KEYWORD]}");
    print("SearchResults filteredMapForSearch: $filteredMapForSearch");
    // print("SearchResults Filter Data Map: ${HiveStorageManager.readFilterDataInfo()}");
    // print("SearchResults Selected City Data Map: ${HiveStorageManager.readSelectedCityInfo()}");
    // print("SearchResults searchRelatedData: ${widget.searchRelatedData}");
    // print("SearchResults filterChipsRelatedList: $filterChipsRelatedList");
    // print("SearchResults chipsSearchDataMap: $chipsSearchDataMap");
    // print("SearchResults filteredMapForSearch[keywordFiltersKey]: ${filteredMapForSearch[keywordFiltersKey]}");
    // print("SearchResults filterChipsRelatedList: $filterChipsRelatedList");

    _futureFilteredArticles = fetchFilteredArticles(
      page,
      perPage,
      filteredMapForSearch,
      fetchSubListing: widget.fetchSubListing,
    );
  }

  Future<List<dynamic>> fetchFilteredArticles(
      int page,
      perPage,
      Map<String, dynamic> dataMap, {
        bool fetchSubListing = false,
      }) async {
    dataMap["page"] = "$page";
    dataMap["per_page"] = "$perPage";
    // print('Map: $dataMap');
    int count = 0;
    bool internetAvailable = false;

    if(isAuthor || fetchSubListing){
      List<dynamic> tempList = [];
       if(isAuthor) {
        tempList = await _propertyBloc.fetchAllProperties('any', page, perPage, realtorId);
      } else if (fetchSubListing) {
        tempList = await _propertyBloc.fetchMultipleArticles(widget.subListingIds);
      }

      if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
        internetAvailable = false;
      }else {
        internetAvailable = true;
        if(refreshing) {
          _filteredArticlesList.clear();
        }
        _filteredArticlesList.addAll(tempList);
        count = _filteredArticlesList.length;
      }
    }else {
      Map<String, dynamic> tempList = await _propertyBloc.fetchFilteredArticles(dataMap);
      if(tempList == null || tempList.containsKey('response')){
        internetAvailable = false;

      }else {
        internetAvailable = true;
        if(refreshing) {
          _filteredArticlesList.clear();
        }
        _filteredArticlesList.addAll(tempList["result"]);
        count = tempList["count"];
      }
    }

    if(mounted) {
      setState(() {
      if (_filteredArticlesList.length % perPage != 0) {
        _infiniteStop = true;
      }

      hasInternet = internetAvailable;
      _zoomToAllLocations = true;

      _isAtBottom = false;
      refreshing = false;
      _totalResults = count;
      _isPaginationFree = true;
    });
    }

    Future.delayed(const Duration(milliseconds: 100), (){
      if(mounted) {
        setState(() {
        _snapCameraToSelectedIndex = false;
        _showMapWaitingWidget = false;
        selectedMarkerId = -1;
      });
      }
    });

    Map<String,dynamic> tempFilterDataMap = HiveStorageManager.readFilterDataInfo() ?? {};
    tempFilterDataMap[SEARCH_COUNT] = _totalResults;
    HiveStorageManager.storeFilterDataInfo(map: tempFilterDataMap);
    widget.searchPageListener!(HiveStorageManager.readFilterDataInfo() ?? {}, "");

    return _filteredArticlesList;
  }

  // setUpBannerAd(){
  //   _bannerAd = BannerAd(
  //       size: AdSize.banner,
  //       adUnitId: GoogleAdWidget.bannerAdUnitId,
  //       listener: BannerAdListener(onAdLoaded: (_) {
  //         setState(() {
  //           _isBannerAdReady = true;
  //         });
  //       }, onAdFailedToLoad: (ad, LoadAdError error) {
  //         print("Failed to Load A Banner Ad: ${error.message}");
  //         _isBannerAdReady = false;
  //         ad.dispose();
  //       }),
  //       request: AdRequest()
  //   );
  //
  //   _bannerAd.load();
  // }

  setUpNativeAd() {
    String themeMode = ThemeStorageManager.readData(THEME_MODE_INFO) ?? LIGHT_THEME_MODE;
    bool isDarkMode = false;
    if (themeMode == DARK_THEME_MODE) {
      isDarkMode = true;
    }
    NativeAdListener nativeAdListener = NativeAdListener(
      onAdLoaded: (ad) {
        nativeAdList.add(ad);
        if(nativeAdList.length == 5){
          _isNativeAdLoaded = true;
          if(mounted){
            setState(() {});
          }
        }
        // print("nativeAdList.length: ${nativeAdList.length}");
      },
      onAdFailedToLoad: (ad, error) {
        // Releases an ad resource when it fails to load
        ad.dispose();
        if (kDebugMode) {
          print('Ad load failed (code=${error.code} message=${error.message})');
        }
      },
    );
    for (int i = 0; i < 5; i++) {
      NativeAd _nativeAd = NativeAd(
        customOptions: {"isDarkMode": isDarkMode},
        adUnitId: Platform.isAndroid ? ANDROID_NATIVE_AD_ID : IOS_NATIVE_AD_ID,
        factoryId: 'listTile',
        request: const AdRequest(),
        listener: nativeAdListener,
      );

      _nativeAd.load();
    }
  }

}