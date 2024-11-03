import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/models/map_marker_data.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_properties_related_widgets/latest_featured_properties_widget/properties_carousel_list_widget.dart';
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/configurations/app_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/houzi_main.dart';
import 'package:houzi_package/files/hooks_files/hooks_v2_interface.dart';
import 'package:houzi_package/l10n/l10n.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/models/drawer_menu_item.dart';
import 'package:houzi_package/models/realtor_model.dart';
import 'package:houzi_package/pages/crm_pages/crm_activities/activities_from_board.dart';
import 'package:houzi_package/pages/crm_pages/crm_deals/deals_from_board.dart';
import 'package:houzi_package/pages/crm_pages/crm_inquiry/inquiries_from_board.dart';
import 'package:houzi_package/pages/crm_pages/crm_leads/leads_from_board.dart';
import 'package:houzi_package/pages/home_page_screens/home_elegant_related/related_widgets/home_elegant_sliver_app_bar.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_drawer_widgets/home_screen_drawer_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_realtors_related_widgets/home_screen_realtors_list_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_sliver_app_bar_widgets/default_right_bar_widget.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/all_agents.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/settings_page.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/phone_sign_in_widgets/user_get_phone_number.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_profile.dart';
import 'package:houzi_package/pages/map_view.dart';

import 'package:houzi_package/pages/property_details_related_pages/pd_widgets_listing.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';
import 'package:houzi_package/widgets/explore_by_type_design_widgets/explore_by_type_design.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';

import 'package:houzi_package/pages/property_details_related_pages/bottom_buttons_action_bar.dart';
import 'package:houzi_package/pages/property_details_related_pages/pd_widgets_listing.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';
import 'package:houzi_package/widgets/custom_segment_widget.dart';
import 'package:houzi_package/widgets/explore_by_type_design_widgets/explore_by_type_design.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class HooksV2 implements HooksV2Interface {

  @override
  Map<String, dynamic> getHeaderMap() {
    Map<String, dynamic> map = {
      "app-secret": "2#4*dv3@4pK9W3",
      // "secret_key": "",
    };
    return map;
  }

  @override
  Map<String, dynamic> getPropertyDetailPageIconsMap() {
    Map<String, dynamic> _iconMap = {
      // "Air Conditioning": Icons.ac_unit_outlined,
      // "Air Conditioning": Image.asset("assets/IMAGE_NAME"),
    };

    return _iconMap;
  }

  @override
  Map<String, dynamic> getElegantHomeTermsIconMap() {
    Map<String, dynamic> _iconMap = {
      // "for-rent": Icons.vpn_key_outlined,
    };

    return _iconMap;
  }

  @override
  FontsHook getFontHook() {
    FontsHook fontsHook = (Locale locale) {
      // return "Ubuntu";
      // return "Qwitcher_Grypen";
      return "";
    };

    return fontsHook;
  }

  @override
  PropertyItemHeightHook getPropertyItemHeightHook() {
    PropertyItemHeightHook propertyItemHeightHook = (String designName) {
      return null;
    };
    return propertyItemHeightHook;
  }

//designName
  @override
  PropertyItemHookV2 getPropertyItemHookV2() {
    PropertyItemHookV2 propertyItemHookV2 =
        (
        {required article, required designName, required heroId, required onTap}) {
      return null;
    };

    return propertyItemHookV2;
  }

  /// Deprecated Method, use getPropertyItemHookV2() instead
  @override
  PropertyItemHook getPropertyItemHook() {
    PropertyItemHook propertyItemHook = (BuildContext context,
        Article article) {
      return null;
    };

    return propertyItemHook;
  }


  @override
  TermItemHook getTermItemHook() {
    TermItemHook termItemHook = (List metaDataList) {
      return null;
    };

    return termItemHook;
  }

  @override
  AgentItemHook getAgentItemHook() {
    AgentItemHook agentItemHook = (BuildContext context, Agent item) {
      // return Container(
      //   height: 100,
      //   padding: EdgeInsets.only(
      //     bottom: 10,
      //   ),
      //   child: Card(
      //     // shape: AppThemePreferences.roundedCorners(AppThemePreferences.realtorPageRoundedCornersRadius),
      //     // elevation: AppThemePreferences.horizontalListForAgentsElevation,
      //     child: InkWell(
      //       borderRadius: const BorderRadius.all(Radius.circular(10)),
      //       onTap: () {
      //         // navigateToRealtorInformationDisplayPage(
      //         //   context: context,
      //         //   heroId: heroId,
      //         //   realtorType: tag == AGENTS_TAG ? AGENT_INFO : AGENCY_INFO,
      //         //   realtorInfo: tag == AGENTS_TAG ? {AGENT_DATA : item} : {AGENCY_DATA : item},
      //         // );
      //       },
      //       child: Container(
      //         // width: ,
      //         // height: 135,
      //         height: 100,
      //         padding: const EdgeInsets.symmetric(horizontal: 10),
      //         child: Text(
      //           item.title,
      //           textAlign: TextAlign.left,
      //           maxLines: 1,
      //           strutStyle: const StrutStyle(forceStrutHeight: true),
      //           overflow: TextOverflow.ellipsis,
      //           // style: AppThemePreferences().appTheme.homeScreenRealtorTitleTextStyle,
      //         ),
      //       ),
      //     ),
      //   ),
      // );
      return null;
    };
    return agentItemHook;
  }

  @override
  AgencyItemHook getAgencyItemHook() {
    AgencyItemHook agencyItemHook = (BuildContext context, Agency agency) {
      return null;
    };

    return agencyItemHook;
  }

  @override
  PropertyPageWidgetsHook getWidgetHook() {
    PropertyPageWidgetsHook detailsHook = (BuildContext context,
        Article article,
        String hook,) {
      if (hook == 'article_images') {
        return null;
      } else if (hook == 'article_title') {
        return null;
      } else if (hook == 'article_address') {
        return null;
      } else if (hook == 'article_status_price') {
        return null;
      } else if (hook == 'valued_features') {
        return null;
      } else if (hook == 'article_features_details') {
        return null;
      } else if (hook == 'article_features') {
        return null;
      } else if (hook == 'article_description') {
        return null;
      } else if (hook == 'article_attachments') {
        return null;
      } else if (hook == 'article_address_info') {
        return null;
      } else if (hook == 'article_map') {
        return null;
      } else if (hook == 'article_floor_plans') {
        return null;
      } else if (hook == 'article_multi_units') {
        return null;
      } else if (hook == 'article_contact_information') {
        return null;
      } else if (hook == 'enquire_info') {
        return null;
      } else if (hook == 'setup_tour') {
        return null;
      } else if (hook == 'watch_video') {
        return null;
      } else if (hook == 'virtual_tour') {
        return null;
      } else if (hook == 'article_related_posts') {
        return null;
      } else if (hook == 'call_button') {
        return null;
      } else if (hook == 'email_button') {
        return null;
      } else if (hook == 'whatsapp_button') {
        return null;
      } else if (hook == 'line_button') {
        return null;
      } else if (hook == 'telegram_button') {
        return null;
      } else if (hook == 'message_button') {
        return null;
      } else if (hook == 'small_call_button') {
        return null;
      } else if (hook == 'small_email_button') {
        return null;
      } else if (hook == 'small_whatsapp_button') {
        return null;
      } else if (hook == 'small_line_button') {
        return null;
      } else if (hook == 'small_telegram_button') {
        return null;
      } else if (hook == 'small_message_button') {
        return null;
      }


      /// Copy and Paste the sample code provide below.
      ///
      /// Replace the 'HOOK_NAME' with that specific hookName that you define in
      /// json via Houzi Builder Desktop application and replace your
      /// Custom widget with 'WIDGET'.
      ///
      /// You are provided with the Property Article Information as the object
      /// 'article'. You and get your desired information from the 'article' and
      /// display in your Custom Widget.
      ///
      ///
      /// This is sample code:
      /// if (hook == 'HOOK_NAME') {
      ///   return WIDGET;
      /// }

      return null;
    };

    return detailsHook;
  }

  @override
  LanguageHook getLanguageCodeAndName() {
    LanguageHook languageHook = () {
      /// Steps to add Language
      ///  Step 1:
      ///  Make sure to add LANGUAGE-CODE_localization.json is added in asset and path
      ///  must be define in project level pubspec.yaml
      ///  assets/localization/LANGUAGE-CODE_localization.json
      ///  Step 2:
      ///  Make language map by defining language Name and Language code against the keys.
      ///  Step 3:
      ///  Add your language map in the languageList.
      ///  Step 4:
      ///  Run flutter pub get command.
      ///

      Map<String, dynamic> yourLanguageMap = {
        "languageName": "YOUR-LANGUAGE-NAME", // Specify your language name
        "languageCode": "YOUR-LANGUAGE-CODE" // Specify your language code
      };

      Map<String, dynamic> arabicLanguageMap = {
        "languageName": "Arabic",
        "languageCode": "ar"
      };

      Map<String, dynamic> englishLanguageMap = {
        "languageName": "English",
        "languageCode": "en"
      };

      Map<String, dynamic> frenchLanguageMap = {
        "languageName": "French",
        "languageCode": "fr"
      };

      Map<String, dynamic> urduLanguageMap = {
        "languageName": "Urdu",
        "languageCode": "ur"
      };

      Map<String, dynamic> russianLanguageMap = {
        "languageName": "Russian",
        "languageCode": "ru"
      };

      Map<String, dynamic> amhericLanguageMap = {
        "languageName": "Amheric",
        "languageCode": "am"
      };

      Map<String, dynamic> turkishLanguageMap = {
        "languageName": "Turkish",
        "languageCode": "tr"
      };

      Map<String, dynamic> spanishLanguageMap = {
        "languageName": "Spanish",
        "languageCode": "es"
      };

      Map<String, dynamic> romanianLanguageMap = {
        "languageName": "Romanian",
        "languageCode": "ro"
      };

      Map<String, dynamic> brazilianLanguageMap = {
        "languageName": "Brazilian",
        "languageCode": "pt"
      };

      Map<String, dynamic> persianLanguageMap = {
        "languageName": "Persian",
        "languageCode": "fa"
      };

      List<dynamic> languageList = [
        englishLanguageMap,
        arabicLanguageMap,
        frenchLanguageMap,
        urduLanguageMap,
        russianLanguageMap,
        amhericLanguageMap,
        turkishLanguageMap,
        spanishLanguageMap,
        romanianLanguageMap,
        brazilianLanguageMap,
        persianLanguageMap,
      ];

      return languageList;
    };

    return languageHook;
  }

  @override
  DefaultLanguageCodeHook getDefaultLanguageHook() {
    DefaultLanguageCodeHook defaultLanguageCodeHook = () {
      /// Add here your default language code
      return "en";
    };

    return defaultLanguageCodeHook;
  }

  @override
  DefaultHomePageHook getDefaultHomePageHook() {
    DefaultHomePageHook defaultHomePageHook = () {
      /// You can choose your default home for the app
      ///
      /// You have four options
      /// 1: home_0   (Home Carousel)
      /// 2: home_1   (Home Elegant)
      /// 3: home_2   (Home Location)
      /// 4: home_3   (Home Tabbed)
      ///
      /// return name of the home you want to make it default
      return "";

      /// Make it empty if you want to set your default home from HOUZI-BUILDER
      /// e.g return "";
    };

    return defaultHomePageHook;
  }

  @override
  DefaultCountryCodeHook getDefaultCountryCodeHook() {
    DefaultCountryCodeHook defaultCountryCodeHook = () {
      /// return 2 Letter ISO Code to make it default country code for phone login
      return "IN";
    };

    return defaultCountryCodeHook;
  }

  @override
  SettingsHook getSettingsItemHook() {
    SettingsHook settingsHook = (BuildContext context) {
      ///
      ///
      /// For info about adding Setting item visit below link:
      /// https://houzi-docs.booleanbites.com/hooks-widgets/add_item_settings/

      List<dynamic> settingsItemHookList = [
        // Add menu item map here
      ];

      return settingsItemHookList;
    };

    return settingsHook;
  }

  @override
  ProfileHook getProfileItemHook() {
    ProfileHook profileHook = (BuildContext context) {
      ///
      ///
      /// For info about adding Profile item visit below link:
      /// https://houzi-docs.booleanbites.com/hooks-widgets/add_item_profile/

      List<Widget> profileItemHookList = [
        // Add menu item map here
      ];
      return profileItemHookList;
    };
    return profileHook;
  }

  @override
  HomeRightBarButtonWidgetHook getHomeRightBarButtonWidgetHook() {
    HomeRightBarButtonWidgetHook homeRightBarButtonWidgetHook = (
        BuildContext context) {
      ///
      ///
      /// For info about customizing Home Right Bar Button Id Widget visit below link:
      /// https://houzi-docs.booleanbites.com/hooks-widgets/customize_home_right_bar_button_widget/

      Widget? rightBarButtonHook;
      // Widget rightBarButtonHook = DefaultRightBarButtonIdWidget();

      return rightBarButtonHook;
    };

    return homeRightBarButtonWidgetHook;
  }

  @override
  MarkerTitleHook getMarkerTitleHook() {
    /// Set title to the marker in MapView
    /// Instance of Article/Property is provided. You can choose whatever the
    /// title you want to set, it can be property title, id, price or anything
    MarkerTitleHook markerTitleHook = (BuildContext context, Article article) {
      /// If you want to set price as a title, use this piece of code

      String markerTitle = article.title!;
      return markerTitle; // return title here (should be string type)
    };

    return markerTitleHook;
  }

  @override
  MarkerIconHook getMarkerIconHook() {
    /// For info about how to add custom marker icon go to
    /// https://houzi-docs.booleanbites.com/hooks-widgets/set_marker_icon/

    MarkerIconHook markerIconHook = (BuildContext context, Article article) {
      /// If you want to set the default Pin Point marker return null
      /// else return the path of the image
      ///
      ///
      return null;
    };

    return markerIconHook;
  }

  @override
  CustomMarkerHook getCustomMarkerHook() {
    /// For info about how to add custom marker go to
    /// https://houzi-docs.booleanbites.com/hooks-widgets/set_custom_marker/

    CustomMarkerHook markerIconHook = (BuildContext context, Article article) {
      /// If you want to set the default Pin Point marker return null
      /// else return the title, background, title-color and an optional text style
      ///
      MapMarkerData markerData = MapMarkerData(
          text: article.getCompactPriceForMap(),
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
      return markerData;
      //return null; //if you don't want to show custom map pin, and want to show default GoogleMaps map pin.
    };

    return markerIconHook;
  }

  @override
  PriceFormatterHook getPriceFormatterHook() {
    PriceFormatterHook priceFormatterHook = (String propertyPrice,
        String firstPrice) {
      // Define your own method here and return the formatted string
      return null;
    };

    return priceFormatterHook;
  }

  @override
  CompactPriceFormatterHook getCompactPriceFormatterHook() {
    /// If you want to format price on Property Card use this method.
    /// If you want to use Houzi pre define formatter than return null
    ///
    ///
    CompactPriceFormatterHook compactPriceFormatterHook = (String inputPrice) {
      // Define your own method here and return the formatted string


      // return UtilityMethods.priceFormatter(inputPrice,"");
      return null;
    };

    return compactPriceFormatterHook;
  }

  @override
  TextFormFieldCustomizationHook getTextFormFieldCustomizationHook() {
    TextFormFieldCustomizationHook textFormFieldCustomizationHook = () {
      Map<String, dynamic> textFormFieldCustomizationMap = {
        'labelTextStyle': null,
        'hintTextStyle': null,
        'additionalHintTextStyle': null,
        'backgroundColor': null,
        'focusedBorderColor': null,
        'hideBorder': null,
        'borderRadius': null,
      };

      return textFormFieldCustomizationMap;
    };

    return textFormFieldCustomizationHook;
  }

  @override
  TextFormFieldWidgetHook getTextFormFieldWidgetHook() {
    TextFormFieldWidgetHook textFormFieldWidgetHook = (context,
        labelText,
        hintText,
        additionalHintText,
        suffixIcon,
        initialValue,
        maxLines,
        readOnly,
        obscureText,
        controller,
        keyboardType,
        inputFormatters,
        validator,
        onSaved,
        onChanged,
        onFieldSubmitted,
        onTap,) {
      Widget? textFormFieldWidget;
      return textFormFieldWidget;
    };

    return textFormFieldWidgetHook;
  }

  @override
  CustomSegmentedControlHook getCustomSegmentedControlHook() {
    CustomSegmentedControlHook customSegmentedControlHook = (
        BuildContext context,
        List<dynamic> itemList,
        int selectionIndex,
        Function(int) onSegmentChosen,) {
      return null;
    };

    return customSegmentedControlHook;
  }

  @override
  DrawerHeaderHook getDrawerHeaderHook() {
    DrawerHeaderHook drawerHeaderHook = (BuildContext context,
        String appName,
        String appIconPath,
        String? userProfileName,
        String? userProfileImageUrl,) {
      Widget? drawerHeaderWidget;

      return drawerHeaderWidget;
    };

    return drawerHeaderHook;
  }

  @override
  DrawerHook getDrawerItems() {
    DrawerHook drawerHook = (BuildContext context) {
      DrawerItem drawerItem = DrawerItem(
        sectionType: "hook",
        title: "check",
        checkLogin: false,
        enable: true,
        icon: Icons.real_estate_agent_outlined,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllAgents(),
            ),
          );
        },
        insertAt: 3,
      );

      DrawerItem crmExpandedDrawerItem = DrawerItem(
          sectionType: "hook",
          title: "CRM Dashboard",
          checkLogin: false,
          enable: true,
          icon: Icons.dashboard_outlined,
          insertAt: 14,
          expansionTileChildren: [
            DrawerItem(
              sectionType: "hook",
              title: "Activities",
              checkLogin: true,
              enable: true,
              icon: Icons.article_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivitiesFromBoard(),
                  ),
                );
              },
            ),
            DrawerItem(
              sectionType: "hook",
              title: "Inquiries",
              checkLogin: true,
              enable: true,
              icon: Icons.question_answer,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InquiriesFromBoard(),
                  ),
                );
              },
            ),
            DrawerItem(
              sectionType: "hook",
              title: "Deals",
              checkLogin: true,
              enable: true,
              icon: Icons.app_registration_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DealsFromBoard(),
                  ),
                );
              },
            ),
            DrawerItem(
              sectionType: "hook",
              title: "Leads",
              checkLogin: true,
              enable: true,
              icon: Icons.trending_up,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeadsFromBoard(),
                  ),
                );
              },
            )
          ]
      );

      List<dynamic> drawerItemList = [];

      return drawerItemList;
    };
    return drawerHook;
  }

  @override
  HidePriceHook getHidePriceHook() {
    HidePriceHook hidePriceHook = () {
      /// Hook to hide price on property item and property details.
      ///
      /// Returns a boolean value indicating whether prices should be
      /// hidden on the property item and property details.
      ///
      /// If this function returns `true`, all prices displayed on the
      /// property item and property details will be hidden from view.
      ///
      ///
      ///
      bool hidePropertyPrice = false;

      // Use isLoggedIn, if you want to show price to logged in users.
      // bool isLoggedIn = HiveStorageManager.isUserLoggedIn();
      // hidePropertyPrice = isLoggedIn ? false : true;

      // Use roles, if you want to show price to certain roles for logged in user.
      // String userRole = HiveStorageManager.getUserRole() ?? "";
      // hidePropertyPrice = (userRole == ROLE_ADMINISTRATOR || userRole == USER_ROLE_HOUZEZ_AGENCY_VALUE) ? false : true;

      return hidePropertyPrice;
    };

    return hidePriceHook;
  }

  @override
  HideEmptyTerm hideEmptyTerm() {
    /// Hook to decide if we should hide the empty enteries in Terms when showing them in filters.
    ///
    /// Terms are added on backend, and there can be lot of terms
    /// with empty data
    ///
    /// If this function returns `true`, for a Term, the empty enteries
    /// in that terms will be hidden.
    ///
    /// For example, for property_city, you've three cities [New York, Miami, Los Angeles]
    /// One of the city doesn't have any listing. Meaning you don't have any data in that
    /// city. So do you want to hide the cities that has zero listings? return true
    /// when it asks for term 'property_city'
    ///
    /// Specially useful for property_area, as it can be filtered out to show only non-empty areas.
    ///
    HideEmptyTerm shouldHide = (String termName) {
      if (termName == 'property_country') {
        return false; // return true to hide empty countries.
      }
      if (termName == 'property_state') {
        return false; // return true to hide empty states.
      }
      if (termName == 'property_city') {
        return false; //return true to hide empty cities.
      }
      if (termName == 'property_area') {
        return false; //return true to hide empty areas.
      }
      if (termName == 'property_type') {
        return false; //return true to hide empty types, like apartments, villas, shops.
      }
      if (termName == 'property_features') {
        return false; //return true to hide empty features, oven, garden, garage etc..
      }
      if (termName == 'property_label') {
        return false; //return true to hide empty labels in filters, like hot offer, new.
      }
      if (termName == 'property_status') {
        return false; //return true to hide empty statuses like for-sale, for-rent.
      }
      return false; //false shows all.
    };
    return shouldHide;
  }

  @override
  HomeSliverAppBarBodyHook getHomeSliverAppBarBodyHook() {
    HomeSliverAppBarBodyHook _homeSliverAppBarBodyHook = (context) {
      Map<String, dynamic>? _bodyHookMap;
      double? _bodyWidgetHeight;
      Widget? _bodyWidget;

      // _bodyWidgetHeight = 220;
      // _bodyWidget = HomeSliverAppBarBodyWidget();
      //
      _bodyHookMap = {
        "height": _bodyWidgetHeight,
        "widget": _bodyWidget,
      };
      return _bodyHookMap;
    };
    return _homeSliverAppBarBodyHook;
  }

  MembershipPlanHook getMembershipPlanHook() {
    MembershipPlanHook membershipPlanHook = (BuildContext context,
        List<dynamic> membershipPackageList) {
      /// To use the provided hook for membership packages, follow the steps below:
      ///
      /// The context parameter is used to build the UI, and the
      /// membershipPackageList parameter contains the list of membership packages.
      ///
      /// Inside the membership plan hook function, create a widget that will
      /// display the membership packages. You can customize the UI based on
      /// your requirements. You can use ListView.builder or PageView.builder etc.
      /// In this example, we'll use a ListView.builder to create a list view of the packages.
      ///
      /// return ListView.builder(
      ///         itemCount: membershipPackageList.length,
      ///        // controller: PageController(viewportFraction: 0.9),
      ///         itemBuilder: (context, index) {
      ///           Article article = membershipPackageList[index];
      ///           return Padding(
      ///             padding: const EdgeInsets.all(10),
      ///             child: Column(
      ///               children: [
      ///                 GenericTextWidget(article.title!), // title of the package
      ///                 GenericTextWidget(article.membershipPlanDetails!.packagePrice!), // price of the package
      ///               ],
      ///             )
      ///           );
      ///         },
      ///       );
      ///
      /// By typing article.membershipPlanDetails!.DIFFERENT_VARIABLE you will
      /// get all variables like package price, total number of featured properties,
      /// duration of the package etc.
      ///
      /// Once you have customized the UI, you can choose to return either
      /// the custom widget you created or the default UI. If you want to use
      /// the default UI provided by the hook, return null. Otherwise, return your custom widget.

      return null;
    };

    return membershipPlanHook;
  }

  @override
  DrawerWidgetsHook getDrawerWidgetsHook() {
    DrawerWidgetsHook drawerWidgetsHook = (BuildContext context,
        String? hookName) {

      /// Copy and Paste the sample code provide below.
      ///
      /// Replace the 'HOOK_NAME' with that specific hookName that you define in
      /// json via Houzi Builder Desktop application and replace your
      /// Custom widget with 'WIDGET'.
      ///
      ///
      /// This is sample code:
      /// if (hookName == 'HOOK_NAME') {
      ///   return WIDGET;
      /// }

      return null;
    };

    return drawerWidgetsHook;
  }

  @override
  HomeWidgetsHook getHomeWidgetsHook() {
    HomeWidgetsHook homeWidgetsHook = (BuildContext context,
        String? hookName,
        bool isRefreshed) {

      /// Copy and Paste the sample code provide below.
      ///
      /// Replace the 'HOOK_NAME' with that specific hookName that you define in
      /// json via Houzi Builder Desktop application and replace your
      /// Custom widget with 'WIDGET'.
      ///
      /// Whenever the home is refreshed, 'isRefreshed' will return true, if you
      /// want to perform anything when the home refreshes, you can use the
      /// 'isRefreshed'
      ///
      ///
      /// This is sample code:
      /// if (hookName == 'HOOK_NAME') {
      ///   return WIDGET;
      /// }

      return null;
    };

    return homeWidgetsHook;
  }

  PaymentHook getPaymentHook() {
    PaymentHook hook = (List<String> productIds,
        String? membershipPackageId,
        String? propertyId,
        bool isMembership,
        bool isFeaturedForPerListing,) {
      return null;
    };

    return hook;
  }

  @override
  PaymentSuccessfulHook getPaymentSuccessfulHook() {
    PaymentSuccessfulHook hook = (BuildContext context, bool success) {

    };
    return hook;
  }

  @override
  MembershipPackageUpdatedHook getMembershipPackageUpdatedHook() {
    MembershipPackageUpdatedHook hook = (BuildContext context, bool updated) {

    };
    return hook;
  }

  @override
  MembershipPayWallDesignHook getMembershipPayWallDesignHook() {
    MembershipPayWallDesignHook hook = (BuildContext context) {
      /// Determines the preferred design for displaying the membership plan pay wall.
      ///
      /// If you want to display the pay wall in a PageView/SlideView, return "PageView".
      /// If you want to display it in a VerticalView/ListView, return "ListView".

      return "PageView";
      // return "ListView";
    };
    return hook;
  }

  @override
  AddPlusButtonInBottomBarHook getAddPlusButtonInBottomBarHook() {
    AddPlusButtonInBottomBarHook hook = (BuildContext context) {
      /// If you wish to include a Plus button in the center of the bottom bar,
      /// return your widget else return null.
      ///
      /// Please note that this approach is not compatible with BOTTOM BAR DESIGN_02.

      return null;

      /// Example:
      // return Container(
      //   width: 65,
      //   height: 65,
      //   margin: const EdgeInsets.only(top: 0),
      //   child: FloatingActionButton(
      //     backgroundColor: AppThemePreferences.appSecondaryColor,
      //     child: Icon(Icons.add,color: Colors.white,size: 35),
      //     elevation: 4.0,
      //     onPressed: () {
      //       UtilityMethods.navigateToRoute(
      //         context: context,
      //         builder: (context) => HiveStorageManager.isUserLoggedIn()
      //             ? UtilityMethods.navigateToAddPropertyPage()
      //             : UserSignIn(
      //               (String closeOption) {
      //             if (closeOption == CLOSE) {
      //               Navigator.pop(context);
      //             }
      //           },
      //         ),
      //       );
      //     },
      //   ),
      // );
    };
    return hook;
  }

  @override
  NavbarWidgetsHook getNavbarWidgetsHook() {
    NavbarWidgetsHook navbarWidgetsHook = (BuildContext context,
        String? hookName,) {

      /// Copy and Paste the sample code provide below.
      ///
      /// Replace the 'HOOK_NAME' with that specific hookName that you define in
      /// json via Houzi Builder Desktop application and replace your
      /// Custom widget with 'WIDGET'.
      ///
      ///
      /// This is sample code:
      /// if (hookName == 'HOOK_NAME') {
      ///   return WIDGET;
      /// }

      return null;
    };

    return navbarWidgetsHook;
  }

  @override
  ClusterMarkerIconHook getCustomizeClusterMarkerIconHook() {

    /// If you want to show the Cluster Marker Icon with default settings, return null
    /// else return the customizedClusterMarkerIconHook with your required
    /// customization of Cluster Marker Icon against the respective key/keys.

    ClusterMarkerIconHook customizedClusterMarkerIconHook = () {
      Map<String, dynamic>? clusterMarkerDataMap = {
        "clusterColor": Colors.blue,
        "clusterTextColor": Colors.white,
        "clusterBorderColor": Colors.white,
        "clusterWidth": 80, // int
        "clusterBorderWidth": 10.0, // double
      };

      // return clusterMarkerDataMap;
      return null;
    };

    return customizedClusterMarkerIconHook;
  }

  @override
  CustomClusterMarkerIconHook getCustomClusterMarkerIconHook() {
    CustomClusterMarkerIconHook customClusterMarkerIconHook = (
        BuildContext context, int clusterSize) {
      /// If you want to set the default Cluster Marker Icon, return null
      /// else return your Custom Cluster Marker Icon

      return null;
    };

    return customClusterMarkerIconHook;
  }

  @override
  MinimumPasswordLengthHook getMinimumPasswordLengthHook() {
    MinimumPasswordLengthHook minimumPasswordLengthHook = () {
      return 8;
    };
    return minimumPasswordLengthHook;
  }

  @override
  AgentProfileConfigurationsHook getAgentProfileConfigurationsHook() {
    AgentProfileConfigurationsHook agentProfileConfigurationsHook = (hook) {
      if (hook == "additional_info") {
        return null;
      } else if (hook == "license") {
        return null;
      } else if (hook == "tax_number") {
        return null;
      } else if (hook == "service_areas") {
        return null;
      } else if (hook == "specialities") {
        return null;
      }

      return null;
    };
    return agentProfileConfigurationsHook;
  }

  @override
  AddPropertyActionHook? getAddPropertyActionHook() {
    AddPropertyActionHook addPropertyActionHook = ({
      required context,
      required addPropertyNonce,
      required uploadImagesNonce,
      required addPropertyDataMap,
      required defaultAddPropertyFunc}) {
      // define your action here
    };

    // return addPropertyActionHook;
    return null;
  }

  @override
  DrawerMenuItemDesignHook? getDrawerMenuItemDesignHook() {
    DrawerMenuItemDesignHook drawerMenuItemDesignHook = ({
      required iconData, required label, required onTap, required selectedItem}) {
      // return your design widget here
      return null;
    };

    return drawerMenuItemDesignHook;
  }

  @override
  UserLoginActionHook? getUserLoginActionHook() {
    UserLoginActionHook loginActionHook = ({
      required context,
      required formKey,
      required usernameEmail,
      required password,
      required loginNonce,
      required defaultLoginFunc}) {
      // define your action here
    };

    // return loginActionHook;
    return null;
  }

  @override
  DefaultAppThemeModeHook? getDefaultAppThemeModeHook() {
    DefaultAppThemeModeHook defaultAppThemeModeHook = () {
      return "light";
    };

    return defaultAppThemeModeHook;
  }

  @override
  MessageApiRefreshTimeHook? getMessageApiRefreshTimeHook() {
    MessageApiRefreshTimeHook? messageApiRefreshTimeHook = () {
      return 5; // time in seconds
    };

    return messageApiRefreshTimeHook;
  }

  @override
  ThreadApiRefreshTimeHook? getThreadApiRefreshTimeHook() {
    ThreadApiRefreshTimeHook? threadApiRefreshTimeHook = () {
      return 5; // time in seconds
    };

    return threadApiRefreshTimeHook;
  }
}