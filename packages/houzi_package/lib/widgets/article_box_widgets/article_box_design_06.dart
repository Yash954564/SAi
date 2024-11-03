import 'package:flutter/material.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_01.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_02.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_03.dart';

class ArticleBox06 extends StatelessWidget {
  final bool isInMenu;
  final void Function() onTap;
  final Map<String, dynamic> infoDataMap;

  const ArticleBox06({
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
        shape: AppThemePreferences.roundedCorners(
            AppThemePreferences.articleDesignRoundedCornersRadius),
        elevation: AppThemePreferences.articleDeignsElevation,
        child: Stack(
          children: [
            ArticleBox03ImageWidget(
                height: 295.0,
                infoDataMap: infoDataMap,
                isInMenu: isInMenu,
                onTap: onTap),
            ArticleBox02FeaturedTagWidget(infoDataMap: infoDataMap),
            ArticleBox02StatusTagWidget(infoDataMap: infoDataMap),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: containerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ArticleBox01TitleWidget(
                        infoDataMap: infoDataMap,
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0)),
                    ArticleBox01FeaturesWidget(
                        infoDataMap: infoDataMap,
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0)),
                    ArticleBox01DetailsWidget(
                        infoDataMap: infoDataMap,
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 5)),
                  ],
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
      color: AppThemePreferences()
          .appTheme
          .articleDesignItemBackgroundColor!
          .withOpacity(0.8),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
    );
  }
}
