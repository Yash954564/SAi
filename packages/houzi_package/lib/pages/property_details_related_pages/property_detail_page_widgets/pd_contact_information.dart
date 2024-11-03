import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/property_details_related_pages/property_detail_page_widgets/pd_heading_widget.dart';
import 'package:houzi_package/pages/realtor_information_page.dart';
import 'package:houzi_package/pages/send_email_to_realtor.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailPageContactInformation extends StatefulWidget {
  final Article article;
  final String title;
  final Map<String, dynamic> realtorInfoMap;
  final List<dynamic> realtorInfoList;

  const PropertyDetailPageContactInformation({
    required this.article,
    required this.title,
    required this.realtorInfoMap,
    required this.realtorInfoList,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageContactInformation> createState() => _PropertyDetailPageContactInformationState();
}

class _PropertyDetailPageContactInformationState extends State<PropertyDetailPageContactInformation> {

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

  Map<String, dynamic> realtorInfoMap = {};
  List<dynamic> realtorInfoList = [];

  bool isAgent = false;
  bool isAgency = false;
  bool isAuthor = false;

  @override
  void initState() {
    super.initState();
    _article = widget.article;
    agentDisplayOption = _article!.propertyInfo!.agentDisplayOption ?? "";
    if(agentDisplayOption.isNotEmpty) {
      if (agentDisplayOption == AGENCY_INFO) {
        isAgency = true;
      } else if (agentDisplayOption == AGENT_INFO) {
        isAgent = true;
      } else if (agentDisplayOption == AUTHOR_INFO) {
        isAuthor = true;
      }
    }

    loadData();
  }

  loadData() {
    if(realtorInfoMap.isEmpty && widget.realtorInfoMap.isNotEmpty) {
      realtorInfoMap.addAll(widget.realtorInfoMap);
      tempRealtorId = realtorInfoMap[tempRealtorIdKey];
      tempRealtorName = realtorInfoMap[tempRealtorNameKey] ?? "";
      tempRealtorEmail = realtorInfoMap[tempRealtorEmailKey] ?? "";
      tempRealtorThumbnail = realtorInfoMap[tempRealtorThumbnailKey] ?? "";
      tempRealtorPhone = realtorInfoMap[tempRealtorPhoneKey] ?? "";
      tempRealtorMobile = realtorInfoMap[tempRealtorMobileKey] ?? "";
      tempRealtorWhatsApp = realtorInfoMap[tempRealtorWhatsAppKey] ?? "";
      tempRealtorLink = realtorInfoMap[tempRealtorLinkKey] ?? "";

    }

    if (realtorInfoList.isEmpty && widget.realtorInfoList.isNotEmpty) {
        realtorInfoList.addAll(widget.realtorInfoList);
    }

    if(mounted)setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (realtorInfoList.isEmpty && widget.realtorInfoList.isNotEmpty) {
      loadData();
    }

    if (realtorInfoMap.isEmpty && widget.realtorInfoMap.isNotEmpty) {
      loadData();
    }

    if (agentDisplayOption == AUTHOR_INFO) {
      return realtorInfoMap.isEmpty
          ? Container()
          : authorContactInformationWidget(widget.title);
    } else {
      return realtorInfoList.isEmpty
          ? Container()
          : agentOrAgencyDisplayInformationWidget(widget.title);
    }
  }

  Widget authorContactInformationWidget(String title) {
    if (title == null || title.isEmpty) {
      title = UtilityMethods.getLocalizedString("contact_information");
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: Container(
        decoration: AppThemePreferences.dividerDecoration(bottom: true),
        child: Column(
          children: [
            textHeadingWidget(
              text: UtilityMethods.getLocalizedString(title),
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: commonContactInfoWidget(fromAuthor: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget agentOrAgencyDisplayInformationWidget(String title) {
    if (title == null || title.isEmpty) {
      title = UtilityMethods.getLocalizedString("contact_information");
    }

    return realtorInfoList.isEmpty ? Container() : Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: Container(
        decoration: AppThemePreferences.dividerDecoration(bottom: true),
        child: Column(
          children: <Widget>[
              textHeadingWidget(
                text: UtilityMethods.getLocalizedString(title),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: realtorInfoList.map((item) {
                    String heroId = "hero" + item.id.toString();
                    tempRealtorId = item.id;
                    tempRealtorName = item.title ?? "";
                    tempRealtorEmail = item.email ?? "";
                    tempRealtorThumbnail = item.thumbnail ?? "";
                    tempRealtorPhone = isAgent
                        ? item.agentOfficeNumber ?? ""
                        : item.agencyPhoneNumber ?? "";
                    tempRealtorMobile = isAgent
                        ? item.agentMobileNumber ?? ""
                        : item.agencyMobileNumber ?? "";
                    tempRealtorWhatsApp = isAgent
                        ? item.agentWhatsappNumber ?? ""
                        : item.agencyWhatsappNumber ?? "";
                    tempRealtorLink = isAgent
                        ? item.agentLink ?? ""
                        : item.agencyLink ?? "";
                    return commonContactInfoWidget(item: item,heroId: heroId);
                  }).toList(),
                ),
              ),
          ],
      ),
          ),
    );
  }

  Widget commonContactInfoWidget({item, bool fromAuthor = false,String heroId = "1"}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 100,
            width: 50,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Hero(
              tag: heroId,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  // borderRadius: BorderRadius.circular(AppThemePreferences.propertyDetailFeaturesRoundedCornersRadius),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  onTap: () {
                    navigateToRealtorInfoPage(
                      buildContext: context,
                      agentType: agentDisplayOption,
                      heroId: heroId,
                      realtorInfo: isAuthor ?  {
                        AUTHOR_DATA: realtorInfoMap,
                      } : isAgent
                          ? {
                        AGENT_DATA: item,
                      }
                          : {
                        AGENCY_DATA: item,
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child:FancyShimmerImage(
                        imageUrl: fromAuthor ? tempRealtorThumbnail : item.thumbnail,
                        boxFit: BoxFit.fill,
                        shimmerBaseColor:
                        AppThemePreferences()
                            .appTheme
                            .shimmerEffectBaseColor,
                        shimmerHighlightColor:
                        AppThemePreferences()
                            .appTheme
                            .shimmerEffectHighLightColor,
                        errorWidget: ShimmerEffectErrorWidget(
                            iconSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              navigateToRealtorInfoPage(
                buildContext: context,
                agentType: agentDisplayOption,
                heroId: heroId,
                realtorInfo: isAuthor ?  {
                  AUTHOR_DATA: realtorInfoMap,
                } : isAgent
                    ? {
                  AGENT_DATA: item,
                }
                    : {
                  AGENCY_DATA: item,
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(05, 10, 0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GenericTextWidget(
                    tempRealtorName,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.visible,
                    strutStyle: StrutStyle(
                        height: AppThemePreferences
                            .genericTextHeight),
                    style: AppThemePreferences().appTheme.labelTextStyle,
                    // style: AppThemePreferences().appTheme.body01TextStyle,
                  ),
                  GenericTextWidget(
                    getContactInfoDisplayName(),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.visible,
                    strutStyle: StrutStyle(
                        height: AppThemePreferences
                            .genericTextHeight),
                    style: AppThemePreferences()
                        .appTheme
                        .subTitle02TextStyle,
                    // style: AppThemePreferences().appTheme.body01TextStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        tempRealtorEmail.isEmpty ? Container() : Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(AppThemePreferences.propertyDetailFeaturesRoundedCornersRadius),
                  onTap: () {
                    // fromAuthor ? launch('mailto:$tempRealtorEmail'):
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SendEmailToRealtor(
                          informationMap: {
                            SEND_EMAIL_APP_BAR_TITLE:
                            UtilityMethods.getLocalizedString(
                                "enquire_information"),
                            SEND_EMAIL_REALTOR_ID: tempRealtorId,
                            SEND_EMAIL_REALTOR_NAME:
                            tempRealtorName,
                            SEND_EMAIL_REALTOR_EMAIL:
                            tempRealtorEmail,
                            SEND_EMAIL_REALTOR_TYPE:
                            agentDisplayOption,
                            SEND_EMAIL_MESSAGE:
                            UtilityMethods.getLocalizedString(
                                "hello_i_am_interested_in",
                                inputWords: [
                                  UtilityMethods.stripHtmlIfNeeded(_article!.title!), _article!.title,
                                  tempRealtorLink
                                ]),
                            SEND_EMAIL_THUMBNAIL:
                            tempRealtorThumbnail,
                            SEND_EMAIL_SITE_NAME: APP_NAME,
                            SEND_EMAIL_LISTING_ID: _article!.id,
                            SEND_EMAIL_LISTING_NAME: _article!.title,
                            SEND_EMAIL_LISTING_LINK: _article!.link,
                            SEND_EMAIL_UNIQUE_ID: _article!.propertyInfo!.uniqueId!,
                            SEND_EMAIL_SOURCE: PROPERTY,
                          },
                        ),
                      ),
                    );
                  },
                  child: CardWidget(
                    elevation: AppThemePreferences.zeroElevation,
                    // margin: EdgeInsets.zero,
                    shape: AppThemePreferences.roundedCorners(
                        AppThemePreferences.propertyDetailFeaturesRoundedCornersRadius),
                    color: AppThemePreferences()
                        .appTheme
                        .primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        AppThemePreferences.emailIcon,
                        color: Colors.white,
                        size: AppThemePreferences
                            .propertyDetailsFeaturesIconSize,
                      ),
                    ),
                  ),
                ),
                tempRealtorMobile.isEmpty
                    ? Container()
                    : Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppThemePreferences.propertyDetailFeaturesRoundedCornersRadius),
                    onTap: () {
                      launchUrl(Uri.parse("tel://$tempRealtorMobile"));
                    },
                    child: CardWidget(
                      elevation: AppThemePreferences.zeroElevation,
                      shape: AppThemePreferences
                          .roundedCorners(AppThemePreferences
                          .propertyDetailFeaturesRoundedCornersRadius),
                      color: AppThemePreferences
                          .callButtonBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          AppThemePreferences.phoneIcon,
                          color: Colors.white,
                          size: AppThemePreferences
                              .propertyDetailsFeaturesIconSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void navigateToRealtorInfoPage({required BuildContext buildContext,
    required String agentType,
    required String heroId,
    required Map<String, dynamic> realtorInfo}) {
    Navigator.push(
      buildContext,
      MaterialPageRoute(
        builder: (context) =>
            RealtorInformationDisplayPage(
              agentType: agentType,
              heroId: heroId,
              realtorInformation: realtorInfo,
            ),
      ),
    );
  }

  String getContactInfoDisplayName() {
    if (isAuthor) {
      return UtilityMethods.getLocalizedString("author");
    }
    else if (isAgency) {
      return UtilityMethods.getLocalizedString("agency");
    }
    else if (isAgent) {
      return UtilityMethods.getLocalizedString("agent");
    }
    else {
      return "";
    }
  }
}