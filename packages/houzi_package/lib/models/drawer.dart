// To parse this JSON data, do
//
//     final drawerLayoutConfig = drawerLayoutConfigFromJson(jsonString);

import 'dart:convert';

DrawerLayoutConfig drawerLayoutConfigFromJson(String str) => DrawerLayoutConfig.fromJson(json.decode(str));

String drawerLayoutConfigToJson(DrawerLayoutConfig data) => json.encode(data.toJson());

class DrawerLayoutConfig {
  DrawerLayoutConfig({
    this.drawerLayout,
  });

  List<DrawerLayout>? drawerLayout;

  factory DrawerLayoutConfig.fromJson(Map<String, dynamic> json) => DrawerLayoutConfig(
    drawerLayout: List<DrawerLayout>.from(json["drawer_layout"].map((x) => DrawerLayout.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "drawer_layout": List<dynamic>.from(drawerLayout!.map((x) => x.toJson())),
  };
}

class DrawerLayout {
  DrawerLayout({
    this.sectionType,
    this.title,
    this.checkLogin,
    this.enable,
    this.expansionTileChildren,
    this.dataMap,
  });

  String? sectionType;
  String? title;
  bool? checkLogin;
  bool? enable;
  List<ExpansionTileChild>? expansionTileChildren;
  Map<String, dynamic>? dataMap;

  factory DrawerLayout.fromJson(Map<String, dynamic> json) => DrawerLayout(
    sectionType: json["section_type"],
    title: json["title"],
    checkLogin: json["check_login"],
    enable: json["enable"],
    expansionTileChildren: json["expansion_tile_children"] == null ? null : List<ExpansionTileChild>.from(json["expansion_tile_children"].map((x) => ExpansionTileChild.fromJson(x))),
    dataMap: json["data_map"],
  );

  Map<String, dynamic> toJson() => {
    "section_type": sectionType,
    "title": title,
    "check_login": checkLogin,
    "enable": enable,
    "expansion_tile_children": expansionTileChildren == null ? null : List<dynamic>.from(expansionTileChildren!.map((x) => x.toJson())),
    "data_map" : dataMap,
  };
}

class ExpansionTileChild {
  ExpansionTileChild({
    this.sectionType,
    this.title,
    this.checkLogin,
  });

  String? sectionType;
  String? title;
  bool? checkLogin;

  factory ExpansionTileChild.fromJson(Map<String, dynamic> json) => ExpansionTileChild(
    sectionType: json["section_type"],
    title: json["title"],
    checkLogin: json["check_login"],
  );

  Map<String, dynamic> toJson() => {
    "section_type": sectionType,
    "title": title,
    "check_login": checkLogin,
  };
}
