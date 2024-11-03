import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_01.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_02.dart';

class ArticleBox03 extends StatelessWidget {
  final bool isInMenu;
  final void Function() onTap;
  final Map<String, dynamic> infoDataMap;

  const ArticleBox03({
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
        child: Stack(
          children: [
            ArticleBox03ImageWidget(infoDataMap: infoDataMap, isInMenu: isInMenu, onTap: onTap),
            ArticleBox02FeaturedTagWidget(infoDataMap: infoDataMap),
            ArticleBox02StatusTagWidget(infoDataMap: infoDataMap),
            Positioned(
              bottom: 0.0, left: 0.0, right: 0.0,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(10),),
                onTap: onTap,
                child: Container(
                  decoration: containerDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ArticleBox01TitleWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(20, 10, 20, 0)),
                      ArticleBox01AddressWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(20, 8, 20, 0)),
                      ArticleBox01FeaturesWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(20, 8, 20, 0)),
                      ArticleBox01DetailsWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(20, 5, 20, 5)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Decoration containerDecoration() {
    return BoxDecoration(
      // color: AppThemePreferences().appTheme.CardWidgetColor!.withOpacity(0.8),
      color: AppThemePreferences().appTheme.articleDesignItemBackgroundColor!.withOpacity(0.8),
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
    );
  }
}

class ArticleBox03ImageWidget extends StatelessWidget {
  final double? height;
  final bool isInMenu;
  final void Function() onTap;
  final Map<String, dynamic> infoDataMap;

  const ArticleBox03ImageWidget({
    super.key,
    this.height,
    this.isInMenu = false,
    required this.onTap,
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
      width: MediaQuery.of(context).size.width,
      child: Hero(
        tag: _heroId,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: isInMenu ? Image.asset(
            _imagePath,
            fit: BoxFit.cover,
          ) : Stack(
            fit: StackFit.expand,
            children: [
              !_validURL ? ShimmerEffectErrorWidget(iconSize: 100) : FancyShimmerImage(
                imageUrl: _imageUrl,
                boxFit: BoxFit.cover,
                shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
                shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
                errorWidget: ShimmerEffectErrorWidget(iconSize: 100),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    onTap: onTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}