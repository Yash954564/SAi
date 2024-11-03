import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/property_details_related_pages/property_detail_page_widgets/pd_heading_widget.dart';
import 'package:houzi_package/pages/send_email_to_realtor.dart';

class PropertyDetailPageEnquireInfo extends StatefulWidget {
  final Article article;
  final String title;
  final Map<String, dynamic> realtorInfoMap;

  const PropertyDetailPageEnquireInfo({
    required this.article,
    required this.title,
    required this.realtorInfoMap,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageEnquireInfo> createState() =>
      _PropertyDetailPageEnquireInfoState();
}

class _PropertyDetailPageEnquireInfoState extends State<PropertyDetailPageEnquireInfo> {
  Article? _article;
  int? tempRealtorId;

  String title = "";
  String tempRealtorThumbnail = "";
  String tempRealtorEmail = "";
  String tempRealtorName = "";
  String tempRealtorPhone = "";
  String tempRealtorMobile = "";
  String tempRealtorWhatsApp = "";
  String tempRealtorLink = "";
  String agentDisplayOption = "";


  @override
  Widget build(BuildContext context) {
    _article = widget.article;
    tempRealtorId = widget.realtorInfoMap[tempRealtorIdKey];
    tempRealtorThumbnail = widget.realtorInfoMap[tempRealtorThumbnailKey] ?? "";
    tempRealtorEmail = widget.realtorInfoMap[tempRealtorEmailKey] ?? "";
    tempRealtorName = widget.realtorInfoMap[tempRealtorNameKey] ?? "";
    tempRealtorPhone = widget.realtorInfoMap[tempRealtorPhoneKey] ?? "";
    tempRealtorMobile = widget.realtorInfoMap[tempRealtorMobileKey] ?? "";
    tempRealtorWhatsApp = widget.realtorInfoMap[tempRealtorWhatsAppKey] ?? "";
    tempRealtorLink = widget.realtorInfoMap[tempRealtorLinkKey] ?? "";
    title = UtilityMethods.isValidString(widget.title) ? widget.title : "enquire_info";

    if(UtilityMethods.isValidString(tempRealtorEmail)){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: getRowWidget(
          text: UtilityMethods.getLocalizedString(title),
          onTap: ()=> navigateToInquireAboutProperty(),
        ),
      );
    }else{
      return Container();
    }
  }

  navigateToInquireAboutProperty(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SendEmailToRealtor(
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
                SEND_EMAIL_LISTING_ID: _article!.id,
                SEND_EMAIL_LISTING_NAME: _article!.title,
                SEND_EMAIL_LISTING_LINK: _article!.link,
                SEND_EMAIL_UNIQUE_ID: _article!.propertyInfo!.uniqueId!,
                SEND_EMAIL_SOURCE: PROPERTY,
              },
            ),
      ),
    );
  }
}
