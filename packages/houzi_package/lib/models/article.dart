import '../common/constants.dart';
import '../files/generic_methods/utility_methods.dart';
import 'floor_plans.dart';
import 'realtor_model.dart';

class Address {
  String? suburb;
  String? subNumber;
  String? street;
  String? streetNumber;
  String? state;
  String? postalCode;
  String? display;
  String? country;
  String? coordinates;
  // Newly Added Item/Items for Houzez
  String? area;
  String? city;
  String? address;
  String? lat;
  String? long;
  bool? hasCoordinates;
  double? latitude;
  double? longitude;

  Address({
    this.suburb,
    this.subNumber,
    this.street,
    this.streetNumber,
    this.state,
    this.postalCode,
    this.country,
    this.display,
    this.coordinates,
    // Newly Added Item/Items for Houzez
    this.city,
    this.area,
    this.address,
    this.lat,
    this.long,

  });
  List<double>? getCoordinates() {
    if(hasCoordinates != null && !hasCoordinates!) {
      return null;
    }
    if (hasCoordinates != null && hasCoordinates!) {
      return [latitude!, longitude!];
    }
    //we never attempted to parse coordinates. lets try now
    if (hasCoordinates == null) {
      String? address = null;
      if (lat != null && lat!.isNotEmpty && long != null && long!.isNotEmpty) {
        // latitude = double.parse(lat);
        // longitude = double.parse(long);
        // hasCoordinates = true;
        // return [latitude, longitude];
        address = lat!+","+long!;
      } else {
        //we couldn't find coordinates in separate vars, try in coordinates variable.
        address = coordinates.toString();
      }

      //we assume valid coordinates consist of lat being -90.0 to 90.0 and long being -180.0 to 180.0, having at least one decimal point
      RegExp coordinateRegex = RegExp(r'^[-+]?([1-8]?\d(\.\d+)|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+))$');

      if ((address.isNotEmpty) && (coordinateRegex.hasMatch(address)) ) {
        var temp = address.split(",");
        latitude = double.parse(temp[0]);
        longitude = double.parse(temp[1]);
        hasCoordinates = true;
        return [latitude!, longitude!];
      }

    }
    hasCoordinates = false;
    return null;
  }

}

class Features {
  String? airConditioning;
  String? bathrooms;
  String? bedrooms;
  String? buildingArea;
  String? buildingAreaUnit;
  String? carport;
  String? energyRating;
  String? ensuite;
  String? garage;
  String? propertyArea;
  String? propertyAreaUnit;
  String? landArea;
  String? landAreaUnit;
  String? landFullyFenced;
  String? newConstruction;
  String? openSpaces;
  String? pool;
  String? rooms;
  String? securitySystem;
  String? toilet;
  String? yearBuilt;
  String? viewsOnProperty;
  // Newly Added Item/Items for Houzez
  List<String>? featuresList = [];
  List<String>? imagesIdList = [];
  String? garageSize;
  List<dynamic>? floorPlansList;
  List<dynamic>? additionalDetailsList = [];
  List<dynamic>? multiUnitsList;
  String? multiUnitsListingIDs;
  List<dynamic>? propertyStatusList = [];
  List<dynamic>? propertyTypeList = [];
  List<dynamic>? propertyLabelList = [];
  List<Attachment>? attachments = [];

  Features({
    this.bedrooms,
    this.bathrooms,
    this.toilet,
    this.ensuite,
    this.garage,
    this.carport,
    this.openSpaces,
    this.rooms,
    this.propertyArea,
    this.propertyAreaUnit,
    this.landArea,
    this.landAreaUnit,
    this.buildingArea,
    this.buildingAreaUnit,
    this.landFullyFenced,
    this.energyRating,
    this.yearBuilt,
    this.newConstruction,
    this.pool,
    this.airConditioning,
    this.securitySystem,

    // Newly Added Item/Items for Houzez
    this.featuresList,
    this.garageSize,
    this.floorPlansList,
    this.imagesIdList,
    this.additionalDetailsList,
    this.multiUnitsList,
    this.multiUnitsListingIDs,
    this.propertyLabelList,
    this.propertyStatusList,
    this.propertyTypeList,
    this.attachments,
    this.viewsOnProperty,
  });

}

class PropertyInfo {
  // static const String LISTING_SALE = "SALE";
  // static const String LISTING_RENT = "RENT";
  // static const String LISTING_LEASE = "LEASE";
  // String listingType = LISTING_SALE;


  String? heading;
  String? category;
  String? uniqueId;
  String? modDate;
  String? listDate;
  String? imagesModDate;
  String? floorplanModDate;
  String? owner;
  String? officeId;
  String? agentHideAuthorBox;
  String? addressHideMap;
  String? price;
  String? priceView;
  String? priceGlobal;
  String? priceDisplay;
  String? priceCurrency;
  String? currency;
  String? status;
  String? inspectionTimes;
  String? auction;
  String? authority;
  String? soldPrice;
  String? soldDate;
  String? soldPriceDisplay;
  String? underOffer;
  String? isHomeLandPackage;
  String? featured;
  String? agent;
  String? secondAgent;

  // Newly Added Item/Items for Rent Property
  String? rent;
  String? rentDisplay;


  // Newly Added Item/Items for Houzez
  String? propertyType;
  String? propertyStatus;
  String? propertyLabel;
  String? pricePostfix;
  String? firstPrice;
  String? secondPrice;
  String? propertyVirtualTourLink;
  String? agentDisplayOption;
  Map<String, dynamic>? agentInfo;
  List<String>? agentList;
  List<String>? agencyList;
  bool? isFeatured;
  String? houzezTotalRating = "";

  String? availability;
  String? subCity;
  String? placeName;
  String? cartaTitleDeed;
  String? woreda = "";
  String? paymentStatus = "";
  String? pricePrefix = "";
  List<dynamic>? securityFeatureList;
  Map<String, String>?  customFieldsMap = {};
  Map<String, dynamic>?  customFieldsMapForEditing = {};
  bool requiredLogin;
  String? privateNote;
  String? disclaimer;
  bool? showPricePlaceholder;
  String? pricePlaceholder;

  PropertyInfo({
    this.heading,
    this.category,
    this.uniqueId,
    this.modDate,
    this.listDate,
    this.imagesModDate,
    this.floorplanModDate,
    this.owner,
    this.officeId,
    this.agentHideAuthorBox,
    this.addressHideMap,
    this.price,
    this.priceView,
    this.priceGlobal,
    this.priceDisplay,
    this.priceCurrency,
    this.status,
    this.inspectionTimes,
    this.auction,
    this.authority,
    this.soldPrice,
    this.soldDate,
    this.soldPriceDisplay,
    this.underOffer,
    this.isHomeLandPackage,
    this.featured,
    this.agent,
    this.secondAgent,

    // Newly Added Item/Items for Rent Property
    this.rent,
    this.rentDisplay,

    // Newly Added Item/Items for Houzez
    this.propertyType,
    this.propertyStatus,
    this.propertyLabel,
    this.pricePostfix,
    this.firstPrice,
    this.secondPrice,
    this.propertyVirtualTourLink,
    this.agentInfo,
    this.agencyList,
    this.agentDisplayOption,
    this.agentList,
    this.isFeatured,
    this.houzezTotalRating,
    this.currency,

    this.availability,
    this.subCity,
    this.placeName,
    this.cartaTitleDeed,
    this.woreda,
    this.securityFeatureList,
    this.customFieldsMap,
    this.customFieldsMapForEditing,
    this.paymentStatus,
    this.requiredLogin = false,

    this.privateNote,
    this.disclaimer,
    this.pricePrefix,
    this.showPricePlaceholder,
    this.pricePlaceholder,
  });


// Map<String, dynamic> toJson(){
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['heading'] = this.heading;
//   data['category'] = this.category;
//   data['unique_id'] = this.uniqueId;
//   data['mod_date'] = this.modDate;
//   data['list_date'] = this.listDate;
//   data['images_mod_date'] = this.imagesModDate;
//   data['floorplan_mod_date'] = this.floorplanModDate;
//   data['owner'] = this.owner;
//   data['office_id'] = this.officeId;
//   data['agent_hide_author_box'] = this.agentHideAuthorBox;
//   data['address_hide_map'] = this.addressHideMap;
//   data['property_price'] = this.price;
//   data['price_view'] = this.priceView;
//   data['price_global'] = this.priceGlobal;
//   data['property_price_display'] = this.priceDisplay;
//   data['price_currency'] = this.priceCurrency;
//   data['status'] = this.status;
//   data['inspection_times'] = this.inspectionTimes;
//   data['auction'] = this.auction;
//   data['authority'] = this.authority;
//   data['sold_price'] = this.soldPrice;
//   data['sold_date'] = this.soldDate;
//   data['sold_price_display'] = this.soldPriceDisplay;
//   data['under_offer'] = this.underOffer;
//   data['is_home_land_package'] = this.isHomeLandPackage;
//   data['featured'] = this.featured;
//   data['agent'] = this.agent;
//   data['second_agent'] = this.secondAgent;
//   return data;
// }
}

class MembershipPlanDetails {
  String? vcPostSettings;
  String? billingTimeUnit;
  String? billingUnit;
  String? packageListings;
  String? unlimitedListings;
  String? packageFeaturedListings;
  String? packagePrice;
  String? packageStripeId;
  String? packageVisible;
  String? packagePopular;
  String? unlimitedImages;
  String? editLock;
  String? editLast;
  String? androidIAPProductId;
  String? iosIAPProductId;
  String? rsPageBgColor;

  MembershipPlanDetails({
    this.vcPostSettings,
    this.billingTimeUnit,
    this.billingUnit,
    this.packageListings,
    this.unlimitedListings,
    this.packageFeaturedListings,
    this.packagePrice,
    this.packageStripeId,
    this.packageVisible,
    this.packagePopular,
    this.unlimitedImages,
    this.editLock,
    this.editLast,
    this.androidIAPProductId,
    this.iosIAPProductId,
    this.rsPageBgColor,
  });


  factory MembershipPlanDetails.fromJson(Map<String, dynamic> json) {
    return MembershipPlanDetails(
      vcPostSettings: json['_vc_post_settings'] ?? "",
      billingTimeUnit: json['fave_billing_time_unit'] ?? "",
      billingUnit: json['fave_billing_unit'] ?? "",
      packageListings: json['fave_package_listings'] ?? "",
      unlimitedListings: json['fave_unlimited_listings'] ?? "0",
      packageFeaturedListings: json['fave_package_featured_listings'] ?? "",
      packagePrice: json['fave_package_price'] ?? "",
      packageStripeId: json['fave_package_stripe_id'] ?? "",
      packageVisible: json['fave_package_visible'] ?? "",
      packagePopular: json['fave_package_popular'] ?? "",
      unlimitedImages: json['fave_unlimited_images'] ?? "",
      editLock: json['_edit_lock'] ?? "",
      editLast: json['_edit_last'] ?? "",
      androidIAPProductId: json['android_iap_product_id'] ?? "",
      iosIAPProductId: json['ios_iap_product_id'] ?? "",
      rsPageBgColor: json['rs_page_bg_color'] ?? "",
    );
  }
}

class Article {
  final int? id;
  final String? title;
  final String? content;
  final String? type;
  String? image;
  final String? video;
  final int? author;
  final String? avatar;
  final String? category;
  final String? date;
  final String? dateGMT;
  final String? link;
  final String? guid;
  final int? featuredImageId;
  String? status;
  final int? catId;
  final bool? isFav;
  final String? reviewPostType;
  final String? reviewStars;
  final String? reviewBy;
  final String? reviewTo;
  final String? reviewPropertyId;
  final String? modifiedDate;
  final String? modifiedGmt;
  Map<String, dynamic>? realtorInfoMap = {};

  // final String reviewLikes;
  // final String reviewDislikes;

  // Newly Added Item/Items for Houzez
  List<String>? imageList = [];
  String? virtualTourLink;

  PropertyInfo? propertyInfo;
  Address? propertyAddress;
  Features? propertyFeatures;

  Map<String, dynamic>? otherFeatures = {};

  PropertyInfo? info;
  Address? address;
  Features? features;
  MembershipPlanDetails? membershipPlanDetails;
  List<String>? internalFeaturesList = [];
  List<String>? externalFeaturesList = [];
  List<String>? heatingAndCoolingFeaturesList = [];
  Map<String, String>? propertyDetailsMap = <String, String>{};
  Author? authorInfo;

  String? userDisplayName = "";
  String? userName = "";
  String? description = "";

  Map<String, dynamic>? avatarUrls = {};

  String? _compactPrice;
  String? _compactFirstPrice;
  String? _compactSecondPrice;
  String? _compactPriceForMap;
  String? _formattedFullPrice;

  Article({
    this.reviewPostType,
    this.reviewStars,
    this.reviewBy,
    this.reviewTo,
    this.reviewPropertyId,
    // this.reviewLikes,
    // this.reviewDislikes,
    this.id,
    this.title,
    this.type,
    this.content,
    this.image,
    this.video,
    this.author,
    this.avatar,
    this.category,
    this.date,
    this.dateGMT,
    this.link,
    this.catId,
    // Newly Added Item/Items for Houzez
    this.imageList,
    this.virtualTourLink,
    this.status,
    this.isFav,
    this.guid,
    this.featuredImageId,
    this.modifiedDate,
    this.modifiedGmt,
    this.userDisplayName,
    this.userName,
    this.avatarUrls,
    this.description,
    this.realtorInfoMap,
  });

  factory Article.fromDatabaseJson(Map<String, dynamic> data) {
    return Article(
        id: data['id'],
        title: data['title'],
        content: data['content'],
        image: data['image'],
        video: data['video'],
        author: data['author'],
        avatar: data['avatar'],
        category: data['category'],
        date: data['date'],
        link: data['link'],
        catId: data["catId"]);
  }

  Map<String, dynamic> toDatabaseJson() => {
    'id': this.id,
    'title': this.title,
    'content': this.content,
    'image': this.image,
    'video': this.video,
    'author': this.author,
    'avatar': this.avatar,
    'category': this.category,
    'date': this.date,
    'link': this.link,
    'catId': this.catId
  };

  String getFormattedAddress(){
    String? propAddress = '';
    if(address!.display == "yes"){
      if(address!.subNumber!.isNotEmpty){
        propAddress = propAddress + address!.subNumber!;
      }
      if(address!.street!.isNotEmpty){
        propAddress = propAddress + " " +  address!.street!;
      }
      if(address!.streetNumber!.isNotEmpty){
        propAddress = propAddress + " " +  address!.streetNumber!;
      }
      if(address!.suburb!.isNotEmpty){
        propAddress = propAddress + ", " + address!.suburb!;
      }
      if(address!.state!.isNotEmpty){
        propAddress = propAddress + " " + address!.state!;
      }
      if(address!.postalCode!.isNotEmpty){
        propAddress = propAddress + " " + address!.postalCode!;
      }
      return propAddress;
    } else {
      return propAddress;
    }

  }

  String getCompactPrice() {
    if (_compactPrice != null) {
      return _compactPrice!;
    }
    String _propertyPrice = "";
    if (propertyDetailsMap!.containsKey(PRICE)) {
      String tempPrice = propertyDetailsMap![PRICE]!;
      if (tempPrice != null && tempPrice.isNotEmpty) {
        _propertyPrice = UtilityMethods.makePriceCompact(tempPrice, propertyInfo!.pricePrefix ?? "");
      }
    }
    _compactPrice = _propertyPrice;
    return _propertyPrice;
  }

  String getCompactFirstPrice() {
    if (_compactFirstPrice != null) {
      return _compactFirstPrice!;
    }
    String _propertyFirstPrice = "";
    if (propertyDetailsMap!.containsKey(FIRST_PRICE)) {
      String tempPrice = propertyDetailsMap![FIRST_PRICE]!;
      if (tempPrice != null && tempPrice.isNotEmpty) {
        _propertyFirstPrice = UtilityMethods.makePriceCompact(tempPrice, propertyInfo!.pricePrefix ?? "");
      }
    }
    _compactFirstPrice = _propertyFirstPrice;
    return _propertyFirstPrice;
  }

  String getCompactSecondPrice() {
    if (_compactSecondPrice != null) {
      return _compactSecondPrice!;
    }
    String _secondPrice = "";
    if(propertyDetailsMap!.containsKey(SECOND_PRICE)){
      String tempPrice = propertyDetailsMap![SECOND_PRICE]!;
      if(tempPrice != null && tempPrice.isNotEmpty){
        _secondPrice = UtilityMethods.makePriceCompact(tempPrice, propertyInfo!.pricePrefix ?? "");
      }
    }
    _compactSecondPrice = _secondPrice;
    return _secondPrice;
  }

  String getCompactPriceForMap() {
    if (_compactPriceForMap != null) {
      return _compactSecondPrice!;
    }

    String _firstPrice = "";
    String _propertyPrice = "";
    if(propertyDetailsMap!.containsKey(FIRST_PRICE)){
      _firstPrice = propertyDetailsMap![FIRST_PRICE]!;
    }
    if(propertyDetailsMap!.containsKey(PRICE)){
      _propertyPrice = propertyDetailsMap![PRICE]!;
    }

    String tempPrice = (_firstPrice.isNotEmpty) ? _firstPrice : _propertyPrice;
    if(tempPrice.isNotEmpty){
      tempPrice = UtilityMethods.makePriceCompact(tempPrice, propertyInfo!.pricePrefix ?? "", priceOnly: true);
    }
    _compactSecondPrice = tempPrice;
    return tempPrice;
  }

  String getListingPrice() {
    if (_formattedFullPrice != null) {
      return _formattedFullPrice!;
    }
    String _firstPrice = "";
    String _propertyPrice = "";
    if(propertyDetailsMap!.containsKey(FIRST_PRICE)){
      _firstPrice = propertyDetailsMap![FIRST_PRICE]!;
    }
    if(propertyDetailsMap!.containsKey(PRICE)){
      _propertyPrice = propertyDetailsMap![PRICE]!;
    }
    String tempPrice = UtilityMethods.priceFormatter(_propertyPrice, _firstPrice, propertyInfo!.pricePrefix ?? "");
    _formattedFullPrice = tempPrice;
    return tempPrice;
  }

}