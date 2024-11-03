import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/article_box_widgets/tags_widgets/featured_tag_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/tags_widgets/tag_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_01.dart';

class ArticleBox02 extends StatelessWidget {
  final bool isInMenu;
  final void Function() onTap;
  final Map<String, dynamic> infoDataMap;

  const ArticleBox02({
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
              Column(
                children: [
                  ArticleBox02ImageWidget(infoDataMap: infoDataMap, isInMenu: isInMenu),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ArticleBox01TitleWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(20, 8, 20, 0)),
                      ArticleBox01AddressWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(20, 8, 20, 0)),
                      ArticleBox01FeaturesWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(20, 8, 20, 0)),
                      ArticleBox01DetailsWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(20, 8, 20, 5)),
                    ],
                  ),
                ],
              ),
              ArticleBox02FeaturedTagWidget(infoDataMap: infoDataMap),
              ArticleBox02StatusTagWidget(infoDataMap: infoDataMap),
            ],
          ),
        ),
      ),
    );
  }
}

class ArticleBox02ImageWidget extends StatelessWidget {
  final bool isInMenu;
  final double height;
  final double width;
  final Map<String, dynamic> infoDataMap;

  const ArticleBox02ImageWidget({
    super.key,
    this.isInMenu = false,
    this.height = 160.0,
    this.width = double.infinity,
    required this.infoDataMap,
  });

  @override
  Widget build(BuildContext context) {
    String _heroId = infoDataMap[AB_HERO_ID];
    String _imageUrl = infoDataMap[AB_IMAGE_URL];
    String _imagePath = infoDataMap[AB_IMAGE_PATH];
    bool _validURL = UtilityMethods.validateURL(_imageUrl);

    return SizedBox(
      height: height,
      width: width,
      child: Hero(
        tag: _heroId,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: isInMenu
              ? Image.asset(
                  _imagePath,
                  fit: BoxFit.cover,
                )
              : !_validURL
                  ? ShimmerEffectErrorWidget(iconSize: 100)
                  : FancyShimmerImage(
                      imageUrl: _imageUrl,
                      boxFit: BoxFit.cover,
                      shimmerBaseColor:
                          AppThemePreferences().appTheme.shimmerEffectBaseColor,
                      shimmerHighlightColor: AppThemePreferences()
                          .appTheme
                          .shimmerEffectHighLightColor,
                      errorWidget: ShimmerEffectErrorWidget(iconSize: 100),
                    ),
        ),
      ),
    );
  }
}

class ArticleBox02FeaturedTagWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;

  const ArticleBox02FeaturedTagWidget({
    super.key,
    required this.infoDataMap,
  });

  @override
  Widget build(BuildContext context) {
    bool isFeatured = infoDataMap[AB_IS_FEATURED];
    return Positioned(
      top: 10,
      left: 15,
      child: isFeatured
          ? Container(
              alignment: Alignment.topLeft,
              child: FeaturedTagWidget(),
            )
          : Container(),
    );
  }
}

class ArticleBox02StatusTagWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;

  const ArticleBox02StatusTagWidget({
    super.key,
    required this.infoDataMap,
  });

  @override
  Widget build(BuildContext context) {
    String _propertyStatus = infoDataMap[AB_PROPERTY_STATUS] ?? "";
    return Positioned(
      top: 10,
      right: 15,
      child: _propertyStatus.isEmpty
          ? Container()
          : Container(
              alignment: Alignment.topRight,
              child: TagWidget(
                  label: UtilityMethods.getLocalizedString(_propertyStatus)
                      .toUpperCase()),
            ),
    );
  }
}