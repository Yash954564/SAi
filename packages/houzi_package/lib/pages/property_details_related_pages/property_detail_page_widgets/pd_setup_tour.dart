import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/property_details_related_pages/property_detail_page_widgets/pd_heading_widget.dart';
import 'package:houzi_package/pages/property_details_related_pages/schedule_a_tour_page.dart';

class PropertyDetailPageSetupTour extends StatefulWidget {
  final Article article;
  final String title;
  final Map<String, dynamic> realtorInfoMap;

  const PropertyDetailPageSetupTour({
    required this.article,
    required this.title,
    required this.realtorInfoMap,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageSetupTour> createState() => _PropertyDetailPageSetupTourState();
}

class _PropertyDetailPageSetupTourState extends State<PropertyDetailPageSetupTour> {
  Article? _article;
  int? tempRealtorId;
  String title = "";
  String tempRealtorEmail = "";


  @override
  Widget build(BuildContext context) {
    _article = widget.article;
    tempRealtorId = widget.realtorInfoMap[tempRealtorIdKey];
    tempRealtorEmail = widget.realtorInfoMap[tempRealtorEmailKey] ?? "";
    title = UtilityMethods.isValidString(widget.title) ? widget.title : "setup_tour";

    if(UtilityMethods.isValidString(tempRealtorEmail)){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: getRowWidget(
          text: UtilityMethods.getLocalizedString(title),
          onTap: () => navigateToScheduleATour(),
        ),
      );
    }else{
      return Container();
    }
  }

  navigateToScheduleATour() {
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
