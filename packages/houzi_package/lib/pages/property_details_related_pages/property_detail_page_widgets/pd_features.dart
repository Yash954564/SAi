import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/property_details_related_pages/features_list.dart';
import 'package:houzi_package/pages/property_details_related_pages/property_detail_page_widgets/pd_heading_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/staggeredGridWidget.dart';

class PropertyDetailPageFeatures extends StatefulWidget {
  final Article article;
  final String title;

  const PropertyDetailPageFeatures({
    required this.article,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageFeatures> createState() => _PropertyDetailPageFeaturesState();
}

class _PropertyDetailPageFeaturesState extends State<PropertyDetailPageFeatures> {

  Article? _article;

  final Map<String, dynamic> _iconMap = UtilityMethods.iconMap;

  List<String> featuresList = [];
  List<String> internalFeaturesList = [];
  List<String> externalFeaturesList = [];
  List<String> featuresWithoutValuesList = [];
  List<String> heatingAndCoolingFeaturesList = [];
  List<String> _withoutValuesFeaturesCheckList = [
    "Air Conditioning",
    "Broadband",
    "Gym",
    "Intercom",
    "Pay Tv",
    "Pool",
    "Security System",
    "Swimming Pool",
    "TV Cable",
    "WiFi",
    "Microwave",
    "Refrigerator",
    "Washer",
    "Elevator",
    "Sliding Doors",
    "Balcony",
    "Security",
    "Fitted Kitchen",
    "Guest Washroom",
    "Laundry",
    "Bar",
    "Fence",
    "Heat Extractor",
    "Stove",
    "Automated Gate",
    "Washing Machine",
    "Parking lot",
    "Lawn",
    "Window Coverings"
  ];

  @override
  void initState() {
    super.initState();
    _article = widget.article;

    List<String> iconMapsKeys = _iconMap.keys.toList();
    _withoutValuesFeaturesCheckList.addAll(iconMapsKeys);
    _withoutValuesFeaturesCheckList = _withoutValuesFeaturesCheckList.toSet().toList();

    loadData(_article!);
  }

  loadData(Article article) {
    // if (featuresList.isEmpty) {
    internalFeaturesList = article.internalFeaturesList ?? [];
    externalFeaturesList = article.externalFeaturesList ?? [];
    heatingAndCoolingFeaturesList = article.heatingAndCoolingFeaturesList ?? [];

    if (internalFeaturesList.isNotEmpty) {
      featuresList.addAll(internalFeaturesList);
    }
    if (externalFeaturesList.isNotEmpty) {
      featuresList.addAll(externalFeaturesList);
    }
    if (heatingAndCoolingFeaturesList.isNotEmpty) {
      featuresList.addAll(heatingAndCoolingFeaturesList);
    }

    featuresList.sort();

    if (featuresWithoutValuesList.isEmpty) {
      for (var element in _withoutValuesFeaturesCheckList) {
        if (internalFeaturesList.contains(element)) {
          featuresWithoutValuesList.add(element);
        }
      }
    }

    if(mounted)setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_article != widget.article) {
      _article = widget.article;
      loadData(_article!);
    }
    return featuresWidget(widget.title);
  }

  Widget featuresWidget(String title) {
    if (title == null || title.isEmpty) {
      title = UtilityMethods.getLocalizedString("features");
    }

    return featuresList == null || featuresList.isEmpty
        ? Container()
        : Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          textHeadingWidget(
            text: UtilityMethods.getLocalizedString(title),
            widget: showMoreFeaturesWidget(),
          ),
          featuresWithoutValuesList != null && featuresWithoutValuesList.isNotEmpty
              ? SizedBox(
            height: 110,
            child: CustomStaggeredGridWidget(
              crossAxisCount: min(5,featuresWithoutValuesList.length),
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              itemCount: min(5,featuresWithoutValuesList.length),
              itemBuilder: (context, index) {
                var item = featuresWithoutValuesList[index];
                String label = UtilityMethods.getLocalizedString(item);

                return Container(
                  // width: 70,
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CardWidget(
                        elevation: AppThemePreferences.zeroElevation,
                        shape: AppThemePreferences.roundedCorners(AppThemePreferences.propertyDetailFeaturesRoundedCornersRadius),
                        color: AppThemePreferences().appTheme.containerBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            _iconMap.containsKey(item)
                                ? _iconMap[item]
                                : Icons.error_outlined,
                            size: AppThemePreferences.propertyDetailsFeaturesIconSize,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: GenericTextWidget(
                          label,
                          strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
                          style: AppThemePreferences().appTheme.label01TextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
              staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              mainAxisSpacing: 3.0,
              crossAxisSpacing: 0.0,
            ),
          )
              : Container(
            padding: const EdgeInsets.only(bottom: 10),
          ),
        ],
      ),
    );
  }

  Widget showMoreFeaturesWidget() {
    return featuresList.length > 4
        ? Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeatureList(
                    featuresList: featuresList,
                  ),
                ),
              );
            },
            child: GenericTextWidget(
              UtilityMethods.getLocalizedString("show_more"),
              strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
              style: AppThemePreferences().appTheme.readMoreTextStyle,
            ),
          ),
        ),
      ],
    )
        : Container();
  }
}
