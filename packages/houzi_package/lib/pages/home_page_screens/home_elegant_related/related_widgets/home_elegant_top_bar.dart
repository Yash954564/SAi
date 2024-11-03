import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/city_picker.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/sequential_location_picker_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:provider/provider.dart';

typedef HomeElegantScreenTopBarWidgetListener = void Function({Map<String, dynamic>? filterDataMap});

class HomeElegantScreenTopBarWidget extends StatefulWidget {
  final Widget? rightBarButtonIdWidget;
  final HomeElegantScreenTopBarWidgetListener? homeElegantScreenTopBarWidgetListener;

  const HomeElegantScreenTopBarWidget({
    Key? key,
    this.rightBarButtonIdWidget,
    this.homeElegantScreenTopBarWidgetListener,
  }) : super(key: key);

  @override
  _HomeElegantScreenTopBarWidgetState createState() => _HomeElegantScreenTopBarWidgetState();
}

class _HomeElegantScreenTopBarWidgetState extends State<HomeElegantScreenTopBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, locale, child) {
        return Container(
          padding: const EdgeInsets.only(top: 5.0, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: HomeElegantScreenLocationWidget(
                  homeElegantScreenTopBarWidgetListener: ({filterDataMap}) {
                    widget.homeElegantScreenTopBarWidgetListener!(filterDataMap: filterDataMap);
                  },
                ),
              ),
              if (widget.rightBarButtonIdWidget != null)
                widget.rightBarButtonIdWidget!,
            ],
          ),
        );
      },
    );
  }
}

class HomeElegantScreenLocationWidget extends StatefulWidget {
  final HomeElegantScreenTopBarWidgetListener? homeElegantScreenTopBarWidgetListener;
  const HomeElegantScreenLocationWidget({
    Key? key,
    this.homeElegantScreenTopBarWidgetListener,
  }) : super(key: key);

  @override
  State<HomeElegantScreenLocationWidget> createState() => _HomeElegantScreenLocationWidgetState();
}

class _HomeElegantScreenLocationWidgetState extends State<HomeElegantScreenLocationWidget> {

  String selectedCity = "please_select";
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
      Map<String, dynamic> map = HiveStorageManager.readFilterDataInfo() ?? {};
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
      Map<String, dynamic>  map = HiveStorageManager.readSelectedCityInfo();
      if (map.isNotEmpty) {
        // print("Loading Data from the Selected City Map.....");
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
          ShowToastWidget(
              buildContext: context,
              text: UtilityMethods.getLocalizedString("data_loading"));
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
                      Map<String, dynamic> filterMap = HiveStorageManager.readFilterDataInfo();
                      filterMap.addAll(map);
                      HiveStorageManager.storeFilterDataInfo(map: filterMap);
                      widget.homeElegantScreenTopBarWidgetListener!(
                          filterDataMap: map);
                    },
                  );
                }
                return CityPicker(
                  citiesMetaDataList: citiesMetaDataList,
                  cityPickerListener: (String pickedCity, int? pickedCityId, String pickedCitySlug) {
                    Map<String, dynamic> filterDataMap = HiveStorageManager.readFilterDataInfo() ?? {};
                    filterDataMap[CITY] = [pickedCity];
                    filterDataMap[CITY_ID] = [pickedCityId];
                    filterDataMap[CITY_SLUG] = [pickedCitySlug];
                    HiveStorageManager.storeFilterDataInfo(map: filterDataMap);

                    widget.homeElegantScreenTopBarWidgetListener!(filterDataMap: filterDataMap);
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GenericTextWidget(
                        UtilityMethods.getLocalizedString("current_location"),
                        strutStyle: const StrutStyle(forceStrutHeight: true),
                        style: AppThemePreferences().appTheme.subTitleTextStyle
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: [
                          AppThemePreferences().appTheme.homeScreenTopBarLocationFilledIcon!,
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 4.0, top: 2),
                              child: GenericTextWidget(
                                UtilityMethods.getLocalizedString(selectedCity),
                                overflow: TextOverflow.ellipsis,
                                strutStyle: const StrutStyle(forceStrutHeight: true),
                                style:  AppThemePreferences().appTheme.titleTextStyle,
                              ),
                            ),
                          ),
                          // AppThemePreferences().appTheme.homeScreenTopBarDownArrowIcon!,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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