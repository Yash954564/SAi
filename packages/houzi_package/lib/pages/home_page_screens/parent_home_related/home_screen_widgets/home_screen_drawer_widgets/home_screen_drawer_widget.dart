import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_drawer_widgets/home_screen_drawer_widget/home_screen_drawer_widget_listing.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_profile.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';


typedef HomeScreenDrawerWidgetListener = void Function(bool loginInfo);

class HomeScreenDrawerWidget extends StatefulWidget{
  
  final HomeScreenDrawerWidgetListener homeScreenDrawerWidgetListener;
  final Map<String, dynamic> userInfoData;
  final List<dynamic> drawerConfigDataList;

  const HomeScreenDrawerWidget({
    Key? key,
    required this.drawerConfigDataList,
    required this.userInfoData,
    required this.homeScreenDrawerWidgetListener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeScreenDrawerWidgetState();

}
typedef DrawerHook = List Function(BuildContext context);
class HomeScreenDrawerWidgetState extends State<HomeScreenDrawerWidget> {

  List<dynamic> drawerConfigDataList = [];

  @override
  void initState() {
    super.initState();
    if(widget.drawerConfigDataList.isNotEmpty){
      drawerConfigDataList = List.from(widget.drawerConfigDataList);
    }

    DrawerHook drawerHook = HooksConfigurations.drawerItemsList;
    List<dynamic> menuItemList = drawerHook(context) ?? [];

    int totalLength = drawerConfigDataList.length;
    for (var item in menuItemList) {
      int? insertAt = item.insertAt;
      if(insertAt != null) {
        if(insertAt > totalLength) {
          drawerConfigDataList.add(item);
        } else {
          drawerConfigDataList.insert(insertAt, item);
        }
      } else {
        drawerConfigDataList.add(item);
      }
    }

    drawerConfigDataList = drawerConfigDataList.toSet().toList();

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppThemePreferences().appTheme.backgroundColor,
      child: ListView(
        children: <Widget>[
          HooksConfigurations.drawerHeaderHook(
            context,
            APP_NAME,
            AppThemePreferences.drawerImagePath,
            widget.userInfoData[USER_PROFILE_NAME],
            widget.userInfoData[USER_PROFILE_IMAGE],
          )
              ?? DrawerHeader(
            decoration: BoxDecoration(color: AppThemePreferences().appTheme.primaryColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppThemePreferences().appTheme.drawerImage!,
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GenericTextWidget(
                          APP_NAME,
                          style: AppThemePreferences().appTheme.homeScreenDrawerTextStyle,
                          strutStyle: const StrutStyle(height: 1.7, forceStrutHeight: true),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 40, 5, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.userInfoData[USER_PROFILE_NAME] == null ||
                          widget.userInfoData[USER_PROFILE_NAME].isEmpty
                      // _userName == null || _userName.isEmpty
                          ? Container()
                          : GestureDetector(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: FancyShimmerImage(
                            imageUrl: widget.userInfoData[USER_PROFILE_IMAGE],
                            boxFit: BoxFit.cover,
                            shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
                            shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
                            width: 40,
                            height: 40,
                            errorWidget: ShimmerEffectErrorWidget(iconSize: 15),
                          ),
                        ),
                        onTap: () => onUserProfileTap(),
                      ),
                      widget.userInfoData[USER_PROFILE_NAME] == null || widget.userInfoData[USER_PROFILE_NAME].isEmpty
                      // _userName == null || _userName.isEmpty
                          ? Container()
                          : Expanded(
                            child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: GestureDetector(
                            onTap: () => onUserProfileTap(),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: GenericTextWidget(
                                widget.userInfoData[USER_PROFILE_NAME],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppThemePreferences().appTheme.homeScreenDrawerUserNameTextStyle,
                              ),
                            ),
                                                    ),
                                                  ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (drawerConfigDataList.isNotEmpty) Column(
            children: drawerConfigDataList.map((itemMap) {
              return HomeScreenDrawerWidgetsListing(
                userInfoMap: widget.userInfoData,
                drawerItemMap: itemMap,
                homeScreenDrawerWidgetsListingListener: widget.homeScreenDrawerWidgetListener,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void onUserProfileTap(){
    UtilityMethods.navigateToRoute(
      context: context,
      builder: (context) => (UserProfile(userProfilePageListener: (String closeOption) {
        if (closeOption == CLOSE) {
          Navigator.pop(context);
        }
      })),
    );
  }
}