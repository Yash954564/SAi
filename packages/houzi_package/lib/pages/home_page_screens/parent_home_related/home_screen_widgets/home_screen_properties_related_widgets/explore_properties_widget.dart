import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/item_design_files/item_design_notifier.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/explore_by_type_design_widgets/explore_by_type_design.dart';
import 'package:provider/provider.dart';


typedef ExplorePropertiesWidgetListener = void Function({Map<String, dynamic>? filterDataMap});

class ExplorePropertiesWidget extends StatelessWidget {
  final List<dynamic> propertiesData;
  final ExplorePropertiesWidgetListener explorePropertiesWidgetListener;
  final String? design;
  final String? listingView;

  const ExplorePropertiesWidget({
    Key? key,
    required this.propertiesData,
    required this.explorePropertiesWidgetListener,
    this.design = DESIGN_01,
    this.listingView = homeScreenWidgetsListingCarouselView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Separate the List with Properties Data
    List<dynamic> _listOfPropertiesWithData = [];
    if(propertiesData != null && propertiesData.isNotEmpty) {
      if(propertiesData[0] is Term) {
        for (int i = 0; i < propertiesData.length; i++) {
          if (propertiesData[i].totalPropertiesCount > 0) {
            _listOfPropertiesWithData.add(propertiesData[i]);
          }
        }
      }
    }
    return _listOfPropertiesWithData == null || _listOfPropertiesWithData.isEmpty ? Container() : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        explorePropertiesList(
          context: context,
          design: design ?? DESIGN_01,
          listingView: listingView ?? homeScreenWidgetsListingCarouselView,
          propertiesData: _listOfPropertiesWithData,
          explorePropertiesListListener: ({filterDataMap}){
            explorePropertiesWidgetListener(filterDataMap: filterDataMap);
          },
        ),
      ],
    );
  }
}


Widget explorePropertiesList({
  String design = DESIGN_01,
  required BuildContext context,
  required List<dynamic> propertiesData,
  required final ExplorePropertiesWidgetListener explorePropertiesListListener,
  String listingView = homeScreenWidgetsListingCarouselView,
}){
  return Consumer<ItemDesignNotifier>(
    builder: (context, itemDesignNotifier, child){
      // String design = tag == EXPLORE_PROP_BY_CITY_TAG ? EXPLORE_PROPERTIES_BY_CITIES_DESIGN : itemDesignNotifier.exploreByTypeItemDesign;
      // String design = itemDesignNotifier.exploreByTypeItemDesign;
      // String design = design;
      ExploreByTypeDesign exploreByTypeDesign = ExploreByTypeDesign();

      return  SizedBox(
        height: design == DESIGN_02 && listingView == homeScreenWidgetsListingListView ? null : exploreByTypeDesign.getExploreByTypeDesignHeight(design: design),
        child: exploreByTypeDesign.getExploreByTypeDesign(
            listingView: listingView,
            design: design,
            buildContext: context,
            metaDataList: propertiesData,
            onTap: (String itemSlug, String itemTaxonomy){
              Map<String, dynamic> map = {};
              String? slugKey = getSearchMapSlugKey(itemTaxonomy);
              String? titleKey = getSearchMapTitleKey(itemTaxonomy);
              if(slugKey != null){
                map[slugKey] = [itemSlug];
              }
              String title = getTermTitle(itemTaxonomy, itemSlug);
              if(title != null && title.isNotEmpty){
                map[titleKey!] = [title];
              }
              // print("Map: $map");

              UtilityMethods.navigateToSearchResultScreen(
                context: context,
                searchRelatedData: map,
                navigateToSearchResultScreenListener: ({filterDataMap}){
                  explorePropertiesListListener(filterDataMap: HiveStorageManager.readFilterDataInfo() ?? {});
                },
              );
            }
        ),
      );
    },
  );
}

String getTermTitle(String dataType, String inputSlug){
  return UtilityMethods.getPropertyMetaDataItemNameWithSlug(dataType: dataType, slug: inputSlug) ?? "";
}



String? getSearchMapSlugKey(String dataType){
  if(dataType == propertyCityDataType){
    return CITY_SLUG;
  }
  if(dataType == propertyTypeDataType){
    return PROPERTY_TYPE_SLUG;
  }
  if(dataType == propertyLabelDataType){
    return PROPERTY_LABEL_SLUG;
  }
  if(dataType == propertyStatusDataType){
    return PROPERTY_STATUS_SLUG;
  }
  if(dataType == propertyAreaDataType){
    return PROPERTY_AREA_SLUG;
  }
  if(dataType == propertyFeatureDataType){
    return PROPERTY_FEATURES_SLUG;
  }
  if(dataType == propertyStateDataType){
    return PROPERTY_STATE_SLUG;
  }
  if(dataType == propertyCountryDataType){
    return PROPERTY_COUNTRY_SLUG;
  }

  return dataType;
}

String? getSearchMapTitleKey(String dataType){
  if(dataType == propertyCityDataType){
    return CITY;
  }
  if(dataType == propertyTypeDataType){
    return PROPERTY_TYPE;
  }
  if(dataType == propertyLabelDataType){
    return PROPERTY_LABEL;
  }
  if(dataType == propertyStatusDataType){
    return PROPERTY_STATUS;
  }
  if(dataType == propertyAreaDataType){
    return PROPERTY_AREA;
  }
  if(dataType == propertyFeatureDataType){
    return PROPERTY_FEATURES;
  }
  if(dataType == propertyStateDataType){
    return PROPERTY_STATE;
  }
  if(dataType == propertyCountryDataType){
    return PROPERTY_COUNTRY;
  }

  return dataType;
}