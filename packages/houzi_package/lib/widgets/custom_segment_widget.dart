import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/segment_control/sliding_segmented_control.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class TabBarTitleWidget extends StatelessWidget {
  final List<dynamic> itemList;
  final int initialSelection;
  final void Function(int)? onSegmentChosen;

  const TabBarTitleWidget({
    super.key,
    required this.itemList,
    required this.initialSelection,
    required this.onSegmentChosen,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MaterialSegmentedControl(
                // horizontalPadding: EdgeInsets.only(left: 5,right: 5),
                children: itemList
                    .map(
                      (item) {
                    var index = itemList.indexOf(item);
                    return Container(
                      // padding:  EdgeInsets.all(10),
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: GenericTextWidget(
                        item,
                        style: TextStyle(
                          fontSize: AppThemePreferences.tabBarTitleFontSize,
                          fontWeight:
                          AppThemePreferences.tabBarTitleFontWeight,
                          color: initialSelection == index
                              ? AppThemePreferences()
                              .appTheme
                              .selectedItemTextColor
                              : AppThemePreferences
                              .unSelectedItemTextColorLight,
                        ),
                      ),
                    );
                  },
                )
                    .toList()
                    .asMap(),
                selectionIndex: initialSelection,
                unselectedColor: AppThemePreferences()
                    .appTheme
                    .unSelectedItemBackgroundColor,
                selectedColor:
                AppThemePreferences().appTheme.selectedItemBackgroundColor!,
                borderColor: Colors.transparent,
                borderRadius: 8.0, //5.0
                verticalOffset: 8.0, // 8.0
                // onSegmentChosen: onSegmentChosen,
                onSegmentTapped: onSegmentChosen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SegmentedControlWidget extends StatefulWidget {
  final List<dynamic> itemList;
  final int selectionIndex;
  final Function(int) onSegmentChosen;
  final EdgeInsetsGeometry? padding;
  final EdgeInsets horizontalPadding;
  final double borderRadius;
  final double verticalOffset;
  final double? fontSize;
  final FontWeight? fontWeight;

  const SegmentedControlWidget({
    Key? key,
    required this.itemList,
    required this.selectionIndex,
    required this.onSegmentChosen,
    this.padding = const EdgeInsets.symmetric(horizontal: 35),
    this.horizontalPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.borderRadius = 5.0,
    this.verticalOffset = 8.0,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  State<SegmentedControlWidget> createState() => _SegmentedControlWidgetState();
}

class _SegmentedControlWidgetState extends State<SegmentedControlWidget> {
  CustomSegmentedControlHook customSegmentedControlHook = HooksConfigurations.customSegmentedControlHook;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: customSegmentedControlHook(
              context,
              widget.itemList,
              widget.selectionIndex,
              widget.onSegmentChosen,
            ) ??
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: buildSegment(),
            ),
      ),
    );
  }

  Widget buildSegment() {
    return USE_CUPERTINO_SEGMENT_CONTROL
        ? CupertinoSlidingSegmentedControl(
            groupValue: widget.selectionIndex,
            thumbColor: AppThemePreferences().appTheme.cupertinoSegmentThumbColor!,
            backgroundColor: AppThemePreferences().appTheme.containerBackgroundColor!,
            onValueChanged: (newValue) {
              if (newValue != null) {
                widget.onSegmentChosen(newValue);
              }
            },
            children: Map.fromEntries(
              widget.itemList.asMap().entries
                .map((entry) {
                  var index = entry.key;
                  var item = entry.value;
                  return MapEntry(
                    index,
                    Container(
                      padding: widget.padding,
                      child: GenericTextWidget(
                        item.runtimeType == Term
                            ? UtilityMethods.getLocalizedString(
                                (item as Term).name!)
                            : UtilityMethods.getLocalizedString(item),
                        style: TextStyle(
                          fontSize: widget.fontSize ?? AppThemePreferences.tabBarTitleFontSize,
                          fontWeight: widget.fontWeight ?? AppThemePreferences.tabBarTitleFontWeight,
                          color: AppThemePreferences().appTheme.selectedItemTextColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        : MaterialSegmentedControl(
            horizontalPadding: widget.horizontalPadding,
            selectionIndex: widget.selectionIndex,
            unselectedColor: AppThemePreferences().appTheme.unSelectedItemBackgroundColor,
            selectedColor: AppThemePreferences().appTheme.selectedItemBackgroundColor!,
            borderRadius: widget.borderRadius,
            verticalOffset: widget.verticalOffset,
            onSegmentTapped: widget.onSegmentChosen,
            // onSegmentChosen: widget.onSegmentChosen,
            children: widget.itemList.map((item) {
                var index = widget.itemList.indexOf(item);
                return Container(
                  padding: widget.padding,
                  child: GenericTextWidget(
                    item.runtimeType == Term
                        ? UtilityMethods.getLocalizedString(item.name)
                        : UtilityMethods.getLocalizedString(item),
                    style: TextStyle(
                      fontSize: widget.fontSize ?? AppThemePreferences.tabBarTitleFontSize,
                      fontWeight: widget.fontWeight ?? AppThemePreferences.tabBarTitleFontWeight,
                      color: widget.selectionIndex == index
                          ? AppThemePreferences().appTheme.selectedItemTextColor
                          : AppThemePreferences.unSelectedItemTextColorLight,
                    ),
                  ),
                );
              },
            ).toList().asMap(),
          );
  }
}
