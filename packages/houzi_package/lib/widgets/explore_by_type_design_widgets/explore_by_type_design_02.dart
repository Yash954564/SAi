import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';

import '../generic_text_widget.dart';

Widget exploreByTypeDesign02({
  required BuildContext context,
  required List<dynamic> data,
  bool isInMenu = false,
  required Function(String, String) onTap,
  String listingView = homeScreenWidgetsListingCarouselView,
}){
  return design02(context: context, listOfMetaData: data, isInMenu: isInMenu, onTap: onTap, listingView: listingView);
}

Widget design02({
  required BuildContext context,
  required List<dynamic> listOfMetaData,
  bool isInMenu = false,
  required Function(String, String) onTap,
  String listingView = homeScreenWidgetsListingCarouselView,
}){
  return Container(
    padding: listingView == homeScreenWidgetsListingListView ? EdgeInsets.only(top: 0, left: 15, right: 15) :
    EdgeInsets.only(
        top: 5,
        left: UtilityMethods.isRTL(context) ? 0 : 15,
        right: UtilityMethods.isRTL(context) ? 10 : 0),
    // padding: listingView == homeScreenWidgetsListingListView ? null : EdgeInsets.only(top: 5, left: 20),
    height: listingView == homeScreenWidgetsListingListView ? null : 200,//290,
    child: ListView.builder(
      physics: listingView == homeScreenWidgetsListingListView ? NeverScrollableScrollPhysics() : null,
      scrollDirection: listingView == homeScreenWidgetsListingListView ? Axis.vertical : Axis.horizontal,
      itemCount: listOfMetaData.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        var item = listOfMetaData[index];
        bool _validURL = UtilityMethods.validateURL(item.fullImage);

        return Container(
          padding: listingView == homeScreenWidgetsListingListView ? EdgeInsets.only(bottom: 10) :
          EdgeInsets.only(
            bottom: 10,
            right: UtilityMethods.isRTL(context) ? 0 : 5,
            left: UtilityMethods.isRTL(context) ? 5 : 0,
          ),
          child: CardWidget(
            // margin: EdgeInsets.zero,
            shape: AppThemePreferences.roundedCorners(AppThemePreferences.exploreTermDesignRoundedCornersRadius),
            elevation: AppThemePreferences.exploreByTypeDesignElevation,
            child: isInMenu == true ? Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 125,//190,
                      width: 200,//320,//MediaQuery.of(context).size.width,
                      // width: 320,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.asset(
                          item.fullImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: GenericTextWidget(
                            "${item.totalPropertiesCount} ${UtilityMethods.getLocalizedString("properties")}",
                            style: AppThemePreferences().appTheme.subBodyTextStyle,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 5),
                          child: GenericTextWidget(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppThemePreferences().appTheme.explorePropertyTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ) : InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              onTap: (){
                onTap(item.slug, item.taxonomy);
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 125,//190,
                        // width: 200,//320,//MediaQuery.of(context).size.width,
                        width: listingView == homeScreenWidgetsListingListView ? double.infinity : 200,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: !_validURL ? errorWidget() : FancyShimmerImage(
                            imageUrl: item.fullImage,//article.image,
                            boxFit: BoxFit.cover,
                            shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
                            shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
                            errorWidget: errorWidget(),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                            child: GenericTextWidget(
                              "${item.totalPropertiesCount} ${UtilityMethods.getLocalizedString("properties")}",
                              style: AppThemePreferences().appTheme.subBodyTextStyle,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 5),
                            child: GenericTextWidget(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppThemePreferences().appTheme.explorePropertyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget errorWidget(){
  return Container(
    color: AppThemePreferences().appTheme.shimmerEffectErrorWidgetBackgroundColor,
    child: Center(
      child: AppThemePreferences().appTheme.shimmerEffectImageErrorIcon,
    ),
  );
}