import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class PropertyDetailPageValuedFeatured extends StatefulWidget {
  final Article article;

  const PropertyDetailPageValuedFeatured({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  State<PropertyDetailPageValuedFeatured> createState() => _PropertyDetailPageValuedFeaturedState();
}

class _PropertyDetailPageValuedFeaturedState extends State<PropertyDetailPageValuedFeatured> {
  Map<String, String> articleDetailsMap = {};
  Map<String, String> _mapOfFeaturesWithValues = {};
  Map<String, dynamic> _iconMap = UtilityMethods.iconMap;

  @override
  void initState() {
    super.initState();

    articleDetailsMap = widget.article.propertyDetailsMap ?? {};

    if(articleDetailsMap.isNotEmpty){
      _iconMap.forEach((key, value) {
        if (articleDetailsMap.containsKey(key)) {
          _mapOfFeaturesWithValues[key] = articleDetailsMap[key]!;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return valuedFeaturesWidget();
  }

  Widget valuedFeaturesWidget() {
    return _mapOfFeaturesWithValues.isEmpty ? Container()
        : Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(
                UtilityMethods.isRTL(context) ? 0 : 16,
                0, UtilityMethods.isRTL(context) ? 16 : 0, 0,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _mapOfFeaturesWithValues.length,
              itemBuilder: (context, index) {
                var key = _mapOfFeaturesWithValues.keys.elementAt(index);
                var value = _mapOfFeaturesWithValues[key];
                String label = UtilityMethods.getLocalizedString(key);
                return SingleValueFeatureWidget(
                    index: index,
                    itemKey: key,
                    value: value ?? "",
                    label: label,
                    iconMap: _iconMap,
                    article: widget.article,
                );
              },
            ),
          );
  }
}

class SingleValueFeatureWidget extends StatelessWidget {
  final int index;
  final String itemKey;
  final String value;
  final String label;
  final Map<String, dynamic> iconMap;
  final Article article;

  const SingleValueFeatureWidget({
    super.key,
    required this.index,
    required this.itemKey,
    required this.value,
    required this.label,
    required this.iconMap,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: index == 0 ? 0 : 5),
      child: CardWidget(
        elevation: AppThemePreferences.zeroElevation,
        shape: AppThemePreferences.roundedCorners(
            AppThemePreferences.propertyDetailPageRoundedCornersRadius),
        color: AppThemePreferences().appTheme.containerBackgroundColor,
        // padding: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconMap.containsKey(itemKey)
                    ? iconMap[itemKey]
                    : AppThemePreferences.errorIcon,
                size: AppThemePreferences.propertyDetailsValuedFeaturesIconSize,
              ),
              Container(
                padding: const EdgeInsets.only(top: 0, left: 5),
                child: GenericTextWidget(
                  value,
                  textAlign: TextAlign.center,
                  strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
                  style: AppThemePreferences().appTheme.label01TextStyle,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 0, left: 5),
                child: GenericTextWidget(
                  getLabel(),
                  textAlign: TextAlign.center,
                  strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
                  style: AppThemePreferences().appTheme.label01TextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getLabel() {
    if (itemKey == PROPERTY_DETAILS_PROPERTY_SIZE) {
      if (UtilityMethods.isValidString(article.features!.propertyAreaUnit)) {
        return "${article.features!.propertyAreaUnit}";
      } else {
        return MEASUREMENT_UNIT_TEXT;
      }
    }
    return label;
  }
}

