import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/filter_page_config.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef KeywordCustomQueryWidgetListener = void Function(String keywordString);

class KeywordCustomQueryWidget extends StatefulWidget {
  final Icon pickerIcon;
  final FilterPageElement filterObj;
  final Map<String, dynamic> filterDataMap;
  final KeywordCustomQueryWidgetListener listener;

  const KeywordCustomQueryWidget({
    super.key,
    required this.filterObj,
    required this.pickerIcon,
    required this.listener,
    required this.filterDataMap,
  });

  @override
  State<KeywordCustomQueryWidget> createState() => _KeywordCustomQueryWidgetState();
}

class _KeywordCustomQueryWidgetState extends State<KeywordCustomQueryWidget> {
  bool _selectedValue = false;

  String _pickerTitle = "";

  String? _optionsString;
  String? _uniqueKey;

  Map<String, dynamic> _filterDataMap = {};
  Map<String,dynamic> _keywordFiltersDataMap = {};

  VoidCallback? generalNotifierLister;

  @override
  void initState() {
    _pickerTitle = widget.filterObj.title ?? "";
    _filterDataMap = widget.filterDataMap;

    // get the options string
    _optionsString = widget.filterObj.options ?? "";
    // get the Unique Key
    _uniqueKey = widget.filterObj.uniqueKey;

    // get the Keyword Filters Data Map
    if (_filterDataMap.isNotEmpty &&
        _filterDataMap.containsKey(keywordFiltersKey) &&
        _filterDataMap[keywordFiltersKey] != null &&
        _filterDataMap[keywordFiltersKey] is Map &&
        _filterDataMap[keywordFiltersKey].isNotEmpty) {
      _keywordFiltersDataMap = Map<String, dynamic>.from(_filterDataMap[keywordFiltersKey]);
    }

    // initialize Data
    if (_uniqueKey != null && _uniqueKey!.isNotEmpty) {
      // add keyword prefix
      if (!_uniqueKey!.contains(KEYWORD_PREFIX)) {
        _uniqueKey = KEYWORD_PREFIX + _uniqueKey!;
      }

      if (_uniqueKey != null && _keywordFiltersDataMap.isNotEmpty &&
          _keywordFiltersDataMap.containsKey(_uniqueKey!) &&
          _keywordFiltersDataMap[_uniqueKey!] is Map &&
          _keywordFiltersDataMap[_uniqueKey!].containsKey(keywordFiltersValueKey) &&
          _keywordFiltersDataMap[_uniqueKey!][keywordFiltersValueKey] is String &&
          _keywordFiltersDataMap[_uniqueKey!][keywordFiltersValueKey].isNotEmpty) {
        _selectedValue = true;
      }
    }

    generalNotifierLister = () {
      if (GeneralNotifier().change == GeneralNotifier.RESET_FILTER_DATA) {
        resetData();
      }
    };
    GeneralNotifier().addListener(generalNotifierLister!);

    super.initState();
  }

  @override
  void dispose() {
    _pickerTitle = "";
    _optionsString = null;
    _uniqueKey = null;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 20.0),
      padding: EdgeInsets.fromLTRB(
          UtilityMethods.isRTL(context) ? 15 : 8, 20,
          UtilityMethods.isRTL(context) ? 8 : 15, 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Wrap(
          children:[
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: widget.pickerIcon,
                    ),
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: UtilityMethods.isRTL(context) ? 0 : 8,
                            right: UtilityMethods.isRTL(context) ? 8 : 0,
                        ),
                        child: GenericTextWidget(
                          UtilityMethods.getLocalizedString(_pickerTitle),
                          style: AppThemePreferences().appTheme.filterPageHeadingTitleTextStyle,
                        ),
                      ),
                    ),
                    if (widget.filterObj.pickerType == switchKey) Expanded(
                      flex: 0,
                      child: CupertinoSwitch(
                        value: _selectedValue,
                        activeColor: AppThemePreferences().appTheme.primaryColor,
                        onChanged: (bool value) => onUpdateValue(value),
                      ),
                    ),
                    if (widget.filterObj.pickerType == checkboxKey) Expanded(
                      flex: 0,
                      child: Checkbox(
                        activeColor: AppThemePreferences().appTheme.primaryColor,
                        value: _selectedValue,
                        onChanged: (value) {
                          if (value != null) {
                            onUpdateValue(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  onUpdateValue(bool val) {
    if(mounted) {
      setState(() {
        _selectedValue = val;
        if (val) {
          if (_optionsString != null && _optionsString!.isNotEmpty) {
            widget.listener(_optionsString!);
          }
        } else {
          widget.listener("");
        }
      });
    }
  }

  resetData(){
    if(mounted) {
      setState(() {
        _selectedValue = false;
      });
    }
  }
}