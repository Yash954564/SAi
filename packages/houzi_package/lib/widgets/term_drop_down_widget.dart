import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef TermDropDownWidgetListener = Function(dynamic selectedDataItem);

class TermDropDownWidget extends StatefulWidget {
  final String? hint;
  final List<dynamic> termDataList;
  final dynamic selectedDataItem;
  final String comparisonOnTheBasisOf;
  final TermDropDownWidgetListener listener;
  final EdgeInsetsGeometry? padding;

  const TermDropDownWidget({
    Key? key,
    this.hint,
    required this.termDataList,
    required this.selectedDataItem,
    required this.listener,
    this.comparisonOnTheBasisOf = TERM_NAME,
    this.padding = const EdgeInsets.fromLTRB(10, 20, 10, 20),
  }) : super(key: key);

  @override
  State<TermDropDownWidget> createState() => _TermDropDownWidgetState();
}

class _TermDropDownWidgetState extends State<TermDropDownWidget> {

  dynamic dataItem;
  dynamic selectedDataItem;

  @override
  void initState() {
    // selectedDataItem = widget.selectedDataItem;
    selectedDataItem = getSlug();

    super.initState();
  }

  @override
  void dispose() {
    selectedDataItem = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.termDataList.isNotEmpty) {
      return DropdownButtonFormField(
        dropdownColor: AppThemePreferences().appTheme.dropdownMenuBgColor,
        isExpanded: true,
        icon: Icon(AppThemePreferences.dropDownArrowIcon),
        decoration: AppThemePreferences.formFieldDecoration(hintText: widget.hint),
        items: widget.termDataList.map((item) {

          return DropdownMenuItem(
            value: item.slug,
            child: GenericTextWidget(UtilityMethods.getLocalizedString(item.name)),
            onTap: () {
              dataItem = item;
            },

          );

        }).toList(),
        value: selectedDataItem,
        onChanged: (value) => updatedValue(widget.comparisonOnTheBasisOf, dataItem),
      );
    }

    return Container();
  }

  updatedValue(String comparisonBase, var item) {
    if (mounted) {
      setState(() {
        selectedDataItem = item.slug;
        if (comparisonBase == TERM_ID) {
          widget.listener(item.id);
        } else if (comparisonBase == TERM_NAME) {
          widget.listener(item.name);
        } else if (comparisonBase == TERM_SLUG) {
          widget.listener(item.slug);
        }
      });
    }

  }

  String? getSlug() {
    if (widget.comparisonOnTheBasisOf == TERM_NAME) {
      Term? term = getTermObjectWithName(dataList: widget.termDataList, name: widget.selectedDataItem);
      return term!.slug;
    } else if (widget.comparisonOnTheBasisOf == TERM_ID) {
      Term? term = getTermObjectWithId(dataList: widget.termDataList, id: widget.selectedDataItem);
      return term!.slug;
    }

    return widget.selectedDataItem;
  }

  static Term? getTermObjectWithId({
    required int id,
    required List<dynamic> dataList,
  }) {
    if (dataList.isNotEmpty) {
      Term? item = dataList.firstWhereOrNull((element) => (element is Term && element.id == id));

      if (item != null) {
        return item;
      }
    }
    return null;
  }

  static Term? getTermObjectWithName({
    required String name,
    required List<dynamic> dataList,
  }) {
    if (dataList.isNotEmpty) {
      Term? item = dataList.firstWhereOrNull((element) => (element is Term && element.name == name));

      if (item != null) {
        return item;
      }
    }
    return null;
  }
}
