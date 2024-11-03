import 'dart:convert';

import 'package:houzi_package/models/terms_with_icon.dart';

HomeConfig homeConfigFromJson(String str) => HomeConfig.fromJson(json.decode(str));

String homeConfigToJson(HomeConfig data) => json.encode(data.toJson());

class HomeConfig {
  HomeConfig({
    this.homeLayout,
  });

  List<HomeLayout>? homeLayout;

  factory HomeConfig.fromJson(Map<String, dynamic> json) => HomeConfig(
    homeLayout: List<HomeLayout>.from(json["home_layout"].map((x) => HomeLayout.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "home_layout": List<dynamic>.from(homeLayout!.map((x) => x.toJson())),
  };
}

class HomeLayout {

  String? sectionType;
  String? title;
  String? layoutDesign;
  String? subType;
  String? subTypeValue;
  String? sectionListingView;
  bool? showFeatured;
  bool? showNearby;
  List<dynamic>? subTypeList;
  List<dynamic>? subTypeValuesList;
  Map<String, dynamic>? searchApiMap;
  Map<String, dynamic>? searchRouteMap;
  List<TermsWithIcon>? termsWithIconLayout;

  HomeLayout({
    this.sectionType,
    this.title,
    this.layoutDesign,
    this.subType,
    this.subTypeValue,
    this.sectionListingView,
    this.showFeatured = false,
    this.showNearby = false,
    this.subTypeList,
    this.subTypeValuesList,
    this.searchApiMap,
    this.searchRouteMap,
    this.termsWithIconLayout,
  });

  factory HomeLayout.fromJson(Map<String, dynamic> json) => HomeLayout(
    sectionType: json["section_type"],
    title: json["title"],
    layoutDesign: json["layout_design"],
    subType: json["sub_type"],
    subTypeValue: json["sub_type_value"],
    sectionListingView: json["section_listing_view"],
    showFeatured: json["show_featured"] ?? false,
    showNearby: json["show_nearby"] ?? false,
    subTypeList: json["sub_type_list"],
    subTypeValuesList: json["sub_type_value_list"],
    searchApiMap: json["search_api_map"] is Map<String, dynamic> ? json["search_api_map"] : {},
    searchRouteMap: json["search_route_map"] is Map<String, dynamic> ? json["search_route_map"] : {},
    termsWithIconLayout: json["terms_with_icon_layout"] == null
        ? [] : TermsWithIcon.decode(json["terms_with_icon_layout"]),
  );

  Map<String, dynamic> toJson() => {
    "section_type": sectionType,
    "title": title,
    "layout_design": layoutDesign,
    "sub_type": subType,
    "sub_type_value": subTypeValue,
    "section_listing_view": sectionListingView,
    "show_featured": showFeatured,
    "show_nearby": showNearby,
    "sub_type_list": subTypeList,
    "sub_type_value_list": subTypeValuesList,
    "search_api_map": searchApiMap,
    "search_route_map": searchRouteMap,
    "terms_with_icon_layout":termsWithIconLayout == null ? []
        : TermsWithIcon.encode(termsWithIconLayout!),
  };
}
