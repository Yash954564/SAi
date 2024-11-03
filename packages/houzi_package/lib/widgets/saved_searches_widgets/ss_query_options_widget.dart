import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/filter_page.dart';
import 'package:houzi_package/pages/search_result.dart';
import 'package:houzi_package/widgets/custom_widgets/alert_dialog_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

typedef QueryOptionsWidgetListener = Function({
  int? queryItemIndex,
});

class QueryOptionsWidget extends StatelessWidget {
  final String queryItemID;
  final int queryItemIndex;
  final Map<String, dynamic> queryDataMap;
  final QueryOptionsWidgetListener listener;

  QueryOptionsWidget({
    Key? key,
    required this.queryItemID,
    required this.queryItemIndex,
    required this.queryDataMap,
    required this.listener,
  }) : super(key: key);

  String? idToDelete;
  final PropertyBloc _propertyBloc = PropertyBloc();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PopupMenuButton(
          surfaceTintColor: Colors.transparent,
          color: AppThemePreferences().appTheme.popUpMenuBgColor,
          offset: Offset(0, 50),
          elevation: AppThemePreferences.popupMenuElevation,
          icon: Icon(
            Icons.more_horiz_outlined,
            color: AppThemePreferences().appTheme.iconsColor,
          ),
          onSelected: (value) {
            if (value == OPTION_EDIT) {
              onEditTap(context, queryDataMap);
            }
            if (value == OPTION_DELETE) {
              onDeleteTap(context, queryDataMap, queryItemID, queryItemIndex);
            }
          },
          itemBuilder: (context) {
            return [
              GenericPopupMenuItem(
                value: OPTION_EDIT,
                text: UtilityMethods.getLocalizedString("edit"),
                iconData: AppThemePreferences.editIcon,
              ),
              GenericPopupMenuItem(
                value: OPTION_DELETE,
                text: UtilityMethods.getLocalizedString("delete"),
                iconData: AppThemePreferences.deleteIcon,
              ),
            ];
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: CardWidget(
            elevation: AppThemePreferences.zeroElevation,
            shape: AppThemePreferences.roundedCorners(
                AppThemePreferences.savedPageSearchIconRoundedCornersRadius),
            color: AppThemePreferences().appTheme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                UtilityMethods.isRTL(context) ?  Icons.west : Icons.east,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
        // SizedBox(height: 50),
      ],
    );
  }

  PopupMenuItem GenericPopupMenuItem({
    required dynamic value,
    required String text,
    required IconData iconData,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            iconData,
            size: 18,
            color: AppThemePreferences().appTheme.iconsColor,
          ),
          SizedBox(width: 10),
          GenericTextWidget(
            text,
            style: AppThemePreferences().appTheme.subBody01TextStyle,
          ),
        ],
      ),
    );
  }

  onDeleteTap(BuildContext context, Map<String, dynamic> queryMap, String dataId, int index) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialogWidget(
        title: GenericTextWidget(UtilityMethods.getLocalizedString("delete")),
        content: GenericTextWidget(
            UtilityMethods.getLocalizedString("delete_confirmation")),
        actions: <Widget>[
          TextButtonWidget(
            onPressed: () => Navigator.pop(context),
            child:
            GenericTextWidget(UtilityMethods.getLocalizedString("cancel")),
          ),
          TextButtonWidget(
            onPressed: () async {
              if (idToDelete != null && idToDelete == dataId) {
                return;
              }
              idToDelete = dataId;
              Map<String, dynamic> deleteSavedSearchInfo = {
                "id": dataId,
              };

              final response = await _propertyBloc.fetchDeleteSavedSearch(deleteSavedSearchInfo);

              String tempResponseString = response.toString().split("{")[1];
              Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");
              idToDelete = null;
              if (map['success'] == true) {
                listener(queryItemIndex: index);
                // setState(() {
                //   savedSearchesList.removeAt(index);
                // });

                Navigator.pop(context);
                // if (savedSearchesList.isEmpty) {
                //   savedSearchesList.clear();
                // }
                _showToast(context, map['msg']);
              } else if (map['success'] == false) {
                Navigator.pop(context);
                if (map['msg'] !=
                    "you don&#039;t have the right to delete this") {
                  _showToast(context, UtilityMethods.cleanContent(map['msg']));
                }
              } else {
                _showToast(context,
                    UtilityMethods.getLocalizedString("error_occurred"));
              }
            },
            child: GenericTextWidget(UtilityMethods.getLocalizedString("yes")),
          ),
        ],
      ),
    );
  }

  onEditTap(BuildContext context, Map<String, dynamic> queryMap) {
    if(queryMap.containsKey(BATHROOMS) && queryMap[BATHROOMS] != null &&
        queryMap[BATHROOMS] is List){
      List tempList = queryMap[BATHROOMS];
      if(tempList.contains("6")){
        int index = tempList.indexWhere((element) => element == "6");
        if(index != -1) {
          tempList[index] = "6+";
        }
      }
      queryMap[BATHROOMS] = tempList;
    }

    if(queryMap.containsKey(BEDROOMS) && queryMap[BEDROOMS] != null &&
        queryMap[BEDROOMS] is List){
      List tempList = queryMap[BEDROOMS];
      if(tempList.contains("6")){
        int index = tempList.indexWhere((element) => element == "6");
        if(index != -1) {
          tempList[index] = "6+";
        }
      }
      queryMap[BEDROOMS] = tempList;
    }

    HiveStorageManager.storeFilterDataInfo(map: queryMap);
    UtilityMethods.navigateToRoute(
      context: context,
      builder: (context) => FilterPage(
        mapInitializeData: queryMap,
        filterPageListener: (Map<String, dynamic> dataMap, String closeOption) {
          if (closeOption == DONE) {
            NavigateToSearchResultScreen(
              context: context,
              dataInitializationMap: queryMap,
            );
          }
          if (closeOption == CLOSE) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  void NavigateToSearchResultScreen({
    required BuildContext context,
    required Map<String, dynamic> dataInitializationMap,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResult(
          dataInitializationMap: dataInitializationMap,
          searchPageListener: (Map<String, dynamic> map, String closeOption) {
            if (closeOption == CLOSE) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }
}
