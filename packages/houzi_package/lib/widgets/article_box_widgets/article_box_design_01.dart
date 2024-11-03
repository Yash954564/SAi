import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/article_box_widgets/tags_widgets/featured_tag_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/tags_widgets/tag_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class ArticleBox01 extends StatelessWidget {
  final bool isInMenu;
  final void Function() onTap;
  final Map<String, dynamic> infoDataMap;

  const ArticleBox01({
    super.key,
    this.isInMenu = false,
    required this.onTap,
    required this.infoDataMap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
          height: 155,//185,
          child: CardWidget(
            color: AppThemePreferences().appTheme.articleDesignItemBackgroundColor,
            shape: AppThemePreferences.roundedCorners(AppThemePreferences.articleDesignRoundedCornersRadius),
            elevation: AppThemePreferences.articleDeignsElevation,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              onTap: onTap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArticleBox01ImageWidget(
                    infoDataMap: infoDataMap,
                    isInMenu: isInMenu,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ArticleBox01TitleWidget(
                          infoDataMap: infoDataMap,
                          padding: const EdgeInsets.fromLTRB(10,0,10,0),
                        ),
                        ArticleBox01TagsWidget(infoDataMap: infoDataMap),
                        ArticleBox01AddressWidget(infoDataMap: infoDataMap),
                        ArticleBox01FeaturesWidget(infoDataMap: infoDataMap),
                        ArticleBox01DetailsWidget(infoDataMap: infoDataMap),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ArticleBox01ImageWidget extends StatelessWidget {
  final bool isInMenu;
  final Map<String, dynamic> infoDataMap;

  const ArticleBox01ImageWidget({
    super.key,
    this.isInMenu = false,
    required this.infoDataMap,
  });

  @override
  Widget build(BuildContext context) {
    String _heroId = infoDataMap[AB_HERO_ID];
    String _imageUrl = infoDataMap[AB_IMAGE_URL];
    String _imagePath = infoDataMap[AB_IMAGE_PATH];
    bool _validURL = UtilityMethods.validateURL(_imageUrl);

    return Container(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 150,
        width: 120,
        child: Hero(
          tag: _heroId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: isInMenu
                ? Image.asset(
                    _imagePath,
                    fit: BoxFit.cover,
                  )
                : !_validURL
                    ? ArticleBox01ImageErrorWidget()
                    : FancyShimmerImage(
                        imageUrl: _imageUrl,
                        boxFit: BoxFit.cover,
                        shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
                        shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
                        errorWidget: ArticleBox01ImageErrorWidget(),
                      ),
          ),
        ),
      ),
    );
  }
}

class ArticleBox01TitleWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;
  final EdgeInsetsGeometry? padding;

  const ArticleBox01TitleWidget({
    super.key,
    required this.infoDataMap,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0),
  });

  @override
  Widget build(BuildContext context) {

    String _title = infoDataMap[AB_TITLE];
    return Container(
      padding: padding,
      child: GenericTextWidget(
        _title,
        maxLines: 1,
        overflow: TextOverflow.clip,
        strutStyle: const StrutStyle(
            forceStrutHeight: true,
            height: 1.7
        ),
        style: AppThemePreferences().appTheme.titleTextStyle,
      ),
    );
  }
}

class ArticleBox01TagsWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;

  const ArticleBox01TagsWidget({
    super.key,
    required this.infoDataMap,
  });

  @override
  Widget build(BuildContext context) {
    List tagsList = [];
    EdgeInsetsGeometry padding = EdgeInsets.only(
      right: UtilityMethods.isRTL(context) ? 0 : 5,
      left: UtilityMethods.isRTL(context) ? 5 : 0,
    );

    if (infoDataMap[AB_IS_FEATURED]) {
      tagsList.add(infoDataMap[AB_IS_FEATURED]);
    }
    if (infoDataMap[AB_PROPERTY_STATUS].isNotEmpty) {
      tagsList.add(infoDataMap[AB_PROPERTY_STATUS]);
    }
    if (infoDataMap[AB_PROPERTY_LABEL].isNotEmpty) {
      tagsList.add(infoDataMap[AB_PROPERTY_LABEL]);
    }

    if (tagsList.length == 3) {
      tagsList.removeLast();
    }

    if (tagsList.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: tagsList.map(
                (item) {
              if (item is bool) {
                return Container(
                  padding: padding,
                  alignment: Alignment.topLeft,
                  child: FeaturedTagWidget(),
                );
              }

              return Container(
                padding: padding,
                child: TagWidget(label: item),
              );
            },
          ).toList(),
        ),
      );
    }

    return Container();
  }
}

class ArticleBox01AddressWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;
  final EdgeInsetsGeometry? padding;

  const ArticleBox01AddressWidget({
    super.key,
    required this.infoDataMap,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0),
  });

  @override
  Widget build(BuildContext context) {
    String _address = infoDataMap[AB_ADDRESS] ?? "";
    if (_address.isNotEmpty) {
      return Container(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            AppThemePreferences().appTheme.articleBoxLocationIcon!,
            Expanded(
              child: Container(
                alignment: UtilityMethods.isRTL(context)
                    ? Alignment.centerRight : Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: UtilityMethods.isRTL(context) ? 0 : 5,
                  right: UtilityMethods.isRTL(context) ? 5 : 0,
                ),
                child: GenericTextWidget(
                  _address,
                  textDirection: TextDirection.ltr,
                  maxLines: 1,
                  strutStyle: const StrutStyle(forceStrutHeight: true),
                  overflow: TextOverflow.clip,
                  style: AppThemePreferences().appTheme.subBodyTextStyle,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }
}

class ArticleBox01FeaturesWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;

  const ArticleBox01FeaturesWidget({
    super.key,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    required this.infoDataMap,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0),
  });

  @override
  Widget build(BuildContext context) {
    String _bedRooms = infoDataMap[AB_BED_ROOMS] ?? "";
    String _bathRooms = infoDataMap[AB_BATH_ROOMS] ?? "";
    String _area = infoDataMap[AB_AREA] ?? "";
    String _areaPostFix = infoDataMap[AB_AREA_POST_FIX] ?? "";

    if (_area.isNotEmpty && _areaPostFix.isNotEmpty) {
      _area = "$_area $_areaPostFix";
    }

    return Container(
      padding: padding,
      child: Row(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        children: [
          if (showFeature(_bedRooms))
            ArticleBox01FeaturesSubWidget(
              title: _bedRooms,
              icon: AppThemePreferences().appTheme.articleBoxBedIcon!,
            ),
          if (showBedRoomsPadding(_bedRooms, _bathRooms, _area))
            const SizedBox(width: 15),

          if (showFeature(_bathRooms))
            ArticleBox01FeaturesSubWidget(
              title: _bathRooms,
              icon: AppThemePreferences().appTheme.articleBoxBathtubIcon!,
            ),
          if (showBathRoomsPadding(_bathRooms, _area))
            const SizedBox(width: 15),

          if (showFeature(_area))
            ArticleBox01FeaturesSubWidget(
              title: _area,
              icon: AppThemePreferences().appTheme.articleBoxAreaSizeIcon!,
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

  bool showBedRoomsPadding(String beds, String baths, String area) {
    if (showFeature(beds) && (showFeature(baths) || showFeature(area))) {
      return true;
    }
    return false;
  }

  bool showBathRoomsPadding(String baths, String area) {
    if (showFeature(baths) && showFeature(area)) {
      return true;
    }
    return false;
  }
}

class ArticleBox01FeaturesSubWidget extends StatelessWidget {
  final String title;
  final Icon icon;

  const ArticleBox01FeaturesSubWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        icon,
        const SizedBox(width: 6),
        GenericTextWidget(
          title,
          strutStyle: const StrutStyle(forceStrutHeight: true),
          style: AppThemePreferences().appTheme.subBodyTextStyle,
        ),
      ],
    );
  }
}

class ArticleBox01DetailsWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;
  final EdgeInsetsGeometry? padding;

  const ArticleBox01DetailsWidget({
    super.key,
    required this.infoDataMap,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0),
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

    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.only(
                left: UtilityMethods.isRTL(context) ? 5 : 0,
                right: UtilityMethods.isRTL(context) ? 0 : 5,
              ),
              child: GenericTextWidget(
                _propertyType,
                strutStyle: const StrutStyle(forceStrutHeight: true),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppThemePreferences().appTheme.articleBoxPropertyStatusTextStyle,
              ),
            ),
          ),
          GenericTextWidget(
            price,
            style: AppThemePreferences().appTheme.articleBoxPropertyPriceTextStyle,
          ),
        ],
      ),
    );
  }
}

class ArticleBox01ImageErrorWidget extends StatelessWidget {
  const ArticleBox01ImageErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppThemePreferences()
          .appTheme.shimmerEffectErrorWidgetBackgroundColor,
      child: Center(
          child: AppThemePreferences().appTheme.shimmerEffectImageErrorIcon),
    );
  }
}