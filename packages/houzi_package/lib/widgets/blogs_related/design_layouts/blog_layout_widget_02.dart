import 'package:flutter/material.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/widgets/blogs_related/design_layouts/blog_layout_widgets.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';

class BlogLayoutWidget02 extends StatelessWidget {
  final String heroId;
  final BlogArticle article;
  final void Function() onTap;

  const BlogLayoutWidget02({
    super.key,
    required this.onTap,
    required this.heroId,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          height: 155, //185,
          child: CardWidget(
            color: AppThemePreferences().appTheme
                .articleDesignItemBackgroundColor,
            shape: AppThemePreferences.roundedCorners(
                AppThemePreferences.articleDesignRoundedCornersRadius),
            elevation: AppThemePreferences.articleDeignsElevation,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              onTap: onTap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlogLayoutImageWidget(
                    heroId: heroId,
                    imageUrl: article.thumbnail ?? "",
                    width: 120,
                    height: double.infinity,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BlogLayoutCategoryWidget(
                            article: article,
                            padding: const EdgeInsets.only(top: 5),
                          ),

                          BlogLayoutTitleWidget(
                            article: article,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            padding: const EdgeInsets.only(top: 10),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                BlogLayoutAuthorInfoWidget(
                                  article: article,
                                  minAllowedChar: 9,
                                ),

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
        ),
      ],
    );
  }
}