import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/review_related_widgets/review_options_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';

import '../../files/generic_methods/utility_methods.dart';
import '../generic_text_widget.dart';

class SingleReviewRow extends StatefulWidget {
  final reviewDetailMap;
  final showDetailedReview;
  final reportNonce;


  SingleReviewRow( this.reviewDetailMap, this.showDetailedReview, this.reportNonce);

  @override
  _SingleReviewRowState createState() => _SingleReviewRowState();
}

class _SingleReviewRowState extends State<SingleReviewRow> {
  @override
  Widget build(BuildContext context) {
    // print(widget.reviewDetailMap.modifiedGmt);
    // if(widget.reviewDetailMap.modifiedGmt == "now") {
    //   // print("true");
    // } else {
    //   // print("false");
    // }
    return CardWidget(
      margin: EdgeInsets.symmetric(vertical: 4.0,horizontal: 2.0),
      shape: AppThemePreferences.roundedCorners(AppThemePreferences.reviewRoundedCornersRadius),
      elevation: AppThemePreferences.reviewsElevation,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showDetailedReview)
              Row(
                children: [
                  userAvatarWidget(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: textWidget(
                          widget.reviewDetailMap.userDisplayName.isEmpty == ""
                              ? widget.reviewDetailMap.userName
                              : widget.reviewDetailMap.userDisplayName,
                          AppThemePreferences().appTheme.heading01TextStyle!),
                    ),
                  ),
                  ReviewOptionsWidget(
                    reportNonce: widget.reportNonce,
                    contentItemID: widget.reviewDetailMap.id,
                    listener: ({contentItemID}) {
                      if(contentItemID != null){
                        // listener(itemIndex: queryItemIndex);
                      }
                    },
                  )

                ],
              ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: textWidget(widget.reviewDetailMap.title,
                      AppThemePreferences().appTheme.articleReviewsTitle!),
                ),
                // textWidget(widget.reviewDetailMap.modifiedGmt == "now" ? widget.reviewDetailMap.modifiedGmt : "${widget.reviewDetailMap.modifiedGmt} ago",
                Expanded(
                  child: textWidget(
                    widget.reviewDetailMap.modifiedGmt,
                    AppThemePreferences().appTheme.subTitle02TextStyle!,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                starsWidget(widget.reviewDetailMap.reviewStars),
                widget.showDetailedReview
                    ? Container()
                    : textWidget(
                      widget.reviewDetailMap.userDisplayName.isEmpty == ""
                        ? widget.reviewDetailMap.userName
                        : widget.reviewDetailMap.userDisplayName,
                        AppThemePreferences().appTheme.subTitle02TextStyle!),
              ],
            ),
            //starsWidget(widget.reviewDetailMap[REVIEW_STARS]),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: textWidget(UtilityMethods.cleanContent(widget.reviewDetailMap.content), null),
            )
          ],
        ),
      ),
    );
  }

  Widget starsWidget(String totalRating) {
    return totalRating == null || totalRating.isEmpty || totalRating == 'null'
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: RatingBar.builder(
              initialRating: double.parse(totalRating),
              minRating: 1,
              itemSize: 20,
              direction: Axis.horizontal,
              allowHalfRating: true,
              ignoreGestures: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: AppThemePreferences.ratingWidgetStarsColor,
              ),
              onRatingUpdate: (rating) {},
            ),
          );
  }

  Widget userAvatarWidget() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: FancyShimmerImage(
          imageUrl: widget.reviewDetailMap.image,
          boxFit: BoxFit.cover,
          shimmerBaseColor:
              AppThemePreferences().appTheme.shimmerEffectBaseColor,
          shimmerHighlightColor:
              AppThemePreferences().appTheme.shimmerEffectHighLightColor,
          width: 50,
          height: 50,
          errorWidget: ShimmerEffectErrorWidget(iconSize: 30),
        ),
      ),
    );
  }

  Widget textWidget(
    String text,
    TextStyle? style, {
    TextAlign textAlign = TextAlign.start,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 5),
      child: GenericTextWidget(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}
