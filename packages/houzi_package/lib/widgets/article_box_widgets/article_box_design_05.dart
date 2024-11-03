import 'package:flutter/material.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_01.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_02.dart';

class ArticleBox05 extends StatelessWidget {
  final bool isInMenu;
  final void Function() onTap;
  final Map<String, dynamic> infoDataMap;

  const ArticleBox05({
    super.key,
    this.isInMenu = false,
    required this.onTap,
    required this.infoDataMap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 7),
      child: CardWidget(
        color: AppThemePreferences().appTheme.articleDesignItemBackgroundColor,
        shape: AppThemePreferences.roundedCorners(AppThemePreferences.articleDesignRoundedCornersRadius),
        elevation: AppThemePreferences.articleDeignsElevation,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: onTap,
          child: Stack(
            children: [
              ArticleBox02ImageWidget(height: 170.0, infoDataMap: infoDataMap, isInMenu: isInMenu),
              ArticleBox02FeaturedTagWidget(infoDataMap: infoDataMap),
              ArticleBox02StatusTagWidget(infoDataMap: infoDataMap),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArticleDesign05DetailsWidget(infoDataMap: infoDataMap),
                    Container(
                      decoration: containerDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ArticleBox01TitleWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(20, 8, 20, 0)),
                          ArticleBox01AddressWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(20, 8, 20, 5)),
                          ArticleDesign05FeaturesWidget(infoDataMap: infoDataMap),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Decoration containerDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
    );
  }
}

class ArticleDesign05DetailsWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;
  final EdgeInsetsGeometry? padding;

  const ArticleDesign05DetailsWidget({
    super.key,
    required this.infoDataMap,
    this.padding = const EdgeInsets.fromLTRB(15, 0, 15, 10),
  });

  @override
  Widget build(BuildContext context) {
    String _propertyType = infoDataMap[AB_PROPERTY_TYPE] ?? "";
    String _firstPrice = infoDataMap[AB_PROPERTY_FIRST_PRICE] ?? "";
    String _propertyPrice = infoDataMap[AB_PROPERTY_PRICE] ?? "";
    String price = "";

    if (_firstPrice.isNotEmpty) {
      price = _firstPrice;
    } else if (_propertyPrice.isNotEmpty) {
      price = _propertyPrice;
    }

    if (_propertyType.isNotEmpty || price.isNotEmpty) {
      return Container(
        padding: padding,
        child: Container(
          constraints: BoxConstraints(
            minHeight: 33,
            maxHeight: (_propertyType.isNotEmpty && price.isNotEmpty) ? 53 : 33,
          ),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppThemePreferences().appTheme.cardColor!.withOpacity(0.9),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (price.isNotEmpty) GenericTextWidget(
                price,
                style: AppThemePreferences().appTheme.body01TextStyle,
              ),
              if (price.isNotEmpty && _propertyType.isNotEmpty)
                const SizedBox(height: 3),
              if (_propertyType.isNotEmpty) Flexible(
                child: GenericTextWidget(
                  _propertyType,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppThemePreferences().appTheme.articleBoxPropertyStatusTextStyle,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container();
  }
}

class ArticleDesign05FeaturesWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;
  final EdgeInsetsGeometry? padding;

  const ArticleDesign05FeaturesWidget({
    super.key,
    required this.infoDataMap,
    this.padding = const EdgeInsets.fromLTRB(10, 5, 10, 8),
  });

  @override
  Widget build(BuildContext context) {
    String _bedRooms = infoDataMap[AB_BED_ROOMS] ?? "";
    String _bathRooms = infoDataMap[AB_BATH_ROOMS] ?? "";
    String _area = infoDataMap[AB_AREA] ?? "";
    String _areaPostFix = infoDataMap[AB_AREA_POST_FIX] ?? "";
    const double paddings = 10.0;

    return Container(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showFeature(_bedRooms))
            ArticleBox05FeaturesSubWidget(
              title: "bedrooms",
              value: _bedRooms,
              icon: AppThemePreferences().appTheme.articleBoxBedIcon!,
            ),
          if (showFeature(_bathRooms))
            ArticleBox05FeaturesSubWidget(
              title: "bathrooms",
              value: _bathRooms,
              icon: AppThemePreferences().appTheme.articleBoxBathtubIcon!,
              showDivider: showBathRoomsDivider(_bedRooms, _bathRooms),
            ),
          if (showFeature(_area))
            ArticleBox05FeaturesSubWidget(
              value: _area,
              title: _areaPostFix,
              icon: AppThemePreferences().appTheme.articleBoxAreaSizeIcon!,
              showDivider: showAreaDivider(_bedRooms, _bathRooms, _area),
            ),
        ],
      ),
    );
  }

  bool showFeature(String feature) {
    if (feature.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool showBathRoomsDivider(String beds, String baths) {
    if (showFeature(beds) && showFeature(baths)) {
      return true;
    }
    return false;
  }

  bool showAreaDivider(String beds, String baths, String area) {
    if (showFeature(area) && (showFeature(baths) || showFeature(beds))) {
      return true;
    }
    return false;
  }
}

class ArticleBox05FeaturesSubWidget extends StatelessWidget {
  final String title;
  final String value;
  final Icon icon;
  final bool showDivider;

  const ArticleBox05FeaturesSubWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: showDivider
            ? AppThemePreferences.dividerDecoration(
                left: UtilityMethods.isRTL(context) ? false : true,
                right: UtilityMethods.isRTL(context) ? true : false,
              )
            : null,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon,
                Container(
                  padding: EdgeInsets.only(
                    left: UtilityMethods.isRTL(context) ? 0 : 8,
                    right: UtilityMethods.isRTL(context) ? 8 : 0,
                  ),
                  child: GenericTextWidget(
                    value,
                    style: AppThemePreferences().appTheme.subBodyTextStyle,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: GenericTextWidget(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppThemePreferences().appTheme.subBodyTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}