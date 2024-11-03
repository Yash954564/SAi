import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/pages/home_page_screens/home_carousel_related/home_carousel_widget.dart';
import 'package:houzi_package/pages/home_page_screens/home_elegant_related/home_elegant_widget.dart';
import 'package:houzi_package/pages/home_page_screens/home_location_related/home_location_widget.dart';
import 'package:houzi_package/pages/home_page_screens/home_tabbed_related/home_tabbed_widget.dart';

class HomeScreenUtilities {

  /// Using singleton pattern: to create only one instance of this class.
  static HomeScreenUtilities? _homeScreenUtilities;
  factory HomeScreenUtilities() {
    _homeScreenUtilities ??= HomeScreenUtilities._internal();
    return _homeScreenUtilities!;
  }

  HomeScreenUtilities._internal(){}

  Widget getHomeScreen({
    String? design,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }){
    if(design == null || design.isEmpty){
      // print("No design specified for 'Home Screen', so returning Home with "
      //     "design # 01...");
    }
    // else{
    //   print("Returning Home with $design...");
    // }

    if (design == DESIGN_01) { // home or home_0
      print("Building Home Carousel...");
      return HomeCarousel(scaffoldKey: scaffoldKey);
    }

    if (design == DESIGN_02) { // home_1
      print("Building Home Elegant...");
      return HomeElegant(scaffoldKey: scaffoldKey);
    }

    if (design == DESIGN_03) { // home_2
      print("Building Home Location...");
      return HomeLocation(scaffoldKey: scaffoldKey);
    }

    if (design == DESIGN_04) { // home_3
      print("Building Home Tabbed...");
      return HomeTabbed(scaffoldKey: scaffoldKey);
    }

    // Default Home
    // In case Design not Found or No Design Specified
    print("Building Home Carousel...");
    return HomeCarousel(scaffoldKey: scaffoldKey); // home or home_0
  }

  SystemUiOverlayStyle getSystemUiOverlayStyle({required String design}){
    // For Home Carousel
    if (design == DESIGN_01) {
      return SystemUiOverlayStyle(
        statusBarColor: AppThemePreferences().appTheme.homeScreenStatusBarColor,
        statusBarIconBrightness: AppThemePreferences().appTheme.statusBarIconBrightness,
        statusBarBrightness:AppThemePreferences().appTheme.statusBarBrightness,
      );
    }

    // For Home Elegant
    if (design == DESIGN_02) {
      return SystemUiOverlayStyle(
          statusBarColor: AppThemePreferences().appTheme.homeScreen02StatusBarColor,
          statusBarIconBrightness: AppThemePreferences().appTheme.statusBarIconBrightness,
          statusBarBrightness:AppThemePreferences().appTheme.statusBarBrightness
      );
    }

    // For Home Tabbed
    if (design == DESIGN_04) {
      return SystemUiOverlayStyle(
        statusBarColor: AppThemePreferences().appTheme.primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness:Brightness.light,
      );
    }

    // Default Home
    // For Home Carousel
    return SystemUiOverlayStyle(
      statusBarColor: AppThemePreferences().appTheme.homeScreenStatusBarColor,
      statusBarIconBrightness: AppThemePreferences().appTheme.statusBarIconBrightness,
      statusBarBrightness:AppThemePreferences().appTheme.statusBarBrightness,
    );
  }
}