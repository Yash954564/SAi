import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/api_providers/place_api_provider.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/address_search.dart';
import 'package:houzi_package/pages/filter_page.dart';
import 'package:houzi_package/pages/search_result.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef HomeElegantScreenSearchBarWidgetListener = void Function({Map<String, dynamic>? filterDataMap});

class HomeElegantScreenSearchBarWidget extends StatefulWidget {
  final HomeElegantScreenSearchBarWidgetListener? homeElegantScreenSearchBarWidgetListener;

  const HomeElegantScreenSearchBarWidget({
    Key? key,
    this.homeElegantScreenSearchBarWidgetListener,
  }) : super(key: key);

  @override
  State<HomeElegantScreenSearchBarWidget> createState() => _HomeElegantScreenSearchBarWidgetState();
}

class _HomeElegantScreenSearchBarWidgetState extends State<HomeElegantScreenSearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 5, left: 5),
      height: 35,
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: GestureDetector(
              onTap: () async {
                final Suggestion? result = await showSearch(
                  context: context,
                  delegate: AddressSearch('', forKeyWordSearch: true),
                );
                if (result != null && result.description!.isNotEmpty) {
                  Map<String, String> keyWordMap = {
                    PROPERTY_KEYWORD: result.description!,
                    KEYWORD_DEFAULT_KEY: result.description!
                  };

                  HiveStorageManager.storeFilterDataInfo(map: keyWordMap);
                  GeneralNotifier().publishChange(GeneralNotifier.FILTER_DATA_LOADING_COMPLETE);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResult(
                        dataInitializationMap: HiveStorageManager.readFilterDataInfo(),
                        searchPageListener: (Map<String, dynamic> map, String closeOption) {
                          if (closeOption == CLOSE) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.only(
                    right: UtilityMethods.isRTL(context) ? 10 : 0,
                    left: UtilityMethods.isRTL(context) ? 0 : 10),
                height: 35,
                child: Row(
                  children: [
                    AppThemePreferences().appTheme.homeScreenSearchBarIcon!,
                    Padding(
                      padding: EdgeInsets.only(
                          right: UtilityMethods.isRTL(context) ? 10 : 0,
                          left: UtilityMethods.isRTL(context) ? 0 : 10),
                      child: GenericTextWidget(
                        UtilityMethods.getLocalizedString("search"),
                        style: AppThemePreferences().appTheme.searchBarTextStyle,
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: AppThemePreferences().appTheme.containerBackgroundColor,
                  border: Border.all(
                      color:
                      AppThemePreferences().appTheme.containerBackgroundColor!,
                      width: 0),
                  borderRadius: BorderRadius.only(
                    topLeft: UtilityMethods.isRTL(context) ? const Radius.circular(0) : const Radius.circular(10),
                    bottomLeft: UtilityMethods.isRTL(context) ? const Radius.circular(0) : const Radius.circular(10),
                    topRight: UtilityMethods.isRTL(context) ? const Radius.circular(10) : const Radius.circular(0),
                    bottomRight: UtilityMethods.isRTL(context) ? const Radius.circular(10) : const Radius.circular(0),
                    //
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                navigateToFilterScreen(
                  context: context,
                  navigateToFilterScreenListener: ({filterDataMap}) {
                    widget.homeElegantScreenSearchBarWidgetListener!(filterDataMap: filterDataMap);
                  },
                );
              },
              child: Container(
                height: 35,
                padding: EdgeInsets.only(right: UtilityMethods.isRTL(context) ? 0 : 10, left: UtilityMethods.isRTL(context) ? 10 :0),
                child: GestureDetector(
                    onTap: () {
                      navigateToFilterScreen(
                        context: context,
                        navigateToFilterScreenListener: (
                            {filterDataMap,
                              recentSearchesDataMapList,
                              loadProperties}) {
                          widget.homeElegantScreenSearchBarWidgetListener!(filterDataMap: filterDataMap);
                        },
                      );
                    },
                    child: AppThemePreferences()
                        .appTheme
                        .homeScreenSearchBarFilterIcon),
                decoration: BoxDecoration(
                  color: AppThemePreferences().appTheme.containerBackgroundColor,
                  border: Border.all(
                      color:
                      AppThemePreferences().appTheme.containerBackgroundColor!,
                      width: 0),
                  borderRadius: BorderRadius.only(
                    topLeft: UtilityMethods.isRTL(context) ? const Radius.circular(10) : const Radius.circular(0),
                    bottomLeft: UtilityMethods.isRTL(context) ? const Radius.circular(10) : const Radius.circular(0),
                    topRight: UtilityMethods.isRTL(context) ? const Radius.circular(0) : const Radius.circular(10),
                    bottomRight: UtilityMethods.isRTL(context) ? const Radius.circular(0) : const Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void navigateToFilterScreen({
  required BuildContext context,
  final HomeElegantScreenSearchBarWidgetListener? navigateToFilterScreenListener,
}) {
  StatefulWidget Function(dynamic context) builder;
  builder = (context) => SHOW_MAP_INSTEAD_FILTER
      ? SearchResult(
    dataInitializationMap: {},
    searchPageListener: (Map<String, dynamic> map, String closeOption) {
      if (closeOption == CLOSE) {
        Navigator.of(context).pop();
      }
    },
  )
      : FilterPage(
    mapInitializeData: HiveStorageManager.readFilterDataInfo(),
    filterPageListener: (Map<String, dynamic> dataMap, String closeOption) {
      if (closeOption == DONE) {
        // print("Filter Page Map: $dataMap");
        // print("Hive Map: ${HiveStorageManager.readFilterDataInfo()}");
        navigateToFilterScreenListener!(filterDataMap: HiveStorageManager.readFilterDataInfo() ?? {});
        Navigator.pop(context);

        // print("Search Page Hive Map: ${HiveStorageManager.readFilterDataInfo()}");
        UtilityMethods.navigateToSearchResultScreen(
            context: context,
            dataInitializationMap: HiveStorageManager.readFilterDataInfo(),
            navigateToSearchResultScreenListener: ({filterDataMap, recentSearchesDataMapList, loadProperties}) {
              navigateToFilterScreenListener(filterDataMap: filterDataMap);
            });
      } else if (closeOption == CLOSE) {
        Navigator.pop(context);
      } else if (closeOption == UPDATE_DATA || closeOption == RESET) {
        navigateToFilterScreenListener!(filterDataMap: dataMap);
      } else {
        navigateToFilterScreenListener!(filterDataMap: dataMap);
      }
    },
  );
  UtilityMethods.navigateToRoute(context: context, builder: builder);
}