import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';


typedef HomeScreenRecentSearchesWidgetListener = void Function({Map<String, dynamic> filterDataMap});

class HomeScreenRecentSearchesWidget extends StatelessWidget {
  final List<dynamic> recentSearchesInfoList;
  final String? listingView;

  const HomeScreenRecentSearchesWidget({
    Key? key,
    required this.recentSearchesInfoList,
    this.listingView = homeScreenWidgetsListingCarouselView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return recentSearchesInfoList.isEmpty ? Container() : Container(
      margin: EdgeInsets.only(
        top: 10,
        left: UtilityMethods.isRTL(context) ? 10 : 20,
        right: UtilityMethods.isRTL(context) ? 20 : 10,
      ),
      height: listingView == homeScreenWidgetsListingCarouselView ? 90 : null,
      child: ListView.builder(
        scrollDirection: listingView == homeScreenWidgetsListingCarouselView ?
        Axis.horizontal : Axis.vertical,
        physics: listingView == homeScreenWidgetsListingListView ?
        NeverScrollableScrollPhysics() : null,
        itemCount: recentSearchesInfoList.length,
        shrinkWrap: listingView == homeScreenWidgetsListingListView ? true : false,
        itemBuilder: (context, index) {
          var result = recentSearchesInfoList[index] ?? {};
          if(result is Map) {
            Map<String, dynamic> item = {};
            for (dynamic type in result.keys) {
              item[type.toString()] = result[type];
            }
            String propertyTitle = '';
            String propertyType = '';
            String propertyCity = '';
            String propertyStatus = '';

            if (item.containsKey(PROPERTY_TYPE) && item[PROPERTY_TYPE] != null &&
                item[PROPERTY_TYPE].isNotEmpty) {
              List<String> tempPropertyTypeList = List<String>.from(item[PROPERTY_TYPE]);
              List<String> tempList = [];
              for (var element in tempPropertyTypeList) {
                tempList.add(UtilityMethods.getLocalizedString(element));
              }
              propertyType = tempList.join(", ");
              // propertyType = '$tempList';
              // propertyType = propertyType.replaceAll("[", '');
              // propertyType = propertyType.replaceAll("]", '');
              // if(propertyType.length > 18){
              //   var temp = '${propertyType.substring(0, 18)}...';
              //   propertyType = temp;
              // }
            }
            if (item.containsKey(CITY) && item[CITY] != null && item[CITY].isNotEmpty) {
              if (item[CITY] is List) {
                propertyCity = item[CITY].join(", ");
              } else {
                propertyCity = '${item[CITY]} ';
              }
            }
            if (item.containsKey(PROPERTY_STATUS) &&
                item[PROPERTY_STATUS] != null &&
                item[PROPERTY_STATUS].isNotEmpty) {
              List<String> tempPropertyStatusList = List<String>.from(
                  item[PROPERTY_STATUS]);
              List<String> tempList = [];
              for (var element in tempPropertyStatusList) {
                tempList.add(UtilityMethods.getLocalizedString(element));
              }
              propertyStatus = tempList.join(", ");
              // propertyStatus = '${GenericMethods.getLocalizedString(item[PROPERTY_STATUS].toString())} ';
              // if(propertyStatus.contains("[")){
              //   propertyStatus = propertyStatus.replaceAll("[", '');
              // }
              // if(propertyStatus.contains("]")){
              //   propertyStatus = propertyStatus.replaceAll("]", '');
              // }
            }

            propertyTitle = propertyType.isNotEmpty ?
            propertyType : UtilityMethods.getLocalizedString("latest_properties");
            // propertyType : GenericMethods.getLocalizedString("error_occurred")latest_properties}${propertyStatus.isNotEmpty ? " $propertyStatus" : ""}';

            return Container(
              height: 90,
              width: 225,
              padding: EdgeInsets.only(
                bottom: 10,
                right: UtilityMethods.isRTL(context) ? 0 : 10,
                left: UtilityMethods.isRTL(context) ? 10 : 0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppThemePreferences().appTheme.recentSearchesBorderColor!),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  onTap: () {
                    UtilityMethods.navigateToSearchResultScreen(
                      context: context,
                      dataInitializationMap: item,
                      navigateToSearchResultScreenListener: ({filterDataMap}) {

                      },
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              AppThemePreferences.searchIcon,
                              size: AppThemePreferences
                                  .homeScreenRecentSearchIconSize,
                            ),
                            Container(
                              width: 170,
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: GenericTextWidget(
                                propertyTitle,
                                overflow: TextOverflow.ellipsis,
                                style: AppThemePreferences().appTheme
                                    .homeScreenRecentSearchTitleTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),

                      propertyStatus.isEmpty ? Container() : Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              AppThemePreferences.checkCircleIcon,
                              size: AppThemePreferences
                                  .homeScreenRecentCheckCircleIconSize,
                            ),
                            Container(
                              width: 170,
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: GenericTextWidget(
                                propertyStatus,
                                overflow: TextOverflow.ellipsis,
                                style: AppThemePreferences().appTheme
                                    .homeScreenRecentSearchCityTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),

                      propertyCity.isEmpty ? Container() : Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: AppThemePreferences
                                  .homeScreenRecentSearchLocationIconSize,
                            ),
                            Container(
                              width: 170,
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: GenericTextWidget(
                                propertyCity,
                                style: AppThemePreferences().appTheme
                                    .homeScreenRecentSearchCityTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}

