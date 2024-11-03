import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/theme_service_files/theme_notifier.dart';
import 'package:houzi_package/models/terms_with_icon.dart';
import 'package:houzi_package/pages/search_result.dart';
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class DynamicTermsWithIconWidget extends StatefulWidget {
  final List<TermsWithIcon> dataList;

  const DynamicTermsWithIconWidget({
    super.key,
    required this.dataList,
  });

  @override
  State<DynamicTermsWithIconWidget> createState() => _DynamicTermsWithIconWidgetState();
}

class _DynamicTermsWithIconWidgetState extends State<DynamicTermsWithIconWidget> {

  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = UtilityMethods.getTermsWithIconWidgetHeight(width);

    if (widget.dataList.isNotEmpty) {
      return Consumer<ThemeNotifier>(
        builder: (context, theme, child) {
          return Consumer<LocaleProvider>(
            builder: (context, locale, child) {
              bool isRTL = UtilityMethods.isRTL(context);
              return Container(
                height: height,
                margin: const EdgeInsets.only(bottom: 5),
                padding: EdgeInsets.only(
                  left: isRTL ? 0 : 5,
                  right: isRTL ? 5 : 0,
                ),
                child: ListView.builder(
                  itemCount: widget.dataList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    TermsWithIcon item = widget.dataList[index];
                    return DynamicTermsWithIconSubWidget(
                      height: height,
                      label: item.title ?? "",
                      iconData: UtilityMethods.fromJsonToIconData(
                          item.icon ?? DUMMY_ICON_JSON),
                      searchRouteMap: item.searchRouteMap ?? {},
                    );
                  },
                ),
              );
            },
          );
        },
      );
    }

    return Container();
  }
}

class DynamicTermsWithIconSubWidget extends StatelessWidget {
  final IconData iconData;
  final double height;
  final String label;
  final Map<String, dynamic> searchRouteMap;

  const DynamicTermsWithIconSubWidget({
    required this.height,
    required this.iconData,
    required this.label,
    required this.searchRouteMap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        width: height,
        padding: const EdgeInsets.only(left: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CardWidget(
              elevation: AppThemePreferences.zeroElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppThemePreferences
                    .propertyDetailFeaturesRoundedCornersRadius),
              ),
              color: AppThemePreferences().appTheme.containerBackgroundColor,
              child: DynamicTermsWithIconSubIconWidget(
                iconData: iconData,
                height: height,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: GenericTextWidget(
                UtilityMethods.getLocalizedString(label),
                  strutStyle: StrutStyle(
                      height: AppThemePreferences.genericTextHeight,
                      forceStrutHeight: true),
                  style: AppThemePreferences().appTheme.label01TextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTap(BuildContext context) {
    Map<String, dynamic> tempMap = HiveStorageManager.readFilterDataInfo();
    tempMap.remove(PROPERTY_STATUS);
    tempMap.remove(PROPERTY_STATUS_SLUG);
    tempMap.remove(PROPERTY_TYPE);
    tempMap.remove(PROPERTY_TYPE_SLUG);
    tempMap.remove(PROPERTY_LABEL);
    tempMap.remove(PROPERTY_LABEL_SLUG);
    tempMap.remove(PROPERTY_FEATURES);
    tempMap.remove(PROPERTY_FEATURES_SLUG);
    tempMap.remove(PRICE_MIN);
    tempMap.remove(PRICE_MAX);
    tempMap.remove(AREA_MIN);
    tempMap.remove(AREA_MAX);
    tempMap.remove(BEDROOMS);
    tempMap.remove(BATHROOMS);
    tempMap.remove(PROPERTY_KEYWORD);
    tempMap.remove(keywordFiltersKey);
    tempMap.remove(metaKeyFiltersKey);

    tempMap.addAll(searchRouteMap);
    HiveStorageManager.storeFilterDataInfo(map: tempMap);
    GeneralNotifier().publishChange(GeneralNotifier.FILTER_DATA_LOADING_COMPLETE);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResult(
          dataInitializationMap: tempMap,
          searchPageListener: (Map<String, dynamic> map, String closeOption) {
            if (closeOption == CLOSE) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );

  }
}

class DynamicTermsWithIconSubIconWidget extends StatelessWidget {
  final IconData iconData;
  final double height;

  const DynamicTermsWithIconSubIconWidget({
    super.key,
    required this.iconData,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Icon(
        iconData,
        size: AppThemePreferences.propertyDetailsFeaturesIconSize,
      ),
    );
  }
}
