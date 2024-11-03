import 'dart:math';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/item_design_files/item_design_notifier.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';


class PropertiesListingGenericWidget extends StatefulWidget {
  final List<dynamic> propertiesList;
  final String design;
  final String listingView;

  const PropertiesListingGenericWidget({
    Key? key,
    required this.propertiesList,
    this.design = DESIGN_01,
    this.listingView = homeScreenWidgetsListingCarouselView,
  }) : super(key: key);

  @override
  State<PropertiesListingGenericWidget> createState() => _PropertiesListingGenericWidgetState();
}

class _PropertiesListingGenericWidgetState extends State<PropertiesListingGenericWidget> {

  bool isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    if (Provider.of<UserLoggedProvider>(context, listen: false).isLoggedIn ?? false) {
      isUserLoggedIn = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemDesignNotifier>(
        builder: (context, itemDesignNotifier, child) {

          if (widget.listingView == homeScreenWidgetsListingSliderView) {
            return SlidingCarousel(
              propertiesList: widget.propertiesList,
              design: widget.design,
              isUserLoggedIn: isUserLoggedIn,
              enablePageIndicator: widget.design.isNotEmpty && widget.design == DESIGN_10 ? true : false,
            );
          }

          if (widget.listingView == homeScreenWidgetsListingListView) {
            final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
            if (UtilityMethods.showTabletView) {
              return PropertiesGridViewWidget(
                  isUserLoggedIn: isUserLoggedIn,
                  propertiesList: widget.propertiesList,
                  crossAxisCount: isLandscape ? 3:2,
                  scrollDirection: Axis.vertical,
                  heightConstrained: false
              );
            }
            return PropertiesListViewWidget(
              propertiesList: widget.propertiesList,
              design: widget.design,
              isUserLoggedIn: isUserLoggedIn
            );
          }

          if (UtilityMethods.showTabletView) {
            return PropertiesGridViewWidget(
                isUserLoggedIn: isUserLoggedIn,
                propertiesList: widget.propertiesList);
          }
          return PropertiesCarouselViewWidget(
            propertiesList: widget.propertiesList,
            design: widget.design,
            isUserLoggedIn: isUserLoggedIn
          );
    });
  }
}

class PropertiesCarouselViewWidget extends StatelessWidget {
  final List<dynamic> propertiesList;
  final String design;
  final bool isUserLoggedIn;

  const PropertiesCarouselViewWidget({
    super.key,
    required this.isUserLoggedIn,
    required this.propertiesList,
    this.design = DESIGN_01,
  });

  @override
  Widget build(BuildContext context) {
    ArticleBoxDesign _articleBoxDesign = ArticleBoxDesign();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: _articleBoxDesign.getArticleBoxDesignHeight(design: design),
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            itemCount: propertiesList.length,
            itemBuilder: (BuildContext context, int itemIndex) {
              var item = propertiesList[itemIndex];
              if(item is! Article){
                return Container();
              }
              var heroId = "${item.id}-${UtilityMethods.getRandomNumber()}-CAROUSEL";
              return _articleBoxDesign.getArticleBoxDesign(
                article: item,
                heroId: heroId,
                buildContext: context,
                design: design,//itemDesignNotifier.homeScreenItemDesign,
                onTap: () {
                  if (item.propertyInfo!.requiredLogin) {
                    isUserLoggedIn
                        ? UtilityMethods.navigateToPropertyDetailPage(
                      context: context,
                      propertyID: item.id!,
                      article: item,
                      heroId: heroId,
                    )
                        : UtilityMethods.navigateToLoginPage(context, false);
                  } else {
                    UtilityMethods.navigateToPropertyDetailPage(
                      context: context,
                      propertyID: item.id!,
                      article: item,
                      heroId: heroId,
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class PropertiesListViewWidget extends StatelessWidget {
  final List<dynamic> propertiesList;
  final String design;
  final bool isUserLoggedIn;

  const PropertiesListViewWidget({
    super.key,
    required this.isUserLoggedIn,
    required this.propertiesList,
    this.design = DESIGN_01,
  });

  @override
  Widget build(BuildContext context) {
    ArticleBoxDesign _articleBoxDesign = ArticleBoxDesign();
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: propertiesList.length,
      itemBuilder: (context, index) {
        var item = propertiesList[index];
        if(item is Article) {
          var heroId = "${item.id}-${UtilityMethods.getRandomNumber()}-LIST";
          return Container(
            height: _articleBoxDesign.getArticleBoxDesignHeight(design: design),
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: _articleBoxDesign.getArticleBoxDesign(
              article: item,
              heroId: heroId,
              buildContext: context,
              design: design,
              onTap: () {
                if (item.propertyInfo!.requiredLogin) {
                  isUserLoggedIn
                      ? UtilityMethods.navigateToPropertyDetailPage(
                    context: context,
                    propertyID: item.id!,
                    article: item,
                    heroId: heroId,
                  )
                      : UtilityMethods.navigateToLoginPage(context, false);
                } else {
                  UtilityMethods.navigateToPropertyDetailPage(
                    context: context,
                    propertyID: item.id!,
                    article: item,
                    heroId: heroId,
                  );
                }
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}


class SlidingCarousel extends StatefulWidget {

  final List propertiesList;
  final String design;
  final bool isUserLoggedIn;
  final bool? enablePageIndicator;

  const SlidingCarousel({
    required this.propertiesList,
    required this.design,
    required this.isUserLoggedIn,
    this.enablePageIndicator = false,
    Key? key,
  }) : super(key: key);

  @override
  State<SlidingCarousel> createState() => _SlidingCarouselState();
}

class _SlidingCarouselState extends State<SlidingCarousel> {

  PageController pageController = PageController(initialPage: 0);
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemDesignNotifier>(
        builder: (context, itemDesignNotifier, child) {
          ArticleBoxDesign _articleBoxDesign = ArticleBoxDesign();
          return Stack(
            children: [
              CarouselSlider.builder(
                carouselController: _controller,
                itemCount: min(10, widget.propertiesList.length),
                options: CarouselOptions(
                  autoPlay: true,
                  height: _articleBoxDesign.getArticleBoxDesignHeight(design: widget.design),
                  viewportFraction: 1.02,
                  onPageChanged: (index, reason) {
                    setState(() {
                      pageController = PageController(initialPage: index);
                      // pageController.animateToPage(index, duration: Duration(seconds: 1), curve: Curves.fastLinearToSlowEaseIn);
                    });
                  },
                ),
                itemBuilder: (BuildContext context, int itemIndex,int realIndex) {
                  var item = widget.propertiesList[itemIndex];
                  if (item is Article) {
                    var heroId = "${item.id}-${UtilityMethods.getRandomNumber()}-SLIDER";

                    return Padding(
                      padding: const EdgeInsets.all(3),
                      child: _articleBoxDesign.getArticleBoxDesign(
                        article: item,
                        heroId: heroId,
                        buildContext: context,
                        design: widget.design,
                        onTap: (){
                          if (item.propertyInfo!.requiredLogin) {
                            widget.isUserLoggedIn
                                ? UtilityMethods.navigateToPropertyDetailPage(
                              context: context,
                              propertyID: item.id!,
                              article: item,
                              heroId: heroId,
                            )
                                : UtilityMethods.navigateToLoginPage(context, false);
                          } else {
                            UtilityMethods.navigateToPropertyDetailPage(
                              context: context,
                              propertyID: item.id!,
                              article: item,
                              heroId: heroId,
                            );
                          }
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              if(widget.enablePageIndicator ?? false) Positioned.fill(
                bottom: 30,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SmoothPageIndicator(
                    textDirection: UtilityMethods.isRTL(context) ? TextDirection.rtl : TextDirection.ltr,
                    axisDirection: Axis.horizontal,
                    controller: pageController,
                    count: min(10,widget.propertiesList.length),
                    effect: CustomizableEffect(
                      activeDotDecoration: DotDecoration(
                        width: 20,
                        height: 10,
                        color: AppThemePreferences().appTheme.primaryColor!,
                        rotationAngle: 180,
                        verticalOffset: -0,
                        borderRadius: BorderRadius.circular(24),
                        // dotBorder: DotBorder(
                        //   padding: 2,
                        //   width: 2,
                        //   color: Colors.indigo,
                        // ),
                      ),
                      dotDecoration: DotDecoration(
                        width: 10,
                        height: 10,
                        color: AppThemePreferences.countIndicatorsColor!,
                        // dotBorder: DotBorder(
                        //   padding: 2,
                        //   width: 2,
                        //   color: Colors.grey,
                        // ),
                        // borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(2),
                        //     topRight: Radius.circular(16),
                        //     bottomLeft: Radius.circular(16),
                        //     bottomRight: Radius.circular(2)),
                        borderRadius: BorderRadius.circular(16),
                        verticalOffset: 0,
                      ),
                      spacing: 6.0,
                      // activeColorOverride: (i) => colors[i],
                      // inActiveColorOverride: (i) => colors[i],
                    ),
                    // effect: ExpandingDotsEffect(),
                    // effect: ScrollingDotsEffect(),
                      // effect: ScrollingDotsEffect(
                      //   activeStrokeWidth: 2.6,
                      //   activeDotScale: 1.3,
                      //   maxVisibleDots: 5,
                      //   radius: 8,
                      //   spacing: 10,
                      //   dotHeight: 12,
                      //   dotWidth: 12,
                      // )
                    // effect: JumpingDotEffect(
                    //   dotHeight: 16,
                    //   dotWidth: 16,
                    //   jumpScale: .7,
                    //   verticalOffset: 15,
                    // ),

                // effect: WormEffect(
                    //   dotHeight: 16,
                    //   dotWidth: 16,
                    //   type: WormType.thin,
                    //   // strokeWidth: 5,
                    // ),

                    // effect: ScrollingDotsEffect(
                    //   dotHeight: 10.0,
                    //   dotWidth: 10.0,
                    //   spacing: 5,
                    //   dotColor: AppThemePreferences.countIndicatorsColor!,
                    //   activeDotColor: AppThemePreferences().appTheme.primaryColor!,
                    // ),
                    // effect: SlideEffect(
                    //   dotHeight: 10.0,
                    //   dotWidth: 10.0,
                    //   spacing: 5,
                    //   dotColor: AppThemePreferences.countIndicatorsColor!,
                    //   activeDotColor: AppThemePreferences().appTheme.primaryColor!,
                    // ),
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}

class PropertiesGridViewWidget extends StatelessWidget {
  final List<dynamic> propertiesList;
  final String design;
  final bool isUserLoggedIn;
  final int crossAxisCount;
  final Axis scrollDirection;
  final bool heightConstrained;
  const PropertiesGridViewWidget({
    super.key,
    required this.isUserLoggedIn,
    required this.propertiesList,
    this.design = DESIGN_06,
    this.crossAxisCount = 1,
    this.scrollDirection = Axis.horizontal,
    this.heightConstrained = true
  });

  @override
  Widget build(BuildContext context) {
    ArticleBoxDesign _articleBoxDesign = ArticleBoxDesign();
    builder(BuildContext context, int itemIndex) {
      var item = propertiesList[itemIndex];
      if(item is! Article){
        return Container();
      }
      var heroId = "${item.id}-${UtilityMethods.getRandomNumber()}-CAROUSEL";
      final articleBox = _articleBoxDesign.getArticleBoxDesign(
        article: item,
        heroId: heroId,
        buildContext: context,
        design: design,//itemDesignNotifier.homeScreenItemDesign,
        onTap: () {
          if (item.propertyInfo!.requiredLogin) {
            isUserLoggedIn
                ? UtilityMethods.navigateToPropertyDetailPage(
              context: context,
              propertyID: item.id!,
              article: item,
              heroId: heroId,
            )
                : UtilityMethods.navigateToLoginPage(context, false);
          } else {
            UtilityMethods.navigateToPropertyDetailPage(
              context: context,
              propertyID: item.id!,
              article: item,
              heroId: heroId,
            );
          }
        },
      );
      if (heightConstrained) {
        return articleBox;
      } else {
        return SizedBox(
            height: _articleBoxDesign.getArticleBoxDesignHeight(design: design),
            child: articleBox);
      }
    }
    if (heightConstrained) {
      return SizedBox(
        height: _articleBoxDesign.getArticleBoxDesignHeight(design: design),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
          ),
          itemCount: propertiesList.length,
          scrollDirection: scrollDirection,
          itemBuilder: builder,
        ),
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: _articleBoxDesign.getArticleBoxDesignHeight(design: design)
        ),
        itemCount: propertiesList.length,
        scrollDirection: scrollDirection,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: builder,
      );
    }
  }
}

// Widget propertiesSlidingCarouselListGenericWidget({
//   required BuildContext context,
//   required List<dynamic> propertiesList,
// }){
//   return Consumer<ItemDesignNotifier>(
//       builder: (context, itemDesignNotifier, child) {
//         ArticleBoxDesign _articleBoxDesign = ArticleBoxDesign();
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             SizedBox(
//               //height: _articleBoxDesign.getArticleBoxDesignHeight(design: itemDesignNotifier.homeScreenItemDesign),
//               child: CarouselSlider.builder(
//                 itemCount: propertiesList.length,
//                 options: CarouselOptions(
//                   autoPlay: true,
//                   height: _articleBoxDesign.getArticleBoxDesignHeight(design: itemDesignNotifier.homeScreenItemDesign),
//                   viewportFraction: 0.9,
//                   //aspectRatio: 16/7,
//                   //enlargeCenterPage: true,
//                   //enlargeStrategy: CenterPageEnlargeStrategy.height,
//                 ),
//                 itemBuilder: (BuildContext context, int itemIndex,int realIndex) {
//                   var item = propertiesList[itemIndex];
//                   var heroId = item.id.toString() + CAROUSEL;
//                   return _articleBoxDesign.getArticleBoxDesign(
//                     article: item,
//                     heroId: heroId,
//                     buildContext: context,
//                     design: itemDesignNotifier.homeScreenItemDesign,
//                     onTap: (){
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PropertyDetailsPage(
//                             article: item,
//                             propertyID: item.id,
//                             heroId: heroId,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       });
// }

Widget genericLoadingWidgetForCarousalWithShimmerEffect(BuildContext context){
  return Container(
    padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
    child: SizedBox(
        height: 170,
        child: Shimmer.fromColors(
          baseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor!,
          highlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor!,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  loadingWidgetGenericContainerWidget(width: 120.0, height: 135.0,
                    decoration: BoxDecoration(color: AppThemePreferences.shimmerLoadingWidgetContainerColor, borderRadius: BorderRadius.circular(10)),
                    // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        loadingWidgetGenericContainerWidget(),
                        loadingWidgetGenericPaddingWidget(),
                        loadingWidgetGenericContainerWidget(),
                        loadingWidgetGenericPaddingWidget(),
                        loadingWidgetGenericContainerWidget(),
                        loadingWidgetGenericPaddingWidget(),
                        loadingWidgetGenericContainerWidget(),
                      ],
                    ),
                  )
                ],
              ),
            ),
            itemCount: 1,
          ),
        )),
  );
}

Widget loadingWidgetGenericPaddingWidget(){
  return const Padding(padding: EdgeInsets.symmetric(vertical: 10.0));
}

Widget loadingWidgetGenericContainerWidget({
  double width = double.infinity,
  double height = 18.0,
  Decoration decoration = const BoxDecoration(color: Colors.white),
  // Decoration decoration = const BoxDecoration(color: AppThemePreferences.shimmerLoadingWidgetContainerColor),
}){
  return Container(width: width, height: height, decoration: decoration);
}