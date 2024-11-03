import 'package:houzi/hooks_v2.dart';
import 'package:houzi_package/houzi_main.dart' as houzi_package;

Future<void> main() async {
  HooksV2 v2Hooks = HooksV2();
  Map<String,dynamic> hooksMap = {};

  hooksMap["headers"] = v2Hooks.getHeaderMap();
  hooksMap["propertyDetailPageIcons"] = v2Hooks.getPropertyDetailPageIconsMap();
  hooksMap["elegantHomeTermsIcons"] = v2Hooks.getElegantHomeTermsIconMap();
  hooksMap["drawerItems"] = v2Hooks.getDrawerItems();
  hooksMap["fonts"] = v2Hooks.getFontHook();
  hooksMap["propertyItem"] = v2Hooks.getPropertyItemHook();
  hooksMap["propertyItemV2"] = v2Hooks.getPropertyItemHookV2();
  hooksMap["propertyItemHeightHook"] = v2Hooks.getPropertyItemHeightHook();
  hooksMap["termItem"] = v2Hooks.getTermItemHook();
  hooksMap["agentItem"] = v2Hooks.getAgentItemHook();
  hooksMap["agencyItem"] = v2Hooks.getAgencyItemHook();
  hooksMap["widgetItems"] = v2Hooks.getWidgetHook();
  hooksMap["languageNameAndCode"] = v2Hooks.getLanguageCodeAndName();
  hooksMap["defaultLanguageCode"] = v2Hooks.getDefaultLanguageHook();
  hooksMap["defaultHomePage"] = v2Hooks.getDefaultHomePageHook();
  hooksMap["defaultCountryCode"] = v2Hooks.getDefaultCountryCodeHook();
  hooksMap["settingsOption"] = v2Hooks.getSettingsItemHook();
  hooksMap["profileItem"] = v2Hooks.getProfileItemHook();
  hooksMap["homeRightBarButtonWidget"] = v2Hooks.getHomeRightBarButtonWidgetHook();
  hooksMap["markerTitle"] = v2Hooks.getMarkerTitleHook();
  hooksMap["markerIcon"] = v2Hooks.getMarkerIconHook();
  hooksMap["customMapMarker"] = v2Hooks.getCustomMarkerHook();
  hooksMap["priceFormatter"] = v2Hooks.getPriceFormatterHook();
  hooksMap["compactPriceFormatter"] = v2Hooks.getCompactPriceFormatterHook();
  hooksMap["textFormFieldCustomizationHook"] = v2Hooks.getTextFormFieldCustomizationHook();
  hooksMap["textFormFieldWidgetHook"] = v2Hooks.getTextFormFieldWidgetHook();
  hooksMap["customSegmentedControlHook"] = v2Hooks.getCustomSegmentedControlHook();
  hooksMap["drawerHeaderHook"] = v2Hooks.getDrawerHeaderHook();
  hooksMap["hidePriceHook"] = v2Hooks.getHidePriceHook();
  hooksMap["hideEmptyTerm"] = v2Hooks.hideEmptyTerm();
  hooksMap["customMapMarker"] = v2Hooks.getCustomMarkerHook();
  hooksMap["homeSliverAppBarBodyHook"] = v2Hooks.getHomeSliverAppBarBodyHook();
  hooksMap["homeWidgetsHook"] = v2Hooks.getHomeWidgetsHook();
  hooksMap["drawerWidgetsHook"] = v2Hooks.getDrawerWidgetsHook();
  hooksMap["membershipPlanHook"] = v2Hooks.getMembershipPlanHook();
  hooksMap["membershipPackageUpdatedHook"] = v2Hooks.getMembershipPackageUpdatedHook();
  hooksMap["paymentHook"] = v2Hooks.getPaymentHook();
  hooksMap["paymentSuccessfulHook"] = v2Hooks.getPaymentSuccessfulHook();
  hooksMap["addPlusButtonInBottomBarHook"] = v2Hooks.getAddPlusButtonInBottomBarHook();
  hooksMap["navbarWidgetsHook"] = v2Hooks.getNavbarWidgetsHook();
  hooksMap["clusterMarkerIconHook"] = v2Hooks.getCustomizeClusterMarkerIconHook();
  hooksMap["customClusterMarkerIconHook"] = v2Hooks.getCustomClusterMarkerIconHook();
  hooksMap["membershipPayWallDesignHook"] = v2Hooks.getMembershipPayWallDesignHook();
  hooksMap["minimumPasswordLengthHook"] = v2Hooks.getMinimumPasswordLengthHook();
  hooksMap["agentProfileConfigurationsHook"] = v2Hooks.getAgentProfileConfigurationsHook();
  hooksMap["userLoginActionHook"] = v2Hooks.getUserLoginActionHook();
  hooksMap["addPropertyActionHook"] = v2Hooks.getAddPropertyActionHook();
  hooksMap["drawerMenuItemDesignHook"] = v2Hooks.getDrawerMenuItemDesignHook();
  hooksMap["defaultAppThemeModeHook"] = v2Hooks.getDefaultAppThemeModeHook();
  hooksMap["messageApiRefreshTimeHook"] = v2Hooks.getMessageApiRefreshTimeHook();
  hooksMap["threadApiRefreshTimeHook"] = v2Hooks.getThreadApiRefreshTimeHook();
  return houzi_package.main("assets/configurations/configurations.json", hooksMap);
}



