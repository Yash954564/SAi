import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';

class AppThemePreferences {
  bool _isDark = false;

  // AppThemePreferences._internal(){}
  AppThemePreferences._internal();

  static AppThemePreferences? _appThemePreferences;

  factory AppThemePreferences() {
    _appThemePreferences ??= AppThemePreferences._internal();
    return _appThemePreferences!;
  }

  AppTheme _darkTheme = AppTheme(isDark: true);
  AppTheme _lightTheme = AppTheme(isDark: false);

  AppTheme get appTheme => _isDark ? _darkTheme : _lightTheme;

  void dark(bool darkMode) {
    _isDark = darkMode;
  }

  ///
  ///
  /// Card Elevation:
  ///
  ///
  static double globalCardElevation = 1.0;
  static double agentAgencyPageElevation = globalCardElevation;
  static double boardPagesElevation = globalCardElevation;
  static double articleDeignsElevation = 1.0;
  static double articleDeigns10Elevation = 5.0;
  static double savedSearchElevation = globalCardElevation;
  static double exploreCitiesHorizontalElevation = articleDeignsElevation;
  static double horizontalListForAgentsElevation = 1.0;
  static double horizontalListForAgenciesElevation =
      horizontalListForAgentsElevation;
  static double authorContactInformationElevation =
      horizontalListForAgentsElevation;
  static double reviewsElevation = globalCardElevation;
  static double exploreByTypeDesignElevation = articleDeignsElevation;
  static double appBarWidgetElevation = 1.0;
  static double popupMenuElevation = 1.0;
  static double zeroElevation = 0.0;
  static double membershipPackageCardElevation = 2.0;
  static double commentsElevation = globalCardElevation;
  static double notificationWidgetElevation = 1.0;
  static double messagePageElevation = globalCardElevation;

  ///
  ///
  /// TextStyle FontSizes:
  ///
  ///
  static double normalFontSize = 12.0;
  static double tagFontSize = 11.0;
  static double buttonFontSize = 18.0;
  static double headingFontSize = 20.0;
  static double heading01FontSize = 20.0;
  static double heading02FontSize = 20.0;
  static double titleFontSize = 18.0;
  static double labelFontSize = 16.0;
  static double label01FontSize = 14.0; // for small font labels
  static double label02FontSize = 18.0; // for colored labels
  static double label03FontSize = 18.0; // for grey labels
  static double heading03FontSize = 18.0;
  static double bodyFontSize = 14.0;
  static double body01FontSize = 16.0;
  static double body02FontSize = 14.0; // without any weight and height
  static double body03FontSize = 14.0; // without any weight and height
  static double linkFontSize = 14.0; // without any weight and height
  static double subBodyFontSize = 12.0;
  static double subBody01FontSize = 12.0;
  static double subTitleFontSize = 13.0;
  static double subTitle01FontSize = 11.0;
  static double articleReviewsTitleFontSize = 14.0;
  static double subTitle02FontSize = 11.0;
  static double hintFontSize = normalFontSize;
  static double toastTextFontSize = 14.0;
  static double readMoreFontSize = 14.0;
  static double searchByIdTextFontSize = 13.0;
  static double searchBarTextFontSize = 14; //normalFontSize;
  static double toggleSwitchTextFontSize = 14.0;
  static double homeScreenDrawerTextFontSize = 28.0;
  static double homeScreenDrawerUserNameTextFontSize = 18.0;
  static double homeScreenRecentSearchTitleFontSize = 16.0;
  static double homeScreenRecentSearchCityFontSize = 14.0;
  static double drawerMenuTextFontSize = 16.0;
  static double articleBoxPropertyStatusFontSize = normalFontSize;
  static double articleBoxPropertyPriceFontSize = normalFontSize;
  static double explorePropertyFontSize = 20.0;
  static double homeScreenRealtorTitleFontSize = 16.0;
  static double filterPageHeadingTitleFontSize = 18.0;
  static double locationWidgetFontSize = 17.0;
  static double tabBarTitleFontSize = 15.0;
  static double realtorPageTabBarTitleFontSize = 14.0;
  static double filterPageChoiceChipFontSize = 13.0;
  static double rangeSliderWidgetConversionUnitFontSize = normalFontSize;
  static double bottomSheetMenuTitleFontSize = 25.0;
  static double bottomSheetMenuTitle01FontSize = 24.0;
  static double bottomSheetMenuSubTitleFontSize = 14.0;
  static double bottomNavigationMenuItemsFontSize = 18.0;
  static double filterPageResetFontSize = 18.0;
  static double filterPageSearchButtonTextFontSize = 18.0;
  static double propertyDetailsPageTopBarTitleFontSize = 18.0;
  static double propertyDetailsPageImageIndicatorTextFontSize = normalFontSize;
  static double propertyDetailsPagePropertyTitleFontSize = 23.0; //25.0;
  static double propertyDetailsPagePropertyStatusFontSize = 18.0;
  static double propertyDetailsPagePropertyPriceFontSize = 18.0;
  static double propertyDetailsPagePropertyDetailFeaturesFontSize =
      normalFontSize;
  static double genericStatusBarTextFontSize = 18.0;
  static double cityPickerTextFontSize = 16.0;
  static double genericAppBarTextFontSize = 25.0;
  static double genericTabBarTextFontSize = 18.0;
  static double formFieldErrorTextFontSize = 12.0;
  static double appInfoTextFontSize = 16.0;
  static double risingLeadsTextFontSize = 18.0;
  static double fallingLeadsTextFontSize = 18.0;
  static double settingOptionsTextFontSize = 16.0;
  static double settingHeadingTextFontSize = 18.0;
  static double settingHeadingSubtitleTextFontSize = 14.0;
  static double aboutPageHeadingTextFontSize = 50.0;
  static double bottomSheetOptionsTextFontSize = 18.0;
  static double socialLoginTextFontSize = 16.0;
  static double sliverGreetingsTextFontSize = 30.0;
  static double sliverUserNameTextFontSize = 30.0;
  static double sliverQuoteTextFontSize = 18.0;
  static double searchResultsTotalResultsTextFontSize = 20.0;
  static double searchResultsShowingSortedTextFontSize = 12.0;
  static double appBarActionWidgetsTextFontSize = 20.0;
  static double filterPageTempTextPlaceHolderTextFontSize = 17.0;
  static double crmTypeHeadingTextFontSize = 13.0;
  static double crmHeadingTextFontSize = 17.0;
  static double crmNormalTextFontSize = 16.0;
  static double crmSubNormalTextFontSize = 14.0;
  static double crmActivitySubTitleTextFontSize = 12.0;
  static double crmActivityHeadingTextFontSize = 30.0;
  static double bottomActionBarFontSize = 12.0;
  static double membershipTitleFontSize = 16.0;
  static double membershipPriceFontSize = 70.0;
  static double membershipPackageNameFontSize = 20.0;
  static double membershipExpireFontSize = 17.0;
  static double privateNoteFontSize = 20.0;
  static double blogLayoutCategoryFontSize = 16.0;
  static double blogCommentAuthorNameFontSize = 20.0;
  static double blogCommentContentFontSize = 18.0;
  static double blogCommentActionsFontSize = 18.0;
  static double messageUserStatusFontSize = 17.0;

  ///
  ///
  /// TextStyle FontHeights:
  ///
  ///
  static double bodyTextHeight = 1.6;
  static double crmNormalTextHeight = 1.6;
  static double body01TextHeight = 1.5;
  static double linkTextHeight = 1.5;
  static double subTitle02TextHeight = 0.8;
  static double readMoreTextHeight = 1.6;
  static double subBody01TextHeight = 1.8;
  static double settingHeadingSubtitleTextHeight = 1.4;
  static double bottomSheetMenuTitle01TextHeight = 1.4;
  static double genericTextHeight = 1.0;
  static double blogCommentContentHeight = 1.0;

  ///
  ///
  /// TextStyle FontWeights:
  ///
  ///
  static FontWeight lightFontWeight = FontWeight.w300;
  static FontWeight boldFontWeight = FontWeight.bold;
  static FontWeight semiBoldWeight = FontWeight.w600;
  static FontWeight mediumWeight = FontWeight.w500;
  static FontWeight tagFontWeight = FontWeight.w400;
  static FontWeight headingFontWeight = FontWeight.w400;
  static FontWeight heading01FontWeight = headingFontWeight;
  static FontWeight heading02FontWeight = headingFontWeight;
  static FontWeight heading03FontWeight = FontWeight.w600;
  static FontWeight labelFontWeight = FontWeight.w500;
  static FontWeight label01FontWeight = FontWeight.w400;
  static FontWeight titleFontWeight = FontWeight.w600;
  static FontWeight bodyFontWeight = lightFontWeight;
  static FontWeight body01FontWeight = lightFontWeight;
  static FontWeight subBodyFontWeight = lightFontWeight;
  static FontWeight subBody01FontWeight = lightFontWeight;
  static FontWeight subTitleFontWeight = lightFontWeight;
  static FontWeight subTitle01FontWeight = boldFontWeight;
  static FontWeight subTitle02FontWeight = lightFontWeight;
  static FontWeight searchByIdTextFontWeight = boldFontWeight;
  static FontWeight homeScreenDrawerTextFontWeight = boldFontWeight;
  static FontWeight drawerMenuTextFontWeight = FontWeight.w400;
  static FontWeight articleBoxPropertyStatusFontWeight = boldFontWeight;
  static FontWeight articleBoxPropertyPriceFontWeight = headingFontWeight;
  static FontWeight explorePropertyFontWeight = headingFontWeight;
  static FontWeight homeScreenRealtorTitleFontWeight = headingFontWeight;
  static FontWeight filterPageHeadingTitleFontWeight = tagFontWeight;
  static FontWeight locationWidgetFontWeight = headingFontWeight;
  static FontWeight tabBarTitleFontWeight = labelFontWeight;
  static FontWeight filterPageChoiceChipFontWeight = lightFontWeight;
  static FontWeight rangeSliderWidgetConversionUnitFontWeight = tagFontWeight;
  static FontWeight propertyDetailsPageTopBarTitleFontWeight = mediumWeight;
  static FontWeight propertyDetailsPageImageIndicatorTextFontWeight =
      headingFontWeight;
  static FontWeight propertyDetailsPagePropertyTitleFontWeight =
      FontWeight.w500;
  static FontWeight propertyDetailsPagePropertyStatusFontWeight =
      headingFontWeight;
  static FontWeight propertyDetailsPagePropertyPriceFontWeight =
      headingFontWeight;
  static FontWeight propertyDetailsPagePropertyDetailFeaturesFontWeight =
      labelFontWeight;
  static FontWeight readMoreFontWeight = labelFontWeight;
  static FontWeight genericStatusBarTextFontWeight = headingFontWeight;
  static FontWeight appInfoTextFontWeight = FontWeight.w500;
  static FontWeight genericAppBarTextFontWeight = headingFontWeight;
  static FontWeight genericTabBarTextFontWeight = headingFontWeight;
  static FontWeight settingOptionsTextFontWeight = FontWeight.w500;
  static FontWeight settingHeadingTextFontWeight = FontWeight.bold;
  static FontWeight settingHeadingSubtitleTextFontWeight = FontWeight.w400;
  static FontWeight aboutPageHeadingTextFontWeight = FontWeight.w200;
  static FontWeight reviewTitleFontWeight = mediumWeight;
  static FontWeight bottomSheetOptionsTextFontWeight = FontWeight.w400;
  static FontWeight bottomSheetEmphasisOptionsTextFontWeight = FontWeight.w500;
  static FontWeight sliverUserNameTextFontWeight = FontWeight.bold;
  static FontWeight searchResultsTotalResultsTextFontWeight = FontWeight.bold;
  static FontWeight filterPageTempTextPlaceHolderTextFontWeight =
      FontWeight.w400;
  static FontWeight crmHeadingTextFontWeight = FontWeight.w500;
  static FontWeight crmNormalTextFontWeight = FontWeight.w100;
  static FontWeight blogAuthorInfoTextFontWeight = FontWeight.bold;
  static FontWeight blogCommentAuthorNameFontWeight = FontWeight.bold;
  static FontWeight messageUserStatusFontWeight = FontWeight.w500;

  ///
  ///
  /// TextStyle FontStyle:
  ///
  ///
  static FontStyle risingLeadsTextFontStyle = FontStyle.normal;
  static FontStyle fallingLeadsTextFontStyle = FontStyle.normal;

  ///
  ///
  /// Brightness:
  ///
  ///
  /// Brightness Light:
  ///
  /// System Brightness Light:
  static Brightness systemBrightnessLight = Brightness.light;

  ///
  /// Status Bar Icons Brightness Light:
  static Brightness statusBarIconBrightnessLight = Brightness.light;

  ///
  /// Generic Status Bar Icons Brightness Light:
  static Brightness genericStatusBarIconBrightnessLight = Brightness.light;

  ///
  ///
  /// Brightness Dark:
  ///
  /// System Brightness Dark:
  static Brightness systemBrightnessDark = Brightness.dark;

  ///
  /// Status Bar Icons Brightness Dark:
  static Brightness statusBarIconBrightnessDark = Brightness.dark;

  ///
  /// Generic Status Bar Icons Brightness Dark:
  static Brightness genericStatusBarIconBrightnessDark = Brightness.light;

  ///
  ///
  /// System Ui Overlay Style:
  ///
  ///
  /// System Ui Overlay Style Light:
  static SystemUiOverlayStyle systemUiOverlayStyleLight =
      SystemUiOverlayStyle.light;

  ///
  /// System Ui Overlay Style Dark:
  static SystemUiOverlayStyle systemUiOverlayStyleDark =
      SystemUiOverlayStyle.dark;

  ///
  ///
  /// Colors:
  ///
  ///
  /// Primary Color Swatch of App:
  static MaterialColor appPrimaryColorSwatch = primaryColorSwatch;

  ///
  /// Secondary Color Swatch of App:
  static MaterialColor appSecondaryColorSwatch = secondaryColorSwatch;

  ///
  /// Primary Color of App:
  static Color appPrimaryColor = Color(0xFF1BB1B1);

  ///
  /// Secondary Color of App:
  static Color appSecondaryColor = Color(0xFF1BB1B1);

  ///
  /// Master Color of App Icons:
  static Color appIconsMasterColorLight = appSecondaryColor;

  ///
  /// Master Color of App Icons:
  static Color appIconsMasterColorDark = Color(0xFF868a8d);

  ///
  /// Selected Item Text Color:
  static Color selectedItemTextColorLight = appSecondaryColor;

  ///
  /// Selected Item Text Color:
  static Color? selectedItemTextColorDark = Colors.grey[400];

  ///
  /// Un-Selected Item Text Color:
  static Color unSelectedItemTextColorLight = Colors.black54;

  ///
  /// Un-Selected Item Text Color:
  static Color? unSelectedItemTextColorDark = Colors.grey[800];

  ///
  /// Selected Item Background Color:
  static Color selectedItemBackgroundColorLight =
      appSecondaryColor.withOpacity(0.3);

  ///
  /// Selected Item Background Color:
  static Color? selectedItemBackgroundColorDark = Colors.grey[800];

  ///
  /// Un-Selected Item Background Color Light:
  static Color? unSelectedItemBackgroundColorLight = Colors.grey[100];

  ///
  /// Un-Selected Item Background Color:
  static Color? unSelectedItemBackgroundColorDark = Colors.grey[600];

  ///
  /// Search Dialog Background Color:
  static Color searchDialogBackgroundColor = Colors.black54;

  ///
  /// Link Color:
  static Color linkColor = appSecondaryColor;

  ///
  /// Error Color:
  static Color? errorColor = Colors.red[700];

  ///
  /// HomeScreen Toggle Switch Selected Background color
  static Color switchSelectedBackgroundLight =
      appSecondaryColor.withOpacity(0.3);

  /// HomeScreen Toggle Switch Selected Background color
  static Color? switchSelectedBackgroundDark = Colors.grey[800];

  ///
  /// HomeScreen Toggle Switch Un-Selected Background color
  static Color? switchUnselectedBackgroundLight = Colors.grey[300];

  /// HomeScreen Toggle Switch Un-Selected Background color
  static Color? switchUnselectedBackgroundDark = Colors.grey[600];

  ///
  /// HomeScreen Toggle Switch Background color
  static Color switchUnselectedTextLight = unSelectedItemTextColorLight;

  /// HomeScreen Toggle Switch Un-Selected Text color
  static Color? switchUnselectedTextDark = Colors.grey[800];

  ///
  /// HomeScreen Toggle Switch Selected Text color
  static Color switchSelectedTextLight = appSecondaryColor;

  ///
  /// HomeScreen Toggle Switch Selected Text color
  static Color? switchSelectedTextDark = Colors.grey[400];

  ///
  /// Search Bar Background color Light
  static Color searchBarBackgroundColorLight = Colors.white;

  ///
  /// Search Bar 02 Background color Light
  static Color? searchBar02BackgroundColorLight = containerBackgroundColorLight;

  ///
  /// Search Bar Background color Dark
  static Color searchBarBackgroundColorDark = Color(0xFF3a3b3d);

  ///
  /// Rating Widget Stars color
  static Color ratingWidgetStarsColor = Colors.amber;

  ///
  /// Favourite Icon color
  static Color favouriteIconColor = Colors.red;

  ///
  /// Filled Button Icon color
  static Color filledButtonIconColor = Colors.white;

  ///
  /// Email Button Background color
  static Color emailButtonBackgroundColor = actionButtonBackgroundColor;

  ///
  /// Call Button Background color
  static Color callButtonBackgroundColor = Colors.green;

  ///
  /// Message Button Background color
  static Color messageButtonBackgroundColor = Colors.orange;

  ///
  /// WhatsApp Button Background color
  static Color whatsAppBackgroundColor = const Color(0xFF25D366);

  ///
  /// Line Button Background color
  static Color lineAppBackgroundColor = const Color(0xFF39CD00);

  ///
  /// Telegram Button Background color
  static Color telegramBackgroundColor = const Color(0xFF1C8ADB);

  ///
  /// Cancel Button Background color
  static Color cancelButtonBackgroundColor = Colors.white;

  ///
  /// Filled Button Text color
  static Color filledButtonTextColor = Colors.white;

  ///
  /// Count Indicators color
  static Color? countIndicatorsColor = Colors.grey[400];

  ///
  /// Image Count Indicator Background color
  static Color imageCountIndicatorBackgroundColor = Colors.white;

  ///
  /// Property Details Chips Icon color
  static Color propertyDetailsChipsIconColor = Colors.grey;

  ///
  /// Property Details Chips Icon color
  static Color? savedSearchDefaultIconColor = Colors.grey[400];

  ///
  /// Property Details Chips Icon color
  static Color label02TextColor = appSecondaryColor;

  ///
  /// User Profile Sub Text color
  static Color label03TextColor = Colors.grey;

  ///
  /// Button Icon Text color
  static Color buttonIconColor = Colors.white;

  ///
  /// Toast Background color
  static Color? toastBackgroundColor = Colors.grey[800];

  ///
  /// Toast Text color
  static Color toastTextColor = Colors.white;

  ///
  /// Toast Button Background color
  static Color? toastButtonBackgroundColor = Colors.grey[800];

  // static Color toastButtonBackgroundColor = appPrimaryColor;
  ///
  /// Remove Circle Icon color
  static Color removeCircleIconColor = Colors.red;

  ///
  /// Add Property Media Star Icon color
  static Color starIconColor = appPrimaryColor;

  ///
  /// No Internet Bottom Action Bar Background color
  static Color noInternetBottomActionBarBackgroundColor = Colors.red;

  ///
  /// Rising Leads Text Font color
  static Color risingLeadsColor = Colors.green;

  ///
  /// Falling Leads Text Font color
  static Color fallingLeadsColor = Colors.red;

  ///
  /// Shimmer Loading Widget Container color
  static Color shimmerLoadingWidgetContainerColor = Colors.white;

  ///
  /// Radio Active Color
  static Color radioActiveColor = appPrimaryColor;

  ///
  /// Bottom Sheet Options Text Color
  static Color bottomSheetOptionsTextColor = appPrimaryColor;

  ///
  /// Bottom Sheet Negative Options Text Color
  static Color? bottomSheetNegativeOptionsTextColor = errorColor;

  ///
  /// Tab bar indicator Color
  static Color tabBarIndicatorColor = Colors.white;

  ///
  /// Bottom Tab Bar Tint Color
  static Color bottomNavBarTintColor = appPrimaryColor;

  ///
  /// Bottom Tab Bar Tint Color
  static Color unSelectedBottomNavBarTintColor = Color(0xFF737373);

  ///
  /// App bottom bar background color
  static Color bottomNavBarBackgroundColorLight = Color(0xFFFAFAFA);

  ///
  /// Slider Tint Color
  static Color sliderTintColor = appSecondaryColor;

  ///
  /// Action Button Background Color
  static Color actionButtonBackgroundColor = appPrimaryColor;

  ///
  /// Form Field Border Color
  static Color formFieldBorderColor = appPrimaryColor;

  ///
  /// AppBar Action Widgets Text Font Color
  static Color appBarActionWidgetsTextFontColor = Colors.white;

  ///
  /// Blog Layout Category Font Color
  static Color blogLayoutCategoryFontColor = appPrimaryColor;

  ///
  /// Blog Layout Time Icon Color
  static Color blogLayoutTimeIconColor = const Color(0xFF737373);

  ///
  /// Blog Layout Time Icon Color
  static Color blogCommentActionsColor = Colors.grey;

  ///
  /// Blog Post Comment Icon Color
  static Color blogPostCommentColor = Colors.white;

  ///
  /// Notification Widget Icon Color
  static Color notificationWidgetIconColor = Colors.grey;

  ///
  /// Notification Widget Icon Bg Color
  static Color notificationWidgetIconBgColor = Colors.white;

  ///
  /// Notification Dot Color
  static Color notificationDotColor = Colors.red;

  ///
  /// Message Time Icon Color
  static Color? messageTimeIconColor = Colors.grey[500];

  ///
  /// Send Message Icon Color
  static Color sendMessageIconColor = Colors.white;

  ///
  /// Message User Status Online Color
  static Color messageUserStatusOnlineColor = Colors.green;

  ///
  /// Message User Status Offline Color
  static Color messageUserStatusOfflineColor = Colors.red;

  ///
  /// Message Sender BG Color
  static Color messageSenderBgColor = appPrimaryColorSwatch[200]!;

  ///
  ///
  /// Light Mode Colors:
  ///
  ///
  /// TextStyle related Light Colors:
  static Color? normalTextColorLight = Colors.grey[900];
  static Color tagTextColorLight = Colors.black;
  static Color? featuredTagTextColorLight = Colors.black;
  static Color tag02TextColorLight = Colors.black;
  static Color buttonTextColorLight = Colors.white;
  static Color? headingTextColorLight = Colors.grey[600];
  static Color labelTextColorLight = Colors.black;
  static Color? label01TextColorLight = normalTextColorLight;
  static Color? label04TextColorLight = Colors.grey[600];
  static Color titleTextColorLight = Colors.black;
  static Color bodyTextColorLight = Colors.black;
  static Color body03TextColorLight = appPrimaryColor;
  static Color subBodyTextColorLight = Colors.black;
  static Color? subBody01TextColorLight = normalTextColorLight;
  static Color? subBody05TextColorLight = Colors.white;
  static Color? subTitleTextColorLight = Colors.grey[600];
  static Color? subTitle01TextColorLight = Colors.grey[800];
  static Color subTitle02TextColorLight = Colors.black;
  static Color readMoreTextColorLight = appSecondaryColor;
  static Color searchByIdTextColorLight = appSecondaryColor;
  static Color searchBarTextColorLight = unSelectedItemTextColorLight;
  static Color homeScreenRecentSearchTitleColorLight = appSecondaryColor;
  static Color? homeScreenRecentSearchCityColorLight = Colors.grey[600];
  static Color articleBoxPropertyStatusColorLight = appSecondaryColor;
  static Color articleBoxPropertyPriceColorLight = Colors.black;
  static Color explorePropertyColorLight = appSecondaryColor;
  static Color propertyDetailsPagePropertyStatusColorLight = appSecondaryColor;
  static Color? propertyDetailsPagePropertyPriceColorLight =
      normalTextColorLight;
  static Color genericStatusBarTextColorLight = Colors.white;
  static Color genericAppBarTextColorLight = Colors.white;
  static Color genericTabBarTextColorLight = Colors.white;
  static Color? appInfoTextColorLight = Colors.grey[600];
  static Color hintColorLight = Colors.black54;
  static Color facebookSignInButtonTextColorLight = Colors.white;
  static Color? googleSignInButtonTextColorLight = normalTextColorLight;
  static Color appleSignInButtonTextColorLight = Colors.white;
  static Color sliverGreetingsTextColorLight = Colors.white;
  static Color sliverUserNameTextColorLight = Colors.white;
  static Color? sliverQuoteTextColorLight = Colors.grey[300];
  static Color? searchResultsShowingSortedTextColorLight = Colors.grey[600];
  static Color? filterPageTitleHeadingTextColorLight = Colors.grey[600];
  static Color? filterPageTempTextPlaceHolderTextColorLight =
      normalTextColorLight;
  static Color? crmTypeHeadingTextColorLight = Color(0xFF898993);
  static Color? crmHeadingTextColorLight = Color(0xFF46455D);
  static Color? crmNormalTextColorLight = Color(0xFF44445C);
  static Color? crmSubNormalTextColorLight = Color(0xFF898993);
  static Color? crmIconColorLight = Color(0xFFB8B8C1);
  static Color? activitySubTitleTextColorLight = Colors.grey;
  static Color? activityHeadingTextColorLight = Colors.black;
  static Color? membershipTitleTextColorLight = Colors.black;
  static Color? membershipPriceTextColorLight = Colors.black;
  static Color? membershipPackageNameTextColorLight = Colors.black;
  static Color? membershipExpireTextColorLight = Colors.grey[700];
  static Color? cupertinoSegmentThumbColorLight = Colors.white;
  static Color? privateNoteColorLight = Colors.black;
  static Color? messagesTextColorLight = normalTextColorLight;

  ///
  /// Generic Status Bar color
  static Color genericStatusBarColorLight = Colors.transparent;

  ///
  /// Generic Status Bar Icons color
  static Color genericAppBarIconsColorLight = Colors.white;

  ///
  /// HomeScreen Status Bar color
  static Color? homeScreenStatusBarColorLight = Colors.grey[200];

  ///
  /// HomeScreen Status Bar color
  static Color homeScreen02StatusBarColorLight = Colors.white;

  ///
  /// SliverAppBar Background color
  static Color? sliverAppBarBackgroundColorLight = Colors.grey[200];

  ///
  /// SliverAppBar Background color
  static Color sliverAppBar02BackgroundColorLight =
      homeScreen02StatusBarColorLight;

  ///
  /// Background color
  static Color backgroundColorLight = Colors.white;

  ///
  /// Divider color
  static Color dividerColorLight = Color(0x1F000000);

  ///
  /// Card color
  static Color cardColorLight = Colors.white;

  ///
  /// Shimmer Effect Base color
  static Color? shimmerEffectBaseColorLight = Colors.grey[300];

  ///
  /// Shimmer Effect HighLight color
  static Color? shimmerEffectHighLightColorLight = Colors.grey[100];

  ///
  /// Shimmer Effect Error Widget Background color
  static Color? shimmerEffectErrorWidgetBackgroundColorLight = Colors.grey[100];

  ///
  /// Shimmer Effect Image Error Icon color
  static Color? shimmerEffectErrorIconColorLight = Colors.grey[300];

  ///
  /// Drawer Menu Icon color
  static Color drawerMenuIconColorLight = appSecondaryColor;

  ///
  /// Drawer Menu Icon color
  static Color drawerMenu02IconColorLight = Colors.black;

  ///
  /// HomeScreen Top Bar Location Icon color
  static Color homeScreenTopBarLocationIconColorLight = appSecondaryColor;

  ///
  /// HomeScreen Top Bar Right Arrow Icon color
  static Color homeScreenTopBarRightArrowIconColorLight = Colors.white;

  ///
  /// HomeScreen Top Bar Right Arrow Icon color
  static Color homeScreenTopBarDownArrowIconColorLight = appSecondaryColor;

  ///
  /// HomeScreen Top Bar Right Arrow Icon Background color
  static Color homeScreenTopBarRightArrowBackgroundColorLight =
      appSecondaryColor;

  ///
  /// HomeScreen Top Bar Search Icon color
  static Color homeScreenTopBarSearchIconColorLight = appSecondaryColor;

  ///
  /// HomeScreen Search Bar Search Icon color
  static Color homeScreenSearchBarIconColorLight = unSelectedItemTextColorLight;

  // static Color homeScreenSearchBarIconColorLight = Colors.black;
  ///
  /// HomeScreen Drawer Text color
  static Color homeScreenDrawerTextColorLight = Colors.white;

  ///
  /// Featured Tag Background color
  static Color? featuredTagBackgroundColorLight = Colors.grey[100];

  ///
  /// Featured Tag Border color
  static Color featuredTagBorderColorLight = appSecondaryColor.withOpacity(0.6);

  ///
  /// Tag Background color
  static Color? tagBackgroundColorLight = Colors.grey[100];

  ///
  /// Tag Border color
  static Color tagBorderColorLight = const Color(0x1F000000);

  ///
  /// Property Status Tag Background color
  static Color propertyStatusTagBackgroundColorLight =
      Colors.black.withOpacity(0.5);

  ///
  /// Article Box Icons color
  static Color articleBoxIconsColorLight = appSecondaryColor;

  ///
  /// Filter Page Icons color
  static Color filterPageIconsColorLight = appSecondaryColor;

  ///
  /// Location Widget Text color
  static Color locationWidgetTextColorLight = appSecondaryColor;

  ///
  /// Bottom Navigation Menu color
  static Color bottomNavigationMenuColorLight = Colors.white;

  ///
  /// Property Details Page Top bar Divider color
  static Color? propertyDetailsPageTopBarDividerColorLight = Colors.grey[300];

  ///
  /// Property Details Page Top bar Shadow color
  static Color propertyDetailsPageTopBarShadowColorLight = Colors.grey;

  ///
  /// Property Details Page Top bar Icons color
  static Color propertyDetailsPageTopBarIconsColorLight = Colors.black;

  ///
  /// Property Details Page Top bar Icons Background color
  static Color propertyDetailsPageTopBarIconsBackgroundColorLight =
      Colors.white;

  ///
  /// Property Details Image Indicator Camera Icon color
  static Color propertyDetailsImageIndicatorCameraIconColorLight = Colors.black;

  ///
  /// Property Details Page Image Indicator Text color
  static Color propertyDetailsPageImageIndicatorTextColorLight = Colors.black;

  ///
  /// Property Details Page Container Background color
  static Color? containerBackgroundColorLight = Colors.grey[100];

  ///
  /// Property Details Page Chips Background color
  static Color? propertyDetailsPageChipsBackgroundColorLight = Colors.grey[200];

  ///
  /// Favourite Widget Background color
  static Color favouriteWidgetBackgroundColorLight = Colors.white;

  ///
  /// Facebook Sign-In Button Background color
  static Color facebookSignInButtonColorLight = Color(0xFF1877f2);

  ///
  /// Google Sign-In Button Background color
  static Color googleSignInButtonColorLight = Color(0xFFD9D9D9);

  ///
  /// Apple Sign-In Button Background color
  static Color appleSignInButtonColorLight = Colors.black;

  ///
  /// Search Page Choice chips Background color
  static Color? searchPageChoiceChipsBackgroundColorLight = Colors.grey[100];

  ///
  /// Home Screen Search Arrow Icon Background color
  static Color homeScreenSearchArrowIconBackgroundColorLight = Colors.white;

  ///
  /// Article Design Item Background color
  static Color articleDesignItemBackgroundColorLight = Colors.white;

  ///
  /// Recent Searches Border color
  static Color recentSearchesBorderColorLight = const Color(0x1F000000);

  ///
  /// Bottom Sheet Bg color
  static Color bottomSheetBgColorLight = const Color(0xFFFAFAFA);

  ///
  /// Choice Chips Bg color
  static Color choiceChipsBgColorLight = const Color(0xFFEEEEEE);

  ///
  /// Pop Up Menu Bg color
  static Color popUpMenuBgColorLight = const Color(0xFFFFFFFF);

  ///
  /// Dropdown Menu Bg color
  static Color dropdownMenuBgColorLight = const Color(0xFFFAFAFA);

  ///
  /// Dialog Bg color
  static Color dialogBgColorLight = const Color(0xFFFFFFFF);

  ///
  /// Popup Menu Bg color
  static Color popupMenuBgColorLight = const Color(0xFFFFFFFF);

  ///
  /// Notification Widget Bg Color Light
  static Color notificationWidgetBgColorLight = const Color(0xFFEEF1F4);

  ///
  /// Message Receiver Bg Color Light
  static Color messageReceiverBgColorLight = const Color(0xFFF1F1F1);

  ///
  /// Message Scroll Down FAB Bg Color Light
  static Color messageScrollPageFABBgColorLight = const Color(0xFFF1F1F1);

  ///
  /// Message Time Bg Color Light
  static Color messageTimeBgColorLight = const Color(0xFFF7F7F8);

  ///
  /// Message Time Text Color Light
  static Color messageTimeTextColorLight = const Color(0xFF838488);

  ///
  /// Message Text Field Outer Bg Color Light
  static Color messageTextFieldOuterBgColorLight = const Color(0xFFF1F1F1);

  ///
  /// Message Text Field Inner Bg Color Light
  static Color messageTextFieldInnerBgColorLight = const Color(0xFFFFFFFF);

  ///
  /// Send Message Icon Color Light
  static Color sendMessageIconColorLight = Colors.white;

  ///
  /// Send Message App Bar Bg Color Light
  static Color sendMessageAppBarBgColorLight =
      AppThemePreferences.appPrimaryColor;

  ///
  /// Dark Mode Colors:
  ///
  ///
  ///TextStyle related Dark Colors:
  static Color? normalTextColorDark = Colors.grey[400];
  static Color? tagTextColorDark = Colors.grey[400];
  static Color? featuredTagTextColorDark = Colors.grey[400];
  static Color? buttonTextColorDark = Colors.grey[300];
  static Color? headingTextColorDark = Colors.grey[400];
  static Color? labelTextColorDark = Colors.grey[300];
  static Color titleTextColorDark = Color(0xFFe1e2e6);

  // static Color titleTextColorDark = Colors.grey[300];
  static Color bodyTextColorDark = Color(0xFFcfd0d4);

  // static Color bodyTextColorDark = Colors.grey[300];
  static Color body03TextColorDark = appPrimaryColor;
  static Color subBodyTextColorDark = bodyTextColorDark;
  static Color subTitle01TextColorDark = bodyTextColorDark;
  static Color subTitle02TextColorDark = bodyTextColorDark;

  // static Color subBodyTextColorDark = Colors.grey[300];
  // static Color subTitle01TextColorDark = Colors.grey[300];
  // static Color subTitle02TextColorDark = Colors.grey[300];
  static Color? label01TextColorDark = normalTextColorDark;
  static Color? subBody01TextColorDark = normalTextColorDark;
  static Color readMoreTextColorDark = appSecondaryColor;
  static Color searchByIdTextColorDark = searchBarTextColorDark;
  static Color searchBarTextColorDark = Color(0xFFb2b3b6);

  // static Color homeScreenSearchBarTextColorDark = unSelectedItemTextColorLight;
  static Color homeScreenRecentSearchTitleColorDark = appSecondaryColor;
  static Color? homeScreenRecentSearchCityColorDark = Colors.grey[600];
  static Color articleBoxPropertyStatusColorDark = appIconsMasterColorDark;

  // static Color articleBoxPropertyStatusColorDark = appPrimaryColor;
  static Color articleBoxPropertyPriceColorDark = bodyTextColorDark;

  // static Color articleBoxPropertyPriceColorDark = Colors.white;
  static Color explorePropertyColorDark = appSecondaryColor;
  static Color propertyDetailsPagePropertyStatusColorDark = appSecondaryColor;
  static Color? propertyDetailsPagePropertyPriceColorDark = normalTextColorDark;
  static Color? genericStatusBarTextColorDark = Colors.grey[400];
  static Color? genericAppBarTextColorDark = Colors.grey[300];
  static Color? genericTabBarTextColorDark = Colors.grey[300];
  static Color hintColorDark = Colors.grey;
  static Color? appInfoTextColorDark = Colors.grey[600];
  static Color? facebookSignInButtonTextColorDark = normalTextColorDark;
  static Color? googleSignInButtonTextColorDark = normalTextColorDark;
  static Color? appleSignInButtonTextColorDark = normalTextColorDark;
  static Color sliverGreetingsTextColorDark = Colors.white;
  static Color sliverUserNameTextColorDark = Colors.white;
  static Color? sliverQuoteTextColorDark = Colors.grey[300];
  static Color? searchResultsShowingSortedTextColorDark = normalTextColorDark;
  static Color? filterPageTitleHeadingTextColorDark = Colors.grey[600];
  static Color? filterPageTempTextPlaceHolderTextColorDark =
      normalTextColorDark;
  static Color? crmTypeHeadingTextColorDark = normalTextColorDark;
  static Color? crmHeadingTextColorDark = normalTextColorDark;
  static Color? crmNormalTextColorDark = normalTextColorDark;
  static Color? crmIconColorDark = normalTextColorDark;
  static Color? membershipTitleTextColorDark = normalTextColorDark;
  static Color? membershipPriceTextColorDark = normalTextColorDark;
  static Color? membershipPackageNameTextColorDark = normalTextColorDark;
  static Color? membershipExpireTextColorDark = normalTextColorDark;
  static Color? cupertinoSegmentThumbColorDark = normalTextColorDark;
  static Color? privateNoteColorDark = normalTextColorDark;
  static Color? filterPageTextColorDark = Colors.grey[500];
  static Color? messagesTextColorDark = Colors.white;

  ///
  /// Generic Status Bar color
  static Color genericStatusBarColorDark = Colors.transparent;

  ///
  /// Generic Status Bar Icons color
  static Color? genericAppBarIconsColorDark = Colors.grey[300];

  ///
  /// HomeScreen Status Bar color
  static Color homeScreenStatusBarColorDark = Color(0XFF242527);

  // static Color homeScreenStatusBarColorDark =  Colors.white10;
  ///
  /// SliverAppBar Background color
  static Color sliverAppBarBackgroundColorDark = Color(0XFF242527);

  // static Color sliverAppBarBackgroundColorDark =  Colors.white10;
  // static Color sliverAppBarBackgroundColorDark =  Colors.white24;
  ///
  /// Background color
  static Color backgroundColorDark = const Color(0xFF18191B);

  // static Color backgroundColorDark =  Colors.black;
  ///
  /// Divider color
  static Color dividerColorDark = Color(0x1FFFFFFF);

  ///
  /// Card color
  static Color cardColorDark = Color(0XFF242527);

  // static Color cardColorDark =  Colors.grey[800];
  ///
  /// Shimmer Effect Base color
  static Color? shimmerEffectBaseColorDark = Colors.grey[850];

  ///
  /// Shimmer Effect HighLight color
  static Color? shimmerEffectHighLightColorDark = Colors.grey[600];

  ///
  /// Shimmer Effect Error Widget Background color
  static Color? shimmerEffectErrorWidgetBackgroundColorDark = Colors.grey[100];

  ///
  /// Shimmer Effect Image Error Icon color
  static Color? shimmerEffectErrorIconColorDark = Colors.grey[300];

  ///
  /// Drawer Menu Icon color
  static Color drawerMenuIconColorDark = appIconsMasterColorDark;

  ///
  /// HomeScreen Top Bar Location Icon color
  static Color homeScreenTopBarLocationIconColorDark = appIconsMasterColorDark;

  // static Color homeScreenTopBarLocationIconColorDark = appPrimaryColor;
  ///
  /// HomeScreen Top Bar Right Arrow Icon color
  static Color homeScreenTopBarRightArrowIconColorDark = Colors.white;

  ///
  /// HomeScreen Top Bar Right Arrow Icon Background color
  static Color homeScreenTopBarRightArrowBackgroundColorDark =
      appIconsMasterColorDark;

  // static Color homeScreenTopBarRightArrowBackgroundColorDark = appPrimaryColor;
  ///
  /// HomeScreen Top Bar Search Icon color
  static Color homeScreenTopBarSearchIconColorDark = appIconsMasterColorDark;

  // static Color homeScreenTopBarSearchIconColorDark = appPrimaryColor;
  ///
  /// Search Bar Icon color
  static Color searchBarIconColorDark = Color(0xFF626365);

  ///
  /// HomeScreen Search Bar Search Icon color
  static Color homeScreenSearchBarIconColorDark = searchBarIconColorDark;

  // static Color homeScreenSearchBarIconColorDark = unSelectedItemTextColorLight;
  // static Color homeScreenSearchBarIconColorDark = Colors.black;
  ///
  /// HomeScreen Drawer Text color
  static Color homeScreenDrawerTextColorDark = Colors.white;

  ///
  /// Featured Tag Background color
  static Color featuredTagBackgroundColorDark = const Color(0xFF3A3B3D);

  ///
  /// Featured Tag Border color
  static Color featuredTagBorderColorDark = appSecondaryColor.withOpacity(0.6);

  ///
  /// Tag Background color
  static Color tagBackgroundColorDark = const Color(0xFF3A3B3D);

  ///
  /// Tag Border color
  static Color tagBorderColorDark = const Color(0x1FFFFFFF);

  ///
  /// Property Status Tag Background color
  static Color propertyStatusTagBackgroundColorDark = tagBackgroundColorDark;

  ///
  /// Article Box Icons color
  static Color articleBoxIconsColorDark = appIconsMasterColorDark;

  // static Color articleBoxIconsColorDark = appPrimaryColor;
  ///
  /// Filter Page Icons color
  static Color filterPageIconsColorDark = appIconsMasterColorDark;

  // static Color filterPageIconsColorDark = Colors.grey;
  ///
  /// Location Widget Text color
  static Color locationWidgetTextColorDark = appSecondaryColor;

  ///
  /// Bottom Navigation Menu color
  static Color bottomNavigationMenuColorDark = backgroundColorDark;

  // static Color bottomNavigationMenuColorDark = Colors.black12;
  ///
  /// Property Details Page Top bar Divider color
  static Color? propertyDetailsPageTopBarDividerColorDark = Colors.grey[700];

  ///
  /// Property Details Page Top bar Shadow color
  static Color? propertyDetailsPageTopBarShadowColorDark = Colors.grey[800];

  ///
  /// Property Details Page Top bar Icons color
  static Color propertyDetailsPageTopBarIconsColorDark = Colors.black;

  ///
  /// Property Details Page Top bar Icons Background color
  static Color? propertyDetailsPageTopBarIconsBackgroundColorDark =
      Colors.grey[300];

  ///
  /// Property Details Image Indicator Camera Icon color
  static Color propertyDetailsImageIndicatorCameraIconColorDark = Colors.black;

  ///
  /// Property Details Page Image Indicator Text color
  static Color propertyDetailsPageImageIndicatorTextColorDark = Colors.black;

  ///
  /// Property Details Page Container Background color
  static Color containerBackgroundColorDark =
      Color(0xFF3a3b3d); //Colors.white10;
  ///
  /// Property Details Page Chips Background color
  static Color? propertyDetailsPageChipsBackgroundColorDark = Colors.grey[900];

  ///
  /// Favourite Widget Background color
  static Color? favouriteWidgetBackgroundColorDark = Colors.grey[300];

  ///
  /// Facebook Sign-In Button Background color
  static Color facebookSignInButtonColorDark = Color(0xFF0a3061);

  // static Color facebookSignInButtonColorDark = Color(0xFF1877f2);
  ///
  /// Google Sign-In Button Background color
  static Color googleSignInButtonColorDark = cardColorDark;

  ///
  /// Apple Sign-In Button Background color
  static Color appleSignInButtonColorDark = cardColorDark;

  ///
  /// Search Page Choice chips Background color
  static Color searchPageChoiceChipsBackgroundColorDark = Colors.white10;

  ///
  /// Home Screen Search Arrow Icon Background color
  static Color homeScreenSearchArrowIconBackgroundColorDark = Colors.white;

  ///
  /// App bottom bar background color
  static Color bottomNavBarBackgroundColorDark = Color(0xFF303030);

  ///
  /// Article Design Item Background color
  static Color articleDesignItemBackgroundColorDark = cardColorDark;

  ///
  /// Recent Searches Border color
  static Color recentSearchesBorderColorDark = const Color(0x1FFFFFFF);

  ///
  /// Bottom Sheet Bg color
  static Color bottomSheetBgColorDark = const Color(0xFF303030);

  ///
  /// Choice Chips Bg color
  static Color choiceChipsBgColorDark = const Color(0xFF757575);

  ///
  /// Pop Up Menu Bg color
  static Color popUpMenuBgColorDark = const Color(0xFF242527);

  ///
  /// Dropdown Menu Bg color
  static Color dropdownMenuBgColorDark = const Color(0xFF303030);

  ///
  /// Dialog Bg color
  static Color dialogBgColorDark = const Color(0xFF424242);

  ///
  /// Popup Menu Bg color
  static Color popupMenuBgColorDark = const Color(0xFF242527);

  ///
  /// Notification Widget Bg Color Dark
  static Color notificationWidgetBgColorDark = cardColorDark;

  ///
  /// Message Receiver Bg Color Dark
  static Color messageReceiverBgColorDark = const Color(0xFF232C33);

  ///
  /// Message Scroll Down FAB Bg Color Dark
  static Color messageScrollPageFABBgColorDark = const Color(0xFF232C33);

  ///
  /// Message Time Bg Color Dark
  static Color messageTimeBgColorDark = const Color(0xFF1E272E);

  ///
  /// Message Time Text Color Dark
  static Color messageTimeTextColorDark = const Color(0xFF959EA4);

  ///
  /// Message Text Field Outer Bg Color Dark
  static Color messageTextFieldOuterBgColorDark = const Color(0xFF0C1319);

  ///
  /// Message Text Field Inner Bg Color Dark
  static Color messageTextFieldInnerBgColorDark = const Color(0xFF232C33);

  ///
  /// Send Message Icon Color Dark
  static Color sendMessageIconColorDark = Colors.black;

  ///
  /// Send Message App Bar Bg Color Dark
  static Color sendMessageAppBarBgColorDark = const Color(0xFF0C1319);

  ///
  ///
  /// Icons:
  ///
  ///
  /// Icon Sizes:
  static double normalIconSize = 24.0;
  static double homeScreenTopBarLocationIconSize = 30.0;
  static double homeScreenTopBarLocationFilledIconSize = 20.0;
  static double homeScreenTopBarRightArrowIconSize = 14.0;
  static double homeScreenTopBarDownArrowIconSize = 18.0;
  static double propertyDetailPageRightArrowIconSize = 20.0;
  static double homeScreenTopBarSearchIconSize = 27.0;
  static double homeScreenSearchBarIconSize = 18.0;
  static double shimmerEffectImageErrorIconSize = 80.0;
  static double articleBoxIconSize = 17.0; //18.0
  static double propertyDetailsValuedFeaturesIconSize = 23.0;
  static double propertyDetailsTopBarIconSize = 20.0;
  static double propertyDetailsFeaturesIconSize = 25.0;
  static double savedPageSearchIconSize = 35.0;
  static double propertyDetailsFloorPlansIconSize = 24.0;
  static double filterPageCheckCircleIconSize = 25.0;
  static double filterPageLocationIconSize = 30.0;
  static double filterPageTermPickerIconSize = 30.0;
  static double filterPageStringPickerIconSize = 30.0;
  static double filterPageRangePickerIconSize = 30.0;
  static double filterPageArrowForwardIconSize = 20.0;
  static double filterPageLocationCityIconSize = 30.0;
  static double filterPageArrowDropDownIconSize = 30.0;
  static double bottomNavigationMenuIconSize = 35.0;
  static double filterPagePriceTagIconSize = normalIconSize;
  static double filterPageAreaSizeIconSize = normalIconSize;
  static double filterPageBedroomIconSize = normalIconSize;
  static double filterPageBathroomIconSize = normalIconSize;
  static double cityPickerLocationIconSize = 26.0;
  static double propertyDetailsPageTopBarIconsIconSize = 20.0;
  static double propertyDetailsPageTopBarCircularAvatarRadius = 20.0;
  static double propertyDetailsImageIndicatorCameraIconSize = 20.0;
  static double propertyDetailsChipsIconSize = 20.0;
  static double genericErrorWidgetIconSize = 140.0;
  static double editProfilePictureIconSize = 16.0;
  static double settingsIconSize = 30.0;
  static double featuredImageStarIconSize = 28.0;
  static double homeScreenRecentSearchIconSize = 18.0;
  static double homeScreenRecentCheckCircleIconSize = 16.0;
  static double homeScreenRecentSearchLocationIconSize = 18.0;
  static double dotIconSize = 8.0;
  static double notificationWidgetIconSize = 50.0;

  ///
  ///
  /// Drawer Menu Icon
  static IconData drawerMenuIcon = Icons.menu_outlined;

  ///
  /// Location Icon
  static IconData locationIcon = Icons.location_on_outlined;

  ///
  /// Location Icon
  static IconData locationFilledIcon = Icons.fmd_good;

  ///
  /// Gps location Icon
  static IconData gpsLocationIcon = Icons.gps_fixed_outlined;

  ///
  /// Radius location Icon
  static IconData radiusLocationIcon = Icons.share_location_rounded;

  ///
  /// Right Arrow in Location Widget Icon
  static IconData rightArrowIcon = Icons.chevron_right_outlined;

  ///
  /// Down Arrow in Location Widget Icon
  static IconData dropDownArrowIcon = Icons.keyboard_arrow_down;

  ///
  /// Search Icon
  static IconData searchIcon = Icons.search;

  ///
  /// Filter Icon
  static IconData filterIcon = Icons.tune;

  ///
  /// Shimmer Effect Image Error Widget Icon
  static IconData imageIcon = Icons.image_outlined;

  ///
  /// Bed Icon
  static IconData bedIcon = Icons.king_bed_outlined;

  ///
  /// Bathtub Icon
  static IconData bathtubIcon = Icons.bathtub_outlined;

  ///
  /// Area Size Icon
  static IconData areaSizeIcon = Icons.square_foot;

  ///
  /// Arrow Back Icon
  static IconData arrowBackIcon = Icons.arrow_back;

  ///
  /// Close Icon
  static IconData closeIcon = Icons.close_outlined;

  ///
  /// Email Icon
  static IconData emailIcon = Icons.email_outlined;

  ///
  /// Email Icon
  static IconData emailFilledIcon = Icons.email;

  ///
  /// Phone Icon
  static IconData phoneIcon = Icons.phone_outlined;

  ///
  /// Phone Icon
  static IconData phoneFilledIcon = Icons.phone;

  ///
  /// No Internet Icon
  static IconData noInternetIcon = Icons.wifi_off_rounded;

  ///
  /// Info Icon
  static IconData infoIcon = Icons.info_outlined;

  ///
  ///
  /// Drawer Menu Icons:
  ///
  /// Home Icon
  static IconData homeIcon = Icons.home_rounded;

  ///
  /// Home Icon outlined
  static IconData homeIconOutlined = Icons.home_outlined;

  ///
  /// Add Property Icon
  static IconData addPropertyIcon = Icons.add_business_outlined;

  ///
  /// Quick Add Property Icon
  static IconData quickAddPropertyIcon = Icons.add_task_outlined;

  ///
  /// Properties Icon
  static IconData propertiesIcon = Icons.apartment_rounded;

  ///
  /// Saved Searches Icon
  static IconData savedSearchesIcon = Icons.bookmark_border_rounded;

  ///
  /// Dashboard Icon
  static IconData dashboardIcon = Icons.dashboard_outlined;

  ///
  /// Activities Icon
  static IconData activitiesIcon = Icons.article_outlined;

  ///
  /// Inquiries Icon
  static IconData inquiriesIcon = Icons.question_answer;

  ///
  /// Deals Icon
  static IconData dealsIcon = Icons.app_registration_rounded;

  ///
  /// Leads Icon
  static IconData leadsIcon = Icons.trending_up;

  ///
  /// Settings Icon
  static IconData settingsIcon = Icons.settings_rounded;

  ///
  /// Request Demo Icon
  static IconData requestDemoIcon = Icons.contact_support_outlined;

  ///
  /// Log Out Icon
  static IconData logOutIcon = Icons.logout_outlined;

  ///
  /// Log In Icon
  static IconData loginIcon = Icons.login_outlined;

  ///
  /// Log In Icon
  static IconData blogIcon = Icons.edit_note_rounded;

  ///
  ///
  /// Add / Update Property Icons:
  ///
  /// Remove Circle Icon
  static IconData removeCircleIcon = Icons.remove_circle;

  ///
  /// Remove Circle Outlined Icon
  static IconData removeCircleOutlinedIcon =
      Icons.remove_circle_outline_outlined;

  ///
  /// Add Circle Outlined Icon
  static IconData addCircleOutlinedIcon = Icons.add_circle_outline_outlined;

  ///
  /// Star Outlined Icon
  static IconData starOutlinedIcon = Icons.star_outline_outlined;

  ///
  /// Star Filled Icon
  static IconData starFilledIcon = Icons.star;

  ///
  /// Edit Done Icon
  static IconData editDoneIcon = Icons.task_alt_outlined;

  ///
  ///
  /// Filter Page Icons:
  ///
  /// Check Circle Icon
  static IconData checkCircleIcon = Icons.check_circle_outline;

  ///
  /// Arrow Forward Icon
  static IconData arrowForwardIcon = Icons.arrow_forward_ios;

  ///
  /// Location Country Icon
  static IconData locationCountryIcon = Icons.public_outlined;

  ///
  /// Location State Icon
  static IconData locationStateIcon = Icons.map_outlined;

  ///
  /// Location City Icon
  static IconData locationCityIcon = Icons.location_city;

  ///
  /// Location Area Icon
  static IconData locationAreaIcon = Icons.signpost_outlined;

  ///
  /// Arrow Drop Down Icon
  // static IconData arrowDropDownIcon = Icons.arrow_drop_down;
  ///
  /// Done(Tick_Mark) Icon
  static IconData doneIcon = Icons.done_outlined;

  ///
  /// Price Tag Icon
  static IconData priceTagIcon = Icons.local_offer_outlined;

  ///
  /// Person Icon
  static IconData personIcon = Icons.person;

  ///
  /// Call Icon
  static IconData callIcon = Icons.call;

  ///
  /// Phone Icon
  static IconData phoneAndroidIcon = Icons.phone_android;

  ///
  /// Location On Icon
  static IconData locationOnIcon = Icons.location_on;

  ///
  /// Keyword Icon
  static IconData keywordIcon = Icons.title_outlined;
  static IconData keywordCupertinoIcon = CupertinoIcons.textbox;

  ///
  ///
  /// Property Details Page Icons:
  ///
  /// Favourite Icon Filled
  static IconData favouriteIconFilled = Icons.favorite;

  ///
  /// Favourite Icon
  static IconData favouriteBorderIcon = Icons.favorite_border;

  ///
  /// Share Icon
  static IconData shareIcon = Icons.share;

  ///
  /// Camera Icon
  static IconData cameraIcon = Icons.photo_camera_outlined;

  ///
  /// Error Icon
  static IconData errorIcon = Icons.error_outlined;

  ///
  /// Date Range Icon
  static IconData dateRangeIcon = Icons.date_range_outlined;

  ///
  /// Movie Icon
  static IconData movieIcon = Icons.movie_outlined;

  ///
  /// Smart Display Icon
  static IconData smartDisplayIcon = Icons.smart_display_outlined;

  ///
  /// Delete Icon
  static IconData deleteIcon = Icons.delete_outlined;

  ///
  /// Up arrow Icon
  static IconData upArrowIcon = Icons.arrow_upward;

  ///
  /// Down arrow Icon
  static IconData downArrowIcon = Icons.arrow_downward;

  ///
  /// Add Icon
  static IconData addIcon = Icons.add;

  ///
  /// Add Icon
  static IconData addNewAgentIcon = Icons.person_add_outlined;

  ///
  /// Add Icon
  static IconData allUsers = Icons.people_alt_outlined;

  ///
  /// Membership Icon
  static IconData membership = Icons.assignment_outlined;

  ///
  /// Real-Estate Agent Icon
  static IconData realEstateAgent = Icons.real_estate_agent_outlined;

  ///
  /// Real-Estate Agent Icon
  static IconData commercialIcon = Icons.storefront_outlined;

  ///
  /// Edit Icon
  static IconData editIcon = Icons.edit_outlined;

  ///
  /// Report Icon
  static IconData reportIcon = Icons.report_outlined;

  ///
  /// Garage Outlined Icon
  static IconData garageIcon = Icons.garage_outlined;

  ///
  /// Print Icon
  static IconData printIcon = Icons.print;

  ///
  ///
  /// Settings Page Icons:
  ///
  /// Link Icon
  static IconData linkIcon = Icons.link_outlined;

  ///
  /// Dark mode Icon
  static IconData darkModeIcon = Icons.dark_mode_outlined;

  ///
  /// Language Icon
  static IconData languageIcon = Icons.translate_outlined;

  ///
  /// Terms and Conditions Icon
  static IconData gravelIcon = Icons.gavel_outlined;

  ///
  /// Policy Icon
  static IconData policyIcon = Icons.policy_outlined;

  ///
  /// Agents Icon
  static IconData agentsIcon = Icons.groups_outlined;

  ///
  /// Agency Icon
  static IconData agencyIcon = Icons.business_outlined;

  ///
  /// Save Icon
  static IconData saveIcon = Icons.save_rounded;

  ///
  /// Visibility Icon
  static IconData visibilityIcon = Icons.visibility;

  ///
  /// Invisibility Icon
  static IconData invisibilityIcon = Icons.visibility_off;

  ///
  /// Availability Icon
  static IconData availabilityIcon = Icons.event_available_outlined;

  ///
  /// Change password Icon
  static IconData changePassword = Icons.password_outlined;

  ///
  /// Profile settings password Icon
  static IconData manageProfile = Icons.manage_accounts_outlined;

  ///
  /// Map Icon
  static IconData mapIcon = Icons.map_outlined;

  ///
  /// Request Property Icon
  static IconData requestPropertyIcon = Icons.edit_note;

  ///
  /// Request Property Icon
  static IconData forRentIcon = Icons.vpn_key_outlined;

  ///
  /// Feature Chip Icon
  static IconData featureChipIcon = Icons.star_outline;

  ///
  /// Property By Label Chip Icon
  static IconData labelIcon = Icons.label;

  ///
  /// Circle dot Icon
  static IconData dotIcon = Icons.circle;

  ///
  /// Schedule Icon
  static IconData scheduleIcon = Icons.schedule;

  ///
  /// Schedule Icon
  static IconData copyToClipBoard = Icons.content_copy;

  // static IconData labelIcon = Icons.label_outlined;
  ///
  /// Website Icon
  static IconData websiteIcon = Icons.language_outlined;

  ///
  ///
  ///
  ///
  /// WhatsApp Icon
  //static IconData whatsAppIcon = Icons.whatsapp,
  ///
  /// Home Screen Search Arrow Icon LTR
  static IconData homeScreenSearchArrowIconLTR = Icons.east_outlined;

  ///
  /// Home Screen Search Arrow Icon RTL
  static IconData homeScreenSearchArrowIconRTL = Icons.west_outlined;

  ///
  /// List Icon
  static IconData listIcon = Icons.list;

  ///
  /// List Icon
  static IconData messageIcon = Icons.message_outlined;

  ///
  /// Verified Icon
  static IconData verifiedIcon = Icons.verified_outlined;

  ///
  /// Ads Click Icon
  static IconData adsClickIcon = Icons.ads_click_outlined;

  ///
  /// Show Charts Icon
  static IconData showCharts = Icons.show_chart;

  ///
  /// Filter Center Focus Icon
  static IconData filterCenterFocus = Icons.filter_center_focus;

  ///
  /// Timer Icon
  static IconData timerOutlined = Icons.timer_outlined;

  ///
  /// Calendar Month Outlined Icon
  static IconData calendarMonthOutlined = Icons.calendar_month_outlined;

  ///
  /// Attachment Icon
  static IconData attachmentIcon = Icons.attach_file;

  ///
  /// Download Icon
  static IconData downloadIcon = Icons.file_download;

  ///
  /// File Download Icon
  static IconData fileDownloadIcon = Icons.file_download_outlined;

  ///
  /// More Vertical Icon
  static IconData moreVert = Icons.more_vert;

  ///
  /// Private note/description Icon
  static IconData descriptionOutlined = Icons.description_outlined;

  ///
  /// Hold/toggle on
  static IconData toggleOnOutlined = Icons.toggle_on_outlined;

  ///
  /// check Outlined Icon
  static IconData checkOutlined = Icons.check_outlined;

  ///
  /// Upgrade Outlined Icon
  static IconData upgradeOutlined = Icons.upgrade_outlined;

  ///
  /// payments Outlined Icon
  static IconData paymentsOutlined = Icons.payments_outlined;

  ///
  /// star Half Outlined Icon
  static IconData starHalfOutlined = Icons.star_half_outlined;

  ///
  /// sell Outlined Icon
  static IconData sellOutlined = Icons.sell_outlined;

  ///
  /// assignment late/expired Outlined Icon
  static IconData expiredOutlined = Icons.assignment_late_outlined;

  ///
  /// Access Time Outlined Icon
  static IconData accessTimeOutlined = Icons.access_time;

  ///
  /// flag Outlined Icon
  static IconData flagOutlined = Icons.flag_outlined;

  ///
  /// Reply Outlined Icon
  static IconData replyOutlined = Icons.reply_outlined;

  ///
  /// Reply Outlined Icon
  static IconData sendIcon = Icons.send;

  ///
  /// Notification Outlined Icon
  static IconData notificationIcon = Icons.notifications_outlined;

  ///
  /// Notification Outlined Icon
  static IconData notificationReviewIcon = Icons.sms_outlined;

  ///
  /// Time Icon
  static IconData timeIcon = Icons.schedule_outlined;

  ///
  /// Page Scroll Down Icon
  static IconData pageScrollDownIcon = Icons.keyboard_double_arrow_down;

  ///
  ///
  ///
  /// Icons Buttons:
  ///
  ///
  /// Icon Button Sizes:
  static double addPropertyDetailsIconButtonSize = 35.0;

  ///
  ///
  /// Images:
  ///
  ///
  ///
  /// Image Sizes:
  ///
  /// Drawer Image Size:
  static double drawerImageHeight = 40.0;
  static double drawerImageWidth = 40.0;

  ///
  /// Whatsapp Image Size:
  static double whatsappImageHeight = 25.0;
  static double whatsappImageWidth = 25.0;

  ///
  /// Line App Button Image Size:
  static double lineAppImageHeight = 40.0;
  static double lineAppImageWidth = 40.0;

  ///
  /// Telegram Button Image Size:
  static double telegramImageHeight = 35.0;
  static double telegramImageWidth = 35.0;

  ///
  /// Property Media GridView Image Size:
  static double propertyMediaGridViewImageHeight = 300.0;
  static double propertyMediaGridViewImageWidth = 300.0;

  ///
  ///
  /// Drawer Image:
  static String drawerImagePath = "assets/icon/icon.png";

  ///
  /// Google Icon Image Path:
  static String googleIconImagePath = "assets/icon/google_logo.png";

  ///
  /// Google Icon Image Path:
  static String phoneIconImagePath = "assets/icon/phone_icon.png";

  ///
  /// Facebook Icon Image Path:
  static String facebookIconImagePath = "assets/icon/facebook_logo.png";

  ///
  /// Apple Light Icon Image Path:
  static String appleLightIconImagePath = "assets/icon/apple_logo_dark.png";

  ///
  /// Apple Dark Icon Image Path:
  static String appleDarkIconImagePath = "assets/icon/apple_logo_light.png";

  ///
  /// WhatsApp Icon Image Path:
  static String whatsAppIconImagePath = "assets/icon/whatsapp-logo.png";

  ///
  /// LineApp Icon Image Path:
  static String lineAppIconImagePath = "assets/icon/line.png";

  ///
  /// Telegram Icon Image Path:
  static String telegramIconImagePath = "assets/icon/telegram.png";

  ///
  ///
  /// Border Related:
  ///
  ///
  ///
  /// Border Width:
  static double filterPageBorderWidth = 1.0;
  static double bottomNavigationMenuBorderWidth = 2.0;
  static double propertyDetailsPageTopBarDividerBorderWidth = 1.0;
  static double propertyDetailsPageBottomMenuBorderWidth = 1.0;

  ///
  ///
  /// Buttons:
  ///
  ///
  ///
  /// Button Heights:
  ///
  /// Filter Search Button:
  static double filterPageSearchButtonHeight = 45.0;

  ///
  ///
  /// Loading Widgets:
  ///
  ///
  ///
  /// Dimensions of Loading Widgets:
  ///
  /// Pagination Loading Widget:
  static double paginationLoadingWidgetHeight = 50.0;
  static double paginationLoadingWidgetWidth = 60.0;

  ///
  ///
  /// Rounded Corners:
  ///
  ///
  /// Rounded Corners Radius:
  static double globalRoundedCornersRadius = 5.0;
  static double propertyDetailPageRoundedCornersRadius = 10.0;
  static double propertyDetailFeaturesRoundedCornersRadius = 100.0;
  static double CRMRoundedCornersRadius = 100.0;
  static double savedPageSearchIconRoundedCornersRadius = 10.0;
  static double realtorPageRoundedCornersRadius = 12.0;
  static double articleDesignRoundedCornersRadius = 10.0;
  static double exploreTermDesignRoundedCornersRadius =
      articleDesignRoundedCornersRadius;
  static double reviewRoundedCornersRadius = 8.0;
  static double searchPageChoiceChipsRoundedCornersRadius = 10.0;
  static double commentsRoundedCornersRadius = 8.0;
  static double notificationWidgetRoundedCornersRadius = 10.0;
  static double messageDateRoundedCornersRadius = 10.0;
  static double messageContentRoundedCornersRadius = 18.0;

  ///
  ///
  /// Input Rounded Corners:
  static RoundedRectangleBorder roundedCorners(
    double radius, {
    BorderSide side = BorderSide.none,
  }) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: side,
      // side: BorderSide(color: AppThemePreferences().appTheme.dividerColor, width: 0.5)
    );
  }

  ///
  ///
  /// Input Fields Decoration:
  ///
  ///
  /// Input Fields Decoration:
  static InputDecoration formFieldDecoration({
    String? hintText,
    Widget? suffixIcon,
    bool hideBorder = false,
    BorderRadius? borderRadius,
    TextStyle? hintTextStyle,
    Color? focusedBorderColor,
    Color? prefixIconColor,
    Color? suffixIconColor,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      hintText: hintText != null
          ? UtilityMethods.getLocalizedString(hintText)
          : hintText,
      hintStyle: hintTextStyle,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      border: hideBorder
          ? InputBorder.none
          : OutlineInputBorder(
              borderRadius: borderRadius ??
                  BorderRadius.circular(
                      AppThemePreferences.globalRoundedCornersRadius),
              borderSide: BorderSide(
                  color: focusedBorderColor ??
                      AppThemePreferences.formFieldBorderColor),
            ),
      focusedBorder: hideBorder
          ? InputBorder.none
          : OutlineInputBorder(
              borderRadius: borderRadius ??
                  BorderRadius.circular(
                      AppThemePreferences.globalRoundedCornersRadius),
              borderSide: BorderSide(
                  color: focusedBorderColor ??
                      AppThemePreferences.formFieldBorderColor),
            ),
      // enabledBorder: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(AppThemePreferences.globalRoundedCornersRadius),
      //   // borderSide: BorderSide(color: Colors.red),
      // ),
      suffixIcon: suffixIcon,
      prefixIconColor: prefixIconColor,
      suffixIconColor: suffixIconColor,
      focusColor: focusedBorderColor,
    );
  }

  ///
  /// Divider Decoration:
  static Decoration dividerDecoration(
      {bool top = false,
      bool bottom = false,
      bool left = false,
      bool right = false,
      double width = 1.0,
      BorderStyle style = BorderStyle.solid}) {
    BoxBorder border;
    Color? borderColor = AppThemePreferences().appTheme.dividerColor;
    BorderSide borderSide =
        BorderSide(color: borderColor!, width: width, style: style);

    if (top == bottom && bottom == left && left == right && right == false) {
      bottom = true;
    }

    border = Border(
      top: top == true ? borderSide : BorderSide.none,
      bottom: bottom == true ? borderSide : BorderSide.none,
      left: left == true ? borderSide : BorderSide.none,
      right: right == true ? borderSide : BorderSide.none,
    );

    return BoxDecoration(
      border: border,
    );
  }

  ///
  ///
  /// Widgets Size:
  ///
  ///
  static double agentsListContainerWidth = 330.0;
  static double agentsListContainerHeight = 155.0;
  static double agentsListImageHeight = 112.0;
  static double agentsListImageWidth = 100.0;
  static double agenciesListContainerWidth = 330.0;
  static double agenciesListContainerHeight = 120.0;
  static double agenciesListImageHeight = 77.0;
  static double agenciesListImageWidth = 80.0;
}

class AppTheme {
  final bool isDark;

  AppTheme({this.isDark = false}) {
    /// textStyles:
    _tagTextStyle = TextStyle(
        fontSize: AppThemePreferences.tagFontSize,
        fontWeight: AppThemePreferences.tagFontWeight,
        color: isDark
            ? AppThemePreferences.tagTextColorDark
            : AppThemePreferences.tagTextColorLight);
    _featuredTagTextStyle = TextStyle(
        fontSize: AppThemePreferences.tagFontSize,
        fontWeight: AppThemePreferences.tagFontWeight,
        color: isDark
            ? AppThemePreferences.featuredTagTextColorDark
            : AppThemePreferences.featuredTagTextColorLight);
    _tag01TextStyle = TextStyle(
        fontSize: AppThemePreferences.tagFontSize,
        fontWeight: AppThemePreferences.tagFontWeight,
        color: isDark
            ? AppThemePreferences.tagTextColorDark
            : AppThemePreferences.tag02TextColorLight);
    _buttonTextStyle = TextStyle(
        fontSize: AppThemePreferences.buttonFontSize,
        color: isDark
            ? AppThemePreferences.buttonTextColorDark
            : AppThemePreferences.buttonTextColorLight);
    _headingTextStyle = TextStyle(
        fontSize: AppThemePreferences.headingFontSize,
        fontWeight: AppThemePreferences.headingFontWeight,
        color: isDark
            ? AppThemePreferences.headingTextColorDark
            : AppThemePreferences.headingTextColorLight);
    _heading01TextStyle = TextStyle(
        fontSize: AppThemePreferences.heading01FontSize,
        fontWeight: AppThemePreferences.heading01FontWeight,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _heading02TextStyle = TextStyle(
        fontSize: AppThemePreferences.heading02FontSize,
        fontWeight: AppThemePreferences.heading02FontWeight,
        color: AppThemePreferences.appPrimaryColor);
    _heading03TextStyle = TextStyle(
        fontSize: AppThemePreferences.heading03FontSize,
        fontWeight: AppThemePreferences.heading03FontWeight,
        color: isDark
            ? AppThemePreferences.headingTextColorLight
            : AppThemePreferences.headingTextColorLight);
    _labelTextStyle = TextStyle(
        fontSize: AppThemePreferences.labelFontSize,
        fontWeight: AppThemePreferences.labelFontWeight,
        color: isDark
            ? AppThemePreferences.labelTextColorDark
            : AppThemePreferences.labelTextColorLight);
    _label01TextStyle = TextStyle(
        fontSize: AppThemePreferences.label01FontSize,
        fontWeight: AppThemePreferences.label01FontWeight,
        color: isDark
            ? AppThemePreferences.label01TextColorDark
            : AppThemePreferences.label01TextColorLight);
    _label04TextStyle = TextStyle(
        fontSize: AppThemePreferences.label01FontSize,
        fontWeight: AppThemePreferences.label01FontWeight,
        color: isDark
            ? AppThemePreferences.label01TextColorDark
            : AppThemePreferences.label04TextColorLight);
    _label02TextStyle = TextStyle(
        fontSize: AppThemePreferences.label02FontSize,
        color: AppThemePreferences.label02TextColor);
    _label03TextStyle = TextStyle(
        fontSize: AppThemePreferences.label03FontSize,
        color: AppThemePreferences.label03TextColor);
    _titleTextStyle = TextStyle(
        fontSize: AppThemePreferences.titleFontSize,
        fontWeight: AppThemePreferences.titleFontWeight,
        color: isDark
            ? AppThemePreferences.titleTextColorDark
            : AppThemePreferences.titleTextColorLight);
    _bodyTextStyle = TextStyle(
        fontSize: AppThemePreferences.bodyFontSize,
        height: AppThemePreferences.bodyTextHeight,
        fontWeight: AppThemePreferences.bodyFontWeight,
        color: isDark
            ? AppThemePreferences.bodyTextColorDark
            : AppThemePreferences.bodyTextColorLight);
    _body01TextStyle = TextStyle(
        fontSize: AppThemePreferences.body01FontSize,
        height: AppThemePreferences.body01TextHeight,
        fontWeight: AppThemePreferences.body01FontWeight,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _body02TextStyle = TextStyle(
        fontSize: AppThemePreferences.body02FontSize,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _body03TextStyle = TextStyle(
        fontSize: AppThemePreferences.body03FontSize,
        color: isDark
            ? AppThemePreferences.body03TextColorDark
            : AppThemePreferences.body03TextColorLight);
    _linkTextStyle = TextStyle(
        fontSize: AppThemePreferences.linkFontSize,
        height: AppThemePreferences.linkTextHeight,
        color: AppThemePreferences.linkColor);
    _subBodyTextStyle = TextStyle(
        fontSize: AppThemePreferences.subBodyFontSize,
        fontWeight: AppThemePreferences.subBodyFontWeight,
        color: isDark
            ? AppThemePreferences.subBodyTextColorDark
            : AppThemePreferences.subBodyTextColorLight);
    _subBody01TextStyle = TextStyle(
        fontSize: AppThemePreferences.subBody01FontSize,
        fontWeight: AppThemePreferences.subBody01FontWeight,
        height: AppThemePreferences.subBody01TextHeight,
        color: isDark
            ? AppThemePreferences.subBody01TextColorDark
            : AppThemePreferences.subBody01TextColorLight);
    _subBody05TextStyle = TextStyle(
        fontSize: AppThemePreferences.subBody01FontSize,
        fontWeight: AppThemePreferences.subBody01FontWeight,
        height: AppThemePreferences.subBody01TextHeight,
        color: isDark
            ? AppThemePreferences.subBody01TextColorDark
            : AppThemePreferences.subBody05TextColorLight);
    _subTitleTextStyle = TextStyle(
        fontSize: AppThemePreferences.subTitle01FontSize,
        color: isDark
            ? AppThemePreferences.subTitle01TextColorDark
            : AppThemePreferences.subTitleTextColorLight);
    _subTitle01TextStyle = TextStyle(
        fontSize: AppThemePreferences.subTitle01FontSize,
        fontWeight: AppThemePreferences.subTitle01FontWeight,
        color: isDark
            ? AppThemePreferences.subTitle01TextColorDark
            : AppThemePreferences.subTitle01TextColorLight);
    _articleReviewsTitle = TextStyle(
        fontSize: AppThemePreferences.articleReviewsTitleFontSize,
        fontWeight: AppThemePreferences.reviewTitleFontWeight,
        color: isDark
            ? AppThemePreferences.subTitle01TextColorDark
            : AppThemePreferences.subTitle01TextColorLight);
    _subTitle02TextStyle = TextStyle(
        fontSize: AppThemePreferences.subTitle02FontSize,
        fontWeight: AppThemePreferences.subTitle02FontWeight,
        height: AppThemePreferences.subTitle02TextHeight,
        color: isDark
            ? AppThemePreferences.subTitle02TextColorDark
            : AppThemePreferences.subTitle02TextColorLight);
    _hintTextStyle = TextStyle(
        fontSize: AppThemePreferences.hintFontSize,
        color: isDark
            ? AppThemePreferences.hintColorDark
            : AppThemePreferences.hintColorLight);
    _toastTextTextStyle = TextStyle(
        fontSize: AppThemePreferences.toastTextFontSize,
        color: AppThemePreferences.toastTextColor);
    _readMoreTextStyle = TextStyle(
        fontSize: AppThemePreferences.readMoreFontSize,
        fontWeight: AppThemePreferences.readMoreFontWeight,
        color: isDark
            ? AppThemePreferences.readMoreTextColorDark
            : AppThemePreferences.readMoreTextColorLight);
    _searchByIdTextStyle = TextStyle(
        fontSize: AppThemePreferences.searchByIdTextFontSize,
        fontWeight: AppThemePreferences.searchByIdTextFontWeight,
        color: isDark
            ? AppThemePreferences.searchByIdTextColorDark
            : AppThemePreferences.searchByIdTextColorLight);
    _searchBarTextStyle = TextStyle(
        fontSize: AppThemePreferences.searchBarTextFontSize,
        color: isDark
            ? AppThemePreferences.searchBarTextColorDark
            : AppThemePreferences.searchBarTextColorLight,
        fontWeight: FontWeight.w400);
    _homeScreenDrawerTextStyle = TextStyle(
        fontSize: AppThemePreferences.homeScreenDrawerTextFontSize,
        fontWeight: AppThemePreferences.homeScreenDrawerTextFontWeight,
        color: isDark
            ? AppThemePreferences.homeScreenDrawerTextColorDark
            : AppThemePreferences.homeScreenDrawerTextColorLight);
    _homeScreenDrawerUserNameTextStyle = TextStyle(
        fontSize: AppThemePreferences.homeScreenDrawerUserNameTextFontSize,
        color: isDark
            ? AppThemePreferences.genericAppBarTextColorDark
            : AppThemePreferences.genericAppBarTextColorLight);
    _homeScreenRecentSearchTitleTextStyle = TextStyle(
        fontSize: AppThemePreferences.homeScreenRecentSearchTitleFontSize,
        color: isDark
            ? AppThemePreferences.homeScreenRecentSearchTitleColorDark
            : AppThemePreferences.homeScreenRecentSearchTitleColorLight);
    _homeScreenRecentSearchCityTextStyle = TextStyle(
        fontSize: AppThemePreferences.homeScreenRecentSearchCityFontSize,
        color: isDark
            ? AppThemePreferences.homeScreenRecentSearchCityColorDark
            : AppThemePreferences.homeScreenRecentSearchCityColorLight);
    _articleBoxPropertyStatusTextStyle = TextStyle(
        fontSize: AppThemePreferences.articleBoxPropertyStatusFontSize,
        fontWeight: AppThemePreferences.articleBoxPropertyStatusFontWeight,
        color: isDark
            ? AppThemePreferences.articleBoxPropertyStatusColorDark
            : AppThemePreferences.articleBoxPropertyStatusColorLight);
    _articleBoxPropertyPriceTextStyle = TextStyle(
        fontSize: AppThemePreferences.articleBoxPropertyPriceFontSize,
        fontWeight: AppThemePreferences.articleBoxPropertyPriceFontWeight,
        color: isDark
            ? AppThemePreferences.articleBoxPropertyPriceColorDark
            : AppThemePreferences.articleBoxPropertyPriceColorLight);
    _explorePropertyTextStyle = TextStyle(
        fontSize: AppThemePreferences.explorePropertyFontSize,
        fontWeight: AppThemePreferences.explorePropertyFontWeight,
        color: isDark
            ? AppThemePreferences.explorePropertyColorDark
            : AppThemePreferences.explorePropertyColorLight);
    _homeScreenRealtorTitleTextStyle = TextStyle(
        fontSize: AppThemePreferences.homeScreenRealtorTitleFontSize,
        fontWeight: AppThemePreferences.homeScreenRealtorTitleFontWeight,
        color: isDark
            ? AppThemePreferences.appSecondaryColor
            : AppThemePreferences.appSecondaryColor);
    _homeScreenRealtorInfoTextStyle = TextStyle(
        fontSize: AppThemePreferences.normalFontSize,
        fontWeight: AppThemePreferences.lightFontWeight,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _filterPageHeadingTitleTextStyle = TextStyle(
        fontSize: AppThemePreferences.filterPageHeadingTitleFontSize,
        fontWeight: AppThemePreferences.filterPageHeadingTitleFontWeight,
        color: isDark
            ? AppThemePreferences.filterPageTitleHeadingTextColorDark
            : AppThemePreferences.filterPageTitleHeadingTextColorLight);
    _locationWidgetTextStyle = TextStyle(
        fontSize: AppThemePreferences.locationWidgetFontSize,
        fontWeight: AppThemePreferences.locationWidgetFontWeight,
        color: isDark
            ? AppThemePreferences.locationWidgetTextColorDark
            : AppThemePreferences.locationWidgetTextColorLight);
    _filterPageChoiceChipTextStyle = TextStyle(
        fontSize: AppThemePreferences.filterPageChoiceChipFontSize,
        fontWeight: AppThemePreferences.filterPageChoiceChipFontWeight,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _rangeSliderWidgetConversionUnitTextStyle = TextStyle(
        fontSize: AppThemePreferences.rangeSliderWidgetConversionUnitFontSize,
        fontWeight:
            AppThemePreferences.rangeSliderWidgetConversionUnitFontWeight,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _bottomSheetMenuTitleTextStyle = TextStyle(
        fontSize: AppThemePreferences.bottomSheetMenuTitleFontSize,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _bottomSheetMenuTitle01TextStyle = TextStyle(
        fontSize: AppThemePreferences.bottomSheetMenuTitle01FontSize,
        height: AppThemePreferences.bottomSheetMenuTitle01TextHeight);
    _bottomSheetMenuSubTitleTextStyle = TextStyle(
        fontSize: AppThemePreferences.bottomSheetMenuSubTitleFontSize);
    _bottomNavigationMenuItemsTextStyle = TextStyle(
        fontSize: AppThemePreferences.bottomNavigationMenuItemsFontSize,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _filterPageResetTextStyle = TextStyle(
        fontSize: AppThemePreferences.filterPageResetFontSize,
        color: isDark
            ? AppThemePreferences.filterPageTextColorDark
            : AppThemePreferences.unSelectedItemTextColorLight);
    _propertyDetailsPageTopBarTitleTextStyle = TextStyle(
        fontSize: AppThemePreferences.propertyDetailsPageTopBarTitleFontSize,
        fontWeight:
            AppThemePreferences.propertyDetailsPageTopBarTitleFontWeight,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _propertyDetailsPageImageIndicatorTextTextStyle = TextStyle(
        fontSize:
            AppThemePreferences.propertyDetailsPageImageIndicatorTextFontSize,
        fontWeight:
            AppThemePreferences.propertyDetailsPageImageIndicatorTextFontWeight,
        color: isDark
            ? AppThemePreferences.propertyDetailsPageImageIndicatorTextColorDark
            : AppThemePreferences
                .propertyDetailsPageImageIndicatorTextColorLight);
    _propertyDetailsPagePropertyTitleTextStyle = TextStyle(
        fontSize: AppThemePreferences.propertyDetailsPagePropertyTitleFontSize,
        fontWeight:
            AppThemePreferences.propertyDetailsPagePropertyTitleFontWeight,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _propertyDetailsPagePropertyStatusTextStyle = TextStyle(
        fontSize: AppThemePreferences.propertyDetailsPagePropertyStatusFontSize,
        fontWeight:
            AppThemePreferences.propertyDetailsPagePropertyStatusFontWeight,
        color: isDark
            ? AppThemePreferences.propertyDetailsPagePropertyStatusColorDark
            : AppThemePreferences.propertyDetailsPagePropertyStatusColorLight);
    _propertyDetailsPagePropertyPriceTextStyle = TextStyle(
        fontSize: AppThemePreferences.propertyDetailsPagePropertyPriceFontSize,
        fontWeight:
            AppThemePreferences.propertyDetailsPagePropertyPriceFontWeight,
        color: isDark
            ? AppThemePreferences.propertyDetailsPagePropertyPriceColorDark
            : AppThemePreferences.propertyDetailsPagePropertyPriceColorLight);
    _propertyDetailsPagePropertyDetailFeaturesTextStyle = TextStyle(
        fontSize: AppThemePreferences
            .propertyDetailsPagePropertyDetailFeaturesFontSize,
        fontWeight: AppThemePreferences
            .propertyDetailsPagePropertyDetailFeaturesFontWeight,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _genericStatusBarTextStyle = TextStyle(
        fontSize: AppThemePreferences.genericStatusBarTextFontSize,
        fontWeight: AppThemePreferences.genericStatusBarTextFontWeight,
        color: isDark
            ? AppThemePreferences.genericStatusBarTextColorDark
            : AppThemePreferences.genericStatusBarTextColorLight);
    _formFieldErrorTextStyle = TextStyle(
        fontSize: AppThemePreferences.formFieldErrorTextFontSize,
        color: AppThemePreferences.errorColor);
    _risingLeadsTextStyle = TextStyle(
        fontSize: AppThemePreferences.risingLeadsTextFontSize,
        fontStyle: AppThemePreferences.risingLeadsTextFontStyle,
        color: AppThemePreferences.risingLeadsColor);
    _fallingLeadsTextStyle = TextStyle(
        fontSize: AppThemePreferences.fallingLeadsTextFontSize,
        fontStyle: AppThemePreferences.fallingLeadsTextFontStyle,
        color: AppThemePreferences.fallingLeadsColor);
    _appInfoTextStyle = TextStyle(
        fontSize: AppThemePreferences.appInfoTextFontSize,
        fontWeight: AppThemePreferences.appInfoTextFontWeight,
        color: isDark
            ? AppThemePreferences.appInfoTextColorDark
            : AppThemePreferences.appInfoTextColorLight);
    _settingOptionsTextStyle = TextStyle(
        fontSize: AppThemePreferences.settingOptionsTextFontSize,
        fontWeight: AppThemePreferences.settingOptionsTextFontWeight,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _settingHeadingTextStyle = TextStyle(
        fontSize: AppThemePreferences.settingHeadingTextFontSize,
        fontWeight: AppThemePreferences.settingHeadingTextFontWeight,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _settingHeadingSubTitleTextStyle = TextStyle(
        fontSize: AppThemePreferences.settingHeadingSubtitleTextFontSize,
        fontWeight: AppThemePreferences.settingHeadingSubtitleTextFontWeight,
        height: AppThemePreferences.settingHeadingSubtitleTextHeight,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _aboutPageHeadingTextStyle = TextStyle(
        fontSize: AppThemePreferences.aboutPageHeadingTextFontSize,
        fontWeight: AppThemePreferences.aboutPageHeadingTextFontWeight,
        color: isDark
            ? AppThemePreferences.normalTextColorDark
            : AppThemePreferences.normalTextColorLight);
    _genericAppBarTextStyle = TextStyle(
        fontSize: AppThemePreferences.genericAppBarTextFontSize,
        fontWeight: AppThemePreferences.genericAppBarTextFontWeight,
        color: isDark
            ? AppThemePreferences.genericAppBarTextColorDark
            : AppThemePreferences.genericAppBarTextColorLight);
    _genericTabBarTextStyle = TextStyle(
        fontSize: AppThemePreferences.genericTabBarTextFontSize,
        fontWeight: AppThemePreferences.genericTabBarTextFontWeight,
        color: isDark
            ? AppThemePreferences.genericTabBarTextColorDark
            : AppThemePreferences.genericTabBarTextColorLight);
    _facebookSignInButtonTextStyle = TextStyle(
        fontSize: AppThemePreferences.socialLoginTextFontSize,
        color: isDark
            ? AppThemePreferences.facebookSignInButtonTextColorDark
            : AppThemePreferences.facebookSignInButtonTextColorLight);
    _googleSignInButtonTextStyle = TextStyle(
        fontSize: AppThemePreferences.socialLoginTextFontSize,
        color: isDark
            ? AppThemePreferences.googleSignInButtonTextColorDark
            : AppThemePreferences.googleSignInButtonTextColorLight);
    _appleSignInButtonTextStyle = TextStyle(
        fontSize: AppThemePreferences.socialLoginTextFontSize,
        color: isDark
            ? AppThemePreferences.appleSignInButtonTextColorDark
            : AppThemePreferences.appleSignInButtonTextColorLight);
    _bottomSheetOptionsTextStyle = TextStyle(
        fontSize: AppThemePreferences.bottomSheetOptionsTextFontSize,
        color: AppThemePreferences.bottomSheetOptionsTextColor,
        fontWeight: AppThemePreferences.bottomSheetOptionsTextFontWeight);
    _bottomSheetNegativeOptionsTextStyle = TextStyle(
        fontSize: AppThemePreferences.bottomSheetOptionsTextFontSize,
        color: AppThemePreferences.bottomSheetNegativeOptionsTextColor,
        fontWeight: AppThemePreferences.bottomSheetOptionsTextFontWeight);
    _bottomSheetEmphasisOptionsTextStyle = TextStyle(
        fontSize: AppThemePreferences.bottomSheetOptionsTextFontSize,
        color: AppThemePreferences.bottomSheetOptionsTextColor,
        fontWeight:
            AppThemePreferences.bottomSheetEmphasisOptionsTextFontWeight);
    _sliverGreetingsTextStyle = TextStyle(
        fontSize: AppThemePreferences.sliverGreetingsTextFontSize,
        color: isDark
            ? AppThemePreferences.sliverGreetingsTextColorDark
            : AppThemePreferences.sliverGreetingsTextColorLight);
    _sliverUserNameTextStyle = TextStyle(
        fontSize: AppThemePreferences.sliverUserNameTextFontSize,
        fontWeight: AppThemePreferences.sliverUserNameTextFontWeight,
        color: isDark
            ? AppThemePreferences.sliverUserNameTextColorDark
            : AppThemePreferences.sliverUserNameTextColorLight);
    _sliverQuoteTextStyle = TextStyle(
        fontSize: AppThemePreferences.sliverQuoteTextFontSize,
        color: isDark
            ? AppThemePreferences.sliverQuoteTextColorDark
            : AppThemePreferences.sliverQuoteTextColorLight);
    _searchResultsTotalResultsTextStyle = TextStyle(
        fontSize: AppThemePreferences.searchResultsTotalResultsTextFontSize,
        fontWeight: AppThemePreferences.searchResultsTotalResultsTextFontWeight,
        color: isDark
            ? AppThemePreferences.titleTextColorDark
            : AppThemePreferences.titleTextColorLight);
    _searchResultsShowingSortedTextStyle = TextStyle(
        fontSize: AppThemePreferences.searchResultsShowingSortedTextFontSize,
        color: isDark
            ? AppThemePreferences.searchResultsShowingSortedTextColorDark
            : AppThemePreferences.searchResultsShowingSortedTextColorLight);
    _appBarActionWidgetsTextStyle = TextStyle(
        fontSize: AppThemePreferences.appBarActionWidgetsTextFontSize,
        color: AppThemePreferences.appBarActionWidgetsTextFontColor);
    _filterPageTempTextPlaceHolderTextStyle = TextStyle(
        fontSize: AppThemePreferences.filterPageTempTextPlaceHolderTextFontSize,
        fontWeight:
            AppThemePreferences.filterPageTempTextPlaceHolderTextFontWeight,
        color: isDark
            ? AppThemePreferences.filterPageTempTextPlaceHolderTextColorDark
            : AppThemePreferences.filterPageTempTextPlaceHolderTextColorLight);
    _crmTypeHeadingTextStyle = TextStyle(
        fontSize: AppThemePreferences.crmTypeHeadingTextFontSize,
        color: isDark
            ? AppThemePreferences.crmTypeHeadingTextColorDark
            : AppThemePreferences.crmTypeHeadingTextColorLight);
    _crmHeadingTextStyle = TextStyle(
        fontSize: AppThemePreferences.crmHeadingTextFontSize,
        fontWeight: AppThemePreferences.crmHeadingTextFontWeight,
        color: isDark
            ? AppThemePreferences.crmHeadingTextColorDark
            : AppThemePreferences.crmHeadingTextColorLight);
    _crmNormalTextStyle = TextStyle(
        fontSize: AppThemePreferences.crmNormalTextFontSize,
        fontWeight: AppThemePreferences.crmNormalTextFontWeight,
        height: AppThemePreferences.crmNormalTextHeight,
        color: isDark
            ? AppThemePreferences.crmNormalTextColorDark
            : AppThemePreferences.crmNormalTextColorLight);
    _crmSubNormalTextStyle = TextStyle(
        fontSize: AppThemePreferences.crmSubNormalTextFontSize,
        fontWeight: AppThemePreferences.crmNormalTextFontWeight,
        height: AppThemePreferences.crmNormalTextHeight,
        color: isDark
            ? AppThemePreferences.crmNormalTextColorDark
            : AppThemePreferences.crmSubNormalTextColorLight);
    _activitySubTitleTextStyle = TextStyle(
        fontSize: AppThemePreferences.crmActivitySubTitleTextFontSize,
        color: isDark
            ? AppThemePreferences.crmNormalTextColorDark
            : AppThemePreferences.activitySubTitleTextColorLight);
    _activityHeadingTextStyle = TextStyle(
        fontSize: AppThemePreferences.crmActivityHeadingTextFontSize,
        fontWeight: FontWeight.bold,
        color: isDark
            ? AppThemePreferences.crmNormalTextColorDark
            : AppThemePreferences.activityHeadingTextColorLight);
    _membershipTitleTextStyle = TextStyle(
        fontSize: AppThemePreferences.membershipTitleFontSize,
        fontWeight: FontWeight.bold,
        color: isDark
            ? AppThemePreferences.membershipTitleTextColorDark
            : AppThemePreferences.membershipTitleTextColorLight);
    _membershipPriceTextStyle = TextStyle(
        fontSize: AppThemePreferences.membershipPriceFontSize,
        fontWeight: FontWeight.bold,
        color: isDark
            ? AppThemePreferences.membershipPriceTextColorDark
            : AppThemePreferences.membershipPriceTextColorLight);
    _membershipPackageNameTextStyle = TextStyle(
        fontSize: AppThemePreferences.membershipPackageNameFontSize,
        fontWeight: FontWeight.bold,
        color: isDark
            ? AppThemePreferences.membershipPackageNameTextColorDark
            : AppThemePreferences.membershipPackageNameTextColorLight);
    _membershipExpireTextStyle = TextStyle(
        fontSize: AppThemePreferences.membershipExpireFontSize,
        color: isDark
            ? AppThemePreferences.membershipExpireTextColorDark
            : AppThemePreferences.membershipExpireTextColorLight);
    _privateNoteTextStyle = TextStyle(
        fontSize: AppThemePreferences.privateNoteFontSize,
        fontWeight: FontWeight.bold,
        color: isDark
            ? AppThemePreferences.privateNoteColorDark
            : AppThemePreferences.privateNoteColorLight);
    _blogLayoutCategoryTextStyle = TextStyle(
        fontSize: AppThemePreferences.blogLayoutCategoryFontSize,
        color: AppThemePreferences.blogLayoutCategoryFontColor);
    _blogAuthorInfoTextStyle =
        TextStyle(fontWeight: AppThemePreferences.blogAuthorInfoTextFontWeight);
    _blogCommentAuthorNameTextStyle = TextStyle(
        fontSize: AppThemePreferences.blogCommentAuthorNameFontSize,
        fontWeight: AppThemePreferences.blogCommentAuthorNameFontWeight);
    _blogCommentContentTextStyle =
        TextStyle(fontSize: AppThemePreferences.blogCommentContentFontSize);
    _blogCommentActionsTextStyle = TextStyle(
        fontSize: AppThemePreferences.blogCommentActionsFontSize,
        color: AppThemePreferences.blogCommentActionsColor);
    _messageUserStatusOnlineTextStyle = TextStyle(
        fontSize: AppThemePreferences.messageUserStatusFontSize,
        fontWeight: AppThemePreferences.messageUserStatusFontWeight,
        color: AppThemePreferences.messageUserStatusOnlineColor);
    _messageUserStatusOfflineTextStyle = TextStyle(
        fontSize: AppThemePreferences.messageUserStatusFontSize,
        fontWeight: AppThemePreferences.messageUserStatusFontWeight,
        color: AppThemePreferences.messageUserStatusOfflineColor);

    /// Brightness:
    _statusBarBrightness = isDark
        ? AppThemePreferences.statusBarIconBrightnessDark
        : AppThemePreferences.statusBarIconBrightnessLight;
    _statusBarIconBrightness = isDark
        ? AppThemePreferences.statusBarIconBrightnessLight
        : AppThemePreferences.statusBarIconBrightnessDark;
    _genericStatusBarIconBrightness = isDark
        ? AppThemePreferences.genericStatusBarIconBrightnessLight
        : AppThemePreferences.genericStatusBarIconBrightnessDark;

    /// SystemUiOverlayStyle:
    _systemUiOverlayStyle = isDark
        ? AppThemePreferences.systemUiOverlayStyleLight
        : AppThemePreferences.systemUiOverlayStyleDark;

    /// colors:
    _primaryColor = AppThemePreferences.appPrimaryColor;
    _normalTextColor = (isDark
        ? AppThemePreferences.normalTextColorDark
        : AppThemePreferences.normalTextColorLight)!;
    _iconsColor = isDark
        ? AppThemePreferences.appIconsMasterColorDark
        : AppThemePreferences.appIconsMasterColorLight;
    _genericStatusBarColor = isDark
        ? AppThemePreferences.genericStatusBarColorDark
        : AppThemePreferences.genericStatusBarColorLight;
    _genericAppBarIconsColor = (isDark
        ? AppThemePreferences.genericAppBarIconsColorDark
        : AppThemePreferences.genericAppBarIconsColorLight)!;
    _homeScreenStatusBarColor = (isDark
        ? AppThemePreferences.homeScreenStatusBarColorDark
        : AppThemePreferences.homeScreenStatusBarColorLight)!;
    _homeScreen02StatusBarColor = isDark
        ? AppThemePreferences.homeScreenStatusBarColorDark
        : AppThemePreferences.homeScreen02StatusBarColorLight;
    _selectedItemTextColor = (isDark
        ? AppThemePreferences.selectedItemTextColorDark
        : AppThemePreferences.selectedItemTextColorLight)!;
    _unSelectedItemTextColor = (isDark
        ? AppThemePreferences.unSelectedItemTextColorDark
        : AppThemePreferences.unSelectedItemTextColorLight)!;
    _selectedItemBackgroundColor = (isDark
        ? AppThemePreferences.selectedItemBackgroundColorDark
        : AppThemePreferences.selectedItemBackgroundColorLight)!;
    _unSelectedItemBackgroundColor = (isDark
        ? AppThemePreferences.unSelectedItemBackgroundColorDark
        : AppThemePreferences.unSelectedItemBackgroundColorLight)!;
    _sliverAppBarBackgroundColor = (isDark
        ? AppThemePreferences.sliverAppBarBackgroundColorDark
        : AppThemePreferences.sliverAppBarBackgroundColorLight)!;
    _sliverAppBar02BackgroundColor = isDark
        ? AppThemePreferences.sliverAppBarBackgroundColorDark
        : AppThemePreferences.sliverAppBar02BackgroundColorLight;
    _backgroundColor = isDark
        ? AppThemePreferences.backgroundColorDark
        : AppThemePreferences.backgroundColorLight;
    _dividerColor = isDark
        ? AppThemePreferences.dividerColorDark
        : AppThemePreferences.dividerColorLight;
    _cardColor = isDark
        ? AppThemePreferences.cardColorDark
        : AppThemePreferences.cardColorLight;
    _hintColor = isDark
        ? AppThemePreferences.hintColorDark
        : AppThemePreferences.hintColorLight;
    _shimmerEffectBaseColor = (isDark
        ? AppThemePreferences.shimmerEffectBaseColorDark
        : AppThemePreferences.shimmerEffectBaseColorLight)!;
    _shimmerEffectHighLightColor = (isDark
        ? AppThemePreferences.shimmerEffectHighLightColorDark
        : AppThemePreferences.shimmerEffectHighLightColorLight)!;
    _shimmerEffectErrorWidgetBackgroundColor = (isDark
        ? AppThemePreferences.shimmerEffectErrorWidgetBackgroundColorDark
        : AppThemePreferences.shimmerEffectErrorWidgetBackgroundColorLight)!;
    _homeScreenTopBarRightArrowBackgroundColor = isDark
        ? AppThemePreferences.homeScreenTopBarRightArrowBackgroundColorDark
        : AppThemePreferences.homeScreenTopBarRightArrowBackgroundColorLight;
    _searchBarBackgroundColor = isDark
        ? AppThemePreferences.searchBarBackgroundColorDark
        : AppThemePreferences.searchBarBackgroundColorLight;
    _searchBar02BackgroundColor = (isDark
        ? AppThemePreferences.searchBarBackgroundColorDark
        : AppThemePreferences.searchBar02BackgroundColorLight)!;
    _switchSelectedItemTextColor = (isDark
        ? AppThemePreferences.switchSelectedTextDark
        : AppThemePreferences.switchSelectedTextLight)!;
    _switchUnselectedItemTextColor = (isDark
        ? AppThemePreferences.switchUnselectedTextDark
        : AppThemePreferences.switchUnselectedTextLight)!;
    _switchSelectedBackgroundColor = (isDark
        ? AppThemePreferences.switchSelectedBackgroundDark
        : AppThemePreferences.switchSelectedBackgroundLight)!;
    _switchUnselectedBackgroundColor = (isDark
        ? AppThemePreferences.switchUnselectedBackgroundDark
        : AppThemePreferences.switchUnselectedBackgroundLight)!;
    _featuredTagBackgroundColor = isDark
        ? AppThemePreferences.featuredTagBackgroundColorDark
        : AppThemePreferences.featuredTagBackgroundColorLight;
    _featuredTagBorderColor = isDark
        ? AppThemePreferences.featuredTagBorderColorDark
        : AppThemePreferences.featuredTagBorderColorLight;
    _tagBackgroundColor = isDark
        ? AppThemePreferences.tagBackgroundColorDark
        : AppThemePreferences.tagBackgroundColorLight;
    _tagBorderColor = isDark
        ? AppThemePreferences.tagBorderColorDark
        : AppThemePreferences.tagBorderColorLight;
    _propertyStatusTagBackgroundColor = isDark
        ? AppThemePreferences.propertyStatusTagBackgroundColorDark
        : AppThemePreferences.propertyStatusTagBackgroundColorLight;
    _shimmerEffectErrorIconColor = (isDark
        ? AppThemePreferences.shimmerEffectErrorIconColorDark
        : AppThemePreferences.shimmerEffectErrorIconColorLight)!;
    _bottomNavigationMenuColor = isDark
        ? AppThemePreferences.bottomNavigationMenuColorDark
        : AppThemePreferences.bottomNavigationMenuColorLight;
    _propertyDetailsPageTopBarDividerColor = (isDark
        ? AppThemePreferences.propertyDetailsPageTopBarDividerColorDark
        : AppThemePreferences.propertyDetailsPageTopBarDividerColorLight)!;
    _propertyDetailsPageTopBarShadowColor = (isDark
        ? AppThemePreferences.propertyDetailsPageTopBarShadowColorDark
        : AppThemePreferences.propertyDetailsPageTopBarShadowColorLight)!;
    _propertyDetailsPageTopBarIconsColor = isDark
        ? AppThemePreferences.propertyDetailsPageTopBarIconsColorDark
        : AppThemePreferences.propertyDetailsPageTopBarIconsColorLight;
    _propertyDetailsPageTopBarIconsBackgroundColor = (isDark
        ? AppThemePreferences.propertyDetailsPageTopBarIconsBackgroundColorDark
        : AppThemePreferences
            .propertyDetailsPageTopBarIconsBackgroundColorLight)!;
    _containerBackgroundColor = (isDark
        ? AppThemePreferences.containerBackgroundColorDark
        : AppThemePreferences.containerBackgroundColorLight)!;
    _propertyDetailsPageChipsBackgroundColor = (isDark
        ? AppThemePreferences.propertyDetailsPageChipsBackgroundColorDark
        : AppThemePreferences.propertyDetailsPageChipsBackgroundColorLight)!;
    _favouriteWidgetBackgroundColor = (isDark
        ? AppThemePreferences.favouriteWidgetBackgroundColorDark
        : AppThemePreferences.favouriteWidgetBackgroundColorLight)!;
    _facebookSignInButtonColor = isDark
        ? AppThemePreferences.facebookSignInButtonColorDark
        : AppThemePreferences.facebookSignInButtonColorLight;
    _googleSignInButtonColor = isDark
        ? AppThemePreferences.googleSignInButtonColorDark
        : AppThemePreferences.googleSignInButtonColorLight;
    _appleSignInButtonColor = isDark
        ? AppThemePreferences.appleSignInButtonColorDark
        : AppThemePreferences.appleSignInButtonColorLight;
    _filterPageIconsColor = isDark
        ? AppThemePreferences.filterPageIconsColorDark
        : AppThemePreferences.filterPageIconsColorLight;
    _homeScreenSearchBarIconColor = isDark
        ? AppThemePreferences.homeScreenSearchBarIconColorDark
        : AppThemePreferences.homeScreenSearchBarIconColorLight;
    _searchPageChoiceChipsBackgroundColor = (isDark
        ? AppThemePreferences.searchPageChoiceChipsBackgroundColorDark
        : AppThemePreferences.searchPageChoiceChipsBackgroundColorLight)!;
    _homeScreenSearchArrowIconBackgroundColor = isDark
        ? AppThemePreferences.homeScreenSearchArrowIconBackgroundColorDark
        : AppThemePreferences.homeScreenSearchArrowIconBackgroundColorLight;
    _bottomNavBarBackgroundColor = isDark
        ? AppThemePreferences.bottomNavBarBackgroundColorDark
        : AppThemePreferences.bottomNavBarBackgroundColorLight;
    _articleDesignItemBackgroundColor = isDark
        ? AppThemePreferences.articleDesignItemBackgroundColorDark
        : AppThemePreferences.articleDesignItemBackgroundColorLight;
    _recentSearchesBorderColor = isDark
        ? AppThemePreferences.recentSearchesBorderColorDark
        : AppThemePreferences.recentSearchesBorderColorLight;
    _crmIconColor = isDark
        ? AppThemePreferences.crmIconColorDark
        : AppThemePreferences.crmIconColorLight;
    _crmTypeHeadingTextColor = isDark
        ? AppThemePreferences.crmTypeHeadingTextColorDark
        : AppThemePreferences.crmTypeHeadingTextColorLight;
    _crmTypeHeadingTextColor = isDark
        ? AppThemePreferences.crmHeadingTextColorDark
        : AppThemePreferences.crmHeadingTextColorLight;
    _cupertinoSegmentThumbColor = isDark
        ? AppThemePreferences.cupertinoSegmentThumbColorDark
        : AppThemePreferences.cupertinoSegmentThumbColorLight;
    _bottomSheetBgColor = isDark
        ? AppThemePreferences.bottomSheetBgColorDark
        : AppThemePreferences.bottomSheetBgColorLight;
    _choiceChipsBgColor = isDark
        ? AppThemePreferences.choiceChipsBgColorDark
        : AppThemePreferences.choiceChipsBgColorLight;
    _popUpMenuBgColor = isDark
        ? AppThemePreferences.popUpMenuBgColorDark
        : AppThemePreferences.popUpMenuBgColorLight;
    _dropdownMenuBgColor = isDark
        ? AppThemePreferences.dropdownMenuBgColorDark
        : AppThemePreferences.dropdownMenuBgColorLight;
    _notificationWidgetBgColor = isDark
        ? AppThemePreferences.notificationWidgetBgColorDark
        : AppThemePreferences.notificationWidgetBgColorLight;
    _messagesTextColor = isDark
        ? AppThemePreferences.messagesTextColorDark
        : AppThemePreferences.messagesTextColorLight;
    _messageReceiverBgColor = isDark
        ? AppThemePreferences.messageReceiverBgColorDark
        : AppThemePreferences.messageReceiverBgColorLight;
    _messageScrollFABBgColor = isDark
        ? AppThemePreferences.messageScrollPageFABBgColorDark
        : AppThemePreferences.messageScrollPageFABBgColorLight;
    _messageTimeBgColor = isDark
        ? AppThemePreferences.messageTimeBgColorDark
        : AppThemePreferences.messageTimeBgColorLight;
    _messageTimeTextColor = isDark
        ? AppThemePreferences.messageTimeTextColorDark
        : AppThemePreferences.messageTimeTextColorLight;
    _messageTextFieldOuterBgColor = isDark
        ? AppThemePreferences.messageTextFieldOuterBgColorDark
        : AppThemePreferences.messageTextFieldOuterBgColorLight;
    _messageTextFieldInnerBgColor = isDark
        ? AppThemePreferences.messageTextFieldInnerBgColorDark
        : AppThemePreferences.messageTextFieldInnerBgColorLight;
    _sendMessageIconColor = isDark
        ? AppThemePreferences.sendMessageIconColorDark
        : AppThemePreferences.sendMessageIconColorLight;
    _sendMessageAppBarBgColor = isDark
        ? AppThemePreferences.sendMessageAppBarBgColorDark
        : AppThemePreferences.sendMessageAppBarBgColorLight;

    /// icons:
    _drawerMenuIcon = Icon(AppThemePreferences.drawerMenuIcon,
        color: isDark
            ? AppThemePreferences.drawerMenuIconColorDark
            : AppThemePreferences.drawerMenuIconColorLight);
    _drawer02MenuIcon = Icon(AppThemePreferences.drawerMenuIcon,
        color: isDark
            ? AppThemePreferences.drawerMenuIconColorDark
            : AppThemePreferences.drawerMenu02IconColorLight);
    _homeScreenTopBarLocationIcon = Icon(AppThemePreferences.locationIcon,
        size: AppThemePreferences.homeScreenTopBarLocationIconSize,
        color: isDark
            ? AppThemePreferences.homeScreenTopBarLocationIconColorDark
            : AppThemePreferences.homeScreenTopBarLocationIconColorLight);
    _homeScreenTopBarLocationFilledIcon = Icon(
        AppThemePreferences.locationFilledIcon,
        size: AppThemePreferences.homeScreenTopBarLocationFilledIconSize,
        color: isDark
            ? AppThemePreferences.homeScreenTopBarLocationIconColorDark
            : AppThemePreferences.homeScreenTopBarLocationIconColorLight);
    _homeScreenTopBarRightArrowIcon = Icon(AppThemePreferences.rightArrowIcon,
        size: AppThemePreferences.homeScreenTopBarRightArrowIconSize,
        color: isDark
            ? AppThemePreferences.homeScreenTopBarRightArrowIconColorDark
            : AppThemePreferences.homeScreenTopBarRightArrowIconColorLight);
    _homeScreenTopBarDownArrowIcon = Icon(AppThemePreferences.dropDownArrowIcon,
        size: AppThemePreferences.homeScreenTopBarDownArrowIconSize,
        color: isDark
            ? AppThemePreferences.homeScreenTopBarRightArrowIconColorDark
            : AppThemePreferences.homeScreenTopBarDownArrowIconColorLight);
    _homeScreenTopBarSearchIcon = Icon(AppThemePreferences.searchIcon,
        size: AppThemePreferences.homeScreenTopBarSearchIconSize,
        color: isDark
            ? AppThemePreferences.homeScreenTopBarSearchIconColorDark
            : AppThemePreferences.homeScreenTopBarSearchIconColorLight);
    _propertyDetailPageRightArrowIcon = Icon(AppThemePreferences.rightArrowIcon,
        size: AppThemePreferences.propertyDetailPageRightArrowIconSize,
        color: isDark
            ? AppThemePreferences.homeScreenTopBarRightArrowIconColorDark
            : AppThemePreferences.homeScreenTopBarRightArrowIconColorLight);
    _homeScreenSearchBarIcon = Icon(AppThemePreferences.searchIcon,
        size: AppThemePreferences.homeScreenSearchBarIconSize,
        color: isDark
            ? AppThemePreferences.homeScreenSearchBarIconColorDark
            : AppThemePreferences.homeScreenSearchBarIconColorLight);
    _homeScreenSearchBarFilterIcon = Icon(AppThemePreferences.filterIcon,
        size: AppThemePreferences.homeScreenSearchBarIconSize,
        color: isDark
            ? AppThemePreferences.homeScreenSearchBarIconColorDark
            : AppThemePreferences.homeScreenSearchBarIconColorLight);
    _searchBarIcon = Icon(AppThemePreferences.searchIcon,
        size: AppThemePreferences.homeScreenSearchBarIconSize,
        color: isDark
            ? AppThemePreferences.unSelectedItemTextColorDark
            : AppThemePreferences.unSelectedItemTextColorLight);
    _shimmerEffectImageErrorIcon = Icon(AppThemePreferences.imageIcon,
        size: AppThemePreferences.shimmerEffectImageErrorIconSize,
        color: isDark
            ? AppThemePreferences.shimmerEffectErrorIconColorDark
            : AppThemePreferences.shimmerEffectErrorIconColorLight);
    _articleBoxLocationIcon = Icon(AppThemePreferences.locationIcon,
        size: AppThemePreferences.articleBoxIconSize,
        color: isDark
            ? AppThemePreferences.articleBoxIconsColorDark
            : AppThemePreferences.articleBoxIconsColorLight);
    _articleBoxBedIcon = Icon(AppThemePreferences.bedIcon,
        size: AppThemePreferences.articleBoxIconSize,
        color: isDark
            ? AppThemePreferences.articleBoxIconsColorDark
            : AppThemePreferences.articleBoxIconsColorLight);
    _articleBoxBathtubIcon = Icon(AppThemePreferences.bathtubIcon,
        size: AppThemePreferences.articleBoxIconSize,
        color: isDark
            ? AppThemePreferences.articleBoxIconsColorDark
            : AppThemePreferences.articleBoxIconsColorLight);
    _articleBoxAreaSizeIcon = Icon(AppThemePreferences.areaSizeIcon,
        size: AppThemePreferences.articleBoxIconSize,
        color: isDark
            ? AppThemePreferences.articleBoxIconsColorDark
            : AppThemePreferences.articleBoxIconsColorLight);
    _filterPageCheckCircleIcon = Icon(AppThemePreferences.checkCircleIcon,
        size: AppThemePreferences.filterPageCheckCircleIconSize,
        color: isDark
            ? AppThemePreferences.filterPageIconsColorDark
            : AppThemePreferences.filterPageIconsColorLight);
    _filterPageLocationIcon = Icon(AppThemePreferences.locationIcon,
        size: AppThemePreferences.filterPageLocationIconSize,
        color: isDark
            ? AppThemePreferences.filterPageIconsColorDark
            : AppThemePreferences.filterPageIconsColorLight);
    _filterPageGpsLocationIcon = Icon(AppThemePreferences.gpsLocationIcon,
        size: AppThemePreferences.filterPageLocationIconSize,
        color: isDark
            ? AppThemePreferences.filterPageIconsColorDark
            : AppThemePreferences.filterPageIconsColorLight);
    _filterPageRadiusLocationIcon = Icon(AppThemePreferences.radiusLocationIcon,
        size: AppThemePreferences.filterPageLocationIconSize,
        color: isDark
            ? AppThemePreferences.filterPageIconsColorDark
            : AppThemePreferences.filterPageIconsColorLight);
    _filterPageArrowForwardIcon = Icon(AppThemePreferences.arrowForwardIcon,
        size: AppThemePreferences.filterPageArrowForwardIconSize,
        color: isDark
            ? AppThemePreferences.filterPageIconsColorDark
            : AppThemePreferences.filterPageIconsColorLight);
    _filterPageLocationCityIcon = Icon(AppThemePreferences.locationCityIcon,
        size: AppThemePreferences.filterPageLocationCityIconSize,
        color: isDark
            ? AppThemePreferences.filterPageIconsColorDark
            : AppThemePreferences.filterPageIconsColorLight);
    _filterPageArrowDropDownIcon = Icon(AppThemePreferences.dropDownArrowIcon,
        size: AppThemePreferences.filterPageArrowDropDownIconSize,
        color: isDark
            ? AppThemePreferences.filterPageIconsColorDark
            : AppThemePreferences.filterPageIconsColorLight);
    _filterPagePriceTagIcon = Icon(AppThemePreferences.priceTagIcon,
        size: AppThemePreferences.filterPagePriceTagIconSize,
        color: isDark
            ? AppThemePreferences.filterPageIconsColorDark
            : AppThemePreferences.filterPageIconsColorLight);
    _filterPageAreaSizeIcon = Icon(AppThemePreferences.areaSizeIcon,
        size: AppThemePreferences.filterPageAreaSizeIconSize,
        color: isDark
            ? AppThemePreferences.filterPageIconsColorDark
            : AppThemePreferences.filterPageIconsColorLight);
    _filterPageBedroomIcon = Icon(AppThemePreferences.bedIcon,
        size: AppThemePreferences.filterPageBedroomIconSize,
        color: isDark
            ? AppThemePreferences.filterPageIconsColorDark
            : AppThemePreferences.filterPageIconsColorLight);
    _filterPageBathroomIcon = Icon(AppThemePreferences.bathtubIcon,
        size: AppThemePreferences.filterPageBathroomIconSize,
        color: isDark
            ? AppThemePreferences.filterPageIconsColorDark
            : AppThemePreferences.filterPageIconsColorLight);
    _bottomNavigationMenuIcon = Icon(AppThemePreferences.doneIcon,
        size: AppThemePreferences.bottomNavigationMenuIconSize,
        color: isDark
            ? AppThemePreferences.appSecondaryColor
            : AppThemePreferences.appSecondaryColor);
    _propertyDetailsImageIndicatorCameraIcon = Icon(
        AppThemePreferences.cameraIcon,
        size: AppThemePreferences.propertyDetailsImageIndicatorCameraIconSize,
        color: isDark
            ? AppThemePreferences
                .propertyDetailsImageIndicatorCameraIconColorDark
            : AppThemePreferences
                .propertyDetailsImageIndicatorCameraIconColorLight);
    _propertyDetailsChipsIcon = Icon(AppThemePreferences.checkCircleIcon,
        size: AppThemePreferences.propertyDetailsChipsIconSize,
        color: AppThemePreferences.propertyDetailsChipsIconColor);
    _messageIconWidget = Icon(AppThemePreferences.messageIcon,
        color: AppThemePreferences.filledButtonIconColor);
    // _dotIcon = Icon(AppThemePreferences.dotIcon, size: AppThemePreferences.dotIconSize, color: AppThemePreferences.dotIconColor);
    /// images:
    _drawerImage = Image.asset(
      AppThemePreferences.drawerImagePath,
      height: AppThemePreferences.drawerImageHeight,
      width: AppThemePreferences.drawerImageWidth,
    );

    /// images path:
    _appleIconImagePath = isDark
        ? AppThemePreferences.appleDarkIconImagePath
        : AppThemePreferences.appleLightIconImagePath;

    /// iconData:
    _imageIconData = AppThemePreferences.imageIcon;
    _whatsAppIcon = Image.asset(
      AppThemePreferences.whatsAppIconImagePath,
      height: AppThemePreferences.whatsappImageHeight,
      width: AppThemePreferences.whatsappImageWidth,
    );
    _lineAppIcon = Image.asset(AppThemePreferences.lineAppIconImagePath,
        height: AppThemePreferences.lineAppImageHeight,
        width: AppThemePreferences.lineAppImageWidth);
    _telegramIcon = Image.asset(AppThemePreferences.telegramIconImagePath,
        height: AppThemePreferences.telegramImageHeight,
        width: AppThemePreferences.telegramImageWidth);

    /// border side:
    _filterPageBorderSide = BorderSide(
        width: AppThemePreferences.filterPageBorderWidth, color: dividerColor!);
    _bottomNavigationMenuBorderSide = BorderSide(
        width: AppThemePreferences.bottomNavigationMenuBorderWidth,
        color: dividerColor!);
    _propertyDetailsPageBottomMenuBorderSide = BorderSide(
        width: AppThemePreferences.propertyDetailsPageBottomMenuBorderWidth,
        color: dividerColor!);
  }

  ///
  ///
  /// TextStyles:
  ///
  ///
  /// tagTextStyle for Tags e.g. For rent, For sale etc.
  TextStyle? _tagTextStyle;

  TextStyle? get tagTextStyle => _tagTextStyle;

  ///
  /// tagTextStyle for Featured Tags.
  TextStyle? _featuredTagTextStyle;

  TextStyle? get featuredTagTextStyle => _featuredTagTextStyle;

  ///
  ///
  TextStyle? _tag01TextStyle;

  TextStyle? get tag01TextStyle => _tag01TextStyle;

  ///
  /// button for text on Button.
  TextStyle? _buttonTextStyle;

  TextStyle? get buttonTextStyle => _buttonTextStyle;

  ///
  /// Heading Style for Main Heading of App in Light Mode e.g. Featured Properties, Latest Properties etc.
  TextStyle? _headingTextStyle;

  TextStyle? get headingTextStyle => _headingTextStyle;

  ///
  /// Bold Heading Style for Main Heading of App in Light Mode e.g. Featured Properties, Latest Properties etc.
  TextStyle? _heading03TextStyle;

  TextStyle? get heading03TextStyle => _heading03TextStyle;

  ///
  /// Heading Style with FontWeight.w400 for Item titles.
  TextStyle? _heading01TextStyle;

  TextStyle? get heading01TextStyle => _heading01TextStyle;

  ///
  /// Heading Style with FontWeight.w400 and Primary Color for Item titles.
  TextStyle? _heading02TextStyle;

  TextStyle? get heading02TextStyle => _heading02TextStyle;

  ///
  /// normalTextStyle1 for Normal text e.g. Labels, Text Fields, Form Field etc.
  TextStyle? _labelTextStyle;

  TextStyle? get labelTextStyle => _labelTextStyle;

  ///
  /// _label01TextStyle for the Labels e.g. Property Detailed Features Property Id: , Price: etc.
  TextStyle? _label01TextStyle;

  TextStyle? get label01TextStyle => _label01TextStyle;

  ///
  /// _label01TextStyle for the Labels e.g. Property Detailed Features Property Id: , Price: etc.
  TextStyle? _label04TextStyle;

  TextStyle? get label04TextStyle => _label04TextStyle;

  ///
  /// _label02TextStyle for the Primary Colored Labels.
  TextStyle? _label02TextStyle;

  TextStyle? get label02TextStyle => _label02TextStyle;

  ///
  /// _label03TextStyle for the Gray Colored (sub text / disabled text) Labels.
  TextStyle? _label03TextStyle;

  TextStyle? get label03TextStyle => _label03TextStyle;

  ///
  /// _titleTextStyle is bold for Item title e.g. Apartment at riverside etc.
  TextStyle? _titleTextStyle;

  TextStyle? get titleTextStyle => _titleTextStyle;

  ///
  /// bodyText for normal body text e.g. Property Description, Any Message, Comments etc.
  TextStyle? _bodyTextStyle;

  TextStyle? get bodyTextStyle => _bodyTextStyle;

  ///
  /// _body01TextStyle
  TextStyle? _body01TextStyle;

  TextStyle? get body01TextStyle => _body01TextStyle;

  ///
  /// _body02TextStyle for body text without any height and weight
  TextStyle? _body02TextStyle;

  TextStyle? get body02TextStyle => _body02TextStyle;

  ///
  /// _body03TextStyle for Primary colored body text without any height and weight
  TextStyle? _body03TextStyle;

  TextStyle? get body03TextStyle => _body03TextStyle;

  ///
  /// _body03TextStyle for Primary colored body text without any height and weight
  TextStyle? _linkTextStyle;

  TextStyle? get linkTextStyle => _linkTextStyle;

  ///
  /// _subBodyTextStyle for sub-body e.g. Address, Sq.ft., Bed, Bath, Property Type, Price, In List Items etc.
  TextStyle? _subBodyTextStyle;

  TextStyle? get subBodyTextStyle => _subBodyTextStyle;

  ///
  /// _subBody01TextStyle for the values e.g. In Property Detailed Features 425, $1900/mo etc.
  TextStyle? _subBody01TextStyle;

  TextStyle? get subBody01TextStyle => _subBody01TextStyle;

  ///
  /// _subBody05TextStyle for the values e.g. In Property Detailed Features 425, $1900/mo etc.
  TextStyle? _subBody05TextStyle;

  TextStyle? get subBody05TextStyle => _subBody05TextStyle;

  ///
  /// _subTitle01TextStyle for the Text below icons e.g. Property Details: Bedroom count, Bathroom count etc.
  TextStyle? _subTitle01TextStyle;

  TextStyle? get subTitle01TextStyle => _subTitle01TextStyle;

  ///
  /// _subTitleTextStyle for the Text below icons e.g. Property Details: Bedroom count, Bathroom count etc.
  TextStyle? _subTitleTextStyle;

  TextStyle? get subTitleTextStyle => _subTitleTextStyle;

  ///
  TextStyle? _articleReviewsTitle;

  TextStyle? get articleReviewsTitle => _articleReviewsTitle;

  ///
  /// _subTitle02TextStyle for the Text below icons Text e.g. Bedrooms, Bathrooms etc.
  TextStyle? _subTitle02TextStyle;

  TextStyle? get subTitle02TextStyle => _subTitle02TextStyle;

  ///
  /// _hintTextStyle for the Hint text.
  TextStyle? _hintTextStyle;

  TextStyle? get hintTextStyle => _hintTextStyle;

  ///
  /// _toastTextTextStyle for the Text of Toast.
  TextStyle? _toastTextTextStyle;

  TextStyle? get toastTextTextStyle => _toastTextTextStyle;

  ///
  /// _readMoreTextStyle.
  TextStyle? _readMoreTextStyle;

  TextStyle? get readMoreTextStyle => _readMoreTextStyle;

  ///
  /// Search by Id Text Style
  TextStyle? _searchByIdTextStyle;

  TextStyle? get searchByIdTextStyle => _searchByIdTextStyle;

  ///
  /// Search Text Style
  TextStyle? _searchBarTextStyle;

  TextStyle? get searchBarTextStyle => _searchBarTextStyle;

  ///
  /// HomeScreen Drawer Text Style
  TextStyle? _homeScreenDrawerTextStyle;

  TextStyle? get homeScreenDrawerTextStyle => _homeScreenDrawerTextStyle;

  ///
  /// HomeScreen Drawer User Name Text Style
  TextStyle? _homeScreenDrawerUserNameTextStyle;

  TextStyle? get homeScreenDrawerUserNameTextStyle =>
      _homeScreenDrawerUserNameTextStyle;

  ///
  /// _articleBoxPropertyStatusTextStyle for Property Status.
  TextStyle? _articleBoxPropertyStatusTextStyle;

  TextStyle? get articleBoxPropertyStatusTextStyle =>
      _articleBoxPropertyStatusTextStyle;

  ///
  /// _articleBoxPropertyPriceTextStyle for Property Price.
  TextStyle? _articleBoxPropertyPriceTextStyle;

  TextStyle? get articleBoxPropertyPriceTextStyle =>
      _articleBoxPropertyPriceTextStyle;

  ///
  /// _explorePropertyTextStyle for Titles like City Names, Property Types etc.
  TextStyle? _explorePropertyTextStyle;

  TextStyle? get explorePropertyTextStyle => _explorePropertyTextStyle;

  ///
  /// _homeScreenRealtorInfoTextStyle for Titles like Realtor Name, Realtor Agency Name etc.
  TextStyle? _homeScreenRealtorTitleTextStyle;

  TextStyle? get homeScreenRealtorTitleTextStyle =>
      _homeScreenRealtorTitleTextStyle;

  ///
  /// _homeScreenRealtorInfoTextStyle for description purposes etc.
  TextStyle? _homeScreenRealtorInfoTextStyle;

  TextStyle? get homeScreenRealtorInfoTextStyle =>
      _homeScreenRealtorInfoTextStyle;

  ///
  /// _filterPageTitleTextStyle for Titles on Filter Page e.g. Property Type, Price Range, Area Range etc.
  TextStyle? _filterPageHeadingTitleTextStyle;

  TextStyle? get filterPageHeadingTitleTextStyle =>
      _filterPageHeadingTitleTextStyle;

  ///
  /// _locationWidgetTextStyle for the Location widget Text.
  TextStyle? _locationWidgetTextStyle;

  TextStyle? get locationWidgetTextStyle => _locationWidgetTextStyle;

  ///
  /// _propertyTypeWidgetChoiceChipTextStyle for the Choice Chips Text.
  TextStyle? _filterPageChoiceChipTextStyle;

  TextStyle? get filterPageChoiceChipTextStyle =>
      _filterPageChoiceChipTextStyle;

  ///
  /// _rangeSliderWidgetConversionUnitTextStyle for the Range Slider Widget Conversion Unit Text e.g. Currency Unit, Area size Unit etc.
  TextStyle? _rangeSliderWidgetConversionUnitTextStyle;

  TextStyle? get rangeSliderWidgetConversionUnitTextStyle =>
      _rangeSliderWidgetConversionUnitTextStyle;

  ///
  /// _bottomNavigationMenuTitleTextStyle for the Title of Bottom Navigation Menu.
  TextStyle? _bottomSheetMenuTitleTextStyle;

  TextStyle? get bottomSheetMenuTitleTextStyle =>
      _bottomSheetMenuTitleTextStyle;

  ///
  /// _bottomNavigationMenuTitle01TextStyle for the Title of Bottom Navigation Menu.
  TextStyle? _bottomSheetMenuTitle01TextStyle;

  TextStyle? get bottomSheetMenuTitle01TextStyle =>
      _bottomSheetMenuTitle01TextStyle;

  ///
  /// _bottomSheetMenuSubTitleTextStyle for the Title of Bottom Navigation Menu.
  TextStyle? _bottomSheetMenuSubTitleTextStyle;

  TextStyle? get bottomSheetMenuSubTitleTextStyle =>
      _bottomSheetMenuSubTitleTextStyle;

  ///
  /// _bottomNavigationMenuItemsTextStyle for the Items of Bottom Navigation Menu.
  TextStyle? _bottomNavigationMenuItemsTextStyle;

  TextStyle? get bottomNavigationMenuItemsTextStyle =>
      _bottomNavigationMenuItemsTextStyle;

  ///
  /// _filterPageResetTextStyle for Reset Text, TextStyle.
  TextStyle? _filterPageResetTextStyle;

  TextStyle? get filterPageResetTextStyle => _filterPageResetTextStyle;

  ///
  /// _propertyDetailsPageTopBarTitleTextStyle for Property Details Page TopBar Title TextStyle.
  TextStyle? _propertyDetailsPageTopBarTitleTextStyle;

  TextStyle? get propertyDetailsPageTopBarTitleTextStyle =>
      _propertyDetailsPageTopBarTitleTextStyle;

  ///
  /// Property Details Page Image Indicator Text TextStyle.
  TextStyle? _propertyDetailsPageImageIndicatorTextTextStyle;

  TextStyle? get propertyDetailsPageImageIndicatorTextTextStyle =>
      _propertyDetailsPageImageIndicatorTextTextStyle;

  ///
  /// Property Details Page Property Title TextStyle.
  TextStyle? _propertyDetailsPagePropertyTitleTextStyle;

  TextStyle? get propertyDetailsPagePropertyTitleTextStyle =>
      _propertyDetailsPagePropertyTitleTextStyle;

  ///
  /// Property Details Page Property Status TextStyle.
  TextStyle? _propertyDetailsPagePropertyStatusTextStyle;

  TextStyle? get propertyDetailsPagePropertyStatusTextStyle =>
      _propertyDetailsPagePropertyStatusTextStyle;

  ///
  /// Property Details Page Property Price TextStyle.
  TextStyle? _propertyDetailsPagePropertyPriceTextStyle;

  TextStyle? get propertyDetailsPagePropertyPriceTextStyle =>
      _propertyDetailsPagePropertyPriceTextStyle;

  ///
  /// Property Details Page Property Detailed Features TextStyle.
  TextStyle? _propertyDetailsPagePropertyDetailFeaturesTextStyle;

  TextStyle? get propertyDetailsPagePropertyDetailFeaturesTextStyle =>
      _propertyDetailsPagePropertyDetailFeaturesTextStyle;

  ///
  /// Generic StatusBar TextStyle.
  TextStyle? _genericAppBarTextStyle;

  TextStyle? get genericAppBarTextStyle => _genericAppBarTextStyle;

  ///
  /// Generic TabBar TextStyle.
  TextStyle? _genericTabBarTextStyle;

  TextStyle? get genericTabBarTextStyle => _genericTabBarTextStyle;

  ///
  /// Generic StatusBar TextStyle.
  TextStyle? _genericStatusBarTextStyle;

  TextStyle? get genericStatusBarTextStyle => _genericStatusBarTextStyle;

  ///
  /// Home Screen Recent Search Title TextStyle.
  TextStyle? _homeScreenRecentSearchTitleTextStyle;

  TextStyle? get homeScreenRecentSearchTitleTextStyle =>
      _homeScreenRecentSearchTitleTextStyle;

  ///
  /// Home Screen Recent Search City TextStyle.
  TextStyle? _homeScreenRecentSearchCityTextStyle;

  TextStyle? get homeScreenRecentSearchCityTextStyle =>
      _homeScreenRecentSearchCityTextStyle;

  ///
  ///  Form Field Error TextStyle.
  TextStyle? _formFieldErrorTextStyle;

  TextStyle? get formFieldErrorTextStyle => _formFieldErrorTextStyle;

  ///
  ///  Rising Leads TextStyle.
  TextStyle? _risingLeadsTextStyle;

  TextStyle? get risingLeadsTextStyle => _risingLeadsTextStyle;

  ///
  ///  Falling Leads TextStyle.
  TextStyle? _fallingLeadsTextStyle;

  TextStyle? get fallingLeadsTextStyle => _fallingLeadsTextStyle;

  ///
  ///  App Info TextStyle.
  TextStyle? _appInfoTextStyle;

  TextStyle? get appInfoTextStyle => _appInfoTextStyle;

  ///
  ///  Setting Options TextStyle.
  TextStyle? _settingOptionsTextStyle;

  TextStyle? get settingOptionsTextStyle => _settingOptionsTextStyle;

  ///
  ///  Setting Heading TextStyle.
  TextStyle? _settingHeadingTextStyle;

  TextStyle? get settingHeadingTextStyle => _settingHeadingTextStyle;

  ///
  ///  Setting Heading SubTitle TextStyle.
  TextStyle? _settingHeadingSubTitleTextStyle;

  TextStyle? get settingHeadingSubTitleTextStyle =>
      _settingHeadingSubTitleTextStyle;

  ///
  ///  About Page Heading TextStyle.
  TextStyle? _aboutPageHeadingTextStyle;

  TextStyle? get aboutPageHeadingTextStyle => _aboutPageHeadingTextStyle;

  ///
  ///  Facebook Sign-In Button TextStyle.
  TextStyle? _facebookSignInButtonTextStyle;

  TextStyle? get facebookSignInButtonTextStyle =>
      _facebookSignInButtonTextStyle;

  ///
  ///  Google Sign-In Button TextStyle.
  TextStyle? _googleSignInButtonTextStyle;

  TextStyle? get googleSignInButtonTextStyle => _googleSignInButtonTextStyle;

  ///
  ///  Apple Sign-In Button TextStyle.
  TextStyle? _appleSignInButtonTextStyle;

  TextStyle? get appleSignInButtonTextStyle => _appleSignInButtonTextStyle;

  ///
  ///  Bottom Sheet Options TextStyle.
  TextStyle? _bottomSheetOptionsTextStyle;

  TextStyle? get bottomSheetOptionsTextStyle => _bottomSheetOptionsTextStyle;

  ///
  ///  Bottom Sheet Negative Options TextStyle.
  TextStyle? _bottomSheetNegativeOptionsTextStyle;

  TextStyle? get bottomSheetNegativeOptionsTextStyle =>
      _bottomSheetNegativeOptionsTextStyle;

  ///
  ///  Bottom Sheet Emphasis Options TextStyle.
  TextStyle? _bottomSheetEmphasisOptionsTextStyle;

  TextStyle? get bottomSheetEmphasisOptionsTextStyle =>
      _bottomSheetEmphasisOptionsTextStyle;

  ///
  ///  Sliver Greetings TextStyle.
  TextStyle? _sliverGreetingsTextStyle;

  TextStyle? get sliverGreetingsTextStyle => _sliverGreetingsTextStyle;

  ///
  ///  Sliver User Name TextStyle.
  TextStyle? _sliverUserNameTextStyle;

  TextStyle? get sliverUserNameTextStyle => _sliverUserNameTextStyle;

  ///
  ///  Sliver Quote TextStyle.
  TextStyle? _sliverQuoteTextStyle;

  TextStyle? get sliverQuoteTextStyle => _sliverQuoteTextStyle;

  ///
  ///  Search Results Total Results TextStyle.
  TextStyle? _searchResultsTotalResultsTextStyle;

  TextStyle? get searchResultsTotalResultsTextStyle =>
      _searchResultsTotalResultsTextStyle;

  ///
  ///  Search Results Showing Sorted TextStyle.
  TextStyle? _searchResultsShowingSortedTextStyle;

  TextStyle? get searchResultsShowingSortedTextStyle =>
      _searchResultsShowingSortedTextStyle;

  ///
  ///  AppBar Action Widgets TextStyle.
  TextStyle? _appBarActionWidgetsTextStyle;

  TextStyle? get appBarActionWidgetsTextStyle => _appBarActionWidgetsTextStyle;

  ///
  /// Filter Page Temp Text (Please Select etc.) PlaceHolder TextStyle.
  TextStyle? _filterPageTempTextPlaceHolderTextStyle;

  TextStyle? get filterPageTempTextPlaceHolderTextStyle =>
      _filterPageTempTextPlaceHolderTextStyle;

  ///
  /// CRM Board pages type heading widget.
  TextStyle? _crmTypeHeadingTextStyle;

  TextStyle? get crmTypeHeadingTextStyle => _crmTypeHeadingTextStyle;

  ///
  /// CRM Board pages heading widget.
  TextStyle? _crmHeadingTextStyle;

  TextStyle? get crmHeadingTextStyle => _crmHeadingTextStyle;

  ///
  /// CRM Board pages heading widget.
  TextStyle? _crmNormalTextStyle;

  TextStyle? get crmNormalTextStyle => _crmNormalTextStyle;

  ///
  /// CRM Board pages heading widget.
  TextStyle? _crmSubNormalTextStyle;

  TextStyle? get crmSubNormalTextStyle => _crmSubNormalTextStyle;

  ///
  /// CRM Board pages heading widget.
  TextStyle? _activitySubTitleTextStyle;

  TextStyle? get activitySubTitleTextStyle => _activitySubTitleTextStyle;

  ///
  /// CRM Board pages heading widget.
  TextStyle? _activityHeadingTextStyle;

  TextStyle? get activityHeadingTextStyle => _activityHeadingTextStyle;

  ///
  /// Membership Title TextStyle.
  TextStyle? _membershipTitleTextStyle;

  TextStyle? get membershipTitleTextStyle => _membershipTitleTextStyle;

  ///
  /// Membership Price TextStyle.
  TextStyle? _membershipPriceTextStyle;

  TextStyle? get membershipPriceTextStyle => _membershipPriceTextStyle;

  ///
  /// Membership Price TextStyle.
  TextStyle? _membershipPackageNameTextStyle;

  TextStyle? get membershipPackageNameTextStyle =>
      _membershipPackageNameTextStyle;

  ///
  /// Membership Price TextStyle.
  TextStyle? _membershipExpireTextStyle;

  TextStyle? get membershipExpireTextStyle => _membershipExpireTextStyle;

  ///
  /// Membership Price TextStyle.
  TextStyle? _privateNoteTextStyle;

  TextStyle? get privateNoteTextStyle => _privateNoteTextStyle;

  ///
  /// Blog Layout Category TextStyle.
  TextStyle? _blogLayoutCategoryTextStyle;

  TextStyle? get blogLayoutCategoryTextStyle => _blogLayoutCategoryTextStyle;

  ///
  /// Blog Author Info TextStyle.
  TextStyle? _blogAuthorInfoTextStyle;

  TextStyle? get blogAuthorInfoTextStyle => _blogAuthorInfoTextStyle;

  ///
  /// Blog Comment Author Name TextStyle.
  TextStyle? _blogCommentAuthorNameTextStyle;

  TextStyle? get blogCommentAuthorNameTextStyle =>
      _blogCommentAuthorNameTextStyle;

  ///
  /// Blog Comment Content TextStyle.
  TextStyle? _blogCommentContentTextStyle;

  TextStyle? get blogCommentContentTextStyle => _blogCommentContentTextStyle;

  ///
  /// Blog Comment Actions TextStyle.
  TextStyle? _blogCommentActionsTextStyle;

  TextStyle? get blogCommentActionsTextStyle => _blogCommentActionsTextStyle;

  ///
  /// Message User Status Online TextStyle.
  TextStyle? _messageUserStatusOnlineTextStyle;

  TextStyle? get messageUserStatusOnlineTextStyle =>
      _messageUserStatusOnlineTextStyle;

  ///
  /// Message User Status Offline TextStyle.
  TextStyle? _messageUserStatusOfflineTextStyle;

  TextStyle? get messageUserStatusOfflineTextStyle =>
      _messageUserStatusOfflineTextStyle;

  ///
  ///
  /// Brightness:
  ///
  ///
  /// Status Bar Icons Brightness:
  Brightness? _statusBarIconBrightness;

  Brightness? get statusBarIconBrightness => _statusBarIconBrightness;

  ///
  ///
  /// Brightness:
  ///
  ///
  /// Status Bar Brightness (iOS):
  Brightness? _statusBarBrightness;

  Brightness? get statusBarBrightness => _statusBarBrightness;

  ///
  /// Generic Status Bar Icons Brightness:
  Brightness? _genericStatusBarIconBrightness;

  Brightness? get genericStatusBarIconBrightness =>
      _genericStatusBarIconBrightness;

  ///
  ///
  /// System Ui Overlay Style:
  ///
  ///
  /// SystemUiOverlayStyle:
  SystemUiOverlayStyle? _systemUiOverlayStyle;

  SystemUiOverlayStyle? get systemUiOverlayStyle => _systemUiOverlayStyle;

  ///
  ///
  /// Color Styles:
  ///
  ///
  /// App Primary Color
  Color? _primaryColor;

  Color? get primaryColor => _primaryColor;

  ///
  /// Normal Text Color
  Color? _normalTextColor;

  Color? get normalTextColor => _normalTextColor;

  ///
  /// Icon color
  Color? _iconsColor;

  Color? get iconsColor => _iconsColor;

  ///
  /// Generic Status Bar color
  Color? _genericStatusBarColor;

  Color? get genericStatusBarColor => _genericStatusBarColor;

  ///
  /// Generic Status Bar Icons color
  Color? _genericAppBarIconsColor;

  Color? get genericAppBarIconsColor => _genericAppBarIconsColor;

  ///
  /// HomeScreen Status Bar Color
  Color? _homeScreenStatusBarColor;

  Color? get homeScreenStatusBarColor => _homeScreenStatusBarColor;

  ///
  /// HomeScreen Status Bar Color
  Color? _homeScreen02StatusBarColor;

  Color? get homeScreen02StatusBarColor => _homeScreen02StatusBarColor;

  ///
  /// Selected Item Text Color:
  Color? _selectedItemTextColor;

  Color? get selectedItemTextColor => _selectedItemTextColor;

  ///
  /// Un-Selected Item Text Color:
  Color? _unSelectedItemTextColor;

  Color? get unSelectedItemTextColor => _unSelectedItemTextColor;

  ///
  /// Selected Item Background Color:
  Color? _selectedItemBackgroundColor;

  Color? get selectedItemBackgroundColor => _selectedItemBackgroundColor;

  ///
  /// Un-Selected Item Background Color:
  Color? _unSelectedItemBackgroundColor;

  Color? get unSelectedItemBackgroundColor => _unSelectedItemBackgroundColor;

  ///
  /// SliverAppBar Background Color
  Color? _sliverAppBarBackgroundColor;

  Color? get sliverAppBarBackgroundColor => _sliverAppBarBackgroundColor;

  ///
  /// SliverAppBar Background Color
  Color? _sliverAppBar02BackgroundColor;

  Color? get sliverAppBar02BackgroundColor => _sliverAppBar02BackgroundColor;

  ///
  /// Background Color
  Color? _backgroundColor;

  Color? get backgroundColor => _backgroundColor;

  ///
  /// Divider Color
  Color? _dividerColor;

  Color? get dividerColor => _dividerColor;

  ///
  /// Card Color
  Color? _cardColor;

  Color? get cardColor => _cardColor;

  ///
  /// Hint Color
  Color? _hintColor;

  Color? get hintColor => _hintColor;

  ///
  /// Shimmer Effect Base Color
  Color? _shimmerEffectBaseColor;

  Color? get shimmerEffectBaseColor => _shimmerEffectBaseColor;

  ///
  /// Shimmer Effect HighLight Color
  Color? _shimmerEffectHighLightColor;

  Color? get shimmerEffectHighLightColor => _shimmerEffectHighLightColor;

  ///
  /// Shimmer Effect Error Widget Background color
  Color? _shimmerEffectErrorWidgetBackgroundColor;

  Color? get shimmerEffectErrorWidgetBackgroundColor =>
      _shimmerEffectErrorWidgetBackgroundColor;

  ///
  /// Shimmer Effect Image Error Icon color
  Color? _shimmerEffectErrorIconColor;

  Color? get shimmerEffectErrorIconColor => _shimmerEffectErrorIconColor;

  ///
  /// HomeScreen Top Bar Right Arrow Icon Background color
  Color? _homeScreenTopBarRightArrowBackgroundColor;

  Color? get homeScreenTopBarRightArrowBackgroundColor =>
      _homeScreenTopBarRightArrowBackgroundColor;

  ///
  /// HomeScreen Top Bar Search Icon color
  Color? _homeScreenTopBarSearchIconColor;

  Color? get homeScreenTopBarSearchIconColor =>
      _homeScreenTopBarSearchIconColor;

  ///
  /// Search Bar Background color
  Color? _searchBarBackgroundColor;

  Color? get searchBarBackgroundColor => _searchBarBackgroundColor;

  ///
  /// Search Bar Background color
  Color? _searchBar02BackgroundColor;

  Color? get searchBar02BackgroundColor => _searchBar02BackgroundColor;

  ///
  /// Switch unselected Background color
  Color? _switchUnselectedBackgroundColor;

  Color? get switchUnselectedBackgroundColor =>
      _switchUnselectedBackgroundColor;

  ///
  /// Switch Selected Background color
  Color? _switchSelectedBackgroundColor;

  Color? get switchSelectedBackgroundColor => _switchSelectedBackgroundColor;

  ///
  /// Switch unselected Background color
  Color? _switchUnselectedItemTextColor;

  Color? get switchUnselectedItemTextColor => _switchUnselectedItemTextColor;

  ///
  /// Switch unselected Background color
  Color? _switchSelectedItemTextColor;

  Color? get switchSelectedItemTextColor => _switchSelectedItemTextColor;

  ///
  /// HomeScreen Search Bar Icon color
  Color? _homeScreenSearchBarIconColor;

  Color? get homeScreenSearchBarIconColor => _homeScreenSearchBarIconColor;

  ///
  /// Featured Tag Background color
  Color? _featuredTagBackgroundColor;

  Color? get featuredTagBackgroundColor => _featuredTagBackgroundColor;

  ///
  /// Featured Tag Border color
  Color? _featuredTagBorderColor;

  Color? get featuredTagBorderColor => _featuredTagBorderColor;

  ///
  /// Tag Background color
  Color? _tagBackgroundColor;

  Color? get tagBackgroundColor => _tagBackgroundColor;

  ///
  /// Tag Border color
  Color? _tagBorderColor;

  Color? get tagBorderColor => _tagBorderColor;

  ///
  /// Property Status Tag Background color
  Color? _propertyStatusTagBackgroundColor;

  Color? get propertyStatusTagBackgroundColor =>
      _propertyStatusTagBackgroundColor;

  ///
  /// Article Box Icons color
  Color? _articleBoxIconsColor;

  Color? get articleBoxIconsColor => _articleBoxIconsColor;

  ///
  /// Bottom Navigation Menu color
  Color? _bottomNavigationMenuColor;

  Color? get bottomNavigationMenuColor => _bottomNavigationMenuColor;

  ///
  /// Property Details Page Top Bar Divider color
  Color? _propertyDetailsPageTopBarDividerColor;

  Color? get propertyDetailsPageTopBarDividerColor =>
      _propertyDetailsPageTopBarDividerColor;

  ///
  /// Property Details Page Top Bar Divider Shadow color
  Color? _propertyDetailsPageTopBarShadowColor;

  Color? get propertyDetailsPageTopBarShadowColor =>
      _propertyDetailsPageTopBarShadowColor;

  ///
  /// Property Details Page Top bar Icons color
  Color? _propertyDetailsPageTopBarIconsColor;

  Color? get propertyDetailsPageTopBarIconsColor =>
      _propertyDetailsPageTopBarIconsColor;

  ///
  /// Property Details Page Top bar Icons Background color
  Color? _propertyDetailsPageTopBarIconsBackgroundColor;

  Color? get propertyDetailsPageTopBarIconsBackgroundColor =>
      _propertyDetailsPageTopBarIconsBackgroundColor;

  ///
  /// Property Details Page Container Background color
  Color? _containerBackgroundColor;

  Color? get containerBackgroundColor => _containerBackgroundColor;

  ///
  /// Property Details Page Chips Background color
  Color? _propertyDetailsPageChipsBackgroundColor;

  Color? get propertyDetailsPageChipsBackgroundColor =>
      _propertyDetailsPageChipsBackgroundColor;

  ///
  /// Favourite Widget Background color
  Color? _favouriteWidgetBackgroundColor;

  Color? get favouriteWidgetBackgroundColor => _favouriteWidgetBackgroundColor;

  ///
  /// Facebook Sign-In Button Background color
  Color? _facebookSignInButtonColor;

  Color? get facebookSignInButtonColor => _facebookSignInButtonColor;

  ///
  /// Google Sign-In Button Background color
  Color? _googleSignInButtonColor;

  Color? get googleSignInButtonColor => _googleSignInButtonColor;

  ///
  /// Apple Sign-In Button Background color
  Color? _appleSignInButtonColor;

  Color? get appleSignInButtonColor => _appleSignInButtonColor;

  ///
  /// Filter Page Icons Color?
  Color? _filterPageIconsColor;

  Color? get filterPageIconsColor => _filterPageIconsColor;

  ///
  /// Search Page Choice Chips Background Color
  Color? _searchPageChoiceChipsBackgroundColor;

  Color? get searchPageChoiceChipsBackgroundColor =>
      _searchPageChoiceChipsBackgroundColor;

  ///
  /// Home Screen Search Arrow Icon Background Color
  Color? _homeScreenSearchArrowIconBackgroundColor;

  Color? get homeScreenSearchArrowIconBackgroundColor =>
      _homeScreenSearchArrowIconBackgroundColor;

  ///
  /// Bottom Nav Bar Background Color
  Color? _bottomNavBarBackgroundColor;

  Color? get bottomNavBarBackgroundColor => _bottomNavBarBackgroundColor;

  ///
  /// Article Design Item Background Color
  Color? _articleDesignItemBackgroundColor;

  Color? get articleDesignItemBackgroundColor =>
      _articleDesignItemBackgroundColor;

  ///
  /// Recent Searches Border Color
  Color? _recentSearchesBorderColor;

  Color? get recentSearchesBorderColor => _recentSearchesBorderColor;

  ///
  /// Recent Searches Border Color
  Color? _crmIconColor;

  Color? get crmIconColor => _crmIconColor;

  ///
  /// Recent Searches Border Color
  Color? _crmTypeHeadingTextColor;

  Color? get crmTypeHeadingTextColor => _crmTypeHeadingTextColor;

  ///
  /// Recent Searches Border Color
  Color? _crmHeadingTextColorDark;

  Color? get crmHeadingTextColorDark => _crmHeadingTextColorDark;

  ///
  /// Recent Searches Border Color
  Color? _cupertinoSegmentThumbColor;

  Color? get cupertinoSegmentThumbColor => _cupertinoSegmentThumbColor;

  ///
  /// Bottom Sheet Bg Color
  Color? _bottomSheetBgColor;

  Color? get bottomSheetBgColor => _bottomSheetBgColor;

  ///
  /// Choice Chips Bg Color
  Color? _choiceChipsBgColor;

  Color? get choiceChipsBgColor => _choiceChipsBgColor;

  ///
  /// Pop Up Menu Bg Color
  Color? _popUpMenuBgColor;

  Color? get popUpMenuBgColor => _popUpMenuBgColor;

  ///
  /// Dropdown Menu Bg Color
  Color? _dropdownMenuBgColor;

  Color? get dropdownMenuBgColor => _dropdownMenuBgColor;

  ///
  /// Notification Widget Bg Color
  Color? _notificationWidgetBgColor;

  Color? get notificationWidgetBgColor => _notificationWidgetBgColor;

  ///
  /// Messages Text Color
  Color? _messagesTextColor;

  Color? get messagesTextColor => _messagesTextColor;

  ///
  /// Message Receiver Bg Color
  Color? _messageReceiverBgColor;

  Color? get messageReceiverBgColor => _messageReceiverBgColor;

  ///
  /// Message Scroll FAB Bg Color
  Color? _messageScrollFABBgColor;

  Color? get messageScrollFABBgColor => _messageScrollFABBgColor;

  ///
  /// Message Time Bg Color
  Color? _messageTimeBgColor;

  Color? get messageTimeBgColor => _messageTimeBgColor;

  ///
  /// Message Time Text Color
  Color? _messageTimeTextColor;

  Color? get messageTimeTextColor => _messageTimeTextColor;

  ///
  /// Message Text Field Outer Bg Color
  Color? _messageTextFieldOuterBgColor;

  Color? get messageTextFieldOuterBgColor => _messageTextFieldOuterBgColor;

  ///
  /// Message Text Field Inner Bg Color
  Color? _messageTextFieldInnerBgColor;

  Color? get messageTextFieldInnerBgColor => _messageTextFieldInnerBgColor;

  ///
  /// Message Text Field Inner Bg Color
  Color? _sendMessageIconColor;

  Color? get sendMessageIconColor => _sendMessageIconColor;

  ///
  /// Send Message App Bar Bg Color
  Color? _sendMessageAppBarBgColor;

  Color? get sendMessageAppBarBgColor => _sendMessageAppBarBgColor;

  ///
  ///
  /// Icon:
  ///
  ///
  /// Drawer Menu Icon
  Icon? _drawerMenuIcon;

  Icon? get drawerMenuIcon => _drawerMenuIcon;

  ///
  /// Drawer Menu Icon
  Icon? _drawer02MenuIcon;

  Icon? get drawer02MenuIcon => _drawer02MenuIcon;

  ///
  /// HomeScreen Top Bar Location Icon
  Icon? _homeScreenTopBarLocationIcon;

  Icon? get homeScreenTopBarLocationIcon => _homeScreenTopBarLocationIcon;

  ///
  /// HomeScreen Top Bar Location Icon
  Icon? _homeScreenTopBar02LocationIcon;

  Icon? get homeScreenTopBar02LocationIcon => _homeScreenTopBar02LocationIcon;

  ///
  /// HomeScreen Top Bar Location Icon
  Icon? _homeScreenTopBarLocationFilledIcon;

  Icon? get homeScreenTopBarLocationFilledIcon =>
      _homeScreenTopBarLocationFilledIcon;

  ///
  /// HomeScreen Top Bar Right Arrow Icon
  Icon? _homeScreenTopBarRightArrowIcon;

  Icon? get homeScreenTopBarRightArrowIcon => _homeScreenTopBarRightArrowIcon;

  ///
  /// HomeScreen Top Bar Right Arrow Icon
  Icon? _homeScreenTopBarDownArrowIcon;

  Icon? get homeScreenTopBarDownArrowIcon => _homeScreenTopBarDownArrowIcon;

  ///
  /// HomeScreen Top Bar Search Icon
  Icon? _homeScreenTopBarSearchIcon;

  Icon? get homeScreenTopBarSearchIcon => _homeScreenTopBarSearchIcon;

  ///
  /// Property Detail Top Bar Right Arrow Icon
  Icon? _propertyDetailPageRightArrowIcon;

  Icon? get propertyDetailPageRightArrowIcon =>
      _propertyDetailPageRightArrowIcon;

  ///
  /// Search Icon
  Icon? _searchBarIcon;

  Icon? get searchBarIcon => _searchBarIcon;

  ///
  /// HomeScreen Search Bar Icon
  Icon? _homeScreenSearchBarIcon;

  Icon? get homeScreenSearchBarIcon => _homeScreenSearchBarIcon;

  ///
  /// HomeScreen Search Bar Icon
  Icon? _homeScreenSearchBarFilterIcon;

  Icon? get homeScreenSearchBarFilterIcon => _homeScreenSearchBarFilterIcon;

  ///
  /// Shimmer Effect Image Error Widget Icon
  Icon? _shimmerEffectImageErrorIcon;

  Icon? get shimmerEffectImageErrorIcon => _shimmerEffectImageErrorIcon;

  ///
  /// Article Box Location Icon
  Icon? _articleBoxLocationIcon;

  Icon? get articleBoxLocationIcon => _articleBoxLocationIcon;

  ///
  /// Article Box Bed Icon
  Icon? _articleBoxBedIcon;

  Icon? get articleBoxBedIcon => _articleBoxBedIcon;

  ///
  /// Article Box Bathtub Icon
  Icon? _articleBoxBathtubIcon;

  Icon? get articleBoxBathtubIcon => _articleBoxBathtubIcon;

  ///
  /// Article Box Area Size Icon?
  Icon? _articleBoxAreaSizeIcon;

  Icon? get articleBoxAreaSizeIcon => _articleBoxAreaSizeIcon;

  ///
  /// Filter Page Check Circle Icon
  Icon? _filterPageCheckCircleIcon;

  Icon? get filterPageCheckCircleIcon => _filterPageCheckCircleIcon;

  ///
  /// Filter Page Location Circle Icon
  Icon? _filterPageLocationIcon;

  Icon? get filterPageLocationIcon => _filterPageLocationIcon;

  /// Filter Page Location Circle Icon
  Icon? _filterPageGpsLocationIcon;

  Icon? get filterPageGpsLocationIcon => _filterPageGpsLocationIcon;

  /// Filter Page Location Circle Icon
  Icon? _filterPageRadiusLocationIcon;

  Icon? get filterPageRadiusLocationIcon => _filterPageRadiusLocationIcon;

  ///
  /// Filter Page Arrow Forward Icon
  Icon? _filterPageArrowForwardIcon;

  Icon? get filterPageArrowForwardIcon => _filterPageArrowForwardIcon;

  ///
  /// Filter Page Location City Icon
  Icon? _filterPageLocationCityIcon;

  Icon? get filterPageLocationCityIcon => _filterPageLocationCityIcon;

  ///
  /// Filter Page Arrow Drop Down Icon
  Icon? _filterPageArrowDropDownIcon;

  Icon? get filterPageArrowDropDownIcon => _filterPageArrowDropDownIcon;

  ///
  /// Filter Page Price Tag Icon
  Icon? _filterPagePriceTagIcon;

  Icon? get filterPagePriceTagIcon => _filterPagePriceTagIcon;

  ///
  /// Filter Page Area Size Icon
  Icon? _filterPageAreaSizeIcon;

  Icon? get filterPageAreaSizeIcon => _filterPageAreaSizeIcon;

  ///
  /// Filter Page Bedroom Icon
  Icon? _filterPageBedroomIcon;

  Icon? get filterPageBedroomIcon => _filterPageBedroomIcon;

  ///
  /// Filter Page Bathroom Icon
  Icon? _filterPageBathroomIcon;

  Icon? get filterPageBathroomIcon => _filterPageBathroomIcon;

  ///
  /// Bottom Navigation Menu Icon
  Icon? _bottomNavigationMenuIcon;

  Icon? get bottomNavigationMenuIcon => _bottomNavigationMenuIcon;

  ///
  /// Camera Icon
  Icon? _propertyDetailsImageIndicatorCameraIcon;

  Icon? get propertyDetailsImageIndicatorCameraIcon =>
      _propertyDetailsImageIndicatorCameraIcon;

  ///
  /// Property Details Chips Icon
  Icon? _propertyDetailsChipsIcon;

  Icon? get propertyDetailsChipsIcon => _propertyDetailsChipsIcon;

  ///
  /// Message Icon Widget
  Icon? _messageIconWidget;

  Icon? get messageIconWidget => _messageIconWidget;

  ///
  ///
  /// IconData:
  ///
  ///
  /// Image IconData
  IconData? _imageIconData;

  IconData? get imageIconData => _imageIconData;

  ///
  ///
  /// Images:
  ///
  ///
  /// Drawer Image
  Image? _drawerImage;

  Image? get drawerImage => _drawerImage;

  ///
  ///
  /// Whatsapp icon Image
  Image? _whatsAppIcon;

  Image? get whatsAppIcon => _whatsAppIcon;

  ///
  ///
  /// Line App icon Image
  Image? _lineAppIcon;

  Image? get lineAppIcon => _lineAppIcon;

  ///
  ///
  /// Telegram icon Image
  Image? _telegramIcon;

  Image? get telegramIcon => _telegramIcon;

  ///
  ///
  /// Images Path:
  ///
  ///
  /// Apple Icon Image Path
  String? _appleIconImagePath;

  String? get appleIconImagePath => _appleIconImagePath;

  ///
  ///
  /// Border Related:
  ///
  ///
  /// Filter Page Border Side
  BorderSide? _filterPageBorderSide;

  BorderSide? get filterPageBorderSide => _filterPageBorderSide;

  ///
  /// Bottom Navigation Menu Border Side
  BorderSide? _bottomNavigationMenuBorderSide;

  BorderSide? get bottomNavigationMenuBorderSide =>
      _bottomNavigationMenuBorderSide;

  ///
  /// Property Details Page Border Side
  BorderSide? _propertyDetailsPageBottomMenuBorderSide;

  BorderSide? get propertyDetailsPageBottomMenuBorderSide =>
      _propertyDetailsPageBottomMenuBorderSide;
}

///
///
// /// Define you custom color.
// Map<int, Color> primaryColorCodes = {
//   50: Color.fromRGBO(37, 173, 222, .1),
//   100: Color.fromRGBO(37, 173, 222, .2),
//   200: Color.fromRGBO(37, 173, 222, .3),
//   300: Color.fromRGBO(37, 173, 222, .4),
//   400: Color.fromRGBO(37, 173, 222, .5),
//   500: Color.fromRGBO(37, 173, 222, .6),
//   600: Color.fromRGBO(37, 173, 222, .7),
//   700: Color.fromRGBO(37, 173, 222, .8),
//   800: Color.fromRGBO(37, 173, 222, .9),
//   900: Color.fromRGBO(37, 173, 222, 1),
// };

MaterialColor primaryColorSwatch = UtilityMethods.getMaterialColor("#FF1BB1B1");
MaterialColor secondaryColorSwatch =
    UtilityMethods.getMaterialColor("#FF1BB1B1");

// MaterialColor secondaryColor = MaterialColor(0xFF329600, secondaryColorSwatches);

// Color propertyTitleTextColorDark = Color(0xFFe1e2e6);
// Color descriptionTextColorDark = Color(0xFFcfd0d4);
// Color baseDarkBackgroundColor = Color(0xFF18191b);
// Color cardDarkBackgroundColor = Color(0xFF242527);
// Color dividerDarkBackgroundColor = Color(0xFF323335);
// Color tagDarkBackgroundColor = Color(0xFF383b3c);
// Color iconsDarkBackgroundColor = Color(0xFF868a8d);
// Color searchBarDarkBackgroundColor = Color(0xFF3a3b3d);
// Color searchBarTextDarkBackgroundColor = Color(0xFFb2b3b6);
// Color searchBarIconDarkBackgroundColor = Color(0xFF626365);
