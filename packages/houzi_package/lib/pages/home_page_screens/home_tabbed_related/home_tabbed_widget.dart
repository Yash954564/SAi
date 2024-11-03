import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/home_page_screens/home_tabbed_related/related_widgets/home_tabbed_sliver_app_bar.dart';
import 'package:houzi_package/pages/home_page_screens/home_tabbed_related/related_widgets/home_tabbed_widgets_listing.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/parent_sliver_home.dart';
import 'package:houzi_package/widgets/custom_widgets/refresh_indicator_widget.dart';

class HomeTabbed extends ParentSliverHome {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const HomeTabbed({
    Key? key,
    this.scaffoldKey
  }) : super(key: key);

  @override
  _HomeTabbedState createState() => _HomeTabbedState();
}

class _HomeTabbedState extends ParentSliverHomeState<HomeTabbed> with TickerProviderStateMixin {

  List<dynamic> homeConfigList = [];

  bool needToRefresh = false; //true
  bool isRefreshStateBusy = false;

  int _tabBarInitialIndex = 0;

  Map selectedHomeConfigItem = {};

  TabController? _tabController;


  @override
  Widget build(BuildContext context) {
    if(widget.scaffoldKey != null){
      super.scaffoldKey = widget.scaffoldKey!;
    }

    return super.build(context);
  }


  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: homeConfigList.length,
        initialIndex: _tabBarInitialIndex,
        vsync: this);
  }


  @override
  void dispose() {
    super.dispose();
    homeConfigList = [];
    selectedHomeConfigItem = {};
    if(_tabController != null)  _tabController!.dispose();


  }

  @override
  getHomeConfigFile() {
    if(mounted) {
      setState(() {
        homeConfigList = UtilityMethods.readHomeConfigFile();

        homeConfigList.removeWhere((homeItem) => (homeItem[sectionTypeKey] == adKey));

        // Set the initial index of TabBar
        for(var item in homeConfigList){
          if(item[sectionTypeKey] != termWithIconsTermKey && item[sectionTypeKey] != recentSearchKey){
            _tabBarInitialIndex = homeConfigList.indexOf(item);
            selectedHomeConfigItem = homeConfigList[_tabBarInitialIndex];
            // selectedHomeConfigItem = homeConfigList[_tabBarInitialIndex][sectionTypeKey];
            // print("selected sectionTypeKey: ${item[sectionTypeKey]}");
            break;
          }
        }
      });
    }
  }

  @override
  Widget getBodyWidget(){
    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              /// Home01 Screen Sliver App Bar Widget
              HomeTabbedSliverAppBar(
                userLoggedIn: isLoggedIn,
                receivedNewNotifications: receivedNewNotifications,
                userName: super.userName,
                onLeadingIconPressed: () => widget.scaffoldKey!.currentState!.openDrawer(),
                homeTabbedSliverAppBarListener: ({filterInfo, hideNotificationDot}) {
                  if (filterInfo != null && filterInfo.isNotEmpty) {
                    updateData(filterInfo);
                  }

                  if (mounted && hideNotificationDot == true) {
                    setState(() {
                      receivedNewNotifications = false;
                    });
                  }
                },
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    tabs: homeConfigList.map((item) {
                      return Tab(text: UtilityMethods.getLocalizedString(item[titleKey]));
                    }).toList(),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    unselectedLabelColor: Colors.grey[400],
                    indicatorColor: Colors.white,
                    isScrollable: true,
                    labelColor: Colors.white,
                    onTap: (index) {
                      selectedHomeConfigItem = homeConfigList[index];
                    },
                    controller: _tabController,
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: homeConfigList.map((item) {
              return item[sectionTypeKey] == recentSearchKey ? SingleChildScrollView(
                child: HomeTabbedListingsWidget(
                  homeScreenData: item,
                  selectedItem: selectedHomeConfigItem,
                  homeTabbedListingsWidgetListener: (bool errorOccur, bool dataLoadingComplete) {

                  },
                ),
              ) :
              RefreshIndicatorWidget(
                edgeOffset: 0.0,
                onRefresh: () async {
                  if(!isRefreshStateBusy && mapEquals(selectedHomeConfigItem, item)){
                    isRefreshStateBusy = true;
                    setState(() {
                      clearMetaData();
                      needToRefresh = true;
                    });
                    loadData();
                  }

                  return;
                },
                child: SingleChildScrollView(
                  child: HomeTabbedListingsWidget(
                    homeScreenData: item,
                    refresh: needToRefresh,
                    selectedItem: selectedHomeConfigItem,
                    homeTabbedListingsWidgetListener: (bool errorOccur, bool dataLoadingComplete) {
                      errorWhileDataLoading = errorOccur;
                      if(dataLoadingComplete){
                        setState(() {
                          needToRefresh = false;
                          isRefreshStateBusy = false;
                        });
                      }
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if(errorWhileDataLoading) super.getInternetConnectionErrorWidget(),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {

  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppThemePreferences().appTheme.primaryColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
