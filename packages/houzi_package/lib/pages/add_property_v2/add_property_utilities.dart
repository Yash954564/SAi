import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/article.dart';

class AddPropertyUtilities {
  
  static Map<String, dynamic> convertArticleToMapForEditing(Article article) {
    Map<String, dynamic> _convertedArticle = {};

    List<dynamic> propertyTypesList = HiveStorageManager.readPropertyTypesMetaData() ?? [];
    List<dynamic> propertyLabelList = HiveStorageManager.readPropertyLabelsMetaData() ?? [];
    List<dynamic> propertyStatusList = HiveStorageManager.readPropertyStatusMetaData() ?? [];
    List<dynamic> propertyFeaturesList = HiveStorageManager.readPropertyFeaturesMetaData() ?? [];

    int intPropertyType;
    int intPropertyStatus;
    int intPropertyLabel;
    String featuredImageId = "${article.featuredImageId}";
    String propertyType = article.propertyInfo!.propertyType ?? "";
    String propertyStatus = article.propertyInfo!.propertyStatus ?? "";
    String propertyLabel = article.propertyInfo!.propertyLabel ?? "";
    String propertyFirstPrice = article.propertyInfo!.firstPrice ?? "";
    String propertyPrice = article.propertyInfo!.price ?? "";
    String propertyBuildingAreaUnit = article.features!.buildingAreaUnit ?? "";
    String propertyAddress = article.address!.address ?? "";
    String propertyCountry = article.address!.country ?? "";
    String propertyState = article.address!.state ?? "";
    String propertyCity = article.address!.city ?? "";
    String propertyArea = article.address!.area ?? "";
    String propertyPostalCode = article.address!.postalCode ?? "";
    String propertyLat = article.address!.lat ?? "";
    String propertyLong = article.address!.long ?? "";
    String multiUnitsListingIDs = article.features!.multiUnitsListingIDs ?? "";
    Map<String, dynamic> propertyCustomFieldsMap = article.propertyInfo!.customFieldsMapForEditing ?? {};
    List<dynamic> propertyFeaturesListFromArticle = article.features!.featuresList ?? [];
    List<dynamic> propertyImagesIdList = article.features!.imagesIdList ?? [];
    List<dynamic> floorPlansList = article.features!.floorPlansList ?? [];
    List<dynamic> additionalDetailsList = article.features!.additionalDetailsList ?? [];
    List<dynamic> multiUnitsList = article.features!.multiUnitsList ?? [];
    bool isFeatured = article.propertyInfo!.isFeatured ?? false;
    bool isLoginRequired = article.propertyInfo!.requiredLogin;
    String isFeaturedStr = isFeatured ? "1" : "0";
    String isLoginRequiredStr = isLoginRequired ? "1" : "0";

    int comparedValueForType = getIDS(propertyTypesList, propertyType);
    int comparedValueForLabel = getIDS(propertyLabelList, propertyLabel);
    int comparedValueForStatus = getIDS(propertyStatusList, propertyStatus);
    var listOfFeatures = UtilityMethods.getIdsForFeatures(propertyFeaturesList, propertyFeaturesListFromArticle);
    intPropertyType = comparedValueForType;
    intPropertyLabel = comparedValueForLabel;
    intPropertyStatus = comparedValueForStatus;

    if (propertyPrice == "") {
      propertyPrice = propertyFirstPrice;
    }
    String featuredImageIndex = "0";
    for (int i = 0; i < propertyImagesIdList.length; i++) {

      if (featuredImageId == propertyImagesIdList[i]) {
        featuredImageIndex = "$i";
      }
    }

    _convertedArticle = {
      ADD_PROPERTY_ACTION: ADD_PROPERTY_ACTION_UPDATE,
      ADD_PROPERTY_USER_HAS_NO_MEMBERSHIP: 'no',
      //ADD_PROPERTY_CURRENCY : '\$',
      //ADD_PROPERTY_MULTI_UNITS : '${0}',
      ADD_PROPERTY_FLOOR_PLANS_ENABLE: '0',
      ADD_PROPERTY_TITLE: article.title ?? "",
      ADD_PROPERTY_DESCRIPTION: UtilityMethods.stripHtmlIfNeeded(article.content ?? ""),
      ADD_PROPERTY_TYPE: [intPropertyType],
      ADD_PROPERTY_STATUS: [intPropertyStatus],
      ADD_PROPERTY_LABELS: [intPropertyLabel],
      ADD_PROPERTY_TYPE_NAMES_LIST: [propertyType],
      ADD_PROPERTY_LABEL_NAMES_LIST: [propertyLabel],
      ADD_PROPERTY_STATUS_NAMES_LIST: [propertyStatus],
      ADD_PROPERTY_PRICE: propertyPrice,
      ADD_PROPERTY_PRICE_POSTFIX: article.propertyInfo!.pricePostfix ?? "",
      ADD_PROPERTY_PRICE_PREFIX: '',
      //ADD_PROPERTY_PRICE_PREFIX : 'prop_price_prefix',
      ADD_PROPERTY_SECOND_PRICE: article.propertyInfo!.secondPrice ?? "",
      ADD_PROPERTY_VIDEO_URL: article.video ?? "",
      ADD_PROPERTY_BEDROOMS: article.features!.bedrooms ?? "",
      ADD_PROPERTY_BATHROOMS: article.features!.bathrooms ?? "",
      ADD_PROPERTY_SIZE: article.features!.propertyArea ?? "",
      ADD_PROPERTY_SIZE_PREFIX: article.features!.propertyAreaUnit ?? "",
      ADD_PROPERTY_LAND_AREA: article.features!.landArea ?? "",
      ADD_PROPERTY_LAND_AREA_PREFIX: article.features!.landAreaUnit ?? "",
      ADD_PROPERTY_GARAGE: article.features!.garage ?? "",
      ADD_PROPERTY_GARAGE_SIZE: article.features!.garageSize ?? "",
      ADD_PROPERTY_YEAR_BUILT: article.features!.yearBuilt ?? "",
      ADD_PROPERTY_FEATURES_LIST: listOfFeatures,
      ADD_PROPERTY_VIRTUAL_TOUR: article.propertyInfo!.propertyVirtualTourLink ?? "",
      ADD_PROPERTY_FAVE_PROPERTY_MAP: '',
      ADD_PROPERTY_FLOOR_PLANS: getFloorPlansList(floorPlansList),
      ADD_PROPERTY_ADDITIONAL_FEATURES: getAdditionalDetailsList(additionalDetailsList),
      ADD_PROPERTY_FAVE_MULTI_UNITS: getMultiUnitsList(multiUnitsList),
      // ADD_PROPERTY_FAVE_PROPERTY_MAP: 'fave_property_map',
      UPDATE_PROPERTY_IMAGES: article.imageList ?? [],
      // ADD_PROPERTY_PROPERTY_ID: 'property_id',
      ADD_PROPERTY_IMAGE_IDS: propertyImagesIdList,
      ADD_PROPERTY_FEATURED_IMAGE_ID: featuredImageId,
      ADD_PROPERTY_FEATURED_IMAGE_LOCAL_INDEX: featuredImageIndex,
      ADD_PROPERTY_FAVE_AGENT_DISPLAY_OPTION: article.propertyInfo!.agentDisplayOption ?? "",
      ADD_PROPERTY_FAVE_AGENT: article.propertyInfo!.agentList ?? [],
      ADD_PROPERTY_FAVE_AGENCY: article.propertyInfo!.agencyList ?? [],
      ADD_PROPERTY_PROPERTY_FEATURED: isFeaturedStr,
      ADD_PROPERTY_LOGGED_IN_REQUIRED: isLoginRequiredStr,
      ADD_PROPERTY_PRIVATE_NOTE: article.propertyInfo!.privateNote,
      ADD_PROPERTY_SHOW_PRICE_PLACEHOLDER: article.propertyInfo!.showPricePlaceholder == true ? 'on' : '0',
      ADD_PROPERTY_PRICE_PLACEHOLDER: article.propertyInfo!.pricePlaceholder ?? "",
      // ADD_PROPERTY_MAKE_PROPERTY_FEATURED: isFeaturedStr,
      // ADD_PROPERTY_USER_LOGGED_IN_TO_VIEW: isLoginRequiredStr,
    };

    if (propertyAddress.isNotEmpty) {
      _convertedArticle[ADD_PROPERTY_MAP_ADDRESS] = propertyAddress;
    }
    if (SHOW_COUNTRY_NAME_FIELD && propertyCountry.isNotEmpty) {
      _convertedArticle[ADD_PROPERTY_COUNTRY] = propertyCountry;
    }
    if (SHOW_STATE_COUNTY_FIELD && propertyState.isNotEmpty) {
      _convertedArticle[ADD_PROPERTY_STATE_OR_COUNTY] = propertyState;
    }
    if (SHOW_LOCALITY_FIELD && propertyCity.isNotEmpty) {
      _convertedArticle[ADD_PROPERTY_CITY] = propertyCity;
    }
    if (SHOW_NEIGHBOURHOOD_FIELD && propertyArea.isNotEmpty) {
      _convertedArticle[ADD_PROPERTY_AREA] = propertyArea;
    }
    if (propertyPostalCode.isNotEmpty) {
      _convertedArticle[ADD_PROPERTY_POSTAL_CODE] = propertyPostalCode;
    }
    if (propertyLat.isNotEmpty) {
      _convertedArticle[ADD_PROPERTY_LATITUDE] = propertyLat;
    }
    if (propertyLong.isNotEmpty) {
      _convertedArticle[ADD_PROPERTY_LONGITUDE] = propertyLong;
    }
    if (multiUnitsListingIDs.isNotEmpty) {
      _convertedArticle[ADD_PROPERTY_FAVE_MULTI_UNITS_IDS] = multiUnitsListingIDs;
    }

    if (propertyCustomFieldsMap.isNotEmpty) {
      propertyCustomFieldsMap.forEach((key, value) {
        Map<String,dynamic> map = {key:value};
        _convertedArticle.addAll(map);
      });
    }
    
    return _convertedArticle;
  }

  static int getIDS(List<dynamic>? inputList, String? inputString) {
    int itemId = -1;
    if (inputList == null || inputList.isEmpty || inputString == null) {
      return -1;
    } else {
      for (int i = 0; i < inputList.length; i++) {
        if (inputString == inputList[i].name) {
          itemId = inputList[i].id;
        }
      }
      return itemId;
    }
  }

  static List<Map<String, dynamic>> getFloorPlansList(List<dynamic> list){
    if(list != null && list.isNotEmpty){
      List<Map<String, dynamic>> floorPlanList = [];
      for(var floorPlanElement in list){
        floorPlanList.add({
          favePlanTitle : floorPlanElement.title,
          favePlanRooms : floorPlanElement.rooms,
          favePlanBathrooms : floorPlanElement.bathrooms,
          favePlanPrice : floorPlanElement.price,
          favePlanPricePostFix : floorPlanElement.pricePostFix,
          favePlanSize : floorPlanElement.size,
          favePlanImage : floorPlanElement.image,
          favePlanDescription : floorPlanElement.description,
        });
      }
      return floorPlanList;
    }

    return [];
  }

  static List<Map<String, dynamic>> getAdditionalDetailsList(List<dynamic> list){
    if(list != null && list.isNotEmpty){
      List<Map<String, dynamic>> additionalDetailsList = [];
      for(var additionalDetailElement in list){
        additionalDetailsList.add({
          faveAdditionalFeatureTitle : additionalDetailElement.title,
          faveAdditionalFeatureValue : additionalDetailElement.value,
        });
      }
      return additionalDetailsList;
    }

    return [];
  }

  static List<Map<String, dynamic>> getMultiUnitsList(List<dynamic> list){
    if(list != null && list.isNotEmpty){
      List<Map<String, dynamic>> multiUnitsList = [];
      for(var multiUnitsElement in list){
        multiUnitsList.add({
          faveMUTitle : multiUnitsElement.title,
          faveMUBeds : multiUnitsElement.bedrooms,
          faveMUBaths : multiUnitsElement.bathrooms,
          faveMUPrice : multiUnitsElement.price,
          faveMUPricePostfix : multiUnitsElement.pricePostfix,
          faveMUSizePostfix : multiUnitsElement.sizePostfix,
          faveMUSize : multiUnitsElement.size,
          faveMUType : multiUnitsElement.type,
          faveMUAvailabilityDate : multiUnitsElement.availabilityDate,
        });
      }
      return multiUnitsList;
    }

    return [];
  }
}