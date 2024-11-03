import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/generic_link_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/text_span_widgets/text_span_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AboutState();

}

class AboutState extends State<About> {

  String _appVersion = '';
  String _appName = '';

  @override
  void initState() {
    super.initState();
    _appVersion = HiveStorageManager.readAppInfo()[APP_INFO_APP_VERSION] ?? "";
    _appName = HiveStorageManager.readAppInfo()[APP_NAME] ?? APP_NAME;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("about"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textAppName(),
                textVersionInfoWidget(),
                textAllRightReservedWidget(),
                textTermsAndConditions(),
              ],
            ),
        ),
      ),
    );
  }

  Widget textAppName(){
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: GenericTextWidget(
        _appName,
        style: AppThemePreferences().appTheme.aboutPageHeadingTextStyle,

      ),
    );
  }

  Widget textVersionInfoWidget(){
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericTextWidget(UtilityMethods.getLocalizedString("version_text"), style: AppThemePreferences().appTheme.subTitle02TextStyle),
          GenericTextWidget(
            _appVersion.isNotEmpty ? _appVersion : "000.0.0.00.001",
            style: AppThemePreferences().appTheme.bodyTextStyle,
          ),
        ],
      ),
    );
  }
  Widget textAllRightReservedWidget(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: RichText(
        text: GenericLinkTextSpanWidget(
          text: _appName,
          children: [
            GenericNormalTextSpanWidget(text: " ${UtilityMethods.getLocalizedString("about_app_description_text01")} "),
            GenericLinkTextSpanWidget(text: _appName),
            GenericNormalTextSpanWidget(text: " ${UtilityMethods.getLocalizedString("about_app_description_text02")} "),
            GenericLinkTextSpanWidget(
              text: COMPANY_NAME,
              onTap: () => _launchCompanyUrl(),
            ),
            GenericNormalTextSpanWidget(text: " ${UtilityMethods.getLocalizedString("about_app_description_text03")}"),
          ],
        ),
      )
    );
  }


  void _launchCompanyUrl() async {
    var url = COMPANY_URL;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (kDebugMode) {
        print('Could not launch $url');
      }
    }
  }

  Widget textTermsAndConditions(){
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GenericLinkWidget(
        linkText: UtilityMethods.getLocalizedString("terms_and_conditions"),//AppLocalizations.of(context).terms_and_conditions,
        onLinkPressed: (){
          UtilityMethods.navigateToRoute(
            context: context,
            builder: (context) => WebPage(APP_TERMS_URL, UtilityMethods.getLocalizedString("terms_and_conditions")),
          );
        },
      ),
    );
  }
}