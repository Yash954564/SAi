import 'package:flutter/material.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/pages/property_details_page.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class BlogDetailsLayoutTopBarWidget extends StatelessWidget {
  final double opacity;
  final BlogArticle article;

  const BlogDetailsLayoutTopBarWidget({
    super.key,
    required this.opacity,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    String title = article.postTitle ?? "";
    return Positioned(
      top: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: topBarWidgetDecoration(),
        child: SafeArea(
          bottom: false,
          /// Background Container() Widget
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// Back Page Navigation Widget
                Expanded(
                    flex: 1,
                    child: TopBarButtonWidget(
                      iconData: AppThemePreferences.arrowBackIcon,
                      onPressed: () => Navigator.of(context).pop(),
                    )
                ),

                Expanded(
                  flex: 7,
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: UtilityMethods.isRTL(context) ? 20 : 5,
                        right: UtilityMethods.isRTL(context) ? 5 : 20,
                      ),
                      child: GenericTextWidget(
                        UtilityMethods.stripHtmlIfNeeded(title),
                        overflow: TextOverflow.ellipsis,
                        style: AppThemePreferences().appTheme.propertyDetailsPageTopBarTitleTextStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Decoration topBarWidgetDecoration() {
    return BoxDecoration(
      color: AppThemePreferences().appTheme.backgroundColor!.withOpacity(opacity),
      border: Border(
        bottom: BorderSide(
          width: AppThemePreferences.propertyDetailsPageTopBarDividerBorderWidth,
          color: AppThemePreferences().appTheme.propertyDetailsPageTopBarDividerColor!.withOpacity(opacity),
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: AppThemePreferences().appTheme.propertyDetailsPageTopBarShadowColor!.withOpacity(opacity),
          offset: const Offset(0.0, 4.0), //(x,y)
          blurRadius: 3.0,
        ),
      ],
    );
  }
}