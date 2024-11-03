import 'package:flutter/material.dart';
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/theme_service_files/theme_notifier.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:provider/provider.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/search_result.dart';


class TermWithIconsWidget extends StatefulWidget {
  const TermWithIconsWidget({Key? key}) : super(key: key);

  @override
  State<TermWithIconsWidget> createState() => _TermWithIconsWidgetState();
}

class _TermWithIconsWidgetState extends State<TermWithIconsWidget> {

  List<Term> dataList = [];

  final Map<String, dynamic> _iconMap = UtilityMethods.iconMap;

  VoidCallback? generalNotifierListener;
  late double width;
  late double height;

  @override
  void initState() {
    super.initState();

    generalNotifierListener = () {
      if (GeneralNotifier().change == GeneralNotifier.FILTER_DATA_LOADING_COMPLETE) {
        if(mounted){
          setState(() {
            loadData();
          });
        }
      }
    };
    GeneralNotifier().addListener(generalNotifierListener!);

    loadData();
  }

  void loadData() {
    List<Term> propertyStatusDataList = HiveStorageManager.readPropertyStatusMetaData() ?? [];
    List<Term> propertyTypesDataList = HiveStorageManager.readPropertyTypesMetaData() ?? [];

    dataList = [...removeChildTypesStatus(propertyStatusDataList), ...removeChildTypesStatus(propertyTypesDataList)];
  }


  removeChildTypesStatus(List<Term> dataList) {
    dataList.removeWhere((element) => element.parent != 0 || element.totalPropertiesCount! <= 0);
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = UtilityMethods.getTermsWithIconWidgetHeight(width);
    if (UtilityMethods.showTabletView) {
      height = 120;
    }

    return dataList.isEmpty
        ? Container()
        : Consumer<ThemeNotifier>(
            builder: (context, theme, child) {
              return Consumer<LocaleProvider>(
                builder: (context, locale, child) {
                  bool isRTL = UtilityMethods.isRTL(context);
                  loadData();
                  return Container(
                    height: height,
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: EdgeInsets.only(
                      left: isRTL ? 0 : 5,
                      right: isRTL ? 5 : 0,
                    ),
                    child: ListView.builder(
                      itemCount: dataList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        Term propertyMetaData = dataList[index];
                        return TermWithIconsBodyWidget(
                          propertyMetaData: propertyMetaData,
                          boxSize: height,
                          iconMap: _iconMap,
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
  }
}

class TermWithIconsBodyWidget extends StatelessWidget {
  final Term propertyMetaData;
  final double boxSize;
  final Map<String, dynamic> iconMap;

  const TermWithIconsBodyWidget({
    required this.boxSize,
    required this.iconMap,
    required this.propertyMetaData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Map<String, dynamic> map = {
          "${propertyMetaData.taxonomy}_slug" : [propertyMetaData.slug],
          "${propertyMetaData.taxonomy}" : [propertyMetaData.name]
        };
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

        tempMap.addAll(map);
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

      },
      child: Container(
        width: boxSize,
        padding: const EdgeInsets.only(left: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CardWidget(
              elevation: AppThemePreferences.zeroElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppThemePreferences.propertyDetailFeaturesRoundedCornersRadius),
              ),
              color: AppThemePreferences().appTheme.containerBackgroundColor,
              child: _buildIconWidget(propertyMetaData.slug!),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: GenericTextWidget(
                  UtilityMethods.getLocalizedString(propertyMetaData.name!),
                  strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight, forceStrutHeight: true),
                  style: AppThemePreferences().appTheme.label01TextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconWidget(String slug) {
    if (iconMap.containsKey(slug)) {
      final icon = iconMap[slug];
      if (icon is IconData) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Icon(
            icon,
            size: AppThemePreferences.propertyDetailsFeaturesIconSize,
          ),
        );
      } else if (icon is Widget) {
        return SizedBox(
          width: boxSize - 40,
          height: boxSize - 40,
          child: icon,
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Icon(
        AppThemePreferences.homeIcon,
        size: AppThemePreferences.propertyDetailsFeaturesIconSize,
      ),
    );
  }
}

