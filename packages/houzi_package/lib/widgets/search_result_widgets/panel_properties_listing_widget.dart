import 'dart:math';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/item_design_files/item_design_notifier.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/models/sort_first_by_item.dart';
import 'package:houzi_package/pages/filter_page.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';
import 'package:houzi_package/widgets/custom_widgets/showModelBottomSheetWidget.dart';
import 'package:houzi_package/widgets/generic_animate_icon_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/search_result_widgets/panel_loading_widget.dart';
import 'package:houzi_package/widgets/search_result_widgets/search_choice_chip_widget.dart';
import 'package:houzi_package/widgets/search_result_widgets/sort_widget.dart';
import 'package:intl/intl.dart';

typedef PanelPropertiesListingWidgetListener = Function({
bool? performSearch,
int? totalResults,
});

class PanelPropertiesListingWidget extends StatefulWidget {

  final int? totalResults;
  final bool refreshing;
  final bool hasBottomNavigationBar;
  final ScrollController panelScrollController;
  final ItemDesignNotifier itemDesignNotifier;
  final Future<List<dynamic>>? futureFilteredArticles;
  final void Function(Article, int, String) onPropArticleTap;


  final PanelPropertiesListingWidgetListener listener;

  final bool isNativeAdLoaded;
  final List nativeAdList;


  PanelPropertiesListingWidget({
    Key? key,
    required this.totalResults,
    required this.refreshing,
    required this.hasBottomNavigationBar,
    required this.panelScrollController,
    required this.itemDesignNotifier,
    required this.futureFilteredArticles,
    required this.isNativeAdLoaded,
    required this.nativeAdList,
    required this.onPropArticleTap,

    required this.listener,

  }) : super(key: key);

  @override
  State<PanelPropertiesListingWidget> createState() => _PanelPropertiesListingWidgetState();
}

class _PanelPropertiesListingWidgetState extends State<PanelPropertiesListingWidget> {
  AnimateIconController gridListAnimateIconController = AnimateIconController();

  final ArticleBoxDesign _articleBoxDesign = ArticleBoxDesign();

  bool _sortFlag = true;

  bool _showGridView = false;

  int _currentListingSortValue = 0;

  int _previousPropertyListSortValue = -1;

  String gridAnimatedIconLabel = UtilityMethods.getLocalizedString(CHIP_GRID);

  //original list, but sorted.
  List<dynamic> _sortedList = [];

  //all list, but also contains ads.
  List<dynamic> _articleAndAdsList = [];
  @override
  void initState() {
    _currentListingSortValue = sortByOptionsList.indexOf(DEFAULT_SORT_BY_OPTION);
    super.initState();
  }

  @override
  void dispose() {
    _sortedList = [];
    super.dispose();
  }

  /// Solution with SliverList:
  @override
  Widget build(BuildContext context) {
    if (widget.refreshing)  {
      _sortedList.clear();
      _articleAndAdsList.clear();
    }
    return widget.refreshing == true
        ? PanelLoadingWidget()
        : FutureBuilder<List<dynamic>>(
      future: widget.futureFilteredArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) {
            return NoResultFoundPageWidget(
              refreshing: widget.refreshing,
              listener: ({performSearch, totalResults}) {
                widget.listener(performSearch: performSearch);
              },
            );
          }

          List<dynamic> propertyList = articleSnapshot.data!;
          //process only when there's a difference in the data set.
          if (isThereADifferenceInDataset(propertyList) || _sortFlag) {
            //propertyList.removeWhere((element) => element is AdWidget);
            if (shouldPerformSortingOperations(propertyList)) {
              propertyList = performSortingOperationsAndAppendToOld(propertyList);
            }
            _articleAndAdsList = propertyList;
            if (SHOW_ADS_ON_LISTINGS) {
              //propertyList.removeWhere((element) => element is AdWidget);
              _articleAndAdsList = insertAdsInArticleList(propertyList);
            }
          }
          return Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                              color: AppThemePreferences()
                                  .appTheme
                                  .dividerColor,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0))),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 30), //30
                      child: GenericTextWidget(
                        UtilityMethods.getLocalizedString("properties"),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // if (_isNativeAdLoaded)
                    //  Padding(
                    //    padding: EdgeInsets.only(top: 100),
                    //    child: Container(
                    //      height: 50,
                    //      color: Colors.black,
                    //      // child: AdWidget(ad: _nativeAd),
                    //    ),
                    //  ),
                  ],
                ),
              ),
              Column(
                children: [
                  // if (_isNativeAdLoaded && SHOW_ADS_ON_LISTINGS)
                  //   Container(
                  //     margin: EdgeInsets.only(top: 50),
                  //     padding: EdgeInsets.all(5),
                  //     height: 160,
                  //     child: AdWidget(ad: _nativeAd),
                  //   ),

                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height -
                          (widget.hasBottomNavigationBar ? 150 : 100),
                    ),
                    child: CustomScrollView(
                      controller: widget.panelScrollController,
                      slivers: [
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                              childCount: 1,
                                  (context, index) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      top: 70,
                                      left: UtilityMethods.isRTL(context)
                                          ? 10
                                          : 20,
                                      right: UtilityMethods.isRTL(context)
                                          ? 20
                                          : 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            GenericTextWidget(
                                              widget.totalResults != null
                                                  ? "${widget.totalResults} " +
                                                  UtilityMethods
                                                      .getLocalizedString(
                                                      "Results")
                                                  : UtilityMethods
                                                  .getLocalizedString(
                                                  "searching"),
                                              style: AppThemePreferences()
                                                  .appTheme
                                                  .searchResultsTotalResultsTextStyle,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5),
                                              child: GenericTextWidget(
                                                UtilityMethods.getLocalizedString("showing_sorted_results", inputWords: [getTheCurrentSortOption()]),
                                                style: AppThemePreferences()
                                                    .appTheme
                                                    .searchResultsShowingSortedTextStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            if (SHOW_GRID_VIEW_BUTTON && !(UtilityMethods.showTabletView))
                                              SearchResultsChoiceChipsWidget(
                                                label: "",
                                                // label: gridAnimatedIconLabel,
                                                avatar: GenericAnimateIcons(
                                                  startIcon: Icons
                                                      .grid_view_outlined,
                                                  endIcon:
                                                  Icons.list_outlined,
                                                  controller:
                                                  gridListAnimateIconController,
                                                  size: 20,
                                                  onStartIconPress: () {
                                                    onGridAnimatedButtonStartPressed();
                                                    return true;
                                                  },
                                                  onEndIconPress: () {
                                                    onGridAnimatedButtonEndPressed();
                                                    return true;
                                                  },
                                                ),
                                                onSelected: (value) {
                                                  if (gridListAnimateIconController
                                                      .isStart()) {
                                                    onGridAnimatedButtonStartPressed();
                                                  } else if (gridListAnimateIconController
                                                      .isEnd()) {
                                                    onGridAnimatedButtonEndPressed();
                                                  }
                                                },
                                              ),
                                            SearchResultsChoiceChipsWidget(
                                              label: "",
                                              // label: GenericMethods.getLocalizedString(CHIP_SORT),
                                              iconData: Icons.sort_outlined,
                                              onSelected: (value) =>
                                                  onSortWidgetTap(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )),
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                              childCount: 1,
                                  (context, index) {
                                return SizedBox(height: 10);
                              },
                            )),
                        if (_showGridView || (UtilityMethods.showTabletView))
                          SliverGrid(
                            gridDelegate: (UtilityMethods.showTabletView)
                                ? SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 3:2,
                                mainAxisExtent: _articleBoxDesign.getArticleBoxDesignHeight(design: DESIGN_06)
                            ) : const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0, // Adjust as needed
                              mainAxisSpacing: 8.0, // Adjust as needed
                              childAspectRatio: 1.0, // Adjust as needed
                            ),
                            delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  Article item;
                                  var heroId = "";
                                  int propId;
                                  try {
                                    var object = _articleAndAdsList[index];
                                    if (object is AdWidget) {
                                      return Container(
                                        height: 160,
                                        padding: const EdgeInsets.all(5),
                                        child: object,
                                      );
                                    }
                                    item = _articleAndAdsList[index];
                                    heroId =
                                    "${item.id}-${UtilityMethods.getRandomNumber()}-$FILTERED_GRID";
                                    propId = item.id!;
                                  } catch (e) {
                                    return Container();
                                  }

                                  String design = (UtilityMethods.showTabletView) ? DESIGN_06 : DESIGN_09;
                                  // print("Building Property Item at ($index)");
                                  return SizedBox(
                                    height: _articleBoxDesign.getArticleBoxDesignHeight(design: design),
                                    child:
                                    _articleBoxDesign.getArticleBoxDesign(
                                      design: design,
                                      buildContext: context,
                                      heroId: heroId,
                                      article: item,
                                      onTap: () => widget.onPropArticleTap(
                                          item, propId, heroId),
                                    ),
                                  );
                                },
                                childCount: _articleAndAdsList.length),
                          ),
                        if (!_showGridView && !(UtilityMethods.showTabletView))
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                // NativeAd native;
                                // if (SHOW_ADS_ON_LISTINGS && index % 5 == 0 && index != 0){
                                //    native =  getNativeAd();
                                // }
                                Article item;
                                var heroId = "";
                                int propId;
                                try {
                                  var object = _articleAndAdsList[index];
                                  if (object is AdWidget) {
                                    return Container(
                                      height: 160,
                                      padding: const EdgeInsets.all(5),
                                      child: object,
                                    );
                                  }
                                  item = _articleAndAdsList[index];
                                  heroId =
                                  "${item.id}-${UtilityMethods.getRandomNumber()}-$FILTERED";
                                  propId = item.id!;
                                } catch (e) {
                                  return Container();
                                }
                                // print("Building Property Item at ($index)");
                                return SizedBox(
                                  height: _articleBoxDesign
                                      .getArticleBoxDesignHeight(
                                      design:
                                      SEARCH_RESULTS_PROPERTIES_DESIGN),
                                  child: _articleBoxDesign
                                      .getArticleBoxDesign(
                                    design:
                                    SEARCH_RESULTS_PROPERTIES_DESIGN,
                                    buildContext: context,
                                    heroId: heroId,
                                    article: item,
                                    onTap: () => widget.onPropArticleTap(
                                        item, propId, heroId),
                                  ),
                                );
                              },
                              childCount: _articleAndAdsList.length,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        } else if (articleSnapshot.hasError) {
          widget.listener(totalResults: 0);
          return NoResultFoundPageWidget(
            refreshing: widget.refreshing,
            listener: ({performSearch, totalResults}) {
              widget.listener(performSearch: performSearch);
            },
          );
        }

        return PanelLoadingWidget();
      },
    );
  }
  bool isThereADifferenceInDataset(List<dynamic> propertyList) {
    //both lists aren't equal
    if (propertyList.length != _sortedList.length) {
      return true;
    }

    var set1 = Set.from(propertyList);
    var set2 = Set.from(_sortedList);

    int newListingsBatchLength = set1.difference(set2).length;
    return (newListingsBatchLength > 0);
  }

  bool shouldPerformSortingOperations (List<dynamic> propertyList) {
    if ((_sortedList.isEmpty)
        || (_sortedList.isNotEmpty && propertyList != _sortedList)
    ) {
      return true;
    }
    return false;
  }

  List<dynamic> performSortingOperationsAndAppendToOld(List<dynamic> propertyList) {
    //propertyList.removeWhere((element) => element is AdWidget);
    // CHECKING FOR THE ARRIVAL OF NEW LISTINGS
    var set1 = Set.from(propertyList);
    var set2 = Set.from(_sortedList);

    int newListingsBatchLength = set1.difference(set2).length;

    if (newListingsBatchLength > 0) {
      // APPLYING SORT OPERATIONS ON NEW LISTINGS
      propertyList = performSortingOnNewListingsAndAppendToOld(propertyList);
    } else {
      // NO NEW LISTINGS ARRIVED, KEEP THE LAST SORTED LISTINGS
      propertyList = _sortedList;

      // APPLYING SORT OPERATIONS ON OLD LISTINGS
      if (_sortFlag) {
        propertyList = performSortingOnOldListings(propertyList);
        _sortFlag = false;
      }
    }

    return propertyList;
  }

  List<dynamic> performSortingOnNewListingsAndAppendToOld(List<dynamic> propertyList) {
    //propertyList.removeWhere((element) => element is AdWidget);
    // SEPARATING BATCH OF NEW LISTINGS
    var set1 = Set.from(propertyList);
    var set2 = Set.from(_sortedList);
    List<dynamic> newListingsBatch = List.from(set1.difference(set2));

    // APPLYING SORT BY MENU OPERATION e.g. NEWEST, OLDEST etc.
    newListingsBatch = sortBySelectedMenuOption(newListingsBatch);

    //  APPLYING SORT FIRST BY OPERATIONS
    List<dynamic> _filteredList = sortByFirstOptions(newListingsBatch);

    if (_filteredList.isNotEmpty) {
      // SORT FIRST BY OPERATIONS APPLIED, RE-ARRANGING LISTINGS
      var set1 = Set.from(newListingsBatch);
      var set2 = Set.from(_filteredList);
      List<dynamic> newPropertiesList = List.from(set1.difference(set2));
      _filteredList.addAll(newPropertiesList);

      // REPLACING THE NEWLY SORTED BATCH WITH THE PREVIOUS NON-SORTED ONE,
      // IN THE PROPERTIES LISTING LIST
      propertyList.removeRange(
          (propertyList.length - newListingsBatch.length), propertyList.length);
      propertyList.addAll(_filteredList);

      // UPDATING THE RESULTS LIST (FOR KEEPING TRACK OF NEW LISTINGS)
      _sortedList.addAll(_filteredList);
    } else {
      // NO SORT FIRST BY OPERATION APPLIED, REPLACING THE NEWLY SORTED BATCH
      // WITH THE PREVIOUS NON-SORTED ONE, IN THE PROPERTIES LISTING LIST
      propertyList.removeRange(
          (propertyList.length - newListingsBatch.length), propertyList.length);
      propertyList.addAll(newListingsBatch);

      // UPDATING THE RESULTS LIST (FOR KEEPING TRACK OF SORTED LISTINGS)
      _sortedList.addAll(newListingsBatch);
    }

    return propertyList;
  }

  List<dynamic> performSortingOnOldListings(List<dynamic> propertyList) {
    //propertyList.removeWhere((element) => element is AdWidget);
    // APPLYING SORT BY MENU OPERATION e.g. NEWEST, OLDEST etc.
    propertyList = sortBySelectedMenuOption(propertyList);

    //  APPLYING SORT FIRST BY OPERATIONS
    List<dynamic> _filteredList = sortByFirstOptions(propertyList);

    if (_filteredList.isNotEmpty) {
      // SORT FIRST BY OPERATIONS APPLIED, RE-ARRANGING LISTINGS
      var set1 = Set.from(propertyList);
      var set2 = Set.from(_filteredList);
      List<dynamic> newPropertiesList =
      List.from(set1.difference(set2));
      _filteredList.addAll(newPropertiesList);

      // UPDATING THE LISTINGS LIST
      propertyList = _filteredList;

      // UPDATING THE RESULTS LIST (FOR KEEPING TRACK OF SORTED LISTINGS)
      _sortedList = [];
      _sortedList.addAll(propertyList);
    }
    else {
      // APPLIED SORT BY MENU OPERATIONS
      // NO SORT FIRST BY OPERATION APPLIED

      // // UPDATING THE LISTINGS LIST
      // propertyList = _resultsList;
      // UPDATING THE RESULTS LIST (FOR KEEPING TRACK OF SORTED LISTINGS)
      _sortedList = propertyList;
    }

    return propertyList;
  }

  List<dynamic> sortBySelectedMenuOption(List<dynamic> propertyList) {
    //propertyList.removeWhere((element) => element is AdWidget);
    // 0. SORT BY NEWEST
    if (_currentListingSortValue == 0) {
      propertyList.sort((a, b) {
        return b.dateGMT.compareTo(a.dateGMT);
      });
    }

    // 1. SORT BY OLDEST
    else if (_currentListingSortValue == 1) {
      propertyList.sort((a, b) {
        return a.dateGMT.compareTo(b.dateGMT);
      });
    }

    // 2. SORT BY PRICE (LOW TO HIGH)
    else if (_currentListingSortValue == 2) {
      propertyList.sort((a, b) {
        int aPrice = UtilityMethods.getCleanPriceForSorting(
            a.propertyInfo.price.isNotEmpty
                ? a.propertyInfo.price
                : "0");
        int bPrice = UtilityMethods.getCleanPriceForSorting(
            b.propertyInfo.price.isNotEmpty
                ? b.propertyInfo.price
                : "0");

        return aPrice.compareTo(bPrice);
      });
    }

    // 3. SORT BY PRICE (HIGH TO LOW)
    else if (_currentListingSortValue == 3) {
      propertyList.sort((a, b) {
        int aPrice = UtilityMethods.getCleanPriceForSorting(
            a.propertyInfo.price.isNotEmpty
                ? a.propertyInfo.price
                : "0");
        int bPrice = UtilityMethods.getCleanPriceForSorting(
            b.propertyInfo.price.isNotEmpty
                ? b.propertyInfo.price
                : "0");

        return bPrice.compareTo(aPrice);
      });
    }

    // 4. SORT BY AREA (LOW TO HIGH)
    else if (_currentListingSortValue == 4) {
      propertyList.sort((a, b) {
        int aArea = UtilityMethods.getIntValueFromString(
            a.features.landArea.isNotEmpty
                ? a.features.landArea
                : "0");
        int bArea = UtilityMethods.getIntValueFromString(
            b.features.landArea.isNotEmpty
                ? b.features.landArea
                : "0");

        return aArea.compareTo(bArea);
      });
    }

    // 5. SORT BY AREA (HIGH TO LOW)
    else if (_currentListingSortValue == 5) {
      propertyList.sort((a, b) {
        int aArea = UtilityMethods.getIntValueFromString(
            a.features.landArea.isNotEmpty
                ? a.features.landArea
                : "0");
        int bArea = UtilityMethods.getIntValueFromString(
            b.features.landArea.isNotEmpty
                ? b.features.landArea
                : "0");

        return bArea.compareTo(aArea);
      });
    }

    return propertyList;
  }

  List<dynamic> sortByFirstOptions(List<dynamic> propertyList) {
    //propertyList.removeWhere((element) => element is AdWidget);
    List<dynamic> _filteredList = [];
    List<SortFirstByItem> _sortFirstByItemsList = [];
    List<Map<String, String>> _sortFirstBySelectedOptions = [];

    // READING THE SORT FIRST BY CONFIG FROM STORAGE
    _sortFirstByItemsList = UtilityMethods.readSortFirstByConfigFile();

    // GETTING THE SELECTED ITEMS
    for (SortFirstByItem item in _sortFirstByItemsList) {
      if (item.defaultValue == 'on') {
        if (item.sectionType == featuredSortItemKey) {
          _sortFirstBySelectedOptions.add({
            featuredSortItemKey : featuredSortItemKey,
          });
        } else if (item.term != null &&
            item.subTerm != null) {
          _sortFirstBySelectedOptions.add({
            item.term! : item.subTerm!,
          });
        }
      }
    }

    // SORTING w.r.t OPTIONS e.g. FEATURES, HOT OFFER etc. 
    if (_sortFirstBySelectedOptions.isNotEmpty) {
      for (int i = _sortFirstBySelectedOptions.length; i > 0; i--) {
        String key = _sortFirstBySelectedOptions[(i-1)].keys.toList()[0];
        String value = _sortFirstBySelectedOptions[(i-1)][key] ?? '';

        // SEPARATING FEATURED LISTINGS
        if (key == featuredSortItemKey) {
          _filteredList = propertyList
              .where((element) =>
          element.propertyInfo!.isFeatured ?? false).toList();
        }
        // SEPARATING LISTINGS ON THE BASIS OF PROPERTY TYPE
        else if (key == propertyTypeDataType) {
          _filteredList = propertyList
              .where((element) =>
          element.features!.propertyTypeList.contains(value) ?? false).toList();
        }
        // SEPARATING LISTINGS ON THE BASIS OF PROPERTY LABEL
        else if (key == propertyLabelDataType) {
          _filteredList = propertyList
              .where((element) =>
          element.features!.propertyLabelList.contains(value) ?? false).toList();
        }
        // SEPARATING LISTINGS ON THE BASIS OF PROPERTY STATUS
        else if (key == propertyStatusDataType) {
          _filteredList = propertyList
              .where((element) =>
          element.features!.propertyStatusList.contains(value) ?? false).toList();
        }

        // APPLYING SORT FIRST BY OPERATIONS AND RE-ARRANGING LISTINGS
        if (_filteredList.isNotEmpty) {
          var set1 = Set.from(propertyList);
          var set2 = Set.from(_filteredList);
          List<dynamic> newPropertiesList = List.from(set1.difference(set2));
          _filteredList.addAll(newPropertiesList);
          propertyList = _filteredList;
        }
      }
    }

    return _filteredList.isNotEmpty ? _filteredList : propertyList;
  }

  insertAdsInArticleList(List<dynamic> propertyList){
    List<dynamic> articleAndAdsList = [];
    articleAndAdsList.addAll(propertyList);
    if(widget.isNativeAdLoaded){
      if (!(widget.nativeAdList.length <= 0)) {
        int offset = 5;
        int index = min(5, propertyList.length);
        for (NativeAd ad in widget.nativeAdList) {
          if (index > propertyList.length) {
            break;
          }

          articleAndAdsList.insert(index, AdWidget(ad: ad));
          index = index + offset;
          //print("index is $index, offset $offset, ad is ${ad.responseInfo.responseId}");
        }
      }
    }
    return articleAndAdsList;
  }

  String getTheCurrentSortOption(){
    String _currentSortOption = sortByOptionsList[_currentListingSortValue];
    return UtilityMethods.getLocalizedString(_currentSortOption);
  }

  onGridAnimatedButtonStartPressed(){
    gridListAnimateIconController.animateToEnd();

    if(mounted) {
      setState(() {
      _showGridView = true;
    });
    }

    // gridAnimatedIconLabel = UtilityMethods.getLocalizedString(CHIP_LIST);
  }

  onGridAnimatedButtonEndPressed(){
    gridListAnimateIconController.animateToStart();

    if(mounted) {
      setState(() {
      _showGridView = false;
    });
    }

    // gridAnimatedIconLabel = UtilityMethods.getLocalizedString(CHIP_GRID);
  }

  onSortWidgetTap(BuildContext context){
    showModelBottomSheetWidget(
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SortMenuWidget(
              currentSortValue: _currentListingSortValue,
              previousSortValue: _previousPropertyListSortValue,
              listener: ({currentSortValue, previousSortValue, sortFlag}) {
                if (mounted) {
                  setState(() {
                    if (currentSortValue != null) {
                      _currentListingSortValue = currentSortValue;
                    }

                    if (previousSortValue != null) {
                      _previousPropertyListSortValue = previousSortValue;
                    }

                    if (sortFlag != null) {
                      _sortFlag = sortFlag;
                    }
                  });
                }
              },
            ),
          );
        });
  }
}

class NoResultFoundPageWidget extends StatelessWidget {
  final bool refreshing;
  final PanelPropertiesListingWidgetListener listener;

  const NoResultFoundPageWidget({
    Key? key,
    required this.refreshing,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: refreshing == true ? PanelLoadingWidget() : NoResultErrorWidget(
        headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
        bodyErrorText: UtilityMethods.getLocalizedString("no_properties_error_message_filter_page_search"),
        buttonText:  UtilityMethods.getLocalizedString("refine_search_text"),
        onButtonPressed: () => NavigateToFilterPage(context),
      ),
    );
  }

  NavigateToFilterPage(BuildContext context, {Map? dataMap}){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage(
          mapInitializeData: dataMap != null && dataMap.isNotEmpty ?
          dataMap : HiveStorageManager.readFilterDataInfo() ?? {},
          filterPageListener: (Map<String, dynamic> map, String closeOption) {
            if (closeOption == DONE) {
              Navigator.of(context).pop();
              listener(performSearch: true);
            }else if(closeOption == CLOSE){
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }
}