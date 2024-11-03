import 'dart:convert';

class BlogDetailsPageLayout {
  List<BlogDetailPageLayout>? blogDetailPageLayout;

  BlogDetailsPageLayout({
    this.blogDetailPageLayout,
  });

  factory BlogDetailsPageLayout.fromRawJson(String str) => BlogDetailsPageLayout.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogDetailsPageLayout.fromJson(Map<String, dynamic> json) => BlogDetailsPageLayout(
    blogDetailPageLayout: json["blog_detail_page_layout"] == null ? [] : List<BlogDetailPageLayout>.from(json["blog_detail_page_layout"]!.map((x) => BlogDetailPageLayout.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "blog_detail_page_layout": blogDetailPageLayout == null ? [] : List<dynamic>.from(blogDetailPageLayout!.map((x) => x.toJson())),
  };
}

class BlogDetailPageLayout {
  String? widgetType;
  String? widgetTitle;
  bool? widgetEnable;
  String? widgetViewType;

  BlogDetailPageLayout({
    this.widgetType,
    this.widgetTitle,
    this.widgetEnable,
    this.widgetViewType,
  });

  factory BlogDetailPageLayout.fromRawJson(String str) => BlogDetailPageLayout.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogDetailPageLayout.fromJson(Map<String, dynamic> json) => BlogDetailPageLayout(
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