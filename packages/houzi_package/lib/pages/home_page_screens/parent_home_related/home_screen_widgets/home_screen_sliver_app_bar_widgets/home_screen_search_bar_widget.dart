import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/filter_page.dart';
import 'package:houzi_package/pages/search_result.dart';


typedef HomeScreenSearchBarWidgetListener = void Function({Map<String, dynamic>? filterDataMap});

class HomeScreenSearchBarWidget extends StatefulWidget {
  final HomeScreenSearchBarWidgetListener? homeScreenSearchBarWidgetListener;

  const HomeScreenSearchBarWidget({
    Key? key,
    this.homeScreenSearchBarWidgetListener,
  }) : super(key: key);

  @override
  State<HomeScreenSearchBarWidget> createState() => _HomeScreenSearchBarWidgetState();
}

class _HomeScreenSearchBarWidgetState extends State<HomeScreenSearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToFilterScreen(
          context: context,
          navigateToFilterScreenListener: ({filterDataMap}) {
            widget.homeScreenSearchBarWidgetListener!(filterDataMap: filterDataMap);
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
              borderRadius: BorderRadius.circular(24.0),
              borderSide: BorderSide(color: AppThemePreferences().appTheme.searchBarBackgroundColor!),
            ),
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(24.0),
            //   borderSide: BorderSide(
            //       color: AppThemePreferences().appTheme.searchBarBackgroundColor,
            //       width: 0.0,
            //   ),
            // ),
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(24.0),
            //   borderSide: BorderSide(
            //       color: AppThemePreferences().appTheme.searchBarBackgroundColor,
            //       width: 0.0,
            //   ),
            // ),
            contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15),
            fillColor: AppThemePreferences().appTheme.searchBarBackgroundColor,
            filled: true,
            hintText: UtilityMethods.getLocalizedString("search"),
            hintStyle: AppThemePreferences().appTheme.searchBarTextStyle,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: AppThemePreferences().appTheme.homeScreenSearchBarIcon,
            ),
          ),
        ),
      ),
    );
  }
}

void navigateToFilterScreen({
  required BuildContext context,
  required final HomeScreenSearchBarWidgetListener navigateToFilterScreenListener,
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
        navigateToFilterScreenListener(filterDataMap: HiveStorageManager.readFilterDataInfo());
        Navigator.pop(context);

        UtilityMethods.navigateToSearchResultScreen(
            context: context,
            dataInitializationMap: HiveStorageManager.readFilterDataInfo(),
            navigateToSearchResultScreenListener: ({filterDataMap}){
              navigateToFilterScreenListener(filterDataMap: filterDataMap);
            }
        );
      } else if(closeOption == CLOSE){
        Navigator.pop(context);
      }else if(closeOption == UPDATE_DATA || closeOption == RESET){
        navigateToFilterScreenListener(filterDataMap: dataMap);
      }else{
        navigateToFilterScreenListener(filterDataMap: dataMap);
      }
    },
  );
  UtilityMethods.navigateToRoute(context: context, builder: builder);
}