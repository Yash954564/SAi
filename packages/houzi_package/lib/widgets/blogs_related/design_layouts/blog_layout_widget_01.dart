import 'package:flutter/material.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/widgets/blogs_related/design_layouts/blog_layout_widgets.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';

class BlogLayoutWidget01 extends StatelessWidget {
  final String heroId;
  final BlogArticle article;
  final void Function() onTap;

  const BlogLayoutWidget01({
    super.key,
    required this.onTap,
    required this.heroId,
    required this.article,
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
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: onTap,
          child: Stack(
            children: [
              BlogLayoutImageWidget(
                heroId: heroId,
                imageUrl: article.photo ?? "",
                errorIconSize: 100,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlogLayoutCategoryWidget(article: article),

                      BlogLayoutTitleWidget(
                        article: article,
                        padding: const EdgeInsets.only(top: 10),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            BlogLayoutAuthorInfoWidget(article: article),
                            BlogLayoutTimeInfoWidget(article: article),
                          ],
                        ),
                      ),
                    ],
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