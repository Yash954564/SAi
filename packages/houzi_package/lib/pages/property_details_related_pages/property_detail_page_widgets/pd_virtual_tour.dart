import 'package:flutter/material.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/property_details_related_pages/property_detail_page_widgets/pd_heading_widget.dart';
import 'package:houzi_package/pages/property_details_related_pages/virtual_tour_page.dart';

class PropertyDetailPageVirtualTour extends StatefulWidget {
  final Article article;
  final String title;

  const PropertyDetailPageVirtualTour({
    required this.article,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageVirtualTour> createState() =>
      _PropertyDetailPageVirtualTourState();
}

class _PropertyDetailPageVirtualTourState
    extends State<PropertyDetailPageVirtualTour> {
  Article? _article;
  String articleVirtualTourLink = "";

  loadData(Article article) {
    articleVirtualTourLink = article.virtualTourLink ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_article != widget.article) {
      _article = widget.article;
      loadData(_article!);
    }
    return virtualTourWidget(widget.title);
  }

  Widget virtualTourWidget(String title) {
    if (title.isEmpty) {
      title = "virtual_tour_capital";
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: articleVirtualTourLink.isNotEmpty
          ? getRowWidget(
              text: UtilityMethods.getLocalizedString(title),
              onTap: navigateToVirtualTour,
            )
          : Container(),
    );
  }

  navigateToVirtualTour() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VirtualTour(articleVirtualTourLink),
      ),
    );
  }
}
