import 'package:flutter/material.dart';

class DrawerItem {
  String? sectionType;
  String? title;
  bool? checkLogin;
  bool? enable;
  IconData? icon;
  VoidCallback? onTap;
  int? insertAt;
  List<dynamic> expansionTileChildren;

  DrawerItem({
    this.sectionType,
    this.title,
    this.checkLogin,
    this.enable,
    this.icon,
    this.onTap,
    this.insertAt,
    this.expansionTileChildren = const [],
  });



// menuDrawerHelperSetter({
  //   sectionType,
  //   title,
  //   checkLogin,
  //   enable,
  //   onTap,
  //   icon,
  // }) {
  //   this.sectionType = sectionType;
  //   this.title = title;
  //   this.checkLogin = checkLogin;
  //   this.enable = enable;
  //   this.onTap = onTap;
  //   this.icon = icon;
  // }
  //
  //
  // static MenuDrawerHelper get menuDrawerHelper => _menuDrawerHelper;
  //
  // static set menuDrawerHelper(MenuDrawerHelper value) {
  //   _menuDrawerHelper = value;
  // }
  //
  // MenuDrawerHelper._internal();
  //
  // static MenuDrawerHelper _menuDrawerHelper;
  // factory MenuDrawerHelper() {
  //   _menuDrawerHelper ??= MenuDrawerHelper._internal();
  //   return _menuDrawerHelper;
  // }

  // MenuDrawerHelper.fromJson(Map<String, dynamic> json)
  //     : sectionType =  json['section_type'],
  //       title = json['title'],
  //       checkLogin = json['check_login'],
  //       enable = json['enable'],
  //       onTap = json['on_tap'];
  //
  // Map<String, dynamic> toJson() =>
  //     {
  //       'section_type': sectionType,
  //       'title': title,
  //       'check_login': checkLogin,
  //       'enable': enable,
  //       'on_tap': onTap,
  //     };
}