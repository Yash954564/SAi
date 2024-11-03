import 'package:flutter/material.dart';

import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_02.dart';

class ArticleBox09 extends StatelessWidget {
  final bool isInMenu;
  final void Function() onTap;
  final Map<String, dynamic> infoDataMap;

  const ArticleBox09({
    super.key,
    this.isInMenu = false,
    required this.onTap,
    required this.infoDataMap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: CardWidget(
        color: AppThemePreferences().appTheme.articleDesignItemBackgroundColor,
        shape: AppThemePreferences.roundedCorners(AppThemePreferences.articleDesignRoundedCornersRadius),
        elevation: AppThemePreferences.articleDeignsElevation,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: onTap,
          child: Stack(
            children: [
              ArticleBox02ImageWidget(height: 155, width: double.infinity, infoDataMap: infoDataMap, isInMenu: isInMenu),
              // ArticleBox02FeaturedTagWidget(infoDataMap: infoDataMap),
              // ArticleBox02StatusTagWidget(infoDataMap: infoDataMap),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ArticleBox09TitleWidget(infoDataMap: infoDataMap),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ArticleBox09PriceWidget(infoDataMap: infoDataMap),
                          ArticleBox09FeaturesWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
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
}

class ArticleBox09TitleWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;
  final EdgeInsetsGeometry? padding;

  const ArticleBox09TitleWidget({
    super.key,
    required this.infoDataMap,
    this.padding = const EdgeInsets.fromLTRB(10, 10, 10, 0),
  });

  @override
  Widget build(BuildContext context) {
    String _title = infoDataMap[AB_TITLE];
    return Container(
      padding: padding,
      child: GenericTextWidget(
        _title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        strutStyle: const StrutStyle(
            forceStrutHeight: true
        ),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ArticleBox09PriceWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;

  const ArticleBox09PriceWidget({
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

    if (price.isNotEmpty) {
      return GenericTextWidget(
        price,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
      );
    }

    return Container();
  }
}

class ArticleBox09FeaturesWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;
  final EdgeInsetsGeometry? padding;

  const ArticleBox09FeaturesWidget({
    super.key,
    required this.infoDataMap,
    this.padding = const EdgeInsets.fromLTRB(5, 5, 5, 0),
  });

  @override
  Widget build(BuildContext context) {
    String _bedRooms = infoDataMap[AB_BED_ROOMS] ?? "";
    String _bathRooms = infoDataMap[AB_BATH_ROOMS] ?? "";

    return Container(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showFeature(_bedRooms))
            ArticleBox09FeaturesSubWidget(
              icon: AppThemePreferences().appTheme.articleBoxBedIcon!,
              title: _bedRooms,
            ),
          if (showBedRoomsPadding(_bedRooms, _bathRooms))
            const SizedBox(width: 10),
          if (showFeature(_bathRooms))
            ArticleBox09FeaturesSubWidget(
              icon: AppThemePreferences().appTheme.articleBoxBathtubIcon!,
              title: _bathRooms,
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

  bool showBedRoomsPadding(String beds, String baths) {
    if (showFeature(beds) && showFeature(baths)) {
      return true;
    }
    return false;
  }
}

class ArticleBox09FeaturesSubWidget extends StatelessWidget {
  final String title;
  final Icon icon;

  const ArticleBox09FeaturesSubWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        icon,
        const SizedBox(width: 4),
        GenericTextWidget(
          title,
          strutStyle: const StrutStyle(forceStrutHeight: true),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}