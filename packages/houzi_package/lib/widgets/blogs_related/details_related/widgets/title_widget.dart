import 'package:flutter/material.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class BlogDetailsLayoutTitleWidget extends StatelessWidget {
  final BlogArticle article;

  const BlogDetailsLayoutTitleWidget({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    String title = article.postTitle ?? "";

    if (title.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: GenericTextWidget(
          UtilityMethods.stripHtmlIfNeeded(title),
          strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
          style: AppThemePreferences().appTheme.propertyDetailsPagePropertyTitleTextStyle,
        ),
      );
    }
    return Container();
  }
}