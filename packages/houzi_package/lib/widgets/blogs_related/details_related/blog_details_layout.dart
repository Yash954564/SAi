import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/models/blog_models/blog_details_page_layout.dart';
import 'package:houzi_package/widgets/blogs_related/details_related/widgets/comments_widgets/comments_widget.dart';
import 'package:houzi_package/widgets/blogs_related/details_related/widgets/content_widget.dart';
import 'package:houzi_package/widgets/blogs_related/details_related/widgets/image_widget.dart';
import 'package:houzi_package/widgets/blogs_related/details_related/widgets/info_widget.dart';
import 'package:houzi_package/widgets/blogs_related/details_related/widgets/title_widget.dart';
import 'package:houzi_package/widgets/blogs_related/details_related/widgets/top_bar_widget.dart';

class BlogDetailsLayout extends StatefulWidget {
  final BlogArticle article;

  const BlogDetailsLayout({
    super.key,
    required this.article,
  });

  @override
  State<BlogDetailsLayout> createState() => _BlogDetailsLayoutState();
}

class _BlogDetailsLayoutState extends State<BlogDetailsLayout> {

  double _opacity = 0.0;
  List<BlogDetailPageLayout> layoutConfigList = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(scrollControllerListener);
    loadConfigData();
  }

  @override
  dispose() {
    layoutConfigList = [];
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppThemePreferences().appTheme.backgroundColor!.withOpacity(_opacity),
        statusBarIconBrightness: AppThemePreferences().appTheme.statusBarIconBrightness,
      ),
      child: Scaffold(
        body:  Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: BlogDetailsLayoutDynamicWidgetListing(
                article: widget.article,
                layoutConfigList: layoutConfigList,
              ),
            ),
            BlogDetailsLayoutTopBarWidget(
              article: widget.article,
              opacity: _opacity,
            ),
          ],
        ),
      ),
    );
  }

  void scrollControllerListener() {
    if(mounted){
      setState(() {
        if (_scrollController.offset < 50.0) {
          _opacity = 0.0;
        }
        if (_scrollController.offset > 50.0 && _scrollController.offset < 100.0) {
          _opacity = 0.4;
        }
        if (_scrollController.offset > 100.0 && _scrollController.offset < 150.0) {
          _opacity = 0.8;
        }
        if (_scrollController.offset > 190.0) {
          _opacity = 1.0;
        }
      });
    }
  }

  void loadConfigData() {
    getBlogDetailPageConfigFile().then((blogDetailPageLayout) {
      if (mounted) {
        setState(() {
          layoutConfigList = blogDetailPageLayout;
        });
      }
      return null;
    });
  }

  Future<List<BlogDetailPageLayout>> getBlogDetailPageConfigFile() async {
    List<BlogDetailPageLayout> list = HiveStorageManager.readBlogDetailConfigListData();
    if (list.isNotEmpty) {
      return list;
    }

    String configJson = await rootBundle.loadString(APP_CONFIG_JSON_PATH);
    BlogDetailsPageLayout blogDetailPageLayout = BlogDetailsPageLayout.fromRawJson(configJson);
    return blogDetailPageLayout.blogDetailPageLayout!;
  }
}

class BlogDetailsLayoutDynamicWidgetListing extends StatelessWidget {
  final BlogArticle article;
  final List<BlogDetailPageLayout> layoutConfigList;

  const BlogDetailsLayoutDynamicWidgetListing({
    super.key,
    required this.article,
    required this.layoutConfigList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: layoutConfigList.map((item) {
        if (item.widgetEnable == true) {
          switch (item.widgetType) {
            case(BLOG_IMAGE): {
              return BlogDetailsLayoutImageWidget(article: article);
            }
            case(BLOG_TITLE): {
              return BlogDetailsLayoutTitleWidget(article: article);
            }
            case(BLOG_CATEGORY): {
              return BlogDetailsLayoutCategoryWidget(article: article);
            }
            case(BLOG_AUTHOR_AND_TIME): {
              return BlogDetailsLayoutInfoWidget(article: article);
            }
            case(BLOG_CONTENT): {
              return BlogDetailsLayoutContentWidget(article: article);
            }
            case(BLOG_COMMENTS): {
              return BlogDetailsLayoutCommentsWidget(article: article);
            }
            default: {
              return Container();
            }
          }
        }
        return Container();
      }).toList(),
    );
  }
}