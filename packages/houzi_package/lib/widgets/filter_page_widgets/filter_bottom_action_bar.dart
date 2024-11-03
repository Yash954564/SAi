import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef FilterPageBottomActionBarWidgetListener = Function(
  Map<String, dynamic> dataInitializationMap,
  String closeOption,
);

class FilterPageBottomActionBarWidget extends StatelessWidget {
  final Map<String, dynamic> dataInitializationMap;
  final FilterPageBottomActionBarWidgetListener listener;

  const FilterPageBottomActionBarWidget({
    Key? key,
    required this.dataInitializationMap,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          color: AppThemePreferences().appTheme.backgroundColor,
          border: Border(
            top: AppThemePreferences().appTheme.filterPageBorderSide!,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: kFilterPageBottomActionBarHeight,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Padding(
              padding: (UtilityMethods.showTabletView)
                  ? const EdgeInsets.symmetric(horizontal: 150)
                  : const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(flex: 2, child: Container()),
                  Expanded(flex: 0, child: FilterPageResetButtonWidget()),
                  Expanded(flex: 3,child: FilterPageDoneButtonWidget(
                    dataInitializationMap: dataInitializationMap,
                    listener: listener,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FilterPageResetButtonWidget extends StatelessWidget {
  const FilterPageResetButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GeneralNotifier().publishChange(GeneralNotifier.RESET_FILTER_DATA);
        GeneralNotifier().publishChange(GeneralNotifier.CITY_DATA_UPDATE);
      },
      child: Container(
        height: double.infinity,
        padding: EdgeInsets.only(
          right: UtilityMethods.isRTL(context) ? 0 : 15,
          left: UtilityMethods.isRTL(context) ? 15 : 0,
        ),
        child: Center(
          child: GenericTextWidget(
            UtilityMethods.getLocalizedString("reset"),
            style: AppThemePreferences().appTheme.filterPageResetTextStyle,
          ),
        ),
      ),
    );
  }
}

class FilterPageDoneButtonWidget extends StatelessWidget {
  final Map<String, dynamic> dataInitializationMap;
  final FilterPageBottomActionBarWidgetListener listener;
  
  const FilterPageDoneButtonWidget({
    Key? key,
    required this.dataInitializationMap,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      buttonHeight: AppThemePreferences.filterPageSearchButtonHeight,
      fontSize: AppThemePreferences.filterPageSearchButtonTextFontSize,
      text: UtilityMethods.getLocalizedString("search"),
      onPressed: () {
        if(dataInitializationMap.isNotEmpty &&
            dataInitializationMap[SELECTED_INDEX_FOR_TAB] != null){
          if(dataInitializationMap[SELECTED_INDEX_FOR_TAB] == 0){
            dataInitializationMap[LATITUDE]  = "";
            dataInitializationMap[LONGITUDE] =  "";
            // dataInitializationMap[SELECTED_LOCATION] = PLEASE_SELECT;
            dataInitializationMap[RADIUS] = "50.0";
            dataInitializationMap[USE_RADIUS] = "off";
            dataInitializationMap[SEARCH_LOCATION] = "false";
          }else if(dataInitializationMap[SELECTED_INDEX_FOR_TAB] == 1){
            // if(dataInitializationMap[SELECTED_LOCATION] != null && dataInitializationMap[SELECTED_LOCATION] != PLEASE_SELECT){
            //   dataInitializationMap[SELECTED_LOCATION] = dataInitializationMap[SELECTED_LOCATION];
            // }
            if(dataInitializationMap[RADIUS] == null || dataInitializationMap[RADIUS].isEmpty) {
              dataInitializationMap[RADIUS] = "50";
            }
            if (dataInitializationMap[LATITUDE] != null && dataInitializationMap[LONGITUDE] != null && dataInitializationMap[RADIUS] != null) {
              if (dataInitializationMap[LATITUDE].isNotEmpty
                  && dataInitializationMap[LONGITUDE].isNotEmpty
                  && dataInitializationMap[RADIUS].isNotEmpty) {
                dataInitializationMap[USE_RADIUS] = "on";
                dataInitializationMap[SEARCH_LOCATION] = "true";
              }
              dataInitializationMap[CITY] = "";
              dataInitializationMap[CITY_ID] = null;
              dataInitializationMap[CITY_SLUG] = "";
            }
          }
        }

        HiveStorageManager.storeFilterDataInfo(map: dataInitializationMap);

        List recentSearchesList = [];
        recentSearchesList = HiveStorageManager.readRecentSearchesInfo() ?? [];

        /// Save only 10 recent searches
        if(recentSearchesList.isNotEmpty && recentSearchesList.length > 10){
          recentSearchesList.removeLast();
        }

        if (recentSearchesList.isEmpty && dataInitializationMap.isNotEmpty) {
          recentSearchesList.add(dataInitializationMap);
        } else {
          recentSearchesList.insert(0, dataInitializationMap);
        }

        HiveStorageManager.storeRecentSearchesInfo(infoList: recentSearchesList);
        GeneralNotifier().publishChange(GeneralNotifier.RECENT_DATA_UPDATE);

        listener(dataInitializationMap, DONE);

      },
    );
  }
}


