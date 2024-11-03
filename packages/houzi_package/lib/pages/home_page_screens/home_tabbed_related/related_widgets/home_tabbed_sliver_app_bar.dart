import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_utilities.dart';
import 'package:houzi_package/pages/home_page_screens/home_tabbed_related/related_widgets/home_tabbed_search_bar.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/notifications_widgets/notification-bell-widget.dart';


typedef HomeTabbedSliverAppBarListener = void Function({
Map<String, dynamic>? filterInfo,
bool? hideNotificationDot,
});

class HomeTabbedSliverAppBar extends StatefulWidget{

  final String userName;
  final Function() onLeadingIconPressed;
  final HomeTabbedSliverAppBarListener? homeTabbedSliverAppBarListener;
  final bool userLoggedIn;
  final bool receivedNewNotifications;

  HomeTabbedSliverAppBar({
    Key? key,
    required this.userName,
    required this.onLeadingIconPressed,
    this.homeTabbedSliverAppBarListener,
    required this.userLoggedIn,
    required this.receivedNewNotifications,
  }) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => HomeTabbedSliverAppBarState();
}

class HomeTabbedSliverAppBarState extends State<HomeTabbedSliverAppBar>  with TickerProviderStateMixin{

  bool isCollapsed = false;
  bool isStretched = true;
  bool increasePadding = true;
  bool reducePadding = false;

  // double extendedHeight = MediaQuery.of(context).size.height * 0.5;
  double extendedHeight = 185.0;
  double padding = 15.0;
  double currentHeight = 0.0;
  double previousHeight = 0.0;

  TabController? controller;

  HomeRightBarButtonWidgetHook? rightBarButtonIdWidgetHook = HooksConfigurations.homeRightBarButtonWidget;
  HomeSliverAppBarBodyHook? homeSliverAppBarBodyHook = HooksConfigurations.homeSliverAppBarBodyHook;
  Map<String, dynamic>? sliverBodyMap;
  Widget? sliverBodyWidget;

  @override
  void initState(){

    controller = TabController(length: 3, vsync: this);

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
    extendedHeight = MediaQuery.of(context).size.height * 0.35; //0.5
    return SliverAppBar(
      systemOverlayStyle: HomeScreenUtilities().getSystemUiOverlayStyle(design: HOME_SCREEN_DESIGN),
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppThemePreferences().appTheme.primaryColor,
      pinned: true,
      expandedHeight: extendedHeight,
      leading: IconButton(
        padding: const EdgeInsets.all(0),
        onPressed: widget.onLeadingIconPressed,
        icon:  Icon(
          AppThemePreferences.drawerMenuIcon,
          color: Colors.white,
        ),
        // icon:  AppThemePreferences().appTheme.drawerMenuIcon,
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
              padding = 15;
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
              // expandedTitleScale: 1.5,
              centerTitle: false,
              titlePadding: EdgeInsets.only(left: UtilityMethods.isRTL(context) ? 15 : padding, bottom: 10, right: UtilityMethods.isRTL(context) ? padding : 15),
              title: HomeTabbedSearchBarWidget(
                  borderRadius: 10.0,
                  homeTabbedSearchBarWidgetListener: (filterDataMap){
                    widget.homeTabbedSliverAppBarListener!(filterInfo: filterDataMap);
                  }
              ),

              background: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          rightBarButtonIdWidgetHook!(context) ?? NotificationBellWidget(
                            userLoggedIn: widget.userLoggedIn,
                            showNotificationDot: widget.receivedNewNotifications,
                            listener: (hideNotificationDot) {
                              widget.homeTabbedSliverAppBarListener!(hideNotificationDot: hideNotificationDot);
                            },
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child:  Row(
                        children: [
                          getTitleWidget(),
                        ],
                      ),
                    ),
                    if (sliverBodyWidget != null) sliverBodyWidget!,
                  ],
                ),
              ),
            );
          }),
      elevation: 0,
    );
  }

  Widget getTitleWidget(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GenericTextWidget(
            "${UtilityMethods.getLocalizedString("Hello")},",
            style: AppThemePreferences().appTheme.sliverGreetingsTextStyle,
          ),
          if(widget.userName.isNotEmpty) Padding(
              padding: const EdgeInsets.only(top: 5),
              child: GenericTextWidget(
                "${widget.userName.split(" ")[0]}!",
                strutStyle: const StrutStyle(
                  height: 3.0,
                  forceStrutHeight: true,
                ),
                style: AppThemePreferences().appTheme.sliverUserNameTextStyle,
              ),
            ),

          Padding(
            padding: EdgeInsets.only(top: widget.userName.isNotEmpty ? 15 : 30),
            child: GenericTextWidget(
              UtilityMethods.getLocalizedString(TABBED_HOME_QUOTE),
              style: AppThemePreferences().appTheme.sliverQuoteTextStyle,
            ),
          ),
        ],
      ),
    );
  }


}

