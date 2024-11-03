import 'package:flutter/material.dart';

import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/widgets/blogs_related/design_layouts/blog_layout_widgets.dart';

class BlogDetailsLayoutInfoWidget extends StatelessWidget {
  final BlogArticle article;

  const BlogDetailsLayoutInfoWidget({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          BlogLayoutAuthorInfoWidget(
            article: article,
            width: 40,
            height: 40,
            centerPadding: 12,
          ),
          BlogLayoutTimeInfoWidget(article: article),
        ],
      ),
    );
  }
}

class BlogDetailsLayoutCategoryWidget extends StatelessWidget {
  final BlogArticle article;

  const BlogDetailsLayoutCategoryWidget({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: BlogLayoutCategoryWidget(article: article),
    );
  }
}
