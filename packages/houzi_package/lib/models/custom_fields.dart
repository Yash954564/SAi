// To parse this JSON data, do
//
//     final custom = customFromJson(jsonString);

import 'dart:convert';

Custom customFromJson(String str) => Custom.fromJson(json.decode(str));

String customToJson(Custom data) => json.encode(data.toJson());

class Custom {
  Custom({
    this.customFields,
  });

  List<CustomField>? customFields;

  factory Custom.fromJson(Map<String, dynamic> json) => Custom(
    customFields: List<CustomField>.from(json["custom_fields"].map((x) => CustomField.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "custom_fields": List<dynamic>.from(customFields!.map((x) => x.toJson())),
  };
}

class CustomField {
  CustomField({
    this.id,
    this.label,
    this.fieldId,
    this.type,
    this.options,
    this.fvalues,
    this.isSearch,
    this.searchCompare,
    this.placeholder,
  });

  String? id;
  String? label;
  String? fieldId;
  String? type;
  String? options;
  dynamic fvalues;
  String? isSearch;
  dynamic searchCompare;
  String? placeholder;

  factory CustomField.fromJson(Map<String, dynamic> json) => CustomField(
    id: json["id"],
    label: json["label"],
    fieldId: json["field_id"],
    type: json["type"],
    options: json["options"],
    fvalues: json["fvalues"],
    isSearch: json["is_search"],
    searchCompare: json["search_compare"],
    placeholder: json["placeholder"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "field_id": fieldId,
    "type": type,
    "options": options,
    "fvalues": fvalues,
    "is_search": isSearch,
    "search_compare": searchCompare,
    "placeholder": placeholder,
  };
}

class FvaluesClass {
  FvaluesClass({
    this.fValuesMap
  });

  Map<String,dynamic>? fValuesMap;

  factory FvaluesClass.fromJson(Map<String, dynamic> json) => FvaluesClass(
    fValuesMap: json
  );

}

class CustomFieldModel{
  String? name;
  String? parent;

  CustomFieldModel(this.name, this.parent);
}
