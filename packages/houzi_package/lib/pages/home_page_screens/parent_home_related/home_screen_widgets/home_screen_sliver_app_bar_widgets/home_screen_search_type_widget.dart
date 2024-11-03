import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/search_type_widget.dart';
import 'package:provider/provider.dart';


typedef HomeScreenSearchTypeWidgetListener = void Function(String selectedItem, String selectedItemSlug);

class HomeScreenSearchTypeWidget extends StatefulWidget{

  final HomeScreenSearchTypeWidgetListener homeScreenSearchTypeWidgetListener;

  HomeScreenSearchTypeWidget({required this.homeScreenSearchTypeWidgetListener});

  @override
  State<StatefulWidget> createState() => HomeScreenSearchTypeWidgetState();
}

class HomeScreenSearchTypeWidgetState extends State<HomeScreenSearchTypeWidget> {

  int _selectedIndex = 0;
  List<dynamic> propertyStatusMetaData = [];
  List<dynamic> propertyStatusListWithData = [];
  List<String> propertyStatusListOfLabels = [];

  Term tempForRentObject = Term(name: "For Rent", slug: "for-rent");
  Term tempForSaleObject = Term(name: "For Sale", slug: "for-sale");

  int maxAllowed = defaultSearchTypeSwitchOptions;
  // int maxAllowed = 2;

  VoidCallback? generalNotifierListener;

  @override
  void initState() {
    super.initState();
    propertyStatusMetaData = HiveStorageManager.readPropertyStatusMetaData() ?? [];
    loadData();

    /// General Notifier Listener
    generalNotifierListener = () {
      if (GeneralNotifier().change == GeneralNotifier.APP_CONFIGURATIONS_UPDATED) {
        loadData();
      }
    };

    GeneralNotifier().addListener(generalNotifierListener!);
  }

  loadData(){
    maxAllowed = defaultSearchTypeSwitchOptions;
    propertyStatusListWithData.clear();
    propertyStatusListOfLabels.clear();
    if(propertyStatusMetaData.isNotEmpty && propertyStatusMetaData.length > 0){
      propertyStatusMetaData.forEach((item) {
        if(propertyStatusListWithData.length < maxAllowed){
          propertyStatusListWithData.add(item);
        }
        // if(item.totalPropertiesCount > 0 && propertyStatusListWithData.length < maxAllowed ){
        //   propertyStatusListWithData.add(item);
        // }
      });

      if(propertyStatusListWithData.isNotEmpty && propertyStatusListWithData.length > 0){
        propertyStatusListWithData.forEach((item) {
          propertyStatusListOfLabels.add(UtilityMethods.getLocalizedString(item.name));
        });
      }else{
        propertyStatusListWithData.add(tempForRentObject);
        propertyStatusListWithData.add(tempForSaleObject);
        propertyStatusListWithData.forEach((item) {
          propertyStatusListOfLabels.add(UtilityMethods.getLocalizedString(item.name));
        });
      }
    }
    else{
      propertyStatusListWithData.add(tempForRentObject);
      propertyStatusListWithData.add(tempForSaleObject);
      propertyStatusListWithData.forEach((item) {
        propertyStatusListOfLabels.add(UtilityMethods.getLocalizedString(item.name));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if(propertyStatusMetaData.isEmpty){
      propertyStatusMetaData = HiveStorageManager.readPropertyStatusMetaData() ?? [];
      loadData();
    }
    return Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          loadData();
          return Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: searchTypeWidget(
                    cornerRadius: 24,
                    minWidth: 100,//80
                    minHeight: 45,
                    radiusStyle: true,
                    fontSize: AppThemePreferences.toggleSwitchTextFontSize,
                    totalSwitches: propertyStatusListOfLabels.length,
                    labels: propertyStatusListOfLabels,
                    onToggle: (index) {
                      if (index != null) {
                        _selectedIndex = index;
                        widget.homeScreenSearchTypeWidgetListener(
                            propertyStatusListWithData[index].name, propertyStatusListWithData[index].slug);
                      }
                    },
                  ),
                ),
                // ToggleSwitch(
                //   cornerRadius: 24,
                //   minWidth: 100,//80
                //   minHeight: 45,
                //   radiusStyle: true,
                //   fontSize: AppThemePreferences.toggleSwitchTextFontSize,
                //   inactiveBgColor: AppThemePreferences().appTheme.switchUnselectedBackgroundColor,
                //   inactiveFgColor: AppThemePreferences().appTheme.switchUnselectedItemTextColor,
                //   activeFgColor: AppThemePreferences().appTheme.switchSelectedItemTextColor,
                //   activeBgColor: [
                //     AppThemePreferences().appTheme.switchSelectedBackgroundColor,
                //   ],
                //   totalSwitches: _searchTypeList.length,
                //   labels: _searchTypeList,
                //   initialLabelIndex: filterDataMap != null && filterDataMap.containsKey(PROPERTY_STATUS)
                //       && filterDataMap[PROPERTY_STATUS] != null && filterDataMap[PROPERTY_STATUS].isNotEmpty ?
                //   _searchTypeList.indexOf(filterDataMap[PROPERTY_STATUS]) : 0,
                //   onToggle: (index) {
                //     filterDataMap[PROPERTY_STATUS] = _searchTypeList[index];
                //     HiveStorageManager.storeFilterDataInfo(map: filterDataMap);
                //     homeScreenSearchTypeWidgetListener(
                //       filterDataMap: filterDataMap,
                //     );
                //   },
                // ),
              ],
            ),
          );
        });
  }
}