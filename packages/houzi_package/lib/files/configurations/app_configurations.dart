import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

typedef AppConfigurationsListener = void Function(bool areConfigsIntegrated);

class AppConfigurations {
  final String filePath;
  final AppConfigurationsListener appConfigurationsListener;

  AppConfigurations({
    required this.filePath,
    required this.appConfigurationsListener,
  });

  Future<Map<String, dynamic>> getConfigFile() async {
    String? jsonString;
    Map<String, dynamic> configurationsFile = {};

    // if ENABLE_API_CONFIG is true then read the last Saved Config file.
    // else read Local Config File
    if (ENABLE_API_CONFIG) {
      jsonString = HiveStorageManager.readAppConfigurations();
    }

    // Load Local Config File
    if (jsonString == null || jsonString.isEmpty) {
      jsonString = await rootBundle.loadString(filePath);
    }

    Map tempValueHolderMap = jsonDecode(jsonString);
    configurationsFile = UtilityMethods.convertMap(tempValueHolderMap);
    return configurationsFile;
  }

  Future<void> integrateConfigurations() async {
    Map<String, dynamic> configurationsFile = await getConfigFile();

    basicAppConfigIntegration(configurationsFile);
    styleAppConfigIntegration(configurationsFile);
    apiAndConfigAppConfigIntegration(configurationsFile);
    homeRelatedAppConfigIntegration(configurationsFile);
    storeAppConfigItems(configurationsFile);
    resultsAppConfigIntegration(configurationsFile);

    appConfigurationsListener(true);
  }

  basicAppConfigIntegration(Map<String, dynamic> configurationsFile) {
    String? stringValueHolder;

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: appNameConfiguration,
    );
    if (stringValueHolder != null) {
      APP_NAME = stringValueHolder;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: wordpressUrlSchemeConfiguration,
    );
    if (stringValueHolder != null) {
      WORDPRESS_URL_SCHEME = stringValueHolder;
      HiveStorageManager.storeCommunicationProtocol(
          protocol: WORDPRESS_URL_SCHEME);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: wordpressUrlDomainConfiguration,
    );
    if (stringValueHolder != null) {
      WORDPRESS_URL_DOMAIN = stringValueHolder;
      HiveStorageManager.storeUrlAuthority(authority: WORDPRESS_URL_DOMAIN);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: wordpressUrlPathConfiguration,
    );
    if (stringValueHolder != null) {
      WORDPRESS_URL_PATH = stringValueHolder;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: appTermsUrlConfiguration,
    );
    if (stringValueHolder != null) {
      APP_TERMS_URL = stringValueHolder;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: appPrivacyUrlConfiguration,
    );
    if (stringValueHolder != null) {
      APP_PRIVACY_URL = stringValueHolder;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: appTermsOfUseUrlConfiguration,
    );
    if (stringValueHolder != null) {
      APP_TERMS_OF_USE_URL = stringValueHolder;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: wordpressUrlGDPRAgreementConfiguration,
    );
    if (stringValueHolder != null) {
      WORDPRESS_URL_GDPR_AGREEMENT = stringValueHolder;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: companyUrlConfiguration,
    );
    if (stringValueHolder != null) {
      COMPANY_URL = stringValueHolder;
    }
  }

  styleAppConfigIntegration(Map<String, dynamic> configurationsFile) {
    String? stringValueHolder;

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: primaryColorConfiguration,
    );
    if (stringValueHolder != null) {
      MaterialColor tempColor =
          UtilityMethods.getMaterialColor(stringValueHolder);
      AppThemePreferences.appPrimaryColor =
          UtilityMethods.getColorFromString(stringValueHolder);
      AppThemePreferences.appPrimaryColorSwatch = tempColor;
      AppThemePreferences.formFieldBorderColor = tempColor;

      setSecondaryColor(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: secondaryColorConfiguration,
    );
    if (stringValueHolder != null) {
      setSecondaryColor(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: iconTintColorConfiguration,
    );
    if (stringValueHolder != null) {
      Color tempIconTintColor =
          UtilityMethods.getColorFromString(stringValueHolder);
      AppThemePreferences.appIconsMasterColorLight = tempIconTintColor;
      AppThemePreferences.articleBoxIconsColorLight = tempIconTintColor;
      AppThemePreferences.filterPageIconsColorLight = tempIconTintColor;
      AppThemePreferences.drawerMenuIconColorLight = tempIconTintColor;
      AppThemePreferences.homeScreenTopBarLocationIconColorLight =
          tempIconTintColor;
      AppThemePreferences.homeScreenTopBarSearchIconColorLight =
          tempIconTintColor;
      AppThemePreferences.searchByIdTextColorLight = tempIconTintColor;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: iconTintColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      Color tempIconTintColorDarkMode =
          UtilityMethods.getColorFromString(stringValueHolder);
      AppThemePreferences.appIconsMasterColorDark = tempIconTintColorDarkMode;
      AppThemePreferences.articleBoxIconsColorDark = tempIconTintColorDarkMode;
      AppThemePreferences.filterPageIconsColorDark = tempIconTintColorDarkMode;
      AppThemePreferences.drawerMenuIconColorDark = tempIconTintColorDarkMode;
      AppThemePreferences.homeScreenTopBarLocationIconColorDark =
          tempIconTintColorDarkMode;
      AppThemePreferences.homeScreenTopBarSearchIconColorDark =
          tempIconTintColorDarkMode;
      AppThemePreferences.searchByIdTextColorDark = tempIconTintColorDarkMode;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: appBackgroundColorLightModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.backgroundColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: appBackgroundColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.backgroundColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: headingsColorLightModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.headingTextColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: headingsColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.headingTextColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: bottomTabBarTintColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.bottomNavBarTintColor =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: unSelectedBottomTabBarTintColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.unSelectedBottomNavBarTintColor =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: bottomTabBarBackgroundColorLightModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.bottomNavBarBackgroundColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: bottomTabBarBackgroundColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.bottomNavBarBackgroundColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: sliderTintColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.sliderTintColor =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: selectedItemBackgroundColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.selectedItemBackgroundColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: selectedItemTextColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.selectedItemTextColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: unSelectedItemTextColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.unSelectedItemTextColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: unSelectedItemBackgroundColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.unSelectedItemBackgroundColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: actionButtonBackgroundColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.actionButtonBackgroundColor =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: dividerColorLightConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.dividerColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: dividerColorDarkConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.dividerColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: featuredTagBackgroundColorLightModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.featuredTagBackgroundColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: featuredTagBackgroundColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.featuredTagBackgroundColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: featuredTagBorderColorLightModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.featuredTagBorderColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: featuredTagBorderColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.featuredTagBorderColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: featuredTagFontColorLightModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.featuredTagTextColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: featuredTagFontColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.featuredTagTextColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: tagBackgroundColorLightModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.tagBackgroundColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: tagBackgroundColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.tagBackgroundColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: tagBorderColorLightModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.tagBorderColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: tagBorderColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.tagBorderColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: tagFontColorLightModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.tagTextColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: tagFontColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.tagTextColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: favouriteIconTintColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.favouriteIconColor =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: propertyDetailsEmailButtonBgColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.emailButtonBackgroundColor =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: propertyDetailsCallButtonBgColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.callButtonBackgroundColor =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: propertyDetailsWhatsAppButtonBgColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.whatsAppBackgroundColor =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: lineAppButtonBgColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.lineAppBackgroundColor =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: telegramAppButtonBgColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.telegramBackgroundColor =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: messageButtonBgColorConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.messageButtonBackgroundColor =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: propertyItemDesignContainerBgColorLightModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.articleDesignItemBackgroundColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: propertyItemDesignContainerBgColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.articleDesignItemBackgroundColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: filterPageHeadingsColorLightModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.filterPageTitleHeadingTextColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: filterPageHeadingsColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.filterPageTitleHeadingTextColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: filterPageIconTintColorLightModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.filterPageIconsColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: filterPageIconTintColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.filterPageIconsColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: filterPagePlaceHolderTextColorLightModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.filterPageTempTextPlaceHolderTextColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: filterPagePlaceHolderTextColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.filterPageTempTextPlaceHolderTextColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: cupertinoSegmentThumbColorLightConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.cupertinoSegmentThumbColorLight =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: cupertinoSegmentThumbColorDarkConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.cupertinoSegmentThumbColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: selectedItemBackgroundColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.selectedItemBackgroundColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: selectedItemTextColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.selectedItemTextColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: unSelectedItemTextColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.unSelectedItemTextColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: unSelectedItemBackgroundColorDarkModeConfiguration,
    );
    if (stringValueHolder != null) {
      AppThemePreferences.unSelectedItemBackgroundColorDark =
          UtilityMethods.getColorFromString(stringValueHolder);
    }
  }

  setSecondaryColor(String stringValueHolder) {
    MaterialColor secondaryColor =
        UtilityMethods.getMaterialColor(stringValueHolder);
    AppThemePreferences.appSecondaryColor = secondaryColor;
    AppThemePreferences.switchSelectedBackgroundLight = secondaryColor[200]!;
    AppThemePreferences.linkColor = secondaryColor;
    AppThemePreferences.switchSelectedTextLight = secondaryColor;
    AppThemePreferences.label02TextColor = secondaryColor;
    AppThemePreferences.readMoreTextColorLight = secondaryColor;
    AppThemePreferences.homeScreenTopBarRightArrowBackgroundColorLight =
        secondaryColor;

    AppThemePreferences.homeScreenRecentSearchTitleColorLight = secondaryColor;
    AppThemePreferences.articleBoxPropertyStatusColorLight = secondaryColor;
    AppThemePreferences.explorePropertyColorLight = secondaryColor;
    AppThemePreferences.propertyDetailsPagePropertyStatusColorLight =
        secondaryColor;

    AppThemePreferences.readMoreTextColorDark = secondaryColor;
    AppThemePreferences.homeScreenRecentSearchTitleColorDark = secondaryColor;
    AppThemePreferences.explorePropertyColorDark = secondaryColor;
    AppThemePreferences.propertyDetailsPagePropertyStatusColorDark =
        secondaryColor;

    AppThemePreferences.locationWidgetTextColorLight = secondaryColor[500]!;
    AppThemePreferences.locationWidgetTextColorDark = secondaryColor;

    AppThemePreferences.appIconsMasterColorLight = secondaryColor;
    AppThemePreferences.selectedItemTextColorLight = secondaryColor;
    AppThemePreferences.selectedItemBackgroundColorLight =
        secondaryColor.withOpacity(0.3);
    AppThemePreferences.switchSelectedBackgroundLight =
        secondaryColor.withOpacity(0.3);
    AppThemePreferences.switchSelectedTextLight = secondaryColor;
    AppThemePreferences.sliderTintColor = secondaryColor;
    AppThemePreferences.searchByIdTextColorLight = secondaryColor;
    AppThemePreferences.drawerMenuIconColorLight = secondaryColor;
    AppThemePreferences.homeScreenTopBarLocationIconColorLight = secondaryColor;
    AppThemePreferences.homeScreenTopBarDownArrowIconColorLight =
        secondaryColor;
    AppThemePreferences.homeScreenTopBarSearchIconColorLight = secondaryColor;
    AppThemePreferences.featuredTagBorderColorLight =
        secondaryColor.withOpacity(0.6);
    AppThemePreferences.articleBoxIconsColorLight = secondaryColor;
    AppThemePreferences.filterPageIconsColorLight = secondaryColor;
    AppThemePreferences.locationWidgetTextColorLight = secondaryColor;
    AppThemePreferences.bottomNavBarTintColor = secondaryColor;
    AppThemePreferences.featuredTagBorderColorDark =
        secondaryColor.withOpacity(0.6);
  }

  apiAndConfigAppConfigIntegration(Map<String, dynamic> configurationsFile) {
    String? stringValueHolder;
    bool booleanValueHolder = false;

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: localeInUrl,
    );
    currentSelectedLocaleUrlPosition = stringValueHolder ?? doNotChangeUrl;

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: restAPIPropertiesRouteConfiguration,
    );
    if (stringValueHolder != null) {
      REST_API_PROPERTIES_ROUTE = stringValueHolder;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: restAPIAgentRouteConfiguration,
    );
    if (stringValueHolder != null) {
      REST_API_AGENT_ROUTE = stringValueHolder;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: restAPIAgencyRouteConfiguration,
    );
    if (stringValueHolder != null) {
      REST_API_AGENCY_ROUTE = stringValueHolder;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: googleMapAPIKeyConfiguration,
    );
    if (stringValueHolder != null) {
      GOOGLE_MAP_API_KEY = stringValueHolder;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: androidNativeAdIdConfiguration,
    );
    if (stringValueHolder != null) {
      ANDROID_NATIVE_AD_ID = stringValueHolder;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: iosNativeAdIdConfiguration,
    );
    if (stringValueHolder != null) {
      IOS_NATIVE_AD_ID = stringValueHolder;
    }

    booleanValueHolder = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: configurationsFile, key: showAdsConfiguration);
    if (booleanValueHolder) {
      if (Platform.isAndroid &&
          UtilityMethods.getBooleanItemValueFromMap(
              inputMap: configurationsFile, key: showAndroidAdsConfiguration)) {
        SHOW_ADS = true;
      } else if (Platform.isIOS &&
          UtilityMethods.getBooleanItemValueFromMap(
              inputMap: configurationsFile, key: showIOSAdsConfiguration)) {
        SHOW_ADS = true;
      } else {
        SHOW_ADS = false;
      }
    } else {
      SHOW_ADS = false;
    }

    SHOW_ADD_PROPERTY_IN_PROFILE = UtilityMethods.getBooleanItemValueFromMap(
      inputMap: configurationsFile,
      key: showAddPropertyInProfileConfiguration,
    );

    SHOW_ADD_PROPERTY = UtilityMethods.getBooleanItemValueFromMap(
      inputMap: configurationsFile,
      key: SHOW_ADD_PROPERTY_KEY,
    );

    SHOW_REQUEST_DEMO = UtilityMethods.getBooleanItemValueFromMap(
      inputMap: configurationsFile,
      key: SHOW_REQUEST_DEMO_KEY,
    );

    SHOW_LOGIN_WITH_PHONE = UtilityMethods.getBooleanItemValueFromMap(
      inputMap: configurationsFile,
      key: showLoginWithPhoneConfiguration,
    );

    SHOW_LOGIN_WITH_FACEBOOK = UtilityMethods.getBooleanItemValueFromMap(
      inputMap: configurationsFile,
      key: showLoginWithFacebookConfiguration,
    );

    SHOW_LOGIN_WITH_GOOGLE = UtilityMethods.getBooleanItemValueFromMap(
      inputMap: configurationsFile,
      key: showLoginWithGoogleConfiguration,
    );

    SHOW_LOGIN_WITH_APPLE = UtilityMethods.getBooleanItemValueFromMap(
      inputMap: configurationsFile,
      key: showLoginWithAppleConfiguration,
    );

    LOCK_PLACES_API = UtilityMethods.getBooleanItemValueFromMap(
      inputMap: configurationsFile,
      key: lockPlacesApiConfiguration,
    );

    SHOW_EMAIL_BUTTON = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: configurationsFile,
        key: showEmailButtonDetailPageConfiguration,
        defaultValue: true);

    SHOW_CALL_BUTTON = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: configurationsFile,
        key: showCallButtonDetailPageConfiguration,
        defaultValue: true);

    SHOW_MESSAGES_BUTTON = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: configurationsFile,
        key: showMessageButtonConfiguration,
        defaultValue: true);

    SHOW_WHATSAPP_BUTTON = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: configurationsFile,
        key: showWhatsappButtonDetailPageConfiguration,
        defaultValue: true);

    SHOW_LINE_APP_BUTTON = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: configurationsFile,
        key: showLineAppButtonConfiguration,
        defaultValue: true);

    SHOW_TELEGRAM_BUTTON = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: configurationsFile,
        key: showTelegramButtonConfiguration,
        defaultValue: true);

    ENABLE_HTML_IN_DESCRIPTION = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: configurationsFile,
        key: enableHtmlInDescriptionConfig,
        defaultValue: true);

    ENABLE_HTML_IN_BLOG_DESCRIPTION = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: configurationsFile,
        key: enableHtmlInBlogDescriptionConfig,
        defaultValue: true);

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: lockPlacesCountriesApiConfiguration,
    );
    if (LOCK_PLACES_API && stringValueHolder != null) {
      PLACES_API_COUNTRIES =
          UtilityMethods.getPlacesApiLockedCountriesFormattedString(
              stringValueHolder);
    }

    SHOW_PRINT_PROPERTY_BUTTON = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: configurationsFile,
        key: showPrintPropertyButtonConfig,
        defaultValue: true);

    SHOW_DOWNLOAD_IMAGE_BUTTON = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: configurationsFile,
        key: showDownloadImageButtonConfig,
        defaultValue: true);

    USE_CUPERTINO_SEGMENT_CONTROL = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: configurationsFile,
        key: useCupertinoSegmentControlConfig,
        defaultValue: false);

    List<String>? list = UtilityMethods.getStringListItemValueFromMap(
      inputMap: configurationsFile,
      key: HOME_LOCATION_HIERARCHY_CONFIG,
    );
    if (list != null) {
      ENABLE_SEQUENTIAL_LOCATION_PICKER = true;
      homeLocationPickerHierarchyList = list;
    } else {
      ENABLE_SEQUENTIAL_LOCATION_PICKER = false;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: oneSignalAppIdConfiguration,
    );
    if (stringValueHolder != null) {
      ONE_SIGNAL_APP_ID = stringValueHolder;
    }
  }

  homeRelatedAppConfigIntegration(Map<String, dynamic> configurationsFile) {
    String? stringValueHolder;
    int? integerValueHolder;

    integerValueHolder = UtilityMethods.getIntegerItemValueFromMap(
      inputMap: configurationsFile,
      key: totalSearchTypeOptionsApiConfiguration,
    );
    if (integerValueHolder != null) {
      defaultSearchTypeSwitchOptions = integerValueHolder;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: quoteApiConfiguration,
    );
    if (stringValueHolder != null) {
      TABBED_HOME_QUOTE = stringValueHolder;
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: defaultHomeApiConfiguration,
    );
    if (stringValueHolder != null) {
      final DefaultHomePageHook defaultHomePageHook =
          HooksConfigurations.defaultHomePage;
      String? tempHome = defaultHomePageHook();
      if (tempHome == null || tempHome.isEmpty) {
        tempHome = stringValueHolder;
      }

      HiveStorageManager.storeSelectedHomeOption(tempHome);
      GeneralNotifier().publishChange(GeneralNotifier.HOME_DESIGN_MODIFIED);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: DEFAULT_BOTTOM_NAVBAR_DESIGN,
    );
    if (stringValueHolder != null) {
      BOTTOM_NAVIGATION_BAR_DESIGN =
          UtilityMethods.getDesignValue(stringValueHolder)!;
      GeneralNotifier().publishChange(GeneralNotifier.NAVBAR_DESIGN_MODIFIED);
    }

    SHOW_BOTTOM_NAV_BAR_ADD_BTN = UtilityMethods.getBooleanItemValueFromMap(
      inputMap: configurationsFile,
      key: SHOW_BOTTOM_NAVBAR_ADD_BUTTON_CONFIG,
    );
  }

  storeAppConfigItems(Map<String, dynamic> configurationsFile) {
    int? integerValueHolder;
    List? listValueHolder;

    HiveStorageManager.storeAppConfigurations(jsonEncode(configurationsFile));

    // Store current Houzi version to Hive
    integerValueHolder = UtilityMethods.getIntegerItemValueFromMap(
      inputMap: configurationsFile,
      key: versionApiConfiguration,
    );
    if (integerValueHolder != null) {
      HiveStorageManager.storeHouziVersion(integerValueHolder);
    }

    listValueHolder = UtilityMethods.getListItemValueFromMap(
      inputMap: configurationsFile,
      key: homePageLayoutConfiguration,
    );
    if (listValueHolder != null) {
      UtilityMethods.saveHomeConfigFile(configurationsFile);
    }

    listValueHolder = UtilityMethods.getListItemValueFromMap(
      inputMap: configurationsFile,
      key: drawerMenuLayoutConfiguration,
    );
    if (listValueHolder != null) {
      UtilityMethods.saveDrawerConfigFile(configurationsFile);
    }

    listValueHolder = UtilityMethods.getListItemValueFromMap(
      inputMap: configurationsFile,
      key: searchPageLayoutConfiguration,
    );
    if (listValueHolder != null) {
      UtilityMethods.saveFilterPageConfigFile(configurationsFile);
    }

    listValueHolder = UtilityMethods.getListItemValueFromMap(
      inputMap: configurationsFile,
      key: propertyDetailsPageLayoutConfiguration,
    );
    if (listValueHolder != null) {
      UtilityMethods.savePropertyDetailPageConfigFile(configurationsFile);
    }

    listValueHolder = UtilityMethods.getListItemValueFromMap(
      inputMap: configurationsFile,
      key: addPropertyLayoutApiConfiguration,
    );
    if (listValueHolder != null) {
      UtilityMethods.saveAddPropertyConfigFile(configurationsFile);
    }

    listValueHolder = UtilityMethods.getListItemValueFromMap(
      inputMap: configurationsFile,
      key: quickAddPropertyLayoutApiConfiguration,
    );
    if (listValueHolder != null) {
      UtilityMethods.saveQuickAddPropertyConfigFile(configurationsFile);
    }

    listValueHolder = UtilityMethods.getListItemValueFromMap(
      inputMap: configurationsFile,
      key: bottomNavBarLayoutConfiguration,
    );
    if (listValueHolder != null) {
      UtilityMethods.saveBottomNavigationBarConfigFile(configurationsFile);
    }

    listValueHolder = UtilityMethods.getListItemValueFromMap(
      inputMap: configurationsFile,
      key: SORT_FIRST_BY_CONFIG,
    );
    if (listValueHolder != null) {
      UtilityMethods.saveSortFirstByConfigFile(configurationsFile);
    }

    listValueHolder = UtilityMethods.getListItemValueFromMap(
      inputMap: configurationsFile,
      key: blogDetailsPageLayoutConfiguration,
    );
    if (listValueHolder != null) {
      UtilityMethods.saveBlogDetailPageConfigFile(configurationsFile);
    }
  }

  resultsAppConfigIntegration(Map<String, dynamic> configurationsFile) {
    String? stringValueHolder;

    SHOW_MAP_INSTEAD_FILTER = UtilityMethods.getBooleanItemValueFromMap(
      inputMap: configurationsFile,
      key: showMapInsteadFilterConfiguration,
    );

    SHOW_GRID_VIEW_BUTTON = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: configurationsFile,
        key: showGridViewButtonConfig,
        defaultValue: true);

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: DEFAULT_RESULTS_ITEM_DESIGN_CONFIG,
    );
    if (stringValueHolder != null) {
      SEARCH_RESULTS_PROPERTIES_DESIGN =
          UtilityMethods.getDesignValue(stringValueHolder)!;
      // GeneralNotifier().publishChange(GeneralNotifier.RESULTS_ITEM_DESIGN_MODIFIED);
    }

    stringValueHolder = UtilityMethods.getStringItemValueFromMap(
      inputMap: configurationsFile,
      key: DEFAULT_SORT_BY_CONFIG,
    );
    if (stringValueHolder != null) {
      DEFAULT_SORT_BY_OPTION =
          UtilityMethods.getDesignValue(stringValueHolder)!;
    }
  }
}
