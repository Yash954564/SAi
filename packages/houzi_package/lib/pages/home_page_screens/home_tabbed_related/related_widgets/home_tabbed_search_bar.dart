import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/filter_page.dart';
import 'package:houzi_package/pages/search_result.dart';


typedef HomeTabbedSearchBarWidgetListener = void Function(Map<String, dynamic> filterInfo);

class HomeTabbedSearchBarWidget extends StatefulWidget{

  final HomeTabbedSearchBarWidgetListener homeTabbedSearchBarWidgetListener;
  final double? borderRadius;

  HomeTabbedSearchBarWidget({
    Key? key,
    this.borderRadius = 24.0,
    required this.homeTabbedSearchBarWidgetListener,
  }) : super(key: key);
  
  
  @override
  State<StatefulWidget> createState() => HomeTabbedSearchBarWidgetState();
}

class HomeTabbedSearchBarWidgetState extends State<HomeTabbedSearchBarWidget> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToFilterScreen(
          context: context,
          navigateToFilterScreenListener: (filterDataMap) {
            widget.homeTabbedSearchBarWidgetListener(filterDataMap);
          },
        );
      },
      child: SizedBox(
        height: 36.0,
        width: double.infinity,
        child: TextFormField(
          readOnly: true,
          strutStyle: const StrutStyle(forceStrutHeight: true),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            enabled: false,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(color: AppThemePreferences().appTheme.searchBarBackgroundColor!),
            ),
            contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15),
            fillColor: AppThemePreferences().appTheme.searchBarBackgroundColor,
            filled: true,
            hintText: UtilityMethods.getLocalizedString("search"),
            hintStyle: AppThemePreferences().appTheme.searchBarTextStyle,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: AppThemePreferences().appTheme.homeScreenSearchBarIcon,
            ),
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(widget.borderRadius!),
            //   borderSide: BorderSide(
            //     color: AppThemePreferences().appTheme.searchBarBackgroundColor,
            //     width: 1.0,
            //   ),
            // ),
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(widget.borderRadius!),
            //   borderSide: BorderSide(
            //     color: AppThemePreferences().appTheme.searchBarBackgroundColor,
            //     width: 1.0,
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  void navigateToFilterScreen({
    required BuildContext context,
    required final HomeTabbedSearchBarWidgetListener navigateToFilterScreenListener,
  }){
    builder(context) => SHOW_MAP_INSTEAD_FILTER ? SearchResult(
      dataInitializationMap: {},
      searchPageListener: (Map<String, dynamic> map, String closeOption) {
        if (closeOption == CLOSE) {
          Navigator.of(context).pop();
        }
      },
    ) : FilterPage(
      mapInitializeData: HiveStorageManager.readFilterDataInfo(),
      filterPageListener: (Map<String, dynamic> dataMap, String closeOption) {
        if (closeOption == DONE) {
          navigateToFilterScreenListener(HiveStorageManager.readFilterDataInfo());
          Navigator.pop(context);

          UtilityMethods.navigateToSearchResultScreen(
              context: context,
              dataInitializationMap: HiveStorageManager.readFilterDataInfo(),
              navigateToSearchResultScreenListener: ({filterDataMap, recentSearchesDataMapList, loadProperties}){
                navigateToFilterScreenListener(filterDataMap!);
              }
          );
        } else if(closeOption == CLOSE){
          Navigator.pop(context);
        }else if(closeOption == UPDATE_DATA || closeOption == RESET){
          navigateToFilterScreenListener(dataMap);
        }else{
          navigateToFilterScreenListener(dataMap);
        }
      },
    );
    UtilityMethods.navigateToRoute(context: context, builder: builder);
  }
}