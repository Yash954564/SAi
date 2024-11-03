class FilterPageElement {
  String? sectionType;
  String? title;
  String? dataType;
  String? apiValue;
  String? pickerType;
  bool? showSearchByCity;
  bool? showSearchByLocation;
  String? minValue;
  String? maxValue;
  String? divisions;
  String? options;
  String? pickerSubType;
  String? uniqueKey;
  String? queryType;
  String? defaultRadius;
  List<String>? locationPickerHierarchyList;

  FilterPageElement({
    this.sectionType,
    this.title,
    this.dataType,
    this.apiValue,
    this.pickerType,
    this.showSearchByCity = true,
    this.showSearchByLocation = true,
    this.minValue = "0",
    this.maxValue = "1000000",
    this.divisions = "1000",
    this.options,
    this.pickerSubType,
    this.uniqueKey,
    this.queryType,
    this.defaultRadius = "50",
    this.locationPickerHierarchyList,
  });

  factory FilterPageElement.fromJson(Map<String, dynamic> json) => FilterPageElement(
    sectionType: json["section_type"],
    title: json["title"],
    dataType: json["data_type"],
    apiValue: json["api_value"],
    pickerType: json["picker_type"],
    showSearchByCity: json["show_search_by_city"],
    showSearchByLocation: json["show_search_by_location"],
    minValue: json["min_range_value"],
    maxValue: json["max_range_value"],
    pickerSubType: json["picker_sub_type"],
    divisions: json["div_range_value"] ?? "1000",
    options: json["options"],
    uniqueKey: json["unique_key"],
    queryType: json["query_type"],
    defaultRadius: json["default_radius"],
    locationPickerHierarchyList: json["location_hierarchy_list"] == null
            ? []
            : List<String>.from(
                json["location_hierarchy_list"]!.map((x) => x)),
      );

  static Map<String, dynamic> toMap(FilterPageElement filterPageElement) => {
    "section_type": filterPageElement.sectionType,
    "title": filterPageElement.title,
    "data_type": filterPageElement.dataType,
    "api_value": filterPageElement.apiValue,
    "picker_type": filterPageElement.pickerType,
    "show_search_by_city": filterPageElement.showSearchByCity,
    "show_search_by_location": filterPageElement.showSearchByLocation,
    "min_range_value": filterPageElement.minValue,
    "max_range_value": filterPageElement.maxValue,
    "picker_sub_type": filterPageElement.pickerSubType,
    "div_range_value": filterPageElement.divisions,
    "options": filterPageElement.options,
    "unique_key": filterPageElement.uniqueKey,
    "query_type": filterPageElement.queryType,
    "default_radius": filterPageElement.defaultRadius,
    "location_hierarchy_list":
            filterPageElement.locationPickerHierarchyList == null
                ? []
                : List<dynamic>.from(filterPageElement.locationPickerHierarchyList!.map((x) => x)),
      };

  static List<Map<String, dynamic>> encode(List<dynamic> filterPageElementsList) {
    return filterPageElementsList.map<Map<String, dynamic>>((item) =>
        FilterPageElement.toMap(item)).toList();
  }

  static List<dynamic> decode(List<dynamic> filterPageElementsEncodedList) {
    return (filterPageElementsEncodedList).map<FilterPageElement>((item) =>
        FilterPageElement.fromJson(item)).toList();
  }
}

