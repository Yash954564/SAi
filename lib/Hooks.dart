import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/files/configurations/app_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/houzi_main.dart';
import 'package:houzi_package/l10n/l10n.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/models/drawer_menu_item.dart';
import 'package:houzi_package/models/realtor_model.dart';
import 'package:houzi_package/pages/home_page_screens/home_elegant_related/related_widgets/home_elegant_sliver_app_bar.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/all_agents.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/settings_page.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/phone_sign_in_widgets/user_get_phone_number.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_profile.dart';
import 'package:houzi_package/pages/map_view.dart';
import 'package:houzi_package/pages/property_details_related_pages/pd_widgets_listing.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';
import 'package:houzi_package/widgets/explore_by_type_design_widgets/explore_by_type_design.dart';
import 'package:houzi_package/widgets/generic_settings_row_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_drawer_widgets/home_screen_drawer_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_realtors_related_widgets/home_screen_realtors_list_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_sliver_app_bar_widgets/default_right_bar_widget.dart';

/// This file is deprecated. Use hooks_v2.dart file
class IconHooks {
  /// This file is deprecated. Use hooks_v2.dart file
  static getHeaderMap() {
    Map<String, dynamic> map = {
      // "secret_key": "!@#%^&*()_-+=",
      "secret_key": "",
    };
    return map;
  }
  /// This file is deprecated. Use hooks_v2.dart file
  static getPropertyDetailPageIconsMap() {
    Map<String, dynamic> _iconMap = {
      // "Air Conditioning": Icons.ac_unit_outlined,
    };

    return _iconMap;
  }
  /// This file is deprecated. Use hooks_v2.dart file
  static getElegantHomeTermsIconMap() {
    Map<String, dynamic> _iconMap = {
      // "for-rent": Icons.vpn_key_outlined,
    };

    return _iconMap;
  }
}

class CustomDrawerHooks {
  /// This file is deprecated. Use hooks_v2.dart file
  static getDrawerItems() {
    DrawerHook drawerHook = (BuildContext context) {
      DrawerItem drawerItem = DrawerItem(
        sectionType: "hook",
        title: "Agents",
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
        insertAt: 5,
      );

      List<dynamic> drawerItemList = [];

      return drawerItemList;
    };
    return drawerHook;
  }
}

class CustomFontsHooks {
  /// This file is deprecated. Use hooks_v2.dart file
  static getFontHook() {
    FontsHook fontsHook = (Locale locale) {
      // return "Ubuntu";
      // return "Qwitcher_Grypen";
      return "";
    };

    return fontsHook;
  }
}

class CustomItemDesignHooks {
  //provide your own design for property item
  /// This file is deprecated. Use hooks_v2.dart file
  static getPropertyItemHook() {
    PropertyItemHook propertyItemHook = (BuildContext context, Article article) {
      // return Container(
      //   child: Center(child: Text(article.title)),
      // );

      return null;
    };

    return propertyItemHook;
  }
  //provide your own design for term item design in the app
  /// This file is deprecated. Use hooks_v2.dart file
  static getTermItemHook() {
    TermItemHook termItemHook = (List metaDataList) {
      return null;
    };

    return termItemHook;
  }
  //provide your own designs for agent item design in the app.
  /// This file is deprecated. Use hooks_v2.dart file
  static getAgentItemHook() {
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
  //provide your own design for agency item
  /// This file is deprecated. Use hooks_v2.dart file
  static getAgencyItemHook() {
    AgencyItemHook agencyItemHook = (BuildContext context, Agency agency) {
      return null;
    };

    return agencyItemHook;
  }
}

class CustomWidgetHooks {
  //provide your own design for each section of the property page
  //you can use the provided details in Article (property)
  /// This file is deprecated. Use hooks_v2.dart file
  static getWidgetHook() {
    PropertyPageWidgetsHook detailsHook = (BuildContext context, Article article, String hook) {
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
        // return descriptionWidget(article);
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
      }
      return null;
    };

    return detailsHook;
  }
  //a sample widget for description in property details page.
  /// This file is deprecated. Use hooks_v2.dart file
  static Widget descriptionWidget(Article article) {
    if (article != null) {
      String content = article.content!;
      return content != null && content.isNotEmpty
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  content,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
              ),
            )
          : Container();
    } else {
      return Container();
    }
  }

// static Widget descriptionWidget(Article article) {
//     return Text(
//       article.content,
//       maxLines: 5,
//       overflow: TextOverflow.ellipsis,
//       textAlign: TextAlign.justify,
//     );
// }
}

class CustomLanguageHooks {
  //add new language
  /// This file is deprecated. Use hooks_v2.dart file
  static getLanguageCodeAndName() {
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

      Map<String,dynamic> yourLanguageMap = {
        "languageName": "YOUR-LANGUAGE-NAME", // Specify your language name
        "languageCode": "YOUR-LANGUAGE-CODE"  // Specify your language code
      };

      Map<String,dynamic> arabicLanguageMap = {
        "languageName": "Arabic",
        "languageCode": "ar"
      };

      Map<String,dynamic> frenchLanguageMap = {
        "languageName": "French",
        "languageCode": "fr"
      };

      Map<String,dynamic> urduLanguageMap = {
        "languageName": "Urdu",
        "languageCode": "ur"
      };

      Map<String,dynamic> russianLanguageMap = {
        "languageName": "Russian",
        "languageCode": "ru"
      };

      Map<String,dynamic> amhericLanguageMap = {
        "languageName": "Amheric",
        "languageCode": "am"
      };

      Map<String,dynamic> turkishLanguageMap = {
        "languageName": "Turkish",
        "languageCode": "tr"
      };

      Map<String,dynamic> spanishLanguageMap = {
        "languageName": "Spanish",
        "languageCode": "es"
      };

      List<dynamic> languageList = [
        arabicLanguageMap,
        frenchLanguageMap,
        urduLanguageMap,
        russianLanguageMap,
        amhericLanguageMap,
        turkishLanguageMap,
        spanishLanguageMap,
    ];

      return languageList;
    };

    return languageHook;
  }

}

class DefaultHook {
  /// This file is deprecated. Use hooks_v2.dart file
  static getDefaultLanguageHook() {
    DefaultLanguageCodeHook defaultLanguageCodeHook = () {
      /// Add here your default language code
      return "en";
    };

    return defaultLanguageCodeHook;
  }
  /// This file is deprecated. Use hooks_v2.dart file
  static getDefaultHomePageHook() {
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
  /// This file is deprecated. Use hooks_v2.dart file
  static getDefaultCountryCodeHook() {
    DefaultCountryCodeHook defaultCountryCodeHook = () {
      /// return 2 Letter ISO Code to make it default country code for phone login
      return "PK";
    };

    return defaultCountryCodeHook;

  }
}

class SettingsPageHook{
  /// This file is deprecated. Use hooks_v2.dart file
  static getSettingsItemHook(){
    SettingsHook settingsHook = (BuildContext context){
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

}

class ProfilePageHook{
  /// This file is deprecated. Use hooks_v2.dart file
  static getProfileItemHook(){
    ProfileHook profileHook = (BuildContext context){
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
}

class HomeRightBarButtonWidgetHookClass {
  /// This file is deprecated. Use hooks_v2.dart file
  static getHomeRightBarButtonWidgetHook() {
    HomeRightBarButtonWidgetHook homeRightBarButtonWidgetHook = (context) {
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
}

class MapViewHooks {
  /// This file is deprecated. Use hooks_v2.dart file
  static getMarkerTitleHook() {
    /// Set title to the marker in MapView
    /// Instance of Article/Property is provided. You can choose whatever the
    /// title you want to set, it can be property title, id, price or anything
    MarkerTitleHook markerTitleHook = (BuildContext context, Article article) {

      String markerTitle = article.title!;
      return markerTitle; // return title here (should be string type) 
    };

    return markerTitleHook;

  }
  /// This file is deprecated. Use hooks_v2.dart file
  static getMarkerIconHook() {
    /// For info about how to add custom marker go to
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
}

class CustomMethodsHook {
  /// If you want to format price in Property detail page or any other place,
  /// use this method. If you want to use Houzi pre define formatter than return null
  ///
  ///
  /// This file is deprecated. Use hooks_v2.dart file
  static getPriceFormatterHook() {
    PriceFormatterHook priceFormatterHook = (String propertyPrice, String firstPrice) {
      // Define your own method here and return the formatted string
      return null;
    };

    return priceFormatterHook;
  }
  /// This file is deprecated. Use hooks_v2.dart file
  static getCompactPriceFormatterHook() {
    /// If you want to format price on Property Card use this method.
    /// If you want to use Houzi pre define formatter than return null
    ///
    ///
    CompactPriceFormatterHook compactPriceFormatterHook = (String inputPrice) {
      // Define your own method here and return the formatted string
      return null;
    };

    return compactPriceFormatterHook;
  }
}
