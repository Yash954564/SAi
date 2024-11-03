import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/item_design_files/item_design_notifier.dart';
import 'package:houzi_package/pages/app_settings_pages/about.dart';
import 'package:houzi_package/pages/app_settings_pages/dark_mode_setting.dart';
import 'package:houzi_package/pages/app_settings_pages/language_settings.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_settings_row_widget.dart';
import 'package:houzi_package/widgets/settings_page_widgets/demo_config_widget.dart';
import 'package:houzi_package/widgets/settings_page_widgets/item_theme_design_widget.dart';
import 'package:provider/provider.dart';


class HomePageSettings extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => HomePageSettingsState();
}

class HomePageSettingsState extends State<HomePageSettings> {

  SettingsHook settingsHook = HooksConfigurations.settingsOption;

  bool _showLoadingWidget = false;
  String appName = "";

  List<Widget>? preferencesHookWidgetsList = [];
  List<Widget>? communityStandardsAndLegalPoliciesHookWidgetsList = [];
  List<Widget>? hooksWidgetsList = [];

  @override
  void initState() {
    super.initState();

    appName = HiveStorageManager.readAppInfo()[APP_INFO_APP_NAME] ?? "";

    List<dynamic> tempList = [];
    tempList = settingsHook(context);
    if(tempList.isNotEmpty){
      for(var item in tempList){
        if(item != null && item is Map && item.isNotEmpty){
          if(item["sectionType"] == "preferences"){
            preferencesHookWidgetsList!.add(item["menuItem"]);
          }else if(item["sectionType"] == "community_standards_and_legal_policies"){
            communityStandardsAndLegalPoliciesHookWidgetsList!.add(item["menuItem"]);
          }else{
            hooksWidgetsList!.add(item["menuItem"]);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemDesignNotifier>(
      builder: (context, itemDesignNotifier, child){
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            appBar: AppBarWidget(
              appBarTitle: UtilityMethods.getLocalizedString("setting_and_privacy"),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                children: [
                  Column(
                    children: [
                      DemoConfigWidget(
                        listener: (showLoadingWidget){
                          if(mounted){
                            setState(() {
                              _showLoadingWidget = showLoadingWidget;
                            });
                          }
                        },
                      ),
                      ItemThemeDesignWidget(
                        tag: ITEM_THEME_DESIGN,
                        itemDesignNotifier: itemDesignNotifier,
                      ),
                      ItemThemeDesignWidget(
                        tag: EXPLORE_BY_TYPE_ITEM_THEME_DESIGN,
                        itemDesignNotifier: itemDesignNotifier,
                      ),
                      preferencesWidget(),
                      communityStandardsAndLegalPoliciesWidget(),
                      if(hooksWidgetsList != null && hooksWidgetsList!.isNotEmpty) Column(
                        children: hooksWidgetsList!,
                      ),
                      // settingsHook(context),
                    ],
                  ),
                  loadingIndicatorWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget loadingIndicatorWidget() {
    return _showLoadingWidget == false ? Container() :  Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: 80,
            height: 20,
            child: BallBeatLoadingWidget(),
          ),
        ),
      ),
    );
  }

  Widget preferencesWidget(){
    return GenericSettingsWidget(
      headingText: UtilityMethods.getLocalizedString("preference"),
      headingSubTitleText: UtilityMethods.getLocalizedString("customise_your_experience_on_app",inputWords:[appName] ),
      // headingSubTitleText: AppLocalizations.of(context).customise_your_experience_on_app(appName),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericWidgetRow(
            iconData: AppThemePreferences.darkModeIcon,
            text: UtilityMethods.getLocalizedString("dark_mode"),
            removeDecoration: true,
            onTap: ()=> onDarkModeSettingsTap(context),
          ),
          GenericWidgetRow(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            iconData: AppThemePreferences.languageIcon,
            text: UtilityMethods.getLocalizedString("language_label"),
            removeDecoration: true,
            onTap: ()=> onLanguageSettingsTap(context),
          ),
          if(preferencesHookWidgetsList != null && preferencesHookWidgetsList!.isNotEmpty) Column(
            children: preferencesHookWidgetsList!,
          ),
        ],
      ),
    );
  }

  void onDarkModeSettingsTap(BuildContext context){
    UtilityMethods.navigateToRoute(
      context: context,
      builder: (context) => DarkModeSettings(),
    );
  }

  void onLanguageSettingsTap(BuildContext context){
    UtilityMethods.navigateToRoute(
        context: context,
        builder: (context) => LanguageSettings(),
    );
  }

  Widget communityStandardsAndLegalPoliciesWidget(){
    return GenericSettingsWidget(
      headingText: UtilityMethods.getLocalizedString("community_standards_and_legal_policies"),
      removeDecoration: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericWidgetRow(
            iconData: AppThemePreferences.gravelIcon,
            text: UtilityMethods.getLocalizedString("terms_and_conditions"),
            removeDecoration: true,
            onTap: ()=> onTermsAndConditionsTap(context),
          ),
          GenericWidgetRow(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            iconData: AppThemePreferences.policyIcon,
            text: UtilityMethods.getLocalizedString("privacy_policy"),
            removeDecoration: true,
            onTap: (){
              onPrivacyTap(context);
            },
          ),
          GenericWidgetRow(
            padding: const EdgeInsets.only(top: 10.0),
            iconData: AppThemePreferences.infoIcon,
            text: UtilityMethods.getLocalizedString("about"),
            removeDecoration: true,
            onTap: ()=> onAboutTap(context),
          ),
          if(communityStandardsAndLegalPoliciesHookWidgetsList != null && communityStandardsAndLegalPoliciesHookWidgetsList!.isNotEmpty) Column(
            children: communityStandardsAndLegalPoliciesHookWidgetsList!,
          ),
        ],
      ),
    );
  }

  void onTermsAndConditionsTap(BuildContext context){
    UtilityMethods.navigateToRoute(
        context: context,
        builder: (context) => WebPage(APP_TERMS_URL, UtilityMethods.getLocalizedString("terms_and_conditions")));
  }

  void onPrivacyTap(BuildContext context){
    UtilityMethods.navigateToRoute(
        context: context,
        builder: (context) => WebPage(APP_PRIVACY_URL, UtilityMethods.getLocalizedString("privacy_policy")));
  }

  void onAboutTap(BuildContext context){
    SHOW_DEMO_CONFIGURATIONS ? UtilityMethods.navigateToRoute(
        context: context,
        builder: (context) => About()) :
    UtilityMethods.navigateToRoute(
        context: context,
        builder: (context) => WebPage(COMPANY_URL, UtilityMethods.getLocalizedString("about")));
  }
}