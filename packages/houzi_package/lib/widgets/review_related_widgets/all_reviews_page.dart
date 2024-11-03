import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/pages/realtor_information_page.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/review_related_widgets/add_review_page.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/review_related_widgets/single_review_row.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';

import '../../models/api/api_response.dart';

class AllReviews extends StatefulWidget {
  final id;
  final fromProperty;
  final reviewPostType;
  final permaLink;
  final listingTitle;
  final title;

  AllReviews({
    this.id,
    this.fromProperty,
    this.reviewPostType,
    this.permaLink = "",
    this.listingTitle,
    this.title,
  });

  @override
  _AllReviewsState createState() => _AllReviewsState();
}

class _AllReviewsState extends State<AllReviews> {
  final PropertyBloc _propertyBloc = PropertyBloc();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<List<dynamic>>? _futureFetchReviews;
  List<dynamic> articleReviewsList = [];

  int page = 1;
  int perPage = 10;
  bool isInternetConnected = true;
  bool isRefreshing = false;
  bool shouldLoadMore = true;
  bool isLoading = false;
  String nonce = "";
  @override
  void initState() {
    super.initState();
    loadDataFromApi();
    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchReportContentNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  loadDataFromApi({bool forPullToRefresh = true}) {
    if (forPullToRefresh) {
      if (isLoading) {
        return;
      }
      setState(() {
        isRefreshing = true;
        isLoading = true;
      });

      page = 1;
      if (widget.fromProperty) {
        _futureFetchReviews = fetchPropertyReviews(widget.id, page, perPage);
      } else {
        _futureFetchReviews = fetchReviews(widget.id, page, perPage, widget.reviewPostType);
      }
      _refreshController.refreshCompleted();
    } else {
      if (!shouldLoadMore || isLoading) {
        _refreshController.loadComplete();
        return;
      }
      setState(() {
        isRefreshing = false;
        isLoading = true;
      });
      page++;
      if (widget.fromProperty) {
        _futureFetchReviews = fetchPropertyReviews(widget.id, page, perPage);
      } else {
        _futureFetchReviews = fetchReviews(widget.id, page, perPage, widget.reviewPostType);
      }
      _refreshController.loadComplete();

    }
  }

  Future<List<dynamic>> fetchPropertyReviews(int propertyId, int page, int perPage) async {
    if (page == 1) {
      setState(() {
        shouldLoadMore = true;
      });
    }
    List<dynamic> tempList = await _propertyBloc.fetchArticlesReviews(propertyId, page.toString(), perPage.toString());

    if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          isInternetConnected = false;
          shouldLoadMore = false;
        });
      }
    }else {
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }

      if (page == 1) {
        articleReviewsList.clear();
      }
      if (tempList != null && tempList.isNotEmpty) {
        articleReviewsList.addAll(tempList);
      }
      if(tempList.isEmpty || tempList.length < perPage){
      // if(tempList == null || tempList.isEmpty || tempList.length < perPage){
        if (mounted) {
          setState(() {
            shouldLoadMore = false;
          });
        }
      }
    }
    return articleReviewsList;
  }

  Future<List<dynamic>> fetchReviews(int propertyId, int page, int perPage, String type) async {
    if (page == 1) {
      setState(() {
        shouldLoadMore = true;
      });
    }
    List<dynamic> tempList = await _propertyBloc.fetchAgentAgencyAuthorReviews(propertyId, page.toString(), perPage.toString(), type);

    if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          isInternetConnected = false;
          shouldLoadMore = false;
        });
      }
    }else {
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }

      if (page == 1) {
        articleReviewsList.clear();
      }
      if (tempList != null && tempList.isNotEmpty) {
        articleReviewsList.addAll(tempList);
      }
      if(tempList.isEmpty || tempList.length < perPage){
        setState(() {
          shouldLoadMore = false;
        });
      }
    }
    return articleReviewsList;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isInternetConnected == false ? AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("reviews"),
      ) : widgetAppBar(),
      body: isInternetConnected == false ? Align(
        alignment: Alignment.topCenter,
        child: NoInternetConnectionErrorWidget(onPressed: ()=> loadDataFromApi()),
      ) : SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body = Container();
            if (mode == LoadStatus.loading) {
              if (shouldLoadMore) {
                body = paginationLoadingWidget();
              } else {
                body = Container();
              }
            }
            return SizedBox(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        header: const MaterialClassicHeader(),
        controller: _refreshController,
        onRefresh: loadDataFromApi,
        onLoading: () => loadDataFromApi(forPullToRefresh: false),
        child: SingleChildScrollView(
          child: Column(
              children: [
                if (widget.title != null && widget.title.isNotEmpty)
                  propertyNameWidget(),
                articleReviews(context,_futureFetchReviews!),
              ],
          ),
        ),
      )

      // widget.showPropertyName ? Column(
      //   children: [
      //     propertyNameWidget(),
      //     Expanded(child: articleReviews(context,_futureFetchReviews!))
      //   ],
      // ): articleReviews(context,_futureFetchReviews!),
    );
  }

  Widget propertyNameWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        child: CardWidget(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GenericTextWidget(
                  widget.title,
                  style: AppThemePreferences().appTheme.heading01TextStyle,
                ),
                Icon(
                  AppThemePreferences.arrowForwardIcon,
                  color: AppThemePreferences().appTheme.iconsColor,
                  // size: AppThemePreferences.settingsIconSize,
                ),

              ],
            ),
          ),
        ),
        onTap: () {
          if (widget.reviewPostType == PROPERTY) {
            UtilityMethods.navigateToPropertyDetailPage(
              context: context,
              propertyID: widget.id,
              heroId: widget.id.toString(),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RealtorInformationDisplayPage(
                  heroId: "1",
                  realtorId: widget.id.toString(),
                  agentType: widget.reviewPostType == USER_ROLE_HOUZEZ_AGENT_VALUE ? AGENT_INFO : AGENCY_INFO,
                ),
              ),
            );
          }

        },
      ),

    );
  }

  PreferredSizeWidget? widgetAppBar(){
    return AppBarWidget(
      appBarTitle: UtilityMethods.getLocalizedString("reviews"),
      actions: <Widget>[
        widget.title != null && widget.title.isNotEmpty ? Container() :
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              icon: Icon(
                AppThemePreferences.addIcon,
                color: AppThemePreferences.backgroundColorLight,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddReview(
                      reviewPostType: widget.reviewPostType,
                      permaLink: widget.permaLink,
                      listingTitle: widget.listingTitle,
                      listingId: widget.id,
                    ),
                  ),
                );
              },
            ),
          )
      ],
    );
  }

  // Widget articleReviews(BuildContext context, Future<List<dynamic>> futureFetchReviews) {
  //   return FutureBuilder<List<dynamic>>(
  //     future: futureFetchReviews,
  //     builder: (context, articleSnapshot) {
  //       isLoading = false;
  //       if (articleSnapshot.hasData) {
  //         if (articleSnapshot.data!.isEmpty) {
  //           return noResultFoundPage();
  //         }
  //
  //         List<dynamic> list = articleSnapshot.data!;
  //
  //         return SmartRefresher(
  //           enablePullDown: true,
  //           enablePullUp: true,
  //           footer: CustomFooter(
  //             builder: (BuildContext context, LoadStatus? mode) {
  //               Widget body = Container();
  //               if (mode == LoadStatus.loading) {
  //                 if (shouldLoadMore) {
  //                   body = paginationLoadingWidget();
  //                 } else {
  //                   body = Container();
  //                 }
  //               }
  //               return SizedBox(
  //                 height: 55.0,
  //                 child: Center(child: body),
  //               );
  //             },
  //           ),
  //           header: const MaterialClassicHeader(),
  //           controller: _refreshController,
  //           onRefresh: loadDataFromApi,
  //           onLoading: () => loadDataFromApi(forPullToRefresh: false),
  //           child: ListView.builder(
  //             itemCount: list.length,
  //             itemBuilder: (context, index) {
  //               var review = list[index];
  //               return Padding(
  //                 padding: const EdgeInsets.all(10),
  //                 child: SingleReviewRow(review,true),
  //               );
  //             },
  //           ),
  //         );
  //       } else if (articleSnapshot.hasError) {
  //         return noResultFoundPage();
  //       }
  //       return loadingIndicatorWidget();
  //     },
  //   );
  // }
  //

  Widget articleReviews(BuildContext context, Future<List<dynamic>> futureFetchReviews) {
    return FutureBuilder<List<dynamic>>(
      future: futureFetchReviews,
      builder: (context, articleSnapshot) {
        isLoading = false;
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) {
            return noResultFoundPage();
          }

          List<dynamic> list = articleSnapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              var review = list[index];
              return Padding(
                padding: const EdgeInsets.all(10),
                child: SingleReviewRow(review,true, nonce),
              );
            },
          );
        } else if (articleSnapshot.hasError) {
          return noResultFoundPage();
        }
        return loadingIndicatorWidget();
      },
    );
  }
  

  Widget loadingIndicatorWidget() {
    return Container(
      height: (MediaQuery.of(context).size.height) / 2,
      margin: const EdgeInsets.only(top: 50),
      alignment: Alignment.center,
      child: SizedBox(
        width: 80,
        height: 20,
        child: BallBeatLoadingWidget(),
      ),
    );
  }

  Widget starsWidget(String totalRating) {
    return totalRating == null || totalRating.isEmpty || totalRating == 'null'? Container() : Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: RatingBar.builder(
        initialRating: double.parse(totalRating),
        minRating: 1,
        itemSize: 20,
        direction: Axis.horizontal,
        allowHalfRating: true,
        ignoreGestures: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: AppThemePreferences.ratingWidgetStarsColor,
        ),
        onRatingUpdate: (rating) {},
      ),
    );
  }

  Widget paginationLoadingWidget() {
    return Container(
      color: Theme.of(context).canvasColor,
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            width: 60,
            height: 50,
            child: BallRotatingLoadingWidget(),
          ),
        ],
      ),
    );
  }

  Widget noResultFoundPage() {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: UtilityMethods.getLocalizedString("oops_inquiries_not_exist"),
    );
  }

}
