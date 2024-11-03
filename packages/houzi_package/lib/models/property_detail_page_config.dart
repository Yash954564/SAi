// To parse this JSON data, do
//
//     final propertyDetailPageLayout = propertyDetailPageLayoutFromJson(jsonString);

import 'dart:convert';

PropertyDetailPageLayout propertyDetailPageLayoutFromJson(String str) => PropertyDetailPageLayout.fromJson(json.decode(str));

String propertyDetailPageLayoutToJson(PropertyDetailPageLayout data) => json.encode(data.toJson());

class PropertyDetailPageLayout {
  PropertyDetailPageLayout({
    this.propertyDetailPageLayout,
  });

  List<PropertyDetailPageLayoutElement>? propertyDetailPageLayout;

  factory PropertyDetailPageLayout.fromJson(Map<String, dynamic> json) => PropertyDetailPageLayout(
    propertyDetailPageLayout: List<PropertyDetailPageLayoutElement>.from(json["property_detail_page_layout"].map((x) => PropertyDetailPageLayoutElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "property_detail_page_layout": List<dynamic>.from(propertyDetailPageLayout!.map((x) => x.toJson())),
  };
}

class PropertyDetailPageLayoutElement {
  PropertyDetailPageLayoutElement({
    this.widgetType,
    this.widgetTitle,
    this.widgetEnable,
    this.widgetViewType,
  });

  String? widgetType;
  String? widgetTitle;
  bool? widgetEnable;
  String? widgetViewType;

  factory PropertyDetailPageLayoutElement.fromJson(Map<String, dynamic> json) => PropertyDetailPageLayoutElement(
    widgetType: json["widget_type"],
    widgetTitle: json["widget_title"],
    widgetEnable: json["widget_enable"],
    widgetViewType: json["widget_view_type"],
  );

  Map<String, dynamic> toJson() => {
    "widget_type": widgetType,
    "widget_title": widgetTitle,
    "widget_enable": widgetEnable,
    "widget_view_type": widgetViewType,
  };
}
