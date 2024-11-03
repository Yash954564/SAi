import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/pages/crm_pages/crm_activities/activities_from_board.dart';
import 'package:houzi_package/pages/crm_pages/crm_deals/deals_from_board.dart';
import 'package:houzi_package/pages/crm_pages/crm_leads/leads_from_board.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/bottom_nav_bar_widgets/bottom_navigation_bar.dart';

import 'crm_inquiry/inquiries_from_board.dart';

class CRMBottomBar extends StatefulWidget {
  const CRMBottomBar({super.key});

  @override
  State<CRMBottomBar> createState() => _CRMBottomBarState();
}

class _CRMBottomBarState extends State<CRMBottomBar> {

  List<Widget> pageList = <Widget>[];

  Map<String, dynamic> bottomNavBarItemsMap = {
    "Activities": AppThemePreferences.activitiesIcon,
    "Inquiries": AppThemePreferences.inquiriesIcon,
    "Deals": AppThemePreferences.dealsIcon,
    "Leads": AppThemePreferences.leadsIcon,
  };

  bool showIndicatorWidget = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pageList.add(const ActivitiesFromBoard());
    pageList.add(InquiriesFromBoard());
    pageList.add(DealsFromBoard());
    pageList.add(const LeadsFromBoard());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _selectedIndex,
          children: pageList,
        ),
        bottomNavigationBar: BottomNavigationBarWidget(
          design: BOTTOM_NAVIGATION_BAR_DESIGN,
          currentIndex: _selectedIndex,
          itemsMap: bottomNavBarItemsMap,
          onTap: _onItemTapped,
          backgroundColor:
          AppThemePreferences().appTheme.bottomNavBarBackgroundColor,
          selectedItemColor: AppThemePreferences.bottomNavBarTintColor,
          unselectedItemColor:
          AppThemePreferences.unSelectedBottomNavBarTintColor,
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return Future.value(false);
    }
    return Future.value(true);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
