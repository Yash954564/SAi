import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/models/map_marker_data.dart';
import 'package:houzi_package/models/realtor_model.dart';


typedef HidePriceHook = bool Function();
typedef DefaultHomePageHook = String Function();
typedef LanguageHook = List<dynamic> Function();
typedef DefaultCountryCodeHook = String Function();
typedef HideEmptyTerm = bool Function(String term);
typedef DefaultLanguageCodeHook = String Function();
typedef TermItemHook = Widget? Function(List metaDataList);
typedef ProfileHook = List<Widget> Function(BuildContext context);
typedef SettingsHook = List<dynamic> Function(BuildContext context);
typedef AppTrackingPermissionCallback = void Function({String? status});
typedef CompactPriceFormatterHook = String? Function(String inputPrice);
typedef TextFormFieldCustomizationHook = Map<String, dynamic>? Function();
typedef AgentItemHook = Widget? Function(BuildContext context, Agent agent);
typedef HomeRightBarButtonWidgetHook = Widget? Function(BuildContext context);
typedef AgencyItemHook = Widget? Function(BuildContext context, Agency agency);
typedef MarkerTitleHook = String Function(BuildContext context, Article article);
typedef MarkerIconHook = String? Function(BuildContext context, Article article);
typedef DrawerWidgetsHook = Widget? Function(BuildContext context, String hookName);
typedef NavbarWidgetsHook = Widget? Function(BuildContext context, String hookName);
typedef PriceFormatterHook = String? Function(String propertyPrice, String firstPrice);
typedef HomeSliverAppBarBodyHook = Map<String, dynamic>? Function(BuildContext context);
typedef PropertyItemHook = Widget? Function(BuildContext buildContext, Article article);
typedef PropertyItemHookV2 = Widget? Function({
    required Article article,
    required String designName,
    required String heroId,
    required void Function() onTap});
typedef PropertyItemHeightHook = double? Function(String designName);
typedef CustomMarkerHook = MapMarkerData? Function(BuildContext context, Article article);
typedef HomeWidgetsHook = Widget? Function(BuildContext context, String hookName, bool isRefreshed);
typedef NavigateToSearchResultScreenListener = void Function({Map<String, dynamic>? filterDataMap});
typedef PropertyPageWidgetsHook = Widget? Function(BuildContext context, Article article, String hook);
typedef PaymentSuccessfulHook = void Function(BuildContext context, bool success);
typedef MembershipPackageUpdatedHook = void Function(BuildContext context, bool updated);
typedef MembershipPayWallDesignHook = String Function(BuildContext context);
typedef MembershipPlanHook = Widget? Function(BuildContext context, List<dynamic> membershipPackageList);
typedef AddPlusButtonInBottomBarHook = Widget? Function(BuildContext context);
typedef ClusterMarkerIconHook = Map<String, dynamic>? Function();
typedef CustomClusterMarkerIconHook = Future<BitmapDescriptor>? Function(BuildContext context, int clusterSize);
typedef PaymentHook = Widget? Function(
  List<String> productIds,
  String? packageId,
  String? propId,
  bool isMembership,
  bool isFeaturedForPerListing,
);
typedef DrawerHeaderHook = Widget? Function(
  BuildContext context,
  String appName,
  String appIconPath,
  String? userProfileName,
  String? userProfileImageUrl,
);
typedef CustomSegmentedControlHook = Widget? Function(
  BuildContext context,
  List<dynamic> itemList,
  int selectionIndex,
  Function(int) onSegmentChosen,
);
typedef TextFormFieldWidgetHook = Widget? Function(
  BuildContext context,
  String? labelText,
  String? hintText,
  String? additionalHintText,
  Widget? suffixIcon,
  String? initialValue,
  int? maxLines,
  bool? readOnly,
  bool? obscureText,
  TextEditingController? controller,
  TextInputType keyboardType,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String? val)? validator,
  void Function(String?)? onSaved,
  void Function(String?)? onChanged,
  void Function(String?)? onFieldSubmitted,
  void Function()? onTap,
);

typedef MinimumPasswordLengthHook = int? Function();
typedef AgentProfileConfigurationsHook = bool? Function(String hook);

typedef UserLoginActionHook = void Function({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required String usernameEmail,
  required String password,
  required String loginNonce,
  required void Function() defaultLoginFunc,
})?;

typedef AddPropertyActionHook = void Function({
required BuildContext context,
required String addPropertyNonce,
required String uploadImagesNonce,
required Map<String, dynamic> addPropertyDataMap,
required void Function() defaultAddPropertyFunc,
})?;

typedef DrawerMenuItemDesignHook = Widget? Function({
  required String label,
  required IconData iconData,
  required String selectedItem,
  required VoidCallback? onTap,
})?;

typedef DefaultAppThemeModeHook = String? Function()?;

typedef MessageApiRefreshTimeHook = int? Function()?;
typedef ThreadApiRefreshTimeHook = int? Function()?;

class HooksConfigurations {
  static var drawerItemsList;
  static var widgetItem;
  static var propertyItem;
  static var propertyItemV2;
  static var propertyItemHeightHook;
  static var termItem;
  static var agentItem;
  static var agencyItem;
  static var languageNameAndCode;
  static var defaultLanguageCode;
  static var defaultHomePage;
  static var defaultCountryCode;
  static var settingsOption;
  static var profileItem;
  static var homeRightBarButtonWidget;
  static var markerTitle;
  static var markerIcon;
  static var customMapMarker;
  static var priceFormat;
  static var compactPriceFormatter;
  static var textFormFieldCustomizationHook;
  static var textFormFieldWidgetHook;
  static var customSegmentedControlHook;
  static var drawerHeaderHook;
  static var hidePriceHook;
  static var hideEmptyTerm;
  static var homeSliverAppBarBodyHook;
  static var homeWidgetsHook;
  static var drawerWidgetsHook;
  static var membershipPlanHook;
  static var paymentHook;
  static var membershipPackageUpdatedHook;
  static var paymentSuccessfulHook;
  static var membershipPayWallDesignHook;
  static var addPlusButtonInBottomBarHook;
  static var navbarWidgetsHook;
  static var clusterMarkerIconHook;
  static var customClusterMarkerIconHook;
  static var minimumPasswordLengthHook;
  static var agentProfileConfigurationsHook;
  static var userLoginActionHook;
  static var addPropertyActionHook;
  static var drawerMenuItemDesignHook;
  static var defaultAppThemeModeHook;
  static var messageApiRefreshTimeHook;
  static var threadApiRefreshTimeHook;

  static void setHooks(Map<String, dynamic> hooksMap) {
    if (hooksMap.isNotEmpty) {
      if (hooksMap.containsKey("propertyDetailPageIcons") &&
          hooksMap["propertyDetailPageIcons"] != null &&
          hooksMap["propertyDetailPageIcons"].isNotEmpty) {
        UtilityMethods.iconMap.addAll(hooksMap["propertyDetailPageIcons"]);
      }

      if (hooksMap.containsKey("elegantHomeTermsIcons") &&
          hooksMap["elegantHomeTermsIcons"] != null &&
          hooksMap["elegantHomeTermsIcons"].isNotEmpty) {
        UtilityMethods.iconMap.addAll(hooksMap["elegantHomeTermsIcons"]);
      }

      if (hooksMap.containsKey("headers") &&
          hooksMap["headers"] != null &&
          hooksMap["headers"].isNotEmpty) {
        HiveStorageManager.storeSecurityKeyMapData(hooksMap["headers"]);
      }

      if (hooksMap.containsKey("drawerItems") && hooksMap["drawerItems"] != null) {
        drawerItemsList = hooksMap["drawerItems"];
      }

      if (hooksMap.containsKey("widgetItems") && hooksMap["widgetItems"] != null) {
        widgetItem = hooksMap["widgetItems"];
      }

      if (hooksMap.containsKey("propertyItem") && hooksMap["propertyItem"] != null) {
        propertyItem = hooksMap["propertyItem"];
      }

      if (hooksMap.containsKey("propertyItemV2") && hooksMap["propertyItemV2"] != null) {
        propertyItemV2 = hooksMap["propertyItemV2"];
      }

      if (hooksMap.containsKey("propertyItemHeightHook") && hooksMap["propertyItemHeightHook"] != null) {
        propertyItemHeightHook = hooksMap["propertyItemHeightHook"];
      }

      if (hooksMap.containsKey("termItem") && hooksMap["termItem"] != null) {
        termItem = hooksMap["termItem"];
      }

      if (hooksMap.containsKey("agentItem") && hooksMap["agentItem"] != null) {
        agentItem = hooksMap["agentItem"];
      }

      if (hooksMap.containsKey("agencyItem") && hooksMap["agencyItem"] != null) {
        agencyItem = hooksMap["agencyItem"];
      }

      if (hooksMap.containsKey("languageNameAndCode") && hooksMap["languageNameAndCode"] != null) {
        languageNameAndCode = hooksMap["languageNameAndCode"];
      }

      if (hooksMap.containsKey("defaultLanguageCode") && hooksMap["defaultLanguageCode"] != null) {
        defaultLanguageCode = hooksMap["defaultLanguageCode"];
      }

      if (hooksMap.containsKey("defaultHomePage") && hooksMap["defaultHomePage"] != null) {
        defaultHomePage = hooksMap["defaultHomePage"];
      }

      if (hooksMap.containsKey("defaultCountryCode") && hooksMap["defaultCountryCode"] != null) {
        defaultCountryCode = hooksMap["defaultCountryCode"];
      }

      if (hooksMap.containsKey("settingsOption") && hooksMap["settingsOption"] != null) {
        settingsOption = hooksMap["settingsOption"];
      }

      if (hooksMap.containsKey("profileItem") && hooksMap["profileItem"] != null) {
        profileItem = hooksMap["profileItem"];
      }

      if (hooksMap.containsKey("homeRightBarButtonWidget") && hooksMap["homeRightBarButtonWidget"] != null) {
        homeRightBarButtonWidget = hooksMap["homeRightBarButtonWidget"];
      }

      if (hooksMap.containsKey("markerTitle") && hooksMap["markerTitle"] != null) {
        markerTitle = hooksMap["markerTitle"];
      }

      if (hooksMap.containsKey("markerIcon") && hooksMap["markerIcon"] != null) {
        markerIcon = hooksMap["markerIcon"];
      }
      if (hooksMap.containsKey("customMapMarker") && hooksMap["customMapMarker"] != null) {
        customMapMarker = hooksMap["customMapMarker"];
      }

      if (hooksMap.containsKey("priceFormatter") && hooksMap["priceFormatter"] != null) {
        priceFormat = hooksMap["priceFormatter"];
      }

      if (hooksMap.containsKey("compactPriceFormatter") && hooksMap["compactPriceFormatter"] != null) {
        compactPriceFormatter = hooksMap["compactPriceFormatter"];
      }

      if (hooksMap.containsKey("textFormFieldCustomizationHook") && hooksMap["textFormFieldCustomizationHook"] != null) {
        textFormFieldCustomizationHook = hooksMap["textFormFieldCustomizationHook"];
      }

      if (hooksMap.containsKey("textFormFieldWidgetHook") && hooksMap["textFormFieldWidgetHook"] != null) {
        textFormFieldWidgetHook = hooksMap["textFormFieldWidgetHook"];
      }

      if (hooksMap.containsKey("customSegmentedControlHook") && hooksMap["customSegmentedControlHook"] != null) {
        customSegmentedControlHook = hooksMap["customSegmentedControlHook"];
      }

      if (hooksMap.containsKey("drawerHeaderHook") && hooksMap["drawerHeaderHook"] != null) {
        drawerHeaderHook = hooksMap["drawerHeaderHook"];
      }

      if (hooksMap.containsKey("hidePriceHook") && hooksMap["hidePriceHook"] != null) {
        hidePriceHook = hooksMap["hidePriceHook"];
      }

      if (hooksMap.containsKey("hideEmptyTerm") && hooksMap["hideEmptyTerm"] != null) {
        hideEmptyTerm = hooksMap["hideEmptyTerm"];
      }

      if (hooksMap.containsKey("homeSliverAppBarBodyHook") &&
          hooksMap["homeSliverAppBarBodyHook"] != null) {
        homeSliverAppBarBodyHook = hooksMap["homeSliverAppBarBodyHook"];
      }

      if (hooksMap.containsKey("homeWidgetsHook")
          && hooksMap["homeWidgetsHook"] != null) {
        homeWidgetsHook = hooksMap["homeWidgetsHook"];
      }

      if (hooksMap.containsKey("drawerWidgetsHook")
          && hooksMap["drawerWidgetsHook"] != null) {
        drawerWidgetsHook = hooksMap["drawerWidgetsHook"];
      }

      if (hooksMap.containsKey("membershipPlanHook") && hooksMap["membershipPlanHook"] != null) {
        membershipPlanHook = hooksMap["membershipPlanHook"];
      }

      if (hooksMap.containsKey("paymentHook") && hooksMap["paymentHook"] != null) {
        paymentHook = hooksMap["paymentHook"];
      }

      if (hooksMap.containsKey("membershipPackageUpdatedHook") && hooksMap["membershipPackageUpdatedHook"] != null) {
        membershipPackageUpdatedHook = hooksMap["membershipPackageUpdatedHook"];
      }

      if (hooksMap.containsKey("paymentSuccessfulHook") && hooksMap["paymentSuccessfulHook"] != null) {
        paymentSuccessfulHook = hooksMap["paymentSuccessfulHook"];
      }

      if (hooksMap.containsKey("addPlusButtonInBottomBarHook") && hooksMap["addPlusButtonInBottomBarHook"] != null) {
        addPlusButtonInBottomBarHook = hooksMap["addPlusButtonInBottomBarHook"];
      }

      if (hooksMap.containsKey("navbarWidgetsHook") && hooksMap["navbarWidgetsHook"] != null) {
        navbarWidgetsHook = hooksMap["navbarWidgetsHook"];
      }

      if (hooksMap.containsKey("clusterMarkerIconHook") && hooksMap["clusterMarkerIconHook"] != null) {
        clusterMarkerIconHook = hooksMap["clusterMarkerIconHook"];
      }

      if (hooksMap.containsKey("customClusterMarkerIconHook") && hooksMap["customClusterMarkerIconHook"] != null) {
        customClusterMarkerIconHook = hooksMap["customClusterMarkerIconHook"];
      }

      if (hooksMap.containsKey("membershipPayWallDesignHook") && hooksMap["membershipPayWallDesignHook"] != null) {
        membershipPayWallDesignHook = hooksMap["membershipPayWallDesignHook"];
      }

      if (hooksMap.containsKey("minimumPasswordLengthHook") && hooksMap["minimumPasswordLengthHook"] != null) {
        minimumPasswordLengthHook = hooksMap["minimumPasswordLengthHook"];
      }

      if (hooksMap.containsKey("agentProfileConfigurationsHook") && hooksMap["agentProfileConfigurationsHook"] != null) {
        agentProfileConfigurationsHook = hooksMap["agentProfileConfigurationsHook"];
      }

      if (hooksMap.containsKey("userLoginActionHook") && hooksMap["userLoginActionHook"] != null) {
        userLoginActionHook = hooksMap["userLoginActionHook"];
      }

      if (hooksMap.containsKey("addPropertyActionHook") && hooksMap["addPropertyActionHook"] != null) {
        addPropertyActionHook = hooksMap["addPropertyActionHook"];
      }

      if (hooksMap.containsKey("drawerMenuItemDesignHook") && hooksMap["drawerMenuItemDesignHook"] != null) {
        drawerMenuItemDesignHook = hooksMap["drawerMenuItemDesignHook"];
      }

      if (hooksMap.containsKey("defaultAppThemeModeHook") && hooksMap["defaultAppThemeModeHook"] != null) {
        defaultAppThemeModeHook = hooksMap["defaultAppThemeModeHook"];
      }

      if (hooksMap.containsKey("messageApiRefreshTimeHook") && hooksMap["messageApiRefreshTimeHook"] != null) {
        messageApiRefreshTimeHook = hooksMap["messageApiRefreshTimeHook"];
      }

      if (hooksMap.containsKey("threadApiRefreshTimeHook") && hooksMap["threadApiRefreshTimeHook"] != null) {
        threadApiRefreshTimeHook = hooksMap["threadApiRefreshTimeHook"];
      }
    }
  }
}
