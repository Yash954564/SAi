import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/pages/home_page_screens/home_location_related/related_widgets/home_location_search_bar.dart';
import 'package:houzi_package/pages/home_page_screens/home_location_related/related_widgets/home_location_search_type_widget.dart';
import 'package:houzi_package/pages/home_page_screens/home_location_related/related_widgets/home_location_top_bar.dart';

typedef HomeLocationSliverAppBarWidgetListener = void Function({bool? hideNotificationDot});
class HomeLocationSliverAppBarWidget extends StatefulWidget {
  final int selectedStatusIndex;
  final Function() onLeadingIconPressed;
  final bool userLoggedIn;
  final bool receivedNewNotifications;
  final HomeLocationSliverAppBarWidgetListener listener;

  const HomeLocationSliverAppBarWidget({
    Key? key,
    required this.selectedStatusIndex,
    required this.onLeadingIconPressed,
    required this.userLoggedIn,
    required this.receivedNewNotifications,
    required this.listener,
  }) : super(key: key);

  @override
  State<HomeLocationSliverAppBarWidget> createState() => _HomeLocationSliverAppBarWidgetState();
}

class _HomeLocationSliverAppBarWidgetState extends State<HomeLocationSliverAppBarWidget> {

  bool isCollapsed = false;
  bool isStretched = true;
  bool increasePadding = true;
  bool reducePadding = false;
  double extendedHeight = 185.0;
  double padding = 10.0;
  double currentHeight = 0.0;
  double previousHeight = 0.0;

  HomeSliverAppBarBodyHook? homeSliverAppBarBodyHook = HooksConfigurations.homeSliverAppBarBodyHook;
  Map<String, dynamic>? sliverBodyMap;
  Widget? sliverBodyWidget;

  @override
  void initState() {

    if (homeSliverAppBarBodyHook != null) {
      sliverBodyMap = homeSliverAppBarBodyHook!(context);
    }

    if (sliverBodyMap != null && sliverBodyMap!.isNotEmpty) {
      // set extended height of Sliver App Bar
      if (sliverBodyMap!.containsKey("height") &&
          sliverBodyMap!["height"] is double) {
        extendedHeight = extendedHeight + sliverBodyMap!["height"];
      }
      // get the body widget of Sliver App Bar
      if (sliverBodyMap!.containsKey("widget") &&
          sliverBodyMap!["widget"] is Widget?) {
        sliverBodyWidget =  sliverBodyMap!["widget"];
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppThemePreferences().appTheme.homeScreenStatusBarColor,
          statusBarIconBrightness: AppThemePreferences().appTheme.statusBarIconBrightness,
          statusBarBrightness:AppThemePreferences().appTheme.statusBarBrightness
      ),
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppThemePreferences().appTheme.sliverAppBarBackgroundColor,
      pinned: true,
      expandedHeight: extendedHeight,
      leading: IconButton(
        padding: const EdgeInsets.all(0),
        onPressed: widget.onLeadingIconPressed,
        icon:  AppThemePreferences().appTheme.drawerMenuIcon!,
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      ),

      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            isCollapsed = constraints.biggest.height ==  MediaQuery.of(context).padding.top + kToolbarHeight ? true : false;
            isStretched = constraints.biggest.height ==  MediaQuery.of(context).padding.top + extendedHeight ? true : false;
            currentHeight = constraints.maxHeight;
            if(previousHeight < currentHeight){
              increasePadding = false;
              reducePadding = true;
              previousHeight = currentHeight;
            }
            if(previousHeight > currentHeight){
              increasePadding = true;
              reducePadding = false;
              previousHeight = currentHeight;
            }
            if(isCollapsed){
              padding = 60;
              increasePadding = false;
              reducePadding = true;
            }
            if(isStretched){
              padding = 10;
              increasePadding = true;
              reducePadding = false;
            }

            if(increasePadding){
              double temp = padding + (constraints.maxHeight) / 100;
              if(temp <= 60){
                padding = temp;
              }else{
                temp = temp - (temp - 60);
                padding = temp;
              }
            }
            if(reducePadding){
              double temp = padding - (constraints.maxHeight) / 100;
              if(temp >= 10){
                padding = temp;
              }else{
                temp = temp + (10 - temp);
                padding = temp;
              }
            }

            return FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: EdgeInsets.only(left: UtilityMethods.isRTL(context) ? 10 : padding, bottom: 10, right: UtilityMethods.isRTL(context) ? padding : 10),
              title: HomeLocationSearchBarWidget(),
              background: Column(
                children: [
                  HomeLocationTopBarWidget(
                    userLoggedIn: widget.userLoggedIn,
                    receivedNewNotifications: widget.receivedNewNotifications,
                    listener: ({hideNotificationDot}) {
                      widget.listener(hideNotificationDot: hideNotificationDot);
                    },
                  ),
                  HomeLocationSearchTypeWidget(
                    homeLocationSearchTypeWidgetListener: (String selectedItem, String selectedItemSlug){
                      // Do something here
                    }
                  ),
                  if (sliverBodyWidget != null) sliverBodyWidget!,
                ],
              ),
            );
          }),
      elevation: 5,
    );
  }
}