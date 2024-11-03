import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';

class HouziFormItem{
  bool enable;
  List<String>? allowedRoles;
  String apiKey;
  String? sectionType;
  String? termType;
  String? title;
  String? hint;
  String? additionalHint;
  bool performValidation;
  String? validationType;
  int maxLines;
  TextInputType? keyboardType;
  dynamic fieldValues;

  HouziFormItem({
    required this.apiKey,
    required this.sectionType,
    this.title,
    this.enable = true,
    this.allowedRoles,
    this.termType,
    this.hint,
    this.additionalHint,
    this.performValidation = false,
    this.validationType,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.fieldValues,
  });

  static HouziFormItem parseFormItemJson({required Map<String, dynamic> json}) => HouziFormItem(
    apiKey: json["api_key"],
    enable: json["enable"],
    allowedRoles: json["allowed_roles"] == null ? [] : List<String>.from(json["allowed_roles"]!.map((item) => item)),
    sectionType: json["section_type"],
    termType: json["term_type"],
    title: json["title"],
    hint: json["hint"],
    additionalHint: json["additional_hint"],
    performValidation: json["performValidation"],
    validationType: json["validationType"],
    maxLines: json["maxLines"],
    keyboardType: getKeyboardType(json["keyboardType"]),
    fieldValues: json["field_values"] == null ? null : FieldValues.fromJson(json["field_values"]),
    // fieldValues: getKeyboardType(json["field_values"]),
  );

  static TextInputType getKeyboardType(String? type) {
    if(type == textKeyboardType) {
      return TextInputType.text;
    } else if(type == numberKeyboardType) {
      return TextInputType.number;
    } else if(type == urlKeyboardType) {
      return TextInputType.url;
    } else if(type == emailKeyboardType) {
      return TextInputType.emailAddress;
    } else if(type == multilineKeyboardType) {
      return TextInputType.multiline;
    }
    return TextInputType.text;
  }


  static Map<String, dynamic> encodeFormItemToJson({required HouziFormItem formItem}) => {
    "api_key": formItem.apiKey,
    "enable": formItem.enable,
    "allowed_roles": formItem.allowedRoles == null ? [] : List<dynamic>.from(formItem.allowedRoles!.map((item) => item)),
    "section_type": formItem.sectionType,
    "term_type": formItem.termType,
    "title": formItem.title,
    "hint": formItem.hint,
    "additional_hint": formItem.additionalHint,
    "performValidation": formItem.performValidation,
    "validationType": formItem.validationType,
    "maxLines": formItem.maxLines,
    "keyboardType": getStringKeyboardType(formItem.keyboardType),
    "field_values": FieldValues.toJson(formItem.fieldValues),
  };

  static String getStringKeyboardType(TextInputType? type) {
    if(type == TextInputType.text) {
      return textKeyboardType;
    } else if(type == TextInputType.number) {
      return numberKeyboardType;
    } else if(type == TextInputType.url) {
      return urlKeyboardType;
    } else if(type == TextInputType.emailAddress) {
      return emailKeyboardType;
    } else if(type == TextInputType.multiline) {
      return multilineKeyboardType;
    }
    return textKeyboardType;
  }

  static List<Map<String, dynamic>> encode(List<HouziFormItem> formFieldsList) {
    return formFieldsList.map<Map<String, dynamic>>((formField) =>
        HouziFormItem.encodeFormItemToJson(formItem: formField)).toList();
  }

  static List<HouziFormItem> decode(List<dynamic> formFieldsEncodedList) {
    return List<HouziFormItem>.from(formFieldsEncodedList.map<HouziFormItem>((formFieldJson) =>
        HouziFormItem.parseFormItemJson(json: formFieldJson)).toList());
  }
}

class FieldValues {
  Map<String,dynamic>? fieldValuesMap;

  FieldValues({
    this.fieldValuesMap
  });

  static FieldValues fromJson(Map<String, dynamic> json) => FieldValues(
      fieldValuesMap: json
  );

  static Map<String, dynamic>? toJson(FieldValues fieldValues) {
    return fieldValues.fieldValuesMap;
  }

}