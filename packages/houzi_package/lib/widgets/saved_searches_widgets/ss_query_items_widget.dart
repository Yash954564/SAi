import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';


class QueryTermsDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> queryDataMap;

  const QueryTermsDetailsWidget({
    Key? key,
    required this.queryDataMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SavedSearchQueryDataItemRowWidget(
          label: getLocationLabel(queryDataMap),
          iconData: AppThemePreferences.locationIcon,
        ),
        if (queryDataMap["query_status"] != null && queryDataMap["query_status"].isNotEmpty)
          Row(
            children: [
              SavedSearchQueryItemDotWidget(),
              SavedSearchQueryDataItemRowWidget(
                label: queryDataMap["query_status"],
                iconData: AppThemePreferences.checkCircleIcon,
              ),
            ],
          ),


        if ((queryDataMap["query_status"] == null || queryDataMap["query_status"].isEmpty) &&
            (queryDataMap["query_type"] != null && queryDataMap["query_type"].isNotEmpty))
          Row(
            children: [
              SavedSearchQueryItemDotWidget(),
              SavedSearchQueryDataItemRowWidget(
                label: queryDataMap["query_type"],
                iconData: AppThemePreferences.locationCityIcon,
              ),
            ],
          ),

        if ((queryDataMap["query_status"] == null || queryDataMap["query_status"].isEmpty) &&
            (queryDataMap["query_type"] == null || queryDataMap["query_type"].isEmpty))
          Row(
            children: [
              SavedSearchQueryItemDotWidget(),
              SavedSearchQueryDataItemRowWidget(
                label: "All",
                iconData: AppThemePreferences.checkCircleIcon,
              ),

              SavedSearchQueryItemDotWidget(),
              SavedSearchQueryDataItemRowWidget(
                label: "All",
                iconData: AppThemePreferences.locationCityIcon,
              ),
            ],
          ),
      ],
    );
  }

  String getLocationLabel(Map<String, dynamic> map) {
    String location = "All";
    String? city = map[CITY] is List ? map[CITY][0] : map[CITY] is String ? map[CITY] : null;
    String? area = map[PROPERTY_AREA] is List ? map[PROPERTY_AREA][0] : map[PROPERTY_AREA] is String ? map[PROPERTY_AREA] : null;
    String? state = map[PROPERTY_STATE] is List ? map[PROPERTY_STATE][0] : map[PROPERTY_STATE] is String ? map[PROPERTY_STATE] : null;
    String? country = map[PROPERTY_COUNTRY] is List ? map[PROPERTY_COUNTRY][0] : map[PROPERTY_COUNTRY] is String ? map[PROPERTY_COUNTRY] : null;

    if (area != null && area.isNotEmpty) {
      location = area;
    } else if (city != null && city.isNotEmpty) {
      location = city;
    } else if (state != null && state.isNotEmpty) {
      location = state;
    } else if (country != null && country.isNotEmpty) {
      location = country;
    }
    return location;
  }
}

class QueryFeaturesDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> queryDataMap;

  const QueryFeaturesDetailsWidget({
    Key? key,
    required this.queryDataMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 0.0,
      runSpacing: 8.0,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SavedSearchQueryDataItemRowWidget(
              label: getBedroomsLabel(),
              iconData: AppThemePreferences.bedIcon,
              iconPadding: const EdgeInsets.only(left: 2),
            ),
            Row(
              children: [
                SavedSearchQueryItemDotWidget(),
                SavedSearchQueryDataItemRowWidget(
                  label: getBathroomsLabel(),
                  iconData: AppThemePreferences.bathtubIcon,
                ),
                SavedSearchQueryItemDotWidget(),
                Row(
                  children: [
                    SavedSearchQueryDataItemRowWidget(
                      label: getMaxPriceLabel(),
                      iconData: AppThemePreferences.priceTagIcon,
                    ),
                    if (showMaxAreaWidget()) SavedSearchQueryItemDotWidget(),
                  ],
                ),
              ],
            ),
          ],
        ),
        if (showMaxAreaWidget())
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SavedSearchQueryDataItemRowWidget(
                label: getMaxAreaLabel(),
                iconData: AppThemePreferences.areaSizeIcon,
                iconPadding: const EdgeInsets.only(left: 0.5),
              ),
            ],
          ),
      ],
    );
  }

  String getBedroomsLabel() {

    if ( queryDataMap[BEDROOMS] != null ) {
      return queryDataMap[BEDROOMS].last;
    }

    else if ( queryDataMap[metaKeyFiltersKey] != null
        && queryDataMap[metaKeyFiltersKey] is Map
        && queryDataMap[metaKeyFiltersKey].isNotEmpty ) {

      // Get meta_key_filters map in variable:
      Map<String, dynamic> _metaKeyFiltersMap =
      Map<String, dynamic>.from(queryDataMap[metaKeyFiltersKey]);

      if ( _metaKeyFiltersMap[favPropertyBedroomsKey] is Map ) {

        List _bedroomsValuesList = [];
        Map _bedroomsMetaMap = _metaKeyFiltersMap[favPropertyBedroomsKey];

        if ( _bedroomsMetaMap[metaValueKey] is String ) {
          String _bedroomsValuesStr = _bedroomsMetaMap[metaValueKey];
          _bedroomsValuesList = _bedroomsValuesStr.split(",");
          return _bedroomsValuesList.last;
        }

        else if ( _bedroomsMetaMap[metaValueKey] is List ) {
          _bedroomsValuesList = _bedroomsMetaMap[metaValueKey];
          return _bedroomsValuesList.last;
        }
      }

    }

    return UtilityMethods.getLocalizedString("any");
  }

  String getBathroomsLabel() {

    if ( queryDataMap[BATHROOMS] != null ) {
      return queryDataMap[BATHROOMS].last;
    }

    else if ( queryDataMap[metaKeyFiltersKey] != null
        && queryDataMap[metaKeyFiltersKey] is Map
        && queryDataMap[metaKeyFiltersKey].isNotEmpty ) {

      // Get meta_key_filters map in variable:
      Map<String, dynamic> _metaKeyFiltersMap =
      Map<String, dynamic>.from(queryDataMap[metaKeyFiltersKey]);

      if ( _metaKeyFiltersMap[favPropertyBathroomsKey] is Map ) {

        List _bathroomsValuesList = [];
        Map _bathroomsMetaMap = _metaKeyFiltersMap[favPropertyBathroomsKey];

        if ( _bathroomsMetaMap[metaValueKey] is String ) {
          String _bedroomsValuesStr = _bathroomsMetaMap[metaValueKey];
          _bathroomsValuesList = _bedroomsValuesStr.split(",");
          return _bathroomsValuesList.last;
        }

        else if ( _bathroomsMetaMap[metaValueKey] is List ) {
          _bathroomsValuesList = _bathroomsMetaMap[metaValueKey];
          return _bathroomsValuesList.last;
        }
      }

    }

    return UtilityMethods.getLocalizedString("any");
  }

  String getMaxPriceLabel() {

    if ( queryDataMap[PRICE_MAX] != null
        && queryDataMap[PRICE_MAX].isNotEmpty ) {
      return UtilityMethods.makePriceCompact(queryDataMap[PRICE_MAX], "");
    }

    else if ( queryDataMap[metaKeyFiltersKey] != null
        && queryDataMap[metaKeyFiltersKey] is Map
        && queryDataMap[metaKeyFiltersKey].isNotEmpty ) {

      // Get meta_key_filters map in variable:
      Map<String, dynamic> _metaKeyFiltersMap =
      Map<String, dynamic>.from(queryDataMap[metaKeyFiltersKey]);

      if ( _metaKeyFiltersMap[favPropertyPriceKey] is Map ) {
        String _metaPriceValue = _metaKeyFiltersMap[favPropertyPriceKey][metaMaxValueKey];
        return UtilityMethods.makePriceCompact(_metaPriceValue, "");
      }

    }

    return UtilityMethods.getLocalizedString("any");
  }

  bool showMaxAreaWidget() {
    if ( queryDataMap[AREA_MAX] != null && queryDataMap[AREA_MAX].isNotEmpty ) {
      return true;
    }

    else if ( queryDataMap[metaKeyFiltersKey] != null
        && queryDataMap[metaKeyFiltersKey] is Map
        && queryDataMap[metaKeyFiltersKey].isNotEmpty ) {

      // Get meta_key_filters map in variable:
      Map<String, dynamic> _metaKeyFiltersMap =
      Map<String, dynamic>.from(queryDataMap[metaKeyFiltersKey]);

      if ( _metaKeyFiltersMap[favPropertySizeKey] is Map ) {
        return true;
      }
    }

    return false;
  }

  String getMaxAreaLabel() {

    if ( queryDataMap[AREA_MAX] != null && queryDataMap[AREA_MAX].isNotEmpty ) {
      return queryDataMap[AREA_MAX];
    }

    else if ( queryDataMap[metaKeyFiltersKey] != null
        && queryDataMap[metaKeyFiltersKey] is Map
        && queryDataMap[metaKeyFiltersKey].isNotEmpty ) {

      // Get meta_key_filters map in variable:
      Map<String, dynamic> _metaKeyFiltersMap =
      Map<String, dynamic>.from(queryDataMap[metaKeyFiltersKey]);

      if ( _metaKeyFiltersMap[favPropertySizeKey] is Map ) {
        String _metaSizeValue = _metaKeyFiltersMap[favPropertySizeKey][metaMaxValueKey];
        return _metaSizeValue;
      }
    }

    return "";
  }

}

class SavedSearchQueryDataItemRowWidget extends StatelessWidget {
  final String label;
  final IconData iconData;
  final EdgeInsetsGeometry? iconPadding;

  const SavedSearchQueryDataItemRowWidget({
    Key? key,
    required this.label,
    required this.iconData,
    this.iconPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconWidget(label, iconData, padding: iconPadding),
        LabelWidget(label),
      ],
    );
  }

  IconWidget(String value, IconData icon,{EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding,
      child: Icon(
        icon,
        size: 18,
        color: value == "All" || value == UtilityMethods.getLocalizedString("any")
            ? AppThemePreferences.savedSearchDefaultIconColor
            : null,
      ),
    );
  }

  LabelWidget(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GenericTextWidget(
        value,
        overflow: TextOverflow.clip,
        softWrap: true,
        style: AppThemePreferences().appTheme.subBody01TextStyle,
      ),
    );
  }

  DotWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Icon(
        AppThemePreferences.dotIcon,
        size: AppThemePreferences.dotIconSize,
        color: AppThemePreferences.savedSearchDefaultIconColor,
      ),
    );
  }
}

class SavedSearchQueryItemDotWidget extends StatelessWidget {
  const SavedSearchQueryItemDotWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Icon(
        AppThemePreferences.dotIcon,
        size: AppThemePreferences.dotIconSize,
        color: AppThemePreferences.savedSearchDefaultIconColor,
      ),
    );
  }
}
