import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/filter_page_config.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/sequential_location_picker_widget.dart';

typedef FilterSequentialLocationPickerWidgetListener = void Function(Map<String, dynamic> map);
class FilterSequentialLocationPickerWidget extends StatefulWidget {
  final FilterPageElement item;
  final FilterSequentialLocationPickerWidgetListener listener;

  const FilterSequentialLocationPickerWidget({
    super.key,
    required this.item,
    required this.listener,
  });

  @override
  State<FilterSequentialLocationPickerWidget> createState() => _FilterSequentialLocationPickerWidgetState();
}

class _FilterSequentialLocationPickerWidgetState extends State<FilterSequentialLocationPickerWidget> {

  String _selectedLocation = "please_select";
  String _title = "location";
  VoidCallback? _generalNotifierLister;

  @override
  void initState() {
    if (widget.item.locationPickerHierarchyList != null) {
      filterLocationPickerHierarchyList = widget.item.locationPickerHierarchyList!;
    }
    loadData();

    _generalNotifierLister = () {
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

    GeneralNotifier().addListener(_generalNotifierLister!);
    super.initState();
  }

  @override
  void dispose() {
    _generalNotifierLister = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _title = widget.item.title ?? "location";
    return InkWell(
      onTap: ()=> onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: AppThemePreferences().appTheme.dividerColor!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child:
              AppThemePreferences().appTheme.filterPageLocationIcon!,
            ),
            Expanded(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.only(bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GenericTextWidget(
                            UtilityMethods.getLocalizedString(_title),
                            style: AppThemePreferences().appTheme.filterPageHeadingTitleTextStyle,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: GenericTextWidget(
                                    UtilityMethods.getLocalizedString(_selectedLocation),
                                    overflow: TextOverflow.ellipsis,
                                    style: AppThemePreferences().appTheme
                                        .filterPageTempTextPlaceHolderTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AppThemePreferences()
                          .appTheme
                          .filterPageArrowForwardIcon!,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SequentialLocationPickerWidget(
            locationHierarchyList: filterLocationPickerHierarchyList,
            listener: (map) {
              if (mounted) {
                setState(() {
                  _selectedLocation = UtilityMethods.getHomeLocationString(map);
                });
              }
              Map<String, dynamic> filterMap = HiveStorageManager.readFilterDataInfo();
              filterMap.addAll(map);
              HiveStorageManager.storeFilterDataInfo(map: filterMap);
              widget.listener(filterMap);
            },
          );
        },
      ),
    );
  }

  void loadData() {
    Map map = HiveStorageManager.readFilterDataInfo() ?? {};

    Map<String, dynamic> cityMap = HiveStorageManager.readSelectedCityInfo();

    if (map.isNotEmpty) {
      // print("Loading Data from the Filter Map.....");
      _selectedLocation = UtilityMethods.getHomeLocationString(
        map,
        allowCountry: allowCountry(),
        allowState: allowState(),
        allowCity: allowCity(),
        allowArea: allowArea(),
      );
    } else if (cityMap.isNotEmpty){
      // print("Loading Data from the Selected City Map.....");
      String city = UtilityMethods.valueForKeyOrEmpty(cityMap, CITY);
      _selectedLocation = city.isNotEmpty ? city : "please_select";
    } else {
      // print("Filter Data Map and Selected City Map are Empty.....");
      _selectedLocation = "please_select";
    }
  }

  bool allowCountry() {
    if (filterLocationPickerHierarchyList.contains(propertyCountryDataType)) {
      return true;
    }
    return false;
  }

  bool allowState() {
    if (filterLocationPickerHierarchyList.contains(propertyStateDataType)) {
      return true;
    }
    return false;
  }

  bool allowCity() {
    if (filterLocationPickerHierarchyList.contains(propertyCityDataType)) {
      return true;
    }
    return false;
  }

  bool allowArea() {
    if (filterLocationPickerHierarchyList.contains(propertyAreaDataType)) {
      return true;
    }
    return false;
  }
}
