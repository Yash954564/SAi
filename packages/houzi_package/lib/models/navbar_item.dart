class NavbarItem{
  String? sectionType;
  String? title;
  String? url;
  bool? checkLogin;
  List<String>? subTypeList;
  List<String>? subTypeValuesList;
  Map<String, dynamic>? searchApiMap;
  String? iconDataJson;

  NavbarItem({
    this.sectionType,
    this.title,
    this.url,
    this.checkLogin = false,
    this.subTypeList,
    this.subTypeValuesList,
    this.searchApiMap,
    this.iconDataJson,
  });

  factory NavbarItem.fromJson(Map<String, dynamic> json) {
    return NavbarItem(
      sectionType: json["section_type"],
      title: json["title"],
      url: json["url"],
      checkLogin: json["check_login"],
      subTypeList: json["sub_type_list"] is List ? List<String>.from(json["sub_type_list"]) : null,
      subTypeValuesList: json["sub_type_value_list"] is List ? List<String>.from(json["sub_type_value_list"]) : null,
      iconDataJson: json["icon_data"],
      searchApiMap: json["search_api_map"] is Map<String, dynamic> 
          ? json["search_api_map"] : {},
    );
  }

  static Map<String, dynamic> toJson(NavbarItem navbarItem) => {
    'section_type': navbarItem.sectionType,
    'title': navbarItem.title,
    'url': navbarItem.url,
    'check_login': navbarItem.checkLogin,
    'sub_type_list': navbarItem.subTypeList,
    'sub_type_value_list': navbarItem.subTypeValuesList,
    "search_api_map": navbarItem.searchApiMap,
    "icon_data": navbarItem.iconDataJson,
  };

  static List<Map<String, dynamic>> encode(List<dynamic> navbarItemsList) {
    return navbarItemsList.map<Map<String, dynamic>>((item) =>
        NavbarItem.toJson(item)).toList();
  }

  static List<NavbarItem> decode(List<dynamic> navbarItemsJsonList) {
    // List<NavbarItem> dataList =  (navbarItemsJsonList).map<NavbarItem>((item) =>
    //     NavbarItem.fromJson(item)).toList();
    // return dataList;
    return (navbarItemsJsonList).map<NavbarItem>((item) =>
        NavbarItem.fromJson(item)).toList();
  }
}