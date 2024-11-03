import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/city_picker.dart';
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/notifications_widgets/notification-bell-widget.dart';
import 'package:houzi_package/widgets/sequential_location_picker_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:provider/provider.dart';

typedef HomeScreenTopBarWidgetListener = void Function({
Map<String, dynamic>? filterDataMap,
bool? hideNotificationDot,
});

class HomeScreenTopBarWidget extends StatefulWidget {
  final bool userLoggedIn;
  final bool receivedNewNotifications;
  final String selectedCity;
  final HomeScreenTopBarWidgetListener? homeScreenTopBarWidgetListener;

  const HomeScreenTopBarWidget({
    Key? key,
    required this.userLoggedIn,
    required this.receivedNewNotifications,
    required this.selectedCity,
    this.homeScreenTopBarWidgetListener,
  }) : super(key: key);

  @override
  State<HomeScreenTopBarWidget> createState() => _HomeScreenTopBarWidgetState();
}

class _HomeScreenTopBarWidgetState extends State<HomeScreenTopBarWidget> {

  HomeRightBarButtonWidgetHook? rightBarButtonIdWidgetHook = HooksConfigurations.homeRightBarButtonWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: HomeScreenLocationWidget(
              selectedCity: widget.selectedCity,
              homeScreenLocationWidgetListener: ({filterDataMap}) {
                widget.homeScreenTopBarWidgetListener!(filterDataMap: filterDataMap);
              },
            ),
          ),
          rightBarButtonIdWidgetHook!(context) ?? NotificationBellWidget(
            userLoggedIn: widget.userLoggedIn,
            showNotificationDot: widget.receivedNewNotifications,
            listener: (hideNotificationDot) {
              widget.homeScreenTopBarWidgetListener!(hideNotificationDot: hideNotificationDot);
            },
          ),
        ],
      ),
    );
  }
}

typedef HomeScreenLocationWidgetListener = void Function({Map<String, dynamic>? filterDataMap});

class HomeScreenLocationWidget extends StatefulWidget {
  final String selectedCity;
  final HomeScreenLocationWidgetListener? homeScreenLocationWidgetListener;
  const HomeScreenLocationWidget({
    Key? key,
    required this.selectedCity,
    this.homeScreenLocationWidgetListener,
  }) : super(key: key);

  @override
  State<HomeScreenLocationWidget> createState() => _HomeScreenLocationWidgetState();
}

class _HomeScreenLocationWidgetState extends State<HomeScreenLocationWidget> {
  String selectedCity = "";
  List<dynamic> citiesMetaDataList = [];
  VoidCallback? generalNotifierLister;

  @override
  void initState() {
    super.initState();
    citiesMetaDataList = HiveStorageManager.readCitiesMetaData() ?? [];

    loadData();

    generalNotifierLister = () {
      if (GeneralNotifier().change == GeneralNotifier.COUNTRY_DATA_UPDATE ||
          GeneralNotifier().change == GeneralNotifier.STATE_DATA_UPDATE ||
          GeneralNotifier().change == GeneralNotifier.CITY_DATA_UPDATE ||
          GeneralNotifier().change == GeneralNotifier.AREA_DATA_UPDATE) {

        loadData();
        if (mounted) {
          setState(() {});
        }
      }
    };

    GeneralNotifier().addListener(generalNotifierLister!);
  }

  void loadData() {
    if (ENABLE_SEQUENTIAL_LOCATION_PICKER) {
      // print("Sequential Location picker is Enabled.........");
      Map map = HiveStorageManager.readFilterDataInfo() ?? {};
      Map<String, dynamic> cityMap = HiveStorageManager.readSelectedCityInfo();

      if (map.isNotEmpty) {
        // print("Loading Data from the Filter Map.....");
        selectedCity = UtilityMethods.getHomeLocationString(
          map,
          allowCountry: allowCountry(),
          allowState: allowState(),
          allowCity: allowCity(),
          allowArea: allowArea(),
        );
      } else if (cityMap.isNotEmpty){
        String city = UtilityMethods.valueForKeyOrEmpty(cityMap, CITY);
        selectedCity = city.isNotEmpty ? city : "please_select";
      } else {
        // print("Filter Data Map and Selected City Map are Empty.....");
        selectedCity = "please_select";
      }
    } else {
      // print("Sequential Location picker is disabled.........");
      Map<String, dynamic> map = HiveStorageManager.readSelectedCityInfo();
      if (map.isNotEmpty) {
        String city = UtilityMethods.valueForKeyOrEmpty(map, CITY);
        selectedCity = city.isNotEmpty ? city : "please_select";
      } else {
        // print("Selected City Map is Empty.....");
        selectedCity = "please_select";
      }
    }

    // print("Selected City: $selectedCity");
  }


  @override
  void dispose() {
    super.dispose();
    citiesMetaDataList = [];
  }

  @override
  Widget build(BuildContext context) {
    if(citiesMetaDataList.isEmpty){
      citiesMetaDataList = HiveStorageManager.readCitiesMetaData() ?? [];
    }

    return GestureDetector(
      onTap: () {
        if(citiesMetaDataList.isEmpty){
          ShowToastWidget(buildContext: context, text: UtilityMethods.getLocalizedString("data_loading"));
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                if (ENABLE_SEQUENTIAL_LOCATION_PICKER) {
                  return SequentialLocationPickerWidget(
                    locationHierarchyList: homeLocationPickerHierarchyList,
                    listener: (map) {
                      selectedCity = UtilityMethods.getHomeLocationString(map);
                      HiveStorageManager.storeFilterDataInfo(map: map);
                      widget.homeScreenLocationWidgetListener!(
                          filterDataMap: map);
                    },
                  );
                }
                return CityPicker(
                  citiesMetaDataList: citiesMetaDataList,
                  cityPickerListener: (String pickedCity, int? pickedCityId, String pickedCitySlug) {
                    Map<String, dynamic> filterDataMap = HiveStorageManager.readFilterDataInfo() ?? {};
                    filterDataMap[CITY_ID] = [pickedCityId];
                    filterDataMap[CITY] = [pickedCity];
                    filterDataMap[CITY_SLUG] = [pickedCitySlug];
                    HiveStorageManager.storeFilterDataInfo(map: filterDataMap);

                    widget.homeScreenLocationWidgetListener!(filterDataMap: filterDataMap);
                  });
              },
            ),
          );
        }
      },
      child: Consumer<LocaleProvider>(
        builder: (context, value, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 35),
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: AppThemePreferences().appTheme.homeScreenTopBarLocationIcon,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenericTextWidget(
                        UtilityMethods.getLocalizedString("location"),
                        strutStyle: const StrutStyle(forceStrutHeight: true),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: GenericTextWidget(
                                UtilityMethods.getLocalizedString(selectedCity),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                strutStyle: const StrutStyle(forceStrutHeight: true),
                                style: AppThemePreferences().appTheme.locationWidgetTextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Padding(
              //     padding: const EdgeInsets.only(left: 5, top: 20),
              //     child: CircleAvatar(
              //       radius: 7,
              //       backgroundColor: AppThemePreferences().appTheme.homeScreenTopBarRightArrowBackgroundColor,
              //       child: AppThemePreferences().appTheme.homeScreenTopBarRightArrowIcon,
              //     ),
              // ),
            ],
          );
        },
      ),
    );
  }

  bool allowCountry() {
    if (homeLocationPickerHierarchyList.contains(propertyCountryDataType)) {
      return true;
    }
    return false;
  }

  bool allowState() {
    if (homeLocationPickerHierarchyList.contains(propertyStateDataType)) {
      return true;
    }
    return false;
  }

  bool allowCity() {
    if (homeLocationPickerHierarchyList.contains(propertyCityDataType)) {
      return true;
    }
    return false;
  }

  bool allowArea() {
    if (homeLocationPickerHierarchyList.contains(propertyAreaDataType)) {
      return true;
    }
    return false;
  }
}