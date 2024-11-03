import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/item_design_files/item_design_notifier.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';

typedef MapPropertiesWidgetListener = Function({int? currentPage});

class MapPropertiesWidget extends StatelessWidget {
  final double opacity;
  final double carouselOpacity;
  final List<dynamic> propArticlesList;
  final ItemDesignNotifier itemDesignNotifier;
  final PageController carouselPageController;
  final MapPropertiesWidgetListener listener;
  final void Function(Article, int, String) onPropArticleTap;

  const MapPropertiesWidget({
    Key? key,
    required this.opacity,
    required this.carouselOpacity,
    required this.propArticlesList,
    required this.carouselPageController,
    required this.itemDesignNotifier,
    required this.listener,
    required this.onPropArticleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    propArticlesList.removeWhere((element) => element is AdWidget);

    if (opacity < 0.5) return SafeArea(
        child: Stack(
          children: [
            Positioned(
              width: MediaQuery.of(context).size.width,
              // bottom: widget.hasBottomNavigationBar ?  50.0 + kBottomNavigationBarHeight : 50.0,//100.0,
              bottom: 50,
              child: Opacity(
                opacity: carouselOpacity,
                child: Container(
                  child: PropertiesCarouselWidget(
                    propArticlesList: propArticlesList,
                    onPropArticleTap: onPropArticleTap,
                    listener: ({currentPage}) {
                      listener(currentPage: currentPage);
                    },
                    carouselPageController: carouselPageController,
                    itemDesignNotifier: itemDesignNotifier,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

    return Container();
  }
}

class PropertiesCarouselWidget extends StatelessWidget {
  final List<dynamic> propArticlesList;
  final ItemDesignNotifier itemDesignNotifier;
  final PageController carouselPageController;
  final MapPropertiesWidgetListener listener;
  final void Function(Article, int, String) onPropArticleTap;

  const PropertiesCarouselWidget({
    Key? key,
    required this.propArticlesList,
    required this.carouselPageController,
    required this.itemDesignNotifier,
    required this.listener,
    required this.onPropArticleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: UtilityMethods.showTabletView
          ? ArticleBoxDesign().getArticleBoxDesignHeight(design: DESIGN_06)
          : ArticleBoxDesign().getArticleBoxDesignHeight(design: SEARCH_RESULTS_PROPERTIES_DESIGN),
      child: PageView.builder(
        onPageChanged: (int page) {
          listener(currentPage: page);
        },
        controller: carouselPageController,
        itemCount: propArticlesList.length,
        itemBuilder: (BuildContext context, int itemIndex) {
          var item = propArticlesList[itemIndex];
          return CarouselItemWidget(
            propArticleItem: item,
            onPropArticleTap: onPropArticleTap,
            itemDesignNotifier: itemDesignNotifier,
          );
        },
      ),
    );
  }
}

class CarouselItemWidget extends StatelessWidget {
  final dynamic propArticleItem;
  final ItemDesignNotifier itemDesignNotifier;
  final void Function(Article, int, String) onPropArticleTap;
  final ArticleBoxDesign articleBoxDesign = ArticleBoxDesign();

  CarouselItemWidget({
    Key? key,
    required this.propArticleItem,
    required this.itemDesignNotifier,
    required this.onPropArticleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var item = propArticleItem;
    int propId = item.id;
    var heroId = "${item.id}-${UtilityMethods.getRandomNumber()}-MAP-PROP-CAROUSEL";

    return articleBoxDesign.getArticleBoxDesign(
      buildContext: context,
      article: item,
      heroId: heroId,
      design: (UtilityMethods.showTabletView)
          ? DESIGN_06
          : SEARCH_RESULTS_PROPERTIES_DESIGN,
      onTap: () => onPropArticleTap(item, propId, heroId),
    );
  }
}






