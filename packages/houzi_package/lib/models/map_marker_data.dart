import 'package:flutter/material.dart';

class MapMarkerData {
  String text;
  Color backgroundColor;
  Color? textColor;
  TextStyle? textStyle;

  MapMarkerData({
    required this.text,
    required this.backgroundColor,
    this.textColor,
    this.textStyle,
  });
}