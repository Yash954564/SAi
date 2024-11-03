class SortFirstByItem {
  String? sectionType;
  String? title;
  String? defaultValue;
  String? icon;
  String? term;
  String? subTerm;

  SortFirstByItem({
    this.sectionType,
    this.title,
    this.defaultValue,
    this.icon,
    this.term,
    this.subTerm,
  });

  factory SortFirstByItem.fromJson(Map<String, dynamic> json) => SortFirstByItem(
    sectionType: json["section_type"],
    title: json["title"],
    defaultValue: json["default_value"],
    icon: json["icon_data"],
    term: json["term"],
    subTerm: json["sub_term"],
  );

  static Map<String, dynamic> toJson(SortFirstByItem item) => {
    "section_type": item.sectionType,
    "title": item.title,
    "default_value": item.defaultValue,
    "icon_data": item.icon,
    "term": item.term,
    "sub_term": item.subTerm,
  };

  static List<Map<String, dynamic>> encode(List<dynamic> itemsList) {
    return itemsList.map<Map<String, dynamic>>((item) =>
        SortFirstByItem.toJson(item)).toList();
  }

  static List<SortFirstByItem> decode(List<dynamic> encodedItemsList) {
    return (encodedItemsList).map<SortFirstByItem>((item) =>
        SortFirstByItem.fromJson(item)).toList();
  }
}