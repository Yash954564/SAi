import 'package:flutter/material.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/widgets/blogs_related/design_layouts/blog_layout_widget_01.dart';
import 'package:houzi_package/widgets/blogs_related/design_layouts/blog_layout_widget_02.dart';

class BlogUtilities{

  // MAKE IT A SINGLETON CLASS
  static BlogUtilities? _blogUtilities;
  BlogUtilities._internal();

  factory BlogUtilities() {
    _blogUtilities ??= BlogUtilities._internal();
    return _blogUtilities!;
  }


  Widget getBlogWidget({
    required String heroId,
    required String design,
    required BlogArticle article,
    required void Function() onTap,
}) {
    if (design == DESIGN_01) {
      return BlogLayoutWidget01(
        onTap: onTap,
        heroId: heroId,
        article: article,
      );
    }

    if (design == DESIGN_02) {
      return BlogLayoutWidget02(
        onTap: onTap,
        heroId: heroId,
        article: article,
      );
    }

    return BlogLayoutWidget01(
      onTap: onTap,
      heroId: heroId,
      article: article,
    );
  }

  double getLayoutWidgetHeight({
    required String design,
  }) {
    if (design == DESIGN_01) {
      return 335;
    }
    if (design == DESIGN_02) {
      return 135;
    }

    return 335;
  }
}