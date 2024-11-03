import 'package:flutter/material.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_01.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_02.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_07.dart';

class ArticleBox08 extends StatelessWidget {
  final bool isInMenu;
  final void Function() onTap;
  final Map<String, dynamic> infoDataMap;

  const ArticleBox08({
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
              ArticleBox02ImageWidget(height: 165.0, infoDataMap: infoDataMap, isInMenu: isInMenu),
              ArticleBox02FeaturedTagWidget(infoDataMap: infoDataMap),
              ArticleBox02StatusTagWidget(infoDataMap: infoDataMap),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ArticleBox01TitleWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(20, 10, 20, 0)),
                    ArticleBox08DetailsWidget(infoDataMap: infoDataMap),
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

class ArticleBox08DetailsWidget extends StatelessWidget {
  final Map<String, dynamic> infoDataMap;

  const ArticleBox08DetailsWidget({
    super.key,
    required this.infoDataMap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ArticleBox01FeaturesWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
          ArticleBox07PriceWidget(infoDataMap: infoDataMap),
        ],
      ),
    );
  }
}