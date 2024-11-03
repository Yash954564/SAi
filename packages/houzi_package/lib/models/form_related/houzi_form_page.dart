import 'package:houzi_package/models/form_related/houzi_form_item.dart';

class HouziFormPage {
  bool enable;
  String? title;
  List<String>? allowedRoles;
  List<HouziFormSectionFields>? pageFields;

  HouziFormPage({
    this.enable = true,
    this.title,
    this.allowedRoles,
    this.pageFields,
});

  static HouziFormPage parseFormPageJson({required Map<String, dynamic> json}) => HouziFormPage(
    enable: json["enable"] ?? true,
    title: json["title"],
    allowedRoles: json["allowed_roles"] == null ? [] : List<String>.from(json["allowed_roles"]!.map((item) => item)),
    pageFields: json["page_fields"] == null
        ? []
        : List<HouziFormSectionFields>.from(json["page_fields"]!.map((item) => HouziFormSectionFields.parseSectionFieldsJson(json: item))),
  );

  static Map<String, dynamic> encodeFormPageToJson({required HouziFormPage formPage}) => {
    "enable": formPage.enable,
    "title": formPage.title,
    "allowed_roles": formPage.allowedRoles == null ? [] : List<dynamic>.from(formPage.allowedRoles!.map((item) => item)),
    "page_fields": formPage.pageFields == null
        ? []
        : List<dynamic>.from(formPage.pageFields!.map((item) => HouziFormSectionFields.encodeSectionFieldsToJson(formSectionFields: item))),
  };
}

class HouziFormSectionFields {
  bool enable;
  String? section;
  List<HouziFormItem>? fields;

  HouziFormSectionFields({
    this.enable = true,
    this.section,
    this.fields,
  });

  static HouziFormSectionFields parseSectionFieldsJson({required Map<String, dynamic> json}) => HouziFormSectionFields(
    enable: json["enable"] ?? true,
    section: json["section"],
    fields: json["from_fields"] == null
        ? []
        : List<HouziFormItem>.from(json["from_fields"]!.map((item) => HouziFormItem.parseFormItemJson(json: item))),
  );

  static Map<String, dynamic> encodeSectionFieldsToJson({required HouziFormSectionFields formSectionFields}) => {
    "enable": formSectionFields.enable,
    "section": formSectionFields.section,
    "from_fields": formSectionFields.fields == null
        ? []
        : List<dynamic>.from(formSectionFields.fields!.map((item) => HouziFormItem.encodeFormItemToJson(formItem: item))),
  };
}

