import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/string_ext.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'custom_segment_widget.dart';

Widget searchTypeWidget({
  int? totalSwitches,
  required List<String> labels,
  int initialLabelIndex = 0,
  double fontSize = 16.0,
  double minHeight = 40.0,
  double minWidth = 72.0,
  double borderWidth = 1,
  double cornerRadius = 8.0,
  bool radiusStyle = false,
  bool shouldCupertinoSlider = false,
  required Function(int?)? onToggle,
  // required Function(int) onToggle,
}){
  if (!shouldCupertinoSlider) {
    double _minWidth = minWidth;
    for (var element in labels) {
      _minWidth = max(_minWidth, element.textWidth(
          AppThemePreferences().appTheme.bodyTextStyle!.copyWith(
              fontSize: fontSize)));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ToggleSwitch(
        animate: false,
        cornerRadius: cornerRadius,
        borderWidth: borderWidth,
        minHeight: minHeight,
        minWidth: _minWidth,
        radiusStyle: radiusStyle,
        fontSize: fontSize,
        inactiveBgColor: AppThemePreferences().appTheme
            .switchUnselectedBackgroundColor,
        inactiveFgColor: AppThemePreferences().appTheme
            .switchUnselectedItemTextColor,
        activeFgColor: AppThemePreferences().appTheme
            .switchSelectedItemTextColor,
        activeBgColor: [
          AppThemePreferences().appTheme.switchSelectedBackgroundColor!,
        ],
        totalSwitches: totalSwitches!,
        labels: labels,
        initialLabelIndex: initialLabelIndex == -1 ? 0 : initialLabelIndex,
        onToggle: onToggle,
      ),
    );
  } else {
    return TabBarTitleWidget(
      itemList: labels,
      initialSelection: initialLabelIndex == -1 ? 0 : initialLabelIndex,
      onSegmentChosen: onToggle,
    );
  }
}