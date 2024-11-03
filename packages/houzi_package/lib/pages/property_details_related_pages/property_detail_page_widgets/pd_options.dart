import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/pages/property_details_related_pages/schedule_a_tour_page.dart';
import 'package:houzi_package/pages/property_details_related_pages/virtual_tour_page.dart';
import 'package:houzi_package/pages/send_email_to_realtor.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailPageOptions extends StatefulWidget {
  final Article article;
  final String title;
  final bool refreshWidget;
  final Map<String, dynamic> realtorInfoMap;
  final List<dynamic> realtorInfoList;

  const PropertyDetailPageOptions({
    required this.article,
    required this.title,
    this.refreshWidget = false,
    required this.realtorInfoMap,
    required this.realtorInfoList,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageOptions> createState() =>
      _PropertyDetailPageOptionsState();
}

class _PropertyDetailPageOptionsState extends State<PropertyDetailPageOptions> {
  Article? _article;
  int? tempRealtorId;
  String tempRealtorThumbnail = '';
  String tempRealtorEmail = '';
  String tempRealtorName = '';
  String tempRealtorPhone = "";
  String tempRealtorMobile = "";
  String tempRealtorWhatsApp = "";
  String tempRealtorLink = "";
  String agentDisplayOption = "";
  String articleYoutubeVideoLink = "";
  String articleVirtualTourLink = "";

  Map<String, dynamic> realtorInfoMap = {};
  List<dynamic> realtorInfoList = [];

  bool isAgent = false;
  bool isAgency = false;
  bool isAuthor = false;

  @override
  void initState() {
    super.initState();
    _article = widget.article;
    agentDisplayOption = _article!.propertyInfo!.agentDisplayOption!;
    if (agentDisplayOption == AGENCY_INFO) {
      isAgency = true;
    } else if (agentDisplayOption == AGENT_INFO) {
      isAgent = true;
    } else if (agentDisplayOption == AUTHOR_INFO) {
      isAuthor = true;
    }
    loadData(_article!);
  }

  loadData(Article article) {
    if (realtorInfoMap.isEmpty &&
        widget.realtorInfoMap != null &&
        widget.realtorInfoMap.isNotEmpty) {
      articleYoutubeVideoLink = article.video!;
      articleVirtualTourLink = article.virtualTourLink!;
      realtorInfoMap.addAll(widget.realtorInfoMap);
      tempRealtorId = realtorInfoMap[tempRealtorIdKey];
      tempRealtorName = realtorInfoMap[tempRealtorNameKey];
      tempRealtorEmail = realtorInfoMap[tempRealtorEmailKey];
      tempRealtorThumbnail = realtorInfoMap[tempRealtorThumbnailKey];
      tempRealtorPhone = realtorInfoMap[tempRealtorPhoneKey];
      tempRealtorMobile = realtorInfoMap[tempRealtorMobileKey];
      tempRealtorWhatsApp = realtorInfoMap[tempRealtorWhatsAppKey];
      tempRealtorLink = realtorInfoMap[tempRealtorLinkKey];
    } else if (realtorInfoList.isEmpty &&
        widget.realtorInfoList != null &&
        widget.realtorInfoList.isNotEmpty) {
      realtorInfoList.addAll(widget.realtorInfoList);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (realtorInfoList.isEmpty &&
        widget.realtorInfoMap != null &&
        widget.realtorInfoMap.isNotEmpty) {
      _article = widget.article;
      // realtorInfoMap.addAll(widget.realtorInfoMap);
      loadData(_article!);
    }
    return showButtonGridWidget();
  }

  Widget showButtonGridWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          Container(
            decoration: AppThemePreferences.dividerDecoration(top: true),
            child: getRowWidget(
              text: UtilityMethods.getLocalizedString("enquire_info"),
              onTap: navigateToInquireAboutProperty,
            ),
          ),
          Container(
            decoration: AppThemePreferences.dividerDecoration(
              top: true,
              bottom: articleYoutubeVideoLink == null ||
                      articleYoutubeVideoLink.isEmpty
                  ? true
                  : false,
            ),
            child: getRowWidget(
              text: UtilityMethods.getLocalizedString("setup_tour"),
              onTap: navigateToScheduleATour,
            ),
          ),
          articleYoutubeVideoLink != null && articleYoutubeVideoLink.isNotEmpty
              ? Container(
                  decoration: AppThemePreferences.dividerDecoration(
                    top: true,
                    bottom: articleVirtualTourLink == null ||
                            articleVirtualTourLink.isEmpty
                        ? true
                        : false,
                  ),
                  child: getRowWidget(
                    text: UtilityMethods.getLocalizedString("watch_video"),
                    onTap: navigateToYoutubeVideo,
                  ),
                )
              : Container(),
          articleVirtualTourLink != null && articleVirtualTourLink.isNotEmpty
              ? Container(
                  decoration: AppThemePreferences.dividerDecoration(
                      top: true, bottom: true),
                  child: getRowWidget(
                    text: UtilityMethods.getLocalizedString(
                        "virtual_tour_capital"),
                    onTap: navigateToVirtualTour,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget getRowWidget({required String text, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PropertyDetailPageHeaderWidget(
            text: text,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            textStyle: AppThemePreferences().appTheme.body01TextStyle!,
            // padding: const EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 5.0),
          ),
          PropertyDetailPageHeaderWidget(
            text: ">",
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            textStyle: AppThemePreferences().appTheme.body01TextStyle!,
            // padding: const EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 5.0),
          ),
        ],
      ),
    );
  }

  navigateToInquireAboutProperty() {
    if (realtorInfoMap == null || realtorInfoMap.isEmpty) {
      _showToastWhileDataLoading(
          context,
          UtilityMethods.getLocalizedString("please_wait_data_is_loading"),
          false);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SendEmailToRealtor(
            informationMap: {
              SEND_EMAIL_APP_BAR_TITLE:
                  UtilityMethods.getLocalizedString("enquire_information"),
              SEND_EMAIL_REALTOR_ID: tempRealtorId,
              SEND_EMAIL_REALTOR_NAME: tempRealtorName,
              SEND_EMAIL_REALTOR_EMAIL: tempRealtorEmail,
              SEND_EMAIL_REALTOR_TYPE: agentDisplayOption,
              SEND_EMAIL_MESSAGE: UtilityMethods.getLocalizedString(
                  "hello_i_am_interested_in",
                  inputWords: [
                    UtilityMethods.stripHtmlIfNeeded(_article!.title!),
                    _article!.title!,
                    tempRealtorLink
                  ]),
              SEND_EMAIL_THUMBNAIL: tempRealtorThumbnail,
              SEND_EMAIL_SITE_NAME: APP_NAME,
              SEND_EMAIL_LISTING_ID: _article!.id!,
              SEND_EMAIL_LISTING_NAME: _article!.title!,
              SEND_EMAIL_LISTING_LINK: _article!.link!,
              SEND_EMAIL_UNIQUE_ID: _article!.propertyInfo!.uniqueId!,
              SEND_EMAIL_SOURCE: PROPERTY,
            },
          ),
        ),
      );
    }
  }

  navigateToScheduleATour() {
    if (tempRealtorId == null ||
        tempRealtorEmail.isEmpty ||
        _article!.id == null) {
      _showToastWhileDataLoading(
          context,
          UtilityMethods.getLocalizedString("please_wait_data_is_loading"),
          false);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScheduleTour(
            agentId: tempRealtorId!,
            agentEmail: tempRealtorEmail,
            propertyId: _article!.id!,
            propertyTitle: UtilityMethods.stripHtmlIfNeeded(_article!.title!),
            propertyPermalink: _article!.link!,
          ),
        ),
      );
    }
  }

  navigateToYoutubeVideo() async {
    await canLaunchUrl(Uri.parse(articleYoutubeVideoLink))
        ? launchUrl(Uri.parse(articleYoutubeVideoLink))
        : print("URL can't be launched.");
  }
  
  navigateToVirtualTour() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VirtualTour(articleVirtualTourLink),
      ),
    );
  }

  _showToastWhileDataLoading(BuildContext context, String msg, bool forLogin) {
    !forLogin
        ? ShowToastWidget(
            buildContext: context,
            text: msg,
          )
        : ShowToastWidget(
            buildContext: context,
            showButton: true,
            buttonText: UtilityMethods.getLocalizedString("login"),
            text: msg,
            toastDuration: 4,
            onButtonPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserSignIn(
                    (String closeOption) {
                      if (closeOption == CLOSE) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              );
            },
          );
  }
}
