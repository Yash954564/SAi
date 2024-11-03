import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/review_related_widgets/all_reviews_page.dart';
import 'package:houzi_package/widgets/review_related_widgets/single_review_row.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:provider/provider.dart';

import '../../files/generic_methods/utility_methods.dart';
import '../generic_text_widget.dart';
import '../header_widget.dart';
import 'add_review_page.dart';


class ReviewsWidget extends StatefulWidget {

  final idForReviews;
  final totalRating;
  final fromProperty;
  final title;
  final link;
  final type;
  final EdgeInsetsGeometry padding;

  final String? titleFromPropertyDetailsPage;

  ReviewsWidget({
    this.idForReviews,
    this.totalRating,
    this.fromProperty = false,
    this.title,
    this.link,
    this.type,
    this.padding = const EdgeInsets.fromLTRB(20, 25, 20, 0),
    this.titleFromPropertyDetailsPage,
  });

  @override
  _ReviewsWidgetState createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {

  final PropertyBloc _propertyBloc = PropertyBloc();

  String reviewPostType = "";

  Future<List<dynamic>>? _futureArticleReviews;
  List<dynamic> articleReviewsList = [];
  String page = "1";
  String perPage = "5";

  bool isLoggedIn = false;

  bool isInternetConnected = true;

  VoidCallback? generalNotifierListener;

  @override
  void initState() {
    super.initState();

    if (Provider.of<UserLoggedProvider>(context,listen: false).isLoggedIn!) {
      setState(() {
        isLoggedIn = true;
      });
    }

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

  }

  loadData(){
    _futureArticleReviews = fetchArticlesReviews(widget.idForReviews, page, perPage);
    if(mounted)setState(() {});
  }

  Future<List<dynamic>> fetchArticlesReviews(int id, String page, String perPage) async {
    List<dynamic> tempList = [];
    articleReviewsList = [];

    if(widget.fromProperty){
      tempList = await _propertyBloc.fetchArticlesReviews(id, page, perPage);
    } else{
      tempList = await _propertyBloc.fetchAgentAgencyAuthorReviews(id, page, perPage,widget.type);
    }

    if(tempList != null && (tempList.isEmpty || (tempList.isNotEmpty && tempList[0] != null && tempList[0].runtimeType != Response))){
      if (mounted) {
        setState(() {
          isInternetConnected = true;
          if(tempList.isNotEmpty){
            articleReviewsList.addAll(tempList);
          }
        });
      }
    }else{
      if(mounted){
        setState(() {
          isInternetConnected = false;
        });
      }
    }

    return articleReviewsList;
  }


  @override
  Widget build(BuildContext context) {
    return isInternetConnected ? articleReviews(_futureArticleReviews) : Container();
  }

  Widget articleReviews(Future<List<dynamic>>? futureArticleReviews) {
    return futureArticleReviews == null ? leaveReviewButtonWidget() :
    FutureBuilder<List<dynamic>>(
      future: futureArticleReviews,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) {
            return leaveReviewButtonWidget();
          }
          List<dynamic> list = articleSnapshot.data!;

          String headerReview = UtilityMethods.getLocalizedString("reviews");

          if(widget.titleFromPropertyDetailsPage != null &&
          widget.titleFromPropertyDetailsPage!.isNotEmpty){
            headerReview = widget.titleFromPropertyDetailsPage!;
          }

          if (list.length > 3) {
            list = list.sublist(0, 3);
          }
          return Padding(
                  padding: widget.padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      HeaderWidget(
                          text: headerReview,
                          padding: const EdgeInsets.only(left: 0, right: 0),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          children: [
                            widget.totalRating == null ||
                                widget.totalRating.isEmpty ||
                                    widget.totalRating == 'null'
                                ? Container()
                                : starsWidget(widget.totalRating),
                            widget.totalRating == null ||
                                    widget.totalRating.isEmpty ||
                                    widget.totalRating == 'null'
                                ? Container()
                                : textWidget(
                                    UtilityMethods.getLocalizedString(
                                        "reviews_rating_out_of",
                                        inputWords: [widget.totalRating.toString()],
                                    ),
                                    AppThemePreferences().appTheme.heading01TextStyle!,
                                  ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Column(
                            children: list.map<Widget>((review) {
                              reviewPostType = "${review.reviewPostType}";
                              return SingleReviewRow(review, false, "");
                            }).toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              writeReviewsWidget(),
                              seeMoreWidget(reviewPostType),
                              // if (totalReviews > 3) seeMoreWidget(reviewPostType),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                );
              } else if (articleSnapshot.hasError) {
          return Container();
        }
        return Container();
      },
    );
  }

  Widget leaveReviewButtonWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(UtilityMethods.getLocalizedString("give_a_review"), AppThemePreferences().appTheme.heading01TextStyle!),
          textWidget(UtilityMethods.getLocalizedString("tell_others_what_you_think"), null),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: ratingWidget(),
          ),
          writeReviewsWidget(),
        ],
      ),
    );
  }

  // Widget buildList(List<dynamic> list){
  //   return ListView.builder(
  //     physics: NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     itemCount: min(3, list.length),
  //     padding: EdgeInsets.all(0.0),
  //     itemBuilder: (context, index) {
  //       var _title = "${list[index].title}";
  //       var reviewStars = "${list[index].reviewStars}";
  //       var content = "${list[index].content}";
  //       content = cleanContent(content);
  //       reviewPostType = "${list[index].reviewPostType}";
  //
  //       Map<String, dynamic> reviewDetailMap = {
  //         REVIEW_TITLE: _title,
  //         REVIEW_STARS: reviewStars,
  //         REVIEW_CONTENT: content,
  //       };
  //       return SingleReviewRow(reviewDetailMap);
  //     },
  //   );
  // }

  Widget ratingWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: navigateToAddReviewPage,
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RatingBar.builder(
                  initialRating: 0,
                  direction: Axis.horizontal,
                  ignoreGestures: true,
                  allowHalfRating: true,
                  tapOnlyMode: true,
                  itemSize: 40,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    //color: AppThemePreferences.ratingWidgetStarsColor,
                  ),
                  onRatingUpdate: (rating) {

                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );

  }

  Widget starsWidget(String totalRating) {
    return totalRating == null || totalRating.isEmpty || totalRating == 'null'? Container() : Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: RatingBar.builder(
        initialRating: double.parse(totalRating),
        minRating: 1,
        itemSize: 20,
        direction: Axis.horizontal,
        allowHalfRating: true,
        ignoreGestures: true,
        itemCount: 5,
        // itemPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: AppThemePreferences.ratingWidgetStarsColor,
        ),
        onRatingUpdate: (rating) {},
      ),
    );
  }

  Widget textWidget(String text, TextStyle? style) {
    return GenericTextWidget(
      text,
      style: style,
    );
  }

  Widget writeReviewsWidget() {
    return TextButtonWidget(
      onPressed: navigateToAddReviewPage,
      child: textWidget(
          UtilityMethods.getLocalizedString("write_a_review"), AppThemePreferences().appTheme.readMoreTextStyle),
    );
  }

  Widget seeMoreWidget(String type) {
    return TextButtonWidget(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllReviews(
              id: widget.idForReviews,
              fromProperty: widget.fromProperty ? true : false,
              reviewPostType: type,
              listingTitle: widget.title,//_article.title,
              permaLink: widget.link,//_article.link,
            ),
          ),
        );
      },
      child: textWidget(
          UtilityMethods.getLocalizedString("view_all"), AppThemePreferences().appTheme.readMoreTextStyle),
    );
  }

  void navigateToAddReviewPage() {
    isLoggedIn
        ? Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReview(
          listingId: widget.idForReviews,
          listingTitle: widget.title,//_article.title,
          reviewPostType: widget.type,//_article.type,
          permaLink: widget.link//_article.link,
        ),
      ),
    )
        : _showToastWhileDataLoading(context, UtilityMethods.getLocalizedString("you_must_login") + UtilityMethods.getLocalizedString("before_leaving_a_review"),
      true,
    );
  }

  _showToastWhileDataLoading(BuildContext context, String msg, bool forLogin) {
    !forLogin ? ShowToastWidget(
      buildContext: context,
      text: msg,
    ) : ShowToastWidget(
      buildContext: context,
      showButton: true,
      buttonText: UtilityMethods.getLocalizedString("login"),
      text: msg,
      toastDuration: 4,
      onButtonPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserSignIn(
                  (String closeOption) {
                if (closeOption == CLOSE) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
