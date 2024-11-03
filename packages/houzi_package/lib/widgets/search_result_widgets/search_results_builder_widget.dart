import 'package:flutter/material.dart';
import 'package:houzi_package/files/item_design_files/item_design_notifier.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/search_result_widgets/pagination_loading_widget.dart';
import 'package:houzi_package/widgets/search_result_widgets/panel_properties_listing_widget.dart';

typedef PanelBuilderWidgetListener = Function({
  bool? performSearch,
  int? totalResults,
});

class SearchResultBuilderWidget extends StatelessWidget {

  final int? totalResults;
  final bool refreshing;
  final bool isAtBottom;
  final bool infiniteStop;
  final bool hasBottomNavigationBar;
  final void Function(Article, int, String) onPropArticleTap;
  final bool isNativeAdLoaded;
  final List nativeAdList;

  final ScrollController panelScrollController;
  final ItemDesignNotifier itemDesignNotifier;
  final PanelBuilderWidgetListener listener;

  final Future<List<dynamic>>? futureFilteredArticles;

  const SearchResultBuilderWidget({
    Key? key,
    required this.panelScrollController,
    required this.itemDesignNotifier,
    required this.listener,

    required this.isAtBottom,
    required this.infiniteStop,
    required this.hasBottomNavigationBar,
    required this.totalResults,
    required this.refreshing,
    required this.onPropArticleTap,
    required this.isNativeAdLoaded,
    required this.nativeAdList,

    required this.futureFilteredArticles,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,

      child: Stack(
        children: [
          // filteredPosts(futureFilteredArticles!, panelScrollController, itemDesignNotifier),
          PanelPropertiesListingWidget(
            refreshing: refreshing,
            hasBottomNavigationBar: hasBottomNavigationBar,
            onPropArticleTap: onPropArticleTap,
            itemDesignNotifier: itemDesignNotifier,
            futureFilteredArticles: futureFilteredArticles,
            isNativeAdLoaded: isNativeAdLoaded,
            nativeAdList: nativeAdList,
            panelScrollController: panelScrollController,
            totalResults: totalResults,
            listener: listener,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: PaginationLoadingWidget(
              infiniteStop: infiniteStop,
              isAtBottom: isAtBottom,
              hasBottomNavigationBar: hasBottomNavigationBar,
            ),
          ),
        ],
      ),
    );
  }
}
