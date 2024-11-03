import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/models/drawer_menu_item.dart';
import 'package:houzi_package/pages/add_property_v2/add_property_v2.dart';
import 'package:houzi_package/pages/app_settings_pages/about.dart';
import 'package:houzi_package/pages/app_settings_pages/dark_mode_setting.dart';
import 'package:houzi_package/pages/app_settings_pages/language_settings.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/pages/crm_pages/crm_activities/activities_from_board.dart';
import 'package:houzi_package/pages/crm_pages/crm_bottom_bar.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/add_property_request.dart';
import 'package:houzi_package/pages/crm_pages/crm_deals/deals_from_board.dart';
import 'package:houzi_package/pages/crm_pages/crm_inquiry/inquiries_from_board.dart';
import 'package:houzi_package/pages/crm_pages/crm_leads/leads_from_board.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_drawer_widgets/home_screen_drawer_widget/home_screen_drawer_list_tile.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/all_agency.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/all_agents.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/all_blogs.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/favorites.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/my_agency_agents.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/properties.dart';
import 'package:houzi_package/pages/messages_pages/all_threads.dart';
import 'package:houzi_package/pages/quick_add_property/quick_add_property.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/request_demo.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/saved_searches.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/settings_page.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/pages/main_screen_pages/my_home_page.dart';
import 'package:houzi_package/pages/quick_add_property/quick_add_property_v2.dart';
import 'package:houzi_package/pages/search_result.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';


typedef HomeScreenDrawerWidgetsListingListener = void Function(bool loginInfo);

class HomeScreenDrawerWidgetsListing extends StatefulWidget {
  
  final Map<String, dynamic> userInfoMap;
  final dynamic drawerItemMap;
  final HomeScreenDrawerWidgetsListingListener homeScreenDrawerWidgetsListingListener;
  
  const HomeScreenDrawerWidgetsListing({
    Key? key,
    required this.userInfoMap,
    required this.drawerItemMap,
    required this.homeScreenDrawerWidgetsListingListener,
  }) : super(key: key);

  @override
  State<HomeScreenDrawerWidgetsListing> createState() => _HomeScreenDrawerWidgetsListingState();
}

class _HomeScreenDrawerWidgetsListingState extends State<HomeScreenDrawerWidgetsListing> {

  String _selectedHome = home0SectionType;

  Map drawerConfigItemMap = {};
  
  bool isMenuDrawerHelper = false;
  
  DrawerItem? menuDrawerHelper;
  
  List expansionTileChildren = [];

  @override
  void initState() {
    _selectedHome = HiveStorageManager.readSelectedHomeOption() ?? home0SectionType;

    if(widget.drawerItemMap is DrawerItem){
      menuDrawerHelper = widget.drawerItemMap;
      isMenuDrawerHelper = true;
    } else if(widget.drawerItemMap is! Map) {
      drawerConfigItemMap = widget.drawerItemMap.toJson();
    }else {
      drawerConfigItemMap = widget.drawerItemMap;
    }

    if (drawerConfigItemMap[sectionTypeKey] == expansionTileSectionType) {
      expansionTileChildren = drawerConfigItemMap[expansionTileChildrenSectionType] ?? [];
    }
    
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    if (isMenuDrawerHelper && menuDrawerHelper != null) {
      if (menuDrawerHelper!.enable!) {
        if (menuDrawerHelper!.expansionTileChildren.isNotEmpty) {
          return getExpansionTile(
            menuDrawerHelper!.title ?? "",
            menuDrawerHelper!.icon,
            menuDrawerHelper!.expansionTileChildren.map((item) {
              DrawerItem drawer = item;
              return HomeScreenDrawerListTile(
                selectedHome: _selectedHome,
                title: UtilityMethods.getLocalizedString(drawer.title ?? ""),
                iconData: drawer.icon ?? AppThemePreferences.infoIcon,
                sectionType: drawer.sectionType ?? "",
                onTap: drawer.onTap,
                isUserLoggedIn: widget.userInfoMap[USER_LOGGED_IN] ?? false,
                checkLogin: drawer.checkLogin ?? false,
                fromHook: true,
              );
            }).toList(),
          );
        } else {
          return HomeScreenDrawerListTile(
            selectedHome: _selectedHome,
            title: UtilityMethods.getLocalizedString(menuDrawerHelper!.title ?? ""),
            iconData: menuDrawerHelper!.icon ?? AppThemePreferences.infoIcon,
            sectionType: menuDrawerHelper!.sectionType ?? "",
            onTap: menuDrawerHelper!.onTap,
            isUserLoggedIn: widget.userInfoMap[USER_LOGGED_IN] ?? false,
            checkLogin: menuDrawerHelper!.checkLogin ?? false,
            fromHook: true,
          );
        }
      } else {
        return Container();
      }
    }


    return drawerConfigItemMap.isNotEmpty && (drawerConfigItemMap[enableKey] ?? false)
        ? Column(
            children: [
              if (drawerConfigItemMap[sectionTypeKey] == PLACE_HOLDER_SECTION_TYPE)
                HooksConfigurations.drawerWidgetsHook(
                    context,
                    drawerConfigItemMap[titleKey])
                    ?? Container()
              else if (drawerConfigItemMap[sectionTypeKey] != expansionTileSectionType)
                getListTile(
                  itemMap: drawerConfigItemMap,
                  userInfoMap: widget.userInfoMap,
                  listener: widget.homeScreenDrawerWidgetsListingListener,
                )
              else if (drawerConfigItemMap[sectionTypeKey] == expansionTileSectionType &&
                  widget.userInfoMap[USER_ROLE] != USER_ROLE_HOUZEZ_BUYER_VALUE)
                getExpansionTile(
                  drawerConfigItemMap[titleKey] ?? "",
                  AppThemePreferences.dashboardIcon,
                  expansionTileChildren.map((item) {
                    return getListTile(
                      itemMap: item,
                      userInfoMap: widget.userInfoMap,
                      listener: widget.homeScreenDrawerWidgetsListingListener,
                    );
                  }).toList(),
                )
              else
                Container(),
            ],
          )
        : Container();
  }

  Widget getExpansionTile(String title, IconData? icon,expansionTileChildren) {
    return ExpansionTile(
      maintainState: true,
      title: GenericTextWidget(
        UtilityMethods.getLocalizedString(title),
        style: TextStyle(
          fontWeight: AppThemePreferences.drawerMenuTextFontWeight,
          fontSize: AppThemePreferences.drawerMenuTextFontSize,
          color: AppThemePreferences().appTheme.normalTextColor!.withOpacity(0.8),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          icon ?? AppThemePreferences.infoIcon,
          color: AppThemePreferences().appTheme.normalTextColor!.withOpacity(0.8),
        ),
      ),
      children: expansionTileChildren
    );
  }

  Widget getListTile({
    required dynamic itemMap,
    required Map userInfoMap,
    required HomeScreenDrawerWidgetsListingListener listener,
  }) {
    String itemSectionType = itemMap[sectionTypeKey] ?? "";
    bool isUserLogged = userInfoMap[USER_LOGGED_IN] ?? false;

    if (itemSectionType == logoutSectionType && isUserLogged) {
      return HomeScreenDrawerListTile(
        selectedHome: _selectedHome,
        title: UtilityMethods.getLocalizedString(itemMap[titleKey]),
        iconData: getSectionIcon(context, itemSectionType),
        sectionType: itemSectionType,
        logOutConfirm: () {
          logOutConfirmation(
            onPositiveButtonPressed: () {
              Navigator.pop(context);
              listener(false);
              UtilityMethods.userLogOut(
                context: context,
                builder: (context) => const MyHomePage(),
              );
            },
          );
        },
      );
    }
    else if(isHomeSection(itemSectionType)){
      return HomeScreenDrawerListTile(
          selectedHome: _selectedHome,
          title: UtilityMethods.getLocalizedString(itemMap[titleKey] ?? ""),
          iconData: getSectionIcon(context, itemSectionType),
          sectionType: itemSectionType,
          builder: itemMap["on_tap"] ?? getWidgetBuilder(context, itemSectionType, itemMap[dataMapKey], menuItem: itemMap),
          isUserLoggedIn: isUserLogged,
          checkLogin: itemMap[checkLoginKey],
          onTap: ()=> onHomeSectionsTap(itemSectionType) ?? (){}
      );
    }
    else {
      if (itemSectionType == loginSectionType && isUserLogged) {
        return Container();
      } else if (itemSectionType != logoutSectionType) {
        if (userInfoMap[USER_ROLE] == USER_ROLE_HOUZEZ_BUYER_VALUE) {
          if (isRestrictedSection(itemSectionType)) {
            return Container();
          }
        }
        if (itemSectionType == myAgentsSectionType && !isUserLogged) {
          return Container();
        }
        else if(itemSectionType == myAgentsSectionType && userInfoMap[USER_ROLE] != USER_ROLE_HOUZEZ_AGENCY_VALUE){
          return Container();
        } else if (itemSectionType == messagesKey && !SHOW_MESSAGES) {
          return Container();
        }

        return HomeScreenDrawerListTile(
          selectedHome: _selectedHome,
          title: UtilityMethods.getLocalizedString(itemMap[titleKey] ?? ""),
          iconData: getSectionIcon(context, itemSectionType),
          sectionType: itemSectionType,
          builder: itemMap["on_tap"] ?? getWidgetBuilder(context, itemSectionType, itemMap[dataMapKey], menuItem: itemMap),
          isUserLoggedIn: isUserLogged,
          checkLogin: itemMap[checkLoginKey],
        );
      }
    }
    return Container();
  }

  bool isRestrictedSection(String section) {
    if (section == addPropertySectionType ||
        section == quickAddPropertySectionType ||
        section == propertiesSectionType) {
      return true;
    }

    return false;
  }

  bool isHomeSection(String sectionType){
    if(sectionType == homeSectionType || sectionType == home0SectionType ||
        sectionType == home01SectionType || sectionType == home02SectionType ||
        sectionType == home03SectionType){
      return true;
    }
    return false;
  }

  onHomeSectionsTap(String sectionType){
    if(mounted) {
      setState(() {
        _selectedHome = sectionType;
        if (sectionType == homeSectionType || sectionType == home0SectionType) {
          HOME_SCREEN_DESIGN = DESIGN_01;
        } else if (sectionType == home01SectionType) {
          HOME_SCREEN_DESIGN = DESIGN_02;
        } else if (sectionType == home02SectionType) {
          HOME_SCREEN_DESIGN = DESIGN_03;
        } else if (sectionType == home03SectionType) {
          HOME_SCREEN_DESIGN = DESIGN_04;
        } else {
          // Default Home Screen Design
          HOME_SCREEN_DESIGN = DESIGN_01;
        }

        HiveStorageManager.storeSelectedHomeOption(_selectedHome);
        GeneralNotifier().publishChange(GeneralNotifier.HOME_DESIGN_MODIFIED);
      });
    }

    Navigator.pop(context);
  }

  Future logOutConfirmation({required Function() onPositiveButtonPressed}) {
    return ShowDialogBoxWidget(
      context,
      title: UtilityMethods.getLocalizedString("log_out"),
      content: GenericTextWidget(UtilityMethods.getLocalizedString("are_you_sure_you_want_to_log_out")),
      actions: <Widget>[
        TextButtonWidget(
          onPressed: () => Navigator.pop(context),
          child: GenericTextWidget(UtilityMethods.getLocalizedString("cancel")),
        ),
        TextButtonWidget(
          onPressed: onPositiveButtonPressed,
          child: GenericTextWidget(UtilityMethods.getLocalizedString("yes")),
        ),
      ],
    );
  }

  WidgetBuilder? getWidgetBuilder(
    BuildContext context,
    String sectionType,
    Map<String, dynamic>? dataMap,
    { dynamic menuItem, }
  ){
    // if(sectionType == addPropertySectionType) return (context) => AddPropertyV2();
    if(sectionType == quickAddPropertySectionType) return (context) => UtilityMethods.navigateToAddPropertyPage(navigateToQuickAdd: true);//QuickAddPropertyV2();
    if(sectionType == addPropertySectionType) return (context) => UtilityMethods.navigateToAddPropertyPage();
    // if(sectionType == addPropertySectionType) return (context) => AddProperty();
    // if(sectionType == quickAddPropertySectionType) return (context) => QuickAddProperty();
    if(sectionType == propertiesSectionType) return (context) => Properties();
    if(sectionType == agentsSectionType) return (context) => AllAgents();
    if(sectionType == agenciesSectionType) return (context) => AllAgency();
    if(sectionType == myAgentsSectionType) return (context) => MyAgencyAgents();
    if(sectionType == requestPropertySectionType) return (context) => AddPropertyRequest();
    if(sectionType == favoritesSectionType) {
      return (context) => Favorites(
        showAppBar: true,
        favoritesPageListener: (String closeOption) {
          if (closeOption == CLOSE) {
            Navigator.pop(context);
          }
        },
      );
    }
    if(sectionType == savedSearchesSectionType) return (context) =>  SavedSearches(showAppBar: true);
    if(sectionType == activitiesSectionType) return (context) =>  ActivitiesFromBoard();
    if(sectionType == inquiriesSectionType) return (context) =>  InquiriesFromBoard();
    if(sectionType == dealsSectionType) return (context) =>  DealsFromBoard();
    if(sectionType == leadsSectionType) return (context) =>  LeadsFromBoard();
    if(sectionType == settingsSectionType) return (context) =>  HomePageSettings();
    if(sectionType == requestDemoSectionType) return (context) =>  ContactDeveloper();
    if (sectionType == loginSectionType) {
      return (context) =>   UserSignIn(
            (String closeOption) {
          if (closeOption == CLOSE) {
            Navigator.pop(context);
          }
        },
      );
    }
    if (sectionType == menuTermSectionType) {
      List<String> searchListTypeList = [];
      List<String> searchSubListTypeList = [];
      Map<String, dynamic>? searchPageDataInitMap = {};

      if(dataMap != null){
        if(dataMap.containsKey(SEARCH_LIST_TYPE_KEY) &&
            dataMap[SEARCH_LIST_TYPE_KEY] != null &&
            dataMap[SEARCH_LIST_TYPE_KEY] is List){
          searchListTypeList = List<String>.from(dataMap[SEARCH_LIST_TYPE_KEY]);
        }
        if(dataMap.containsKey(SEARCH_SUB_LIST_TYPE_KEY) &&
            dataMap[SEARCH_SUB_LIST_TYPE_KEY] != null &&
            dataMap[SEARCH_SUB_LIST_TYPE_KEY] is List){
          searchSubListTypeList = List<String>.from(dataMap[SEARCH_SUB_LIST_TYPE_KEY]);
        }

        for(var item in searchListTypeList){
          if(item != allString){
            String searchItemNameFilterKey = UtilityMethods.getSearchItemNameFilterKey(item);
            String searchItemSlugFilterKey = UtilityMethods.getSearchItemSlugFilterKey(item);
            List value = UtilityMethods.getSubTypeItemRelatedList(item, searchSubListTypeList);
            if(value.isNotEmpty && value[0].isNotEmpty) {
              searchPageDataInitMap[searchItemSlugFilterKey] = value[0];
              searchPageDataInitMap[searchItemNameFilterKey] = value[1];
            }
          }
        }
      }
      return (context) => SearchResult(
        dataInitializationMap: searchPageDataInitMap,
        searchPageListener: (Map<String, dynamic> map, String closeOption){
          if(closeOption == CLOSE){
            Navigator.of(context).pop();
          }
        },
      );
    }
    if (sectionType == aboutScreenSectionType) {
      return (context) => SHOW_DEMO_CONFIGURATIONS ? About() :
      WebPage(COMPANY_URL, UtilityMethods.getLocalizedString("about"));
    }
    if (sectionType == themeSettingScreenSectionType) {
      return (context) => DarkModeSettings();
    }
    if (sectionType == languageSettingScreenSectionType) {
      return (context) => LanguageSettings();
    }
    if (sectionType == privacyPolicyScreenSectionType) {
      return (context) => WebPage(APP_PRIVACY_URL, UtilityMethods.getLocalizedString("privacy_policy"));
    }
    if (sectionType == termsAndConditionsScreenSectionType) {
      return (context) => WebPage(APP_TERMS_URL, UtilityMethods.getLocalizedString("terms_and_conditions"));
    }
    if (sectionType == webUrlSectionType) {
      // print(UtilityMethods.validateURL(menuItem[dataMapKey][webUrlDataMapKey]));
      return (context) => WebPage(menuItem[dataMapKey][webUrlDataMapKey], UtilityMethods.getLocalizedString(menuItem[titleKey]));
    }
    if (sectionType == crmDashboardSectionType) {
      return (context) => CRMBottomBar();
    }
    if (sectionType == blogsKey) {
      return (context) => AllBlogsPage(title: menuItem[titleKey], blogDesign: BLOGS_DESIGN);
    }
    if (sectionType == messagesKey) {
      return (context) => AllThreadsPage();
    }



    return null;
  }

  IconData getSectionIcon(BuildContext context, sectionData){
    switch (sectionData) {
      case(homeSectionType): {
        return AppThemePreferences.homeIcon;
      }
      case(home0SectionType): {
        return AppThemePreferences.homeIcon;
      }
      case(home01SectionType): {
        return AppThemePreferences.homeIcon;
      }
      case(home02SectionType): {
        return AppThemePreferences.homeIcon;
      }
      case(home03SectionType): {
        return AppThemePreferences.homeIcon;
      }
      case(addPropertySectionType): {
        return AppThemePreferences.addPropertyIcon;
      }
      case(quickAddPropertySectionType): {
        return AppThemePreferences.quickAddPropertyIcon;
      }
      case(propertiesSectionType): {
        return AppThemePreferences.propertiesIcon;
      }
      case(agentsSectionType): {
        return AppThemePreferences.agentsIcon;
      }
      case(agenciesSectionType): {
        return AppThemePreferences.agencyIcon;
      }
      case(myAgentsSectionType): {
        return AppThemePreferences.realEstateAgent;
      }
      case(requestPropertySectionType): {
        return AppThemePreferences.requestPropertyIcon;
      }
      case(favoritesSectionType): {
        return AppThemePreferences.favouriteBorderIcon;
      }
      case(savedSearchesSectionType): {
        return AppThemePreferences.savedSearchesIcon;
      }
      case(activitiesSectionType): {
        return AppThemePreferences.activitiesIcon;
      }
      case(inquiriesSectionType): {
        return AppThemePreferences.inquiriesIcon;
      }
      case(dealsSectionType): {
        return AppThemePreferences.dealsIcon;
      }
      case(leadsSectionType): {
        return AppThemePreferences.leadsIcon;
      }
      case(settingsSectionType): {
        return AppThemePreferences.settingsIcon;
      }
      case(requestDemoSectionType): {
        return AppThemePreferences.requestDemoIcon;
      }
      case(loginSectionType): {
        return AppThemePreferences.loginIcon;
      }
      case(logoutSectionType): {
        return AppThemePreferences.logOutIcon;
      }
      case(menuTermSectionType): {
        return AppThemePreferences.propertiesIcon;
      }
      case(aboutScreenSectionType): {
        return AppThemePreferences.infoIcon;
      }
      case(themeSettingScreenSectionType): {
        return AppThemePreferences.darkModeIcon;
      }
      case(languageSettingScreenSectionType): {
        return AppThemePreferences.languageIcon;
      }
      case(privacyPolicyScreenSectionType): {
        return AppThemePreferences.policyIcon;
      }
      case(termsAndConditionsScreenSectionType): {
        return AppThemePreferences.gravelIcon;
      }
      case(webUrlSectionType): {
        return AppThemePreferences.websiteIcon;
      }
      case(crmDashboardSectionType): {
        return AppThemePreferences.dashboardIcon;
      }
      case(blogsKey): {
        return AppThemePreferences.blogIcon;
      }
      case(messagesKey): {
        return AppThemePreferences.messageIcon;
      }

      default: {
        return AppThemePreferences.infoIcon;
      }
    }
  }
}
