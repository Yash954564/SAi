import 'dart:math';

import 'package:flutter/material.dart';
import 'package:houzi_package/widgets/blogs_related/details_related/blog_details_layout.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/item_design_files/item_design_notifier.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/widgets/blogs_related/blog_utilities.dart';


class BlogsListingWidget extends StatelessWidget {
  final String design;
  final String view;
  final List<BlogArticle>? articlesList;

  const BlogsListingWidget({
    super.key,
    required this.view,
    required this.design,
    required this.articlesList,
  });

  @override
  Widget build(BuildContext context) {
    if (articlesList != null && articlesList!.isNotEmpty) {
      if (view == SLIDER_VIEW) {
        return BlogSliderViewWidget(
          design: design,
          articlesList: articlesList!,
          onTap: (article) => onTap(context, article),
          // enablePageIndicator: ,
        );
      } else if (view == LIST_VIEW) {
        return BlogsListViewWidget(
          design: design,
          articlesList: articlesList!,
          onTap: (article) => onTap(context, article),
        );
      }

      return BlogsCarouselViewWidget(
        design: design,
        articlesList: articlesList!,
        onTap: (article) => onTap(context, article),
      );
    }
    return Container();
  }

  void onTap(BuildContext context, BlogArticle article) {
    UtilityMethods.navigateToRoute(
      context: context,
      builder: (context)=> BlogDetailsLayout(article: article));
  }
}

class BlogsCarouselViewWidget extends StatelessWidget {
  final String design;
  final List<BlogArticle> articlesList;
  final void Function(BlogArticle) onTap;

  const BlogsCarouselViewWidget({
    super.key,
    this.design = DESIGN_01,
    required this.articlesList,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: BlogUtilities().getLayoutWidgetHeight(design: design),
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            itemCount: articlesList.length,
            itemBuilder: (BuildContext context, int index) {
              BlogArticle item = articlesList[index];
              var heroId = "BLOG-${item.id}-${UtilityMethods.getRandomNumber()}-CAROUSEL";
              return BlogUtilities().getBlogWidget(
                article: item,
                heroId: heroId,
                design: design,
                onTap: ()=> onTap(item),
              );
            },
          ),
        ),
      ],
    );
  }
}

class BlogsListViewWidget extends StatelessWidget {
  final String design;
  final List<BlogArticle> articlesList;
  final void Function(BlogArticle) onTap;

  const BlogsListViewWidget({
    super.key,
    this.design = DESIGN_01,
    required this.onTap,
    required this.articlesList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: articlesList.length,
      itemBuilder: (context, index) {
        BlogArticle item = articlesList[index];
        String heroId = "BLOG-${item.id}-${UtilityMethods.getRandomNumber()}-LIST";
        return Container(
          height: BlogUtilities().getLayoutWidgetHeight(design: design),
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: BlogUtilities().getBlogWidget(
            onTap: ()=> onTap(item),
            article: item,
            heroId: heroId,
            design: design,
          ),
        );
      },
    );
  }
}

class BlogSliderViewWidget extends StatefulWidget {
  final String design;
  final void Function(BlogArticle) onTap;
  final bool? enablePageIndicator;
  final List<BlogArticle> articlesList;

  const BlogSliderViewWidget({
    super.key,
    this.design = DESIGN_01,
    required this.onTap,
    required this.articlesList,
    this.enablePageIndicator = false,
  });

  @override
  State<BlogSliderViewWidget> createState() => _BlogSliderViewWidgetState();
}

class _BlogSliderViewWidgetState extends State<BlogSliderViewWidget> {
  PageController pageController = PageController(initialPage: 0);
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemDesignNotifier>(
        builder: (context, itemDesignNotifier, child) {
          return Stack(
            children: [
              CarouselSlider.builder(
                carouselController: _controller,
                itemCount: min(10, widget.articlesList.length),
                options: CarouselOptions(
                  autoPlay: true,
                  height: BlogUtilities().getLayoutWidgetHeight(design: widget.design),
                  viewportFraction: 1.02,
                  onPageChanged: (index, reason) {
                    setState(() {
                      pageController = PageController(initialPage: index);
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  BlogArticle item = widget.articlesList[index];
                  String heroId = "BLOG-${item.id}-${UtilityMethods.getRandomNumber()}-SLIDER";
                  return Container(
                    padding: const EdgeInsets.all(3),
                    child: BlogUtilities().getBlogWidget(
                      onTap: ()=> widget.onTap(item),
                      article: item,
                      heroId: heroId,
                      design: widget.design,
                    ),
                  );
                },
              ),
              if(widget.enablePageIndicator ?? false) Positioned.fill(
                bottom: 30,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SmoothPageIndicator(
                    textDirection: UtilityMethods.isRTL(context)
                        ? TextDirection.rtl : TextDirection.ltr,
                    axisDirection: Axis.horizontal,
                    controller: pageController,
                    count: min(10,widget.articlesList.length),
                    effect: CustomizableEffect(
                      activeDotDecoration: DotDecoration(
                        width: 20,
                        height: 10,
                        color: AppThemePreferences().appTheme.primaryColor!,
                        rotationAngle: 180,
                        verticalOffset: -0,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      dotDecoration: DotDecoration(
                        width: 10,
                        height: 10,
                        color: AppThemePreferences.countIndicatorsColor!,
                        borderRadius: BorderRadius.circular(16),
                        verticalOffset: 0,
                      ),
                      spacing: 6.0,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}