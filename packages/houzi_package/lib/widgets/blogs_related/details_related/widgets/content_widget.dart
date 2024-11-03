import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class BlogDetailsLayoutContentWidget extends StatelessWidget {
  final BlogArticle article;

  const BlogDetailsLayoutContentWidget({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    String content = article.postContent ?? "";
    if (content.isNotEmpty) {
      if (!ENABLE_HTML_IN_BLOG_DESCRIPTION && UtilityMethods.isValidString(content)) {
        content = UtilityMethods.stripHtmlIfNeeded(content);
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Align(
                alignment: UtilityMethods.isRTL(context)
                    ? Alignment.centerRight : Alignment.centerLeft,
                child: ENABLE_HTML_IN_BLOG_DESCRIPTION
                  ? HtmlWidget(content)
                  : GenericTextWidget(
                      content,
                      strutStyle: StrutStyle(
                          height: AppThemePreferences.bodyTextHeight),
                      style: AppThemePreferences().appTheme.bodyTextStyle,
                      textAlign: TextAlign.justify,
                    ),
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
