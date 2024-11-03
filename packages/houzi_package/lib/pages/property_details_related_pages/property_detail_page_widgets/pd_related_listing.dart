import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_properties_related_widgets/latest_featured_properties_widget/properties_carousel_list_widget.dart';
import 'package:houzi_package/pages/property_details_page.dart';
import 'package:houzi_package/pages/property_details_related_pages/property_detail_page_widgets/pd_heading_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';

class PropertyDetailPageRelatedListing extends StatefulWidget {
  final String title;
  final int propertyID;
  final String widgetViewType;

  const PropertyDetailPageRelatedListing({
    required this.title,
    required this.propertyID,
    required this.widgetViewType,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageRelatedListing> createState() =>
      _PropertyDetailPageRelatedListingState();
}

class _PropertyDetailPageRelatedListingState extends State<PropertyDetailPageRelatedListing> {

  List<dynamic> relatedArticles = [];

  Future<List<dynamic>>? _futureRelatedArticles;

  final PropertyBloc _propertyBloc = PropertyBloc();
  VoidCallback? generalNotifierListener;

  @override
  void initState() {
    loadData();
    /// General Notifier Listener
    generalNotifierListener = () {
      if (GeneralNotifier().change == GeneralNotifier.PROPERTY_DETAILS_RELOADED) {
        if(mounted) {
          setState(() {
            loadData();
          });
        }
      }
    };

    GeneralNotifier().addListener(generalNotifierListener!);
    super.initState();
  }

  loadData(){
    _futureRelatedArticles = fetchRelatedArticles(widget.propertyID);
    if(mounted)setState(() {});
  }

  Future<List<dynamic>> fetchRelatedArticles(int propertyId) async {
    List<dynamic> tempList = [];
    relatedArticles = [];

    tempList = await _propertyBloc.fetchSimilarArticles(propertyId);

    if(tempList != null && tempList.isNotEmpty && tempList[0] != null && tempList[0].runtimeType != Response){
      relatedArticles.addAll(tempList);
    }

    return relatedArticles;
  }


  @override
  Widget build(BuildContext context) {
    return relatedPosts(_futureRelatedArticles, widget.title, widget.widgetViewType);
  }

  Widget relatedPosts(Future<List<dynamic>>? futureRelatedArticles, String title, String widgetViewType) {
    if (title == null || title.isEmpty) {
      title = UtilityMethods.getLocalizedString("related_properties");
    }

    return futureRelatedArticles == null ? Container() : FutureBuilder<List<dynamic>>(
      future: futureRelatedArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) return Container();

          List dataList = articleSnapshot.data!;
          return Column(
            children: <Widget>[
              textHeadingWidget(
                  text: UtilityMethods.getLocalizedString(title)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: (UtilityMethods.showTabletView)
                          ? relatedPostsCarouselView(dataList)
                          : (widgetViewType.isNotEmpty &&
                                  (widgetViewType ==
                                      similarPropertiesCarouselView))
                              ? relatedPostsCarouselView(dataList)
                              : relatedPostsListView(dataList),
                    ),
              const SizedBox(
                height: 24,
              )
            ],
          );
        } else if (articleSnapshot.hasError) {
          return Container();
        }
        return Container();
        // return loadingWidgetForRelatedProperties();
      },
    );
  }

  Widget relatedPostsListView(List dataList) {
    return Column(
      children: dataList.map((item) {
        var heroId = "${item.id}-${UtilityMethods.getRandomNumber()}-Related";
        return ArticleBoxDesign().getArticleBoxDesign(
          design: RELATED_PROPERTIES_DESIGN,
          buildContext: context,
          article: item,
          heroId: heroId,
          onTap: () {
            UtilityMethods.navigateToPropertyDetailPage(
              context: context,
              article: item,
              propertyID: item.id,
              heroId: heroId,
            );
          },
        );
      }).toList(),
    );
  }

  Widget relatedPostsCarouselView(List dataList) {
    return PropertiesListingGenericWidget(
      propertiesList: dataList,
      design: RELATED_PROPERTIES_DESIGN,
    );
  }


}
