import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_properties_related_widgets/latest_featured_properties_widget/properties_carousel_list_widget.dart';
import 'package:houzi_package/pages/property_details_related_pages/full_screen_multi_unit_view.dart';
import 'package:houzi_package/pages/property_details_related_pages/property_detail_page_widgets/pd_heading_widget.dart';
import 'package:houzi_package/pages/search_result.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/staggeredGridWidget.dart';

class PropertyDetailPageSubListing extends StatefulWidget {
  final Article article;
  final String title;
  final String widgetViewType;

  const PropertyDetailPageSubListing({
    required this.article,
    required this.title,
    required this.widgetViewType,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageSubListing> createState() => _PropertyDetailPageSubListingState();
}

class _PropertyDetailPageSubListingState extends State<PropertyDetailPageSubListing> {
  Article? _article;

  List<dynamic> multiUnitsList = [];
  List<dynamic> subListingArticles = [];

  Future<List<dynamic>>? _futureSubListingArticles;

  final PropertyBloc _propertyBloc = PropertyBloc();

  @override
  void initState() {
    super.initState();
    _article = widget.article;
    loadData(_article!);
  }

  loadData(Article article) {
    if(UtilityMethods.isValidString(article.features!.multiUnitsListingIDs)){
      _futureSubListingArticles = fetchSubListingArticles(article.features!.multiUnitsListingIDs!);

      _futureSubListingArticles!.then((value) {
        if (value.isEmpty) {
          multiUnitsList = article.features!.multiUnitsList ?? [];
        }
        return null;
      });

      if(mounted)setState(() {});
    }else{
      multiUnitsList = article.features!.multiUnitsList ?? [];
      if(mounted)setState(() {});
    }
  }

  Future<List<dynamic>> fetchSubListingArticles(String propertiesId) async {
    List<dynamic> tempList = [];
    subListingArticles = [];

    tempList = await _propertyBloc.fetchMultipleArticles(propertiesId);

    if (tempList != null && tempList.isNotEmpty && tempList[0] != null && tempList[0].runtimeType != Response) {
      subListingArticles.addAll(tempList);
    }

    return subListingArticles;
  }

  @override
  Widget build(BuildContext context) {
    if (_article != widget.article) {
      _article = widget.article;
      loadData(_article!);
    }
    return subListingsPosts(_futureSubListingArticles, widget.title, widget.widgetViewType);
  }

  Widget subListingsPosts(Future<List<dynamic>>? futureSubListingsArticles, String title, String widgetViewType) {
    if (title == null || title.isEmpty) {
      title = UtilityMethods.getLocalizedString("sub_listings");
    }

    return multiUnitsList.isNotEmpty
        ? articleMultiUnitsWidget(title)
        : FutureBuilder<List<dynamic>>(
      future: futureSubListingsArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) return Container();
          List dataList = articleSnapshot.data!;
          bool viewAll = false;
          if (dataList.length > 3) {
            dataList = dataList.sublist(0, 3);
            viewAll = true;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              textHeadingWidget(
                text: UtilityMethods.getLocalizedString(title),
                widget: viewAll ? seeMoreWidget() : Container(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: widgetViewType.isNotEmpty &&
                    widgetViewType ==
                        subListingPropertiesCarouselView
                    ? subListingsPostsCarouselView(dataList)
                    : subListingsPostsListView(dataList),
              ),
            ],
          );
        } else if (articleSnapshot.hasError) {
          return Container();
        }
        return Container();
        // return loadingWidgetForRelatedProperties();
      },
    );

    // return multiUnitsList.isNotEmpty
    //     ? articleMultiUnitsWidget(title)
    //     : futureSubListingsArticles == null
    //         ? Container()
    //         : FutureBuilder<List<dynamic>>(
    //             future: futureSubListingsArticles,
    //             builder: (context, articleSnapshot) {
    //               if (articleSnapshot.hasData) {
    //                 if (articleSnapshot.data!.isEmpty) return Container();
    //                 List dataList = articleSnapshot.data!;
    //                 bool viewAll = false;
    //                 if (dataList.length > 3) {
    //                   dataList = dataList.sublist(0, 3);
    //                   viewAll = true;
    //                 }
    //                 return Column(
    //                   crossAxisAlignment: CrossAxisAlignment.end,
    //                   children: <Widget>[
    //                     textHeadingWidget(
    //                       text: UtilityMethods.getLocalizedString(title),
    //                       widget: viewAll ? seeMoreWidget() : Container(),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    //                       child: widgetViewType.isNotEmpty &&
    //                               widgetViewType ==
    //                                   subListingPropertiesCarouselView
    //                           ? subListingsPostsCarouselView(dataList)
    //                           : subListingsPostsListView(dataList),
    //                     ),
    //                   ],
    //                 );
    //               } else if (articleSnapshot.hasError) {
    //                 return Container();
    //               }
    //               return Container();
    //               // return loadingWidgetForRelatedProperties();
    //             },
    //           );
  }

  Widget subListingsPostsListView(List dataList) {
    return Column(
      children: dataList.map((item) {
        final heroId = item.id.toString() + RELATED;
        return ArticleBoxDesign().getArticleBoxDesign(
          design: RELATED_PROPERTIES_DESIGN,
          buildContext: context,
          article: item,
          heroId: heroId,
          onTap: () {
            UtilityMethods.navigateToPropertyDetailPage(
              context: context,
              article: item.id!,
              propertyID: item,
              heroId: heroId,
            );
          },
        );
      }).toList(),
    );
  }

  Widget subListingsPostsCarouselView(List dataList) {
    return PropertiesListingGenericWidget(
      propertiesList: dataList,
      design: RELATED_PROPERTIES_DESIGN,
    );
  }

  Widget seeMoreWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButtonWidget(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResult(
                fetchSubListing: true,
                subListingIds: _article!.features!.multiUnitsListingIDs ?? "",
                searchPageListener:
                    (Map<String, dynamic> map, String closeOption) {
                  if (closeOption == CLOSE) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          );
        },
        child: GenericTextWidget(UtilityMethods.getLocalizedString("view_all"),
            style: AppThemePreferences().appTheme.readMoreTextStyle),
      ),
    );
  }

  Widget articleMultiUnitsWidget(String title) {
    if (title == null || title.isEmpty) {
      title = UtilityMethods.getLocalizedString("floor_plans");
    }
    return multiUnitsList != null && multiUnitsList.isNotEmpty ?
    Column(
      children: [
        textHeadingWidget(text: UtilityMethods.getLocalizedString(title)),
        Padding(
          padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
          child: Column(
            children: multiUnitsList.map((item) {
              Map<String, dynamic> multiUnitMap = {};
              String title = item.title ?? "";
              String rooms = item.bedrooms ?? "";
              String bathrooms = item.bathrooms ?? "";
              String size = item.size ?? "";
              String sizePostfix = item.sizePostfix ?? "";
              if(size.isNotEmpty && sizePostfix.isNotEmpty){
                size = "$size $sizePostfix";
              }
              String price = item.price ?? "";
              String pricePostFix = item.pricePostfix ?? "";
              if(price.isNotEmpty && pricePostFix.isNotEmpty){
                price = "$price $pricePostFix";
              }

              if (rooms.isNotEmpty) {
                multiUnitMap[FLOOR_PLAN_ROOMS] = AppThemePreferences.bedIcon;
              }
              if (bathrooms.isNotEmpty) {
                multiUnitMap[FLOOR_PLAN_BATHROOMS] = AppThemePreferences.bathtubIcon;
              }
              if (price.isNotEmpty) {
                multiUnitMap[FLOOR_PLAN_PRICE] = AppThemePreferences.priceTagIcon;
              }
              if (size.isNotEmpty) {
                multiUnitMap[FLOOR_PLAN_SIZE] = AppThemePreferences.areaSizeIcon;
              }

              return multiUnitMap.isEmpty ? Container() :
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                child: CardWidget(
                  elevation: AppThemePreferences.zeroElevation,
                  color: AppThemePreferences()
                      .appTheme
                      .containerBackgroundColor,
                  shape: AppThemePreferences.roundedCorners(
                      AppThemePreferences
                          .globalRoundedCornersRadius),
                  child: InkWell(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(5)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenMultiUnits(multiUnitsList),
                        ),
                      );
                    },
                    child: Container(
                      padding:
                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(
                                10, 0, 10, 5),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                GenericTextWidget(
                                  title,
                                  strutStyle: StrutStyle(
                                      height: AppThemePreferences
                                          .genericTextHeight),
                                  style: AppThemePreferences()
                                      .appTheme
                                      .label01TextStyle,
                                ),
                                GenericTextWidget(
                                  UtilityMethods.getLocalizedString(
                                      "view_sub_listing"),
                                  strutStyle: StrutStyle(
                                      height: AppThemePreferences
                                          .genericTextHeight),
                                  style: AppThemePreferences()
                                      .appTheme
                                      .readMoreTextStyle,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(
                                10, 0, 10, 10),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: 50,
                                maxHeight: 60,
                              ),
                              child: CustomStaggeredGridWidget(
                                physics:
                                const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                //multiUnitMap.length,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10),
                                itemCount: multiUnitMap.length,
                                itemBuilder: (context, index) {
                                  var key = multiUnitMap.keys
                                      .elementAt(index);
                                  var value = key ==
                                      FLOOR_PLAN_ROOMS
                                      ? rooms
                                      : key == FLOOR_PLAN_BATHROOMS
                                      ? bathrooms
                                      : key == FLOOR_PLAN_PRICE
                                      ? price
                                      : key ==
                                      FLOOR_PLAN_SIZE
                                      ? size
                                      : "";
                                  return Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        multiUnitMap[key],
                                        size: AppThemePreferences
                                            .propertyDetailsFloorPlansIconSize,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            left: 8.0),
                                        child: GenericTextWidget(
                                          value,
                                          strutStyle: StrutStyle(
                                              height: AppThemePreferences
                                                  .genericTextHeight),
                                          style:
                                          AppThemePreferences()
                                              .appTheme
                                              .label01TextStyle,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                staggeredTileBuilder: (int index) =>
                                const StaggeredTile.fit(1),
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 100, //16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    )
        : Container();
  }
}
