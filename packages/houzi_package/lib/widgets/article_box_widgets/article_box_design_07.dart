import 'package:flutter/material.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_01.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_02.dart';

class ArticleBox07 extends StatelessWidget {
  final bool isInMenu;
  final void Function() onTap;
  final Map<String, dynamic> infoDataMap;

  const ArticleBox07({
    super.key,
    this.isInMenu = false,
    required this.onTap,
    required this.infoDataMap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 7.0),
      child: CardWidget(
        color: AppThemePreferences().appTheme.articleDesignItemBackgroundColor,
        shape: AppThemePreferences.roundedCorners(AppThemePreferences.articleDesignRoundedCornersRadius),
        elevation: AppThemePreferences.articleDeignsElevation,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: onTap,
          child: Stack(
            children: [
              ArticleBox02ImageWidget(height: getImageHeight(infoDataMap), infoDataMap: infoDataMap, isInMenu: isInMenu),
              ArticleBox02FeaturedTagWidget(infoDataMap: infoDataMap),
              ArticleBox02StatusTagWidget(infoDataMap: infoDataMap),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ArticleBox01TitleWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(20, 8, 20, 0)),
                    ArticleBox07PriceWidget(infoDataMap: infoDataMap),
                    ArticleBox07TypeWidget(infoDataMap: infoDataMap),
                    ArticleBox01FeaturesWidget(
                      infoDataMap: infoDataMap,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                      mainAxisAlignment: MainAxisAlignment.center,
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

  double getImageHeight(Map<String, dynamic> map) {
    String type = infoDataMap[AB_PROPERTY_TYPE] ?? "";
    String firstPrice = infoDataMap[AB_PROPERTY_FIRST_PRICE] ?? "";
    String propertyPrice = infoDataMap[AB_PROPERTY_PRICE] ?? "";
    String price = "";
    if (firstPrice.isNotEmpty) {
      price = firstPrice;
    } else if (propertyPrice.isNotEmpty) {
      price = propertyPrice;
    }

    if (type.isEmpty && price.isEmpty) {
      return 220;
    } else if (type.isEmpty || price.isEmpty) {
      return 195;
    }

    return 170.0;
  }
}

class ArticleBox07PriceWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;

  const ArticleBox07PriceWidget({
    super.key,
    required this.infoDataMap,
  });

  @override
  Widget build(BuildContext context) {
    String _firstPrice = infoDataMap[AB_PROPERTY_FIRST_PRICE] ?? "";
    String _propertyPrice = infoDataMap[AB_PROPERTY_PRICE] ?? "";
    String price = "";

    if (_firstPrice.isNotEmpty) {
      price = _firstPrice;
    } else if (_propertyPrice.isNotEmpty) {
      price = _propertyPrice;
    }

    return price.isEmpty ? Container() : Container(
      padding: const EdgeInsets.only(top: 8),
      child: GenericTextWidget(
        price,
        style: AppThemePreferences().appTheme.articleBoxPropertyPriceTextStyle,
      ),
    );
  }
}

class ArticleBox07TypeWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;

  const ArticleBox07TypeWidget({
    super.key,
    required this.infoDataMap,
  });

  @override
  Widget build(BuildContext context) {
    String _propertyType = infoDataMap[AB_PROPERTY_TYPE] ?? "";

    return _propertyType.isEmpty? Container() : Container(
      padding: const EdgeInsets.only(top: 8),
      child: GenericTextWidget(
        _propertyType,
        style: AppThemePreferences().appTheme.articleBoxPropertyStatusTextStyle,
      ),
    );
  }
}