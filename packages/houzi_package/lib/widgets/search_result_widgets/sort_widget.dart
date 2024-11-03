import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/sort_first_by_item.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef SortMenuWidgetListener = Function({
  int? currentSortValue,
  int? previousSortValue,
  bool? sortFlag
});

class SortMenuWidget extends StatefulWidget {
  final int currentSortValue;
  final int previousSortValue;
  final SortMenuWidgetListener listener;

  const SortMenuWidget({
    Key? key,
    required this.currentSortValue,
    required this.previousSortValue,
    required this.listener,
  }) : super(key: key);

  @override
  State<SortMenuWidget> createState() => _SortMenuWidgetState();
}

class _SortMenuWidgetState extends State<SortMenuWidget> {

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter state) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              color: Theme.of(context).canvasColor,
              height: 340,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SortMenuTitleWidget(),

                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Column(
                            children: [
                              SortFirstByWidget(
                                listener: ({currentSortValue, previousSortValue,
                                  selectionIsModified, sortFlag}) {
                                  widget.listener(sortFlag: sortFlag);
                                },
                              ),
                              SortByMenuOptionsWidget(
                                curSortValue: widget.currentSortValue,
                                preSortValue: widget.previousSortValue,
                                state: state,
                                listener: ({currentSortValue, previousSortValue,
                                  sortFlag, selectionIsModified}) {
                                  widget.listener(
                                    currentSortValue: currentSortValue,
                                    previousSortValue: previousSortValue,
                                    sortFlag: sortFlag,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class SortMenuTitleWidget extends StatelessWidget {
  const SortMenuTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      color: Theme.of(context).canvasColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 20,
          left: UtilityMethods.isRTL(context) ? 25 : 0, //10
          right: UtilityMethods.isRTL(context) ? 0 : 30, //25
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              flex: 2,
              child: Icon(
                Icons.sort_outlined,
                size: 30,
              ),
            ),
            Expanded(
              flex: 8,
              child: GenericTextWidget(
                UtilityMethods.getLocalizedString("sort_by"),
                style: AppThemePreferences().appTheme.bottomSheetMenuTitleTextStyle,
              ),
            ),

            // ICON: TICK MARK => DONE
            Expanded(
              flex: 1,
              child: IconButton(
                icon: AppThemePreferences().appTheme.bottomNavigationMenuIcon!,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SortByMenuOptionsWidget extends StatefulWidget {
  final StateSetter state;
  final int curSortValue;
  final int preSortValue;
  final SortMenuWidgetListener listener;

  const SortByMenuOptionsWidget({
    super.key,
    required this.state,
    required this.curSortValue,
    required this.preSortValue,
    required this.listener,
  });

  @override
  State<SortByMenuOptionsWidget> createState() => _SortByMenuOptionsWidgetState();
}

class _SortByMenuOptionsWidgetState extends State<SortByMenuOptionsWidget> {

  int currentSortValue = 0;
  int previousSortValue = -1;

  @override
  void initState() {
    currentSortValue = widget.curSortValue;
    previousSortValue = widget.preSortValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: UtilityMethods.isRTL(context) ? 30 : 0,
        right: UtilityMethods.isRTL(context) ? 0 : 30,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sortByOptionsList.map<Widget>((item) => Row(
          children: [
            Expanded(
              flex: 2,
              child: Icon(getIconData(item)),
            ),
            Expanded(
              flex: 8,
              child: GestureDetector(
                child: GenericTextWidget(
                  UtilityMethods.getLocalizedString(item),
                  style: AppThemePreferences().appTheme.bottomNavigationMenuItemsTextStyle,
                ),
                onTap: () {
                  onSortItemTap(item);
                  widget.state(() {
                    onSortRadioItemTap(item);
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Radio(
                activeColor: AppThemePreferences.radioActiveColor,
                value: sortByOptionsList.indexWhere((option) =>
                item == option),
                groupValue: currentSortValue,
                onChanged: (value) {
                  onSortItemTap(item);
                  widget.state(() {
                    onSortRadioItemTap(item);
                  });
                },
              ),
            ),
          ],
        )).toList(),
      ),
    );
  }

  void onSortItemTap(String item) {
    if(mounted) {
      setState(() {
        if (currentSortValue != previousSortValue) {
          previousSortValue = currentSortValue;
          widget.listener(
            sortFlag: true,
            previousSortValue: previousSortValue,
          );
        }
        currentSortValue = sortByOptionsList.indexWhere((element) =>
        item == element);

        widget.listener(currentSortValue: currentSortValue);
      });
    }
  }

  void onSortRadioItemTap(String item){
    currentSortValue = sortByOptionsList.indexWhere((element) =>
    item == element);

    widget.listener(currentSortValue: currentSortValue);
  }

  IconData getIconData(String option) {
    final Map<String, IconData> dataMap = {
      newestKey : AppThemePreferences.accessTimeOutlined,
      oldestKey : AppThemePreferences.accessTimeOutlined,
      priceMinKey : AppThemePreferences.sellOutlined,
      priceMaxKey : AppThemePreferences.sellOutlined,
      areaMinKey : AppThemePreferences.areaSizeIcon,
      areaMaxKey : AppThemePreferences.areaSizeIcon,
    };
    return dataMap[option] ?? AppThemePreferences.accessTimeOutlined;
  }
}

class SortFirstByWidget extends StatefulWidget {
  final SortMenuWidgetListener listener;

  const SortFirstByWidget({
    super.key,
    required this.listener,
  });

  @override
  State<SortFirstByWidget> createState() => _SortFirstByWidgetState();
}

class _SortFirstByWidgetState extends State<SortFirstByWidget> {
  
  List<SortFirstByItem> _sortFirstByItems = [];
  
  @override
  void initState() {
    _sortFirstByItems = UtilityMethods.readSortFirstByConfigFile();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: _sortFirstByItems.isNotEmpty ? 20 : 0,
        left: UtilityMethods.isRTL(context) ? 30 : 0,
        right: UtilityMethods.isRTL(context) ? 0 : 30,
      ),
      child: Column(
        children: [
          if (_sortFirstByItems.isNotEmpty) Column(
            children: _sortFirstByItems.map<Widget>((item) {
              int _index = _sortFirstByItems.indexOf(item);
              bool _value = item.defaultValue == 'on' ? true : false;
              return Container(
              padding: EdgeInsets.only(
                bottom: 10,
                right: UtilityMethods.isRTL(context) ? 0 : 10,
                left: UtilityMethods.isRTL(context) ? 10 : 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Icon(
                      UtilityMethods.fromJsonToIconData(item.icon ?? DUMMY_ICON_JSON),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: GestureDetector(
                      child: GenericTextWidget(
                        UtilityMethods.getLocalizedString(item.title ?? ''),
                        style: AppThemePreferences().appTheme.bottomNavigationMenuItemsTextStyle,
                      ),
                      onTap: () => onTap(_index, _value),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CupertinoSwitch(
                      value: _value,
                      activeColor: AppThemePreferences().appTheme.primaryColor,
                      onChanged: (bool value) => onTap(_index, _value),
                    ),
                  ),
                ],
              ),
            );
            }).toList(),
          ),
          if (_sortFirstByItems.isNotEmpty) Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: UtilityMethods.isRTL(context) ? 5 : 30,
              right: UtilityMethods.isRTL(context) ? 30 : 5,
            ),
            child: Divider(thickness: 1),
          ),
        ],
      ),
    );
  }

  void onTap(int index, bool value) {
    if (mounted) {
      setState(() {
        if (value) {
          _sortFirstByItems[index].defaultValue = 'off';
        } else {
          _sortFirstByItems[index].defaultValue = 'on';
        }
      });
    }
    // UPDATE THE STORAGE
    HiveStorageManager.storeSortFirstByConfigData(
        json.encode(SortFirstByItem.encode(_sortFirstByItems)));

    // NOTIFY THE PANEL TO UPDATE THE LISTING SORT ORDER
    widget.listener(sortFlag: true);
  }
}





