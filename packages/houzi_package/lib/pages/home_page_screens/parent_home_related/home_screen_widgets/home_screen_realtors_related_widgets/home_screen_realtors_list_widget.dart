import 'dart:math';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/realtor_model.dart';
import 'package:houzi_package/pages/realtor_information_page.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/realtor_widgets/realtor_description_widget.dart';
import 'package:houzi_package/widgets/realtor_widgets/realtor_image_widget.dart';
import 'package:houzi_package/widgets/realtor_widgets/realtor_name_widget.dart';
import 'package:houzi_package/widgets/realtor_widgets/realtor_position_widget.dart';

class RealtorListingsWidget extends StatelessWidget {
  final List<dynamic> realtorInfoList;
  final String tag;
  final String? listingView;

  const RealtorListingsWidget({
    Key? key,
    required this.realtorInfoList,
    required this.tag,
    this.listingView = homeScreenWidgetsListingCarouselView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (tag == AGENTS_TAG) {
    //   AgentItemHook agentItemHook = GenericMethods.agentItem;
    //   if (agentItemHook(realtorInfoList) != null) {
    //     return agentItemHook(realtorInfoList);
    //   }
    // } else {
    //   AgencyItemHook agencyItemHook = GenericMethods.agencyItem;
    //   if (agencyItemHook(realtorInfoList) != null) {
    //     return agencyItemHook(realtorInfoList);
    //   }
    // }

    double height = tag == AGENTS_TAG ? AppThemePreferences.agentsListContainerHeight : AppThemePreferences.agenciesListContainerHeight;
    double width = tag == AGENTS_TAG ? AppThemePreferences.agentsListContainerWidth : AppThemePreferences.agenciesListContainerWidth;

    return Container(
      // padding: listingView == homeScreenWidgetsListingListView ? null :  EdgeInsets.only(top: 5, left: 20),
      padding: listingView == homeScreenWidgetsListingListView ? const EdgeInsets.symmetric(horizontal: 15) :
      EdgeInsets.only(
          left: UtilityMethods.isRTL(context) ? 0 : 10,
          right: UtilityMethods.isRTL(context) ? 10 : 0),
      // height: height,
      height: listingView == homeScreenWidgetsListingListView ? null : height,
      child: ListView.builder(
        scrollDirection: listingView == homeScreenWidgetsListingListView ? Axis.vertical : Axis.horizontal,
        physics: listingView == homeScreenWidgetsListingListView ? const NeverScrollableScrollPhysics() : null,
        shrinkWrap: true,
        itemCount: min(10, realtorInfoList.length),
        itemBuilder: (context, index) {
          var item = realtorInfoList[index];
          if (tag == AGENTS_TAG) {
            if(item is Agent) {
              AgentItemHook agentItemHook = HooksConfigurations.agentItem;
              if (agentItemHook(context, item) != null) {
                return agentItemHook(context, item)!;
              }
            }
          } else {
            if(item is Agency) {
              AgencyItemHook agencyItemHook = HooksConfigurations.agencyItem;
              if (agencyItemHook(context, item) != null) {
                return agencyItemHook(context, item)!;
              }
            }

          }
          String stringContent = UtilityMethods.stripHtmlIfNeeded(item.content);
          String heroId = HERO + item.id.toString();

          return Container(
            height: height,
            padding: EdgeInsets.only(bottom: 10, right: listingView == homeScreenWidgetsListingListView ? 0 : 5),
            child: CardWidget(
              shape: AppThemePreferences.roundedCorners(AppThemePreferences.realtorPageRoundedCornersRadius),
              elevation: AppThemePreferences.horizontalListForAgentsElevation,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                onTap: () {
                  navigateToRealtorInformationDisplayPage(
                    context: context,
                    heroId: heroId,
                    realtorType: tag == AGENTS_TAG ? AGENT_INFO : AGENCY_INFO,
                    realtorInfo: tag == AGENTS_TAG ? {AGENT_DATA : item} : {AGENCY_DATA : item},
                  );
                },
                child: Container(
                  width: width,
                  // height: 135,
                  height: height,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      RealtorImageWidget(
                        tag: tag,
                        heroId: heroId,
                        imageUrl: item.thumbnail,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              RealtorNameWidget(title: item.title, tag: tag),
                              if (tag == AGENTS_TAG && item is Agent) RealtorPositionWidget(position: "${item.agentPosition}"),
                              if (tag == AGENTS_TAG && item is Agent) RealtorNameWidget(title: "${item.agentCompany}",tag: tag),
                              RealtorDescriptionWidget(description: stringContent.replaceFirst("\n", "")),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void navigateToRealtorInformationDisplayPage({
  required BuildContext context,
  required String heroId,
  required Map<String, dynamic> realtorInfo,
  required String realtorType,
}){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RealtorInformationDisplayPage(
        heroId: heroId,
        realtorInformation: realtorInfo,
        agentType: realtorType,
      ),
    ),
  );
}


