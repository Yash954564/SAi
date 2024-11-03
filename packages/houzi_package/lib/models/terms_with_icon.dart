class TermsWithIcon {
  String? title;
  String? term;
  String? subTerm;
  String? icon;
  Map<String, dynamic>? searchRouteMap;

  TermsWithIcon({
    this.title,
    this.term,
    this.subTerm,
    this.icon,
    this.searchRouteMap,
  });

  factory TermsWithIcon.fromJson(Map<String, dynamic> json) => TermsWithIcon(
    title: json["title"],
    icon: json["icon_data"],
    term: json["term"],
    subTerm: json["sub_term"],
    searchRouteMap: json["search_route_map"] is Map<String, dynamic> ? json["search_route_map"] : {},
  );

  static Map<String, dynamic> toJson(TermsWithIcon item) => {
    "title": item.title,
    "term": item.term,
    "sub_term": item.subTerm,
    "icon_data": item.icon,
    "search_route_map": item.searchRouteMap,
  };

  static List<Map<String, dynamic>> encode(List<TermsWithIcon> itemsList) {
    return itemsList.map<Map<String, dynamic>>((item) =>
        TermsWithIcon.toJson(item)).toList();
  }

  static List<TermsWithIcon> decode(List<dynamic> encodedItemsList) {
    return (encodedItemsList).map<TermsWithIcon>((item) =>
        TermsWithIcon.fromJson(item)).toList();
  }
}