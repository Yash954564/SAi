import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef TermPickerBoxListener = Function(
  List<dynamic> selectedItems,
  List<dynamic> selectedItemsSlugs,
);

class TermPickerBox extends StatefulWidget {
  final String title;
  final List<dynamic> termMetaDataList;
  final Map<String, dynamic> termsDataMap;
  final TermPickerBoxListener? termPickerBoxListener;
  final String termType;
  final bool addAllinData;
  final List<dynamic> selectedItemsList;
  final List<dynamic>? selectedItemsSlugsList;

  TermPickerBox({
    required this.title,
    required this.termMetaDataList,
    required this.termsDataMap,
    required this.termPickerBoxListener,
    required this.termType,
    required this.selectedItemsList,
    this.selectedItemsSlugsList,
    this.addAllinData = true,
  })  : assert(title != null),
        assert(termMetaDataList != null);

  @override
  State<StatefulWidget> createState() => TermPickerBoxState();
}

class TermPickerBoxState extends State<TermPickerBox> {
  List<dynamic> termMetaDataList = [];
  List<String> termNamesDataList = [];
  Map<String, dynamic> termsDataMap = {};
  List<String> termDataMapKeysList = [];

  List<dynamic> selectedItemsList = [];
  List<dynamic> selectedItemsSlugsList = [];


  int? selectedIndex;
  bool _showList = false;
  bool isDarkMode = false;

  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState> key = GlobalKey();
  final TextEditingController _controller = TextEditingController();

  Term allTermObject = Term(
    name: "All",
    slug: "all",
    id: null,
  );

  @override
  void initState() {
    super.initState();
    bool hideEmpty = HooksConfigurations.hideEmptyTerm != null
        ? HooksConfigurations.hideEmptyTerm(widget.termType)
        : false;
    for (int i = 0; i < widget.termMetaDataList.length; i++) {
      //if we shouldn't hide empty, add without checking.
      if (!hideEmpty) {
        termMetaDataList.add(widget.termMetaDataList[i]);
      } else {
        //if we should hide empty, then do check listing count and then add.
        if (widget.termMetaDataList[i].totalPropertiesCount != null &&
            widget.termMetaDataList[i].totalPropertiesCount > 0) {
          termMetaDataList.add(widget.termMetaDataList[i]);
        }
      }
    }

    if (termMetaDataList.isNotEmpty) {
      if (mounted) {
        setState(() {
          _showList = true;
        });
      }
      // Term allTermObject = Term(
      //   name: "All",
      //   slug: "all",
      //   id: null,
      // );

      // Extract all the names of the terms
      for (int i = 0; i < termMetaDataList.length; i++) {
        termNamesDataList.add(termMetaDataList[i].name);
      }

      if (widget.addAllinData) {
        // Addition check: Add 'All' item if not in list
        if (!termNamesDataList.contains("All")) {
          termNamesDataList.insert(0, "All");
        }
      }
    }

    if (widget.termsDataMap.isNotEmpty) {
      termsDataMap = widget.termsDataMap;
      termDataMapKeysList = termsDataMap.keys.toList();
    } else {
      if (termMetaDataList.isNotEmpty) {
        Map<String, dynamic> tempTermsDataMap = {};
        List<dynamic> tempList = [];
        tempList.addAll(termMetaDataList);

        if (tempList[0].name == "All") {
          tempList.removeAt(0);
        }

        tempTermsDataMap = UtilityMethods.getParentAndChildCategorizedMap(
            metaDataList: tempList);
        if (tempTermsDataMap.isNotEmpty) {
          if (widget.addAllinData) {
            tempTermsDataMap["All"] = [];
          }
          termsDataMap = {};
          termsDataMap.addAll(tempTermsDataMap);
          termDataMapKeysList = termsDataMap.keys.toList();
        }
      }
    }

    if (termsDataMap.isNotEmpty) {
      termMetaDataList =
          reArrangeListAccordingToMap(termsDataMap, termMetaDataList);
    }
    if (widget.addAllinData) {
      // Add 'all' term if not in list
      if (termMetaDataList.contains(allTermObject)) {
        termMetaDataList.remove(allTermObject);
      }
      termMetaDataList.insert(0, allTermObject);
    }

    if(widget.selectedItemsList != null && widget.selectedItemsList.isNotEmpty){
      selectedItemsList = widget.selectedItemsList;
    }

    if(widget.selectedItemsSlugsList != null && widget.selectedItemsSlugsList!.isNotEmpty){
      selectedItemsSlugsList = widget.selectedItemsSlugsList!;
    }

    // print("termsDataMap: $termsDataMap");
    // print("termDataMapKeysList: $termDataMapKeysList");
  }

  List<dynamic> reArrangeListAccordingToMap(
      Map<String, dynamic> dataMap, List<dynamic> metaDataList) {
    List<dynamic> dataList = [];
    List<String> mapKeys = dataMap.keys.toList();
    if (mapKeys.isNotEmpty) {
      for (var key in mapKeys) {
        if (key == "All" && widget.addAllinData) {
          dataList.add(allTermObject);
        } else {
          Term? termItem = metaDataList.firstWhereOrNull(
              (element) => (element is Term && element.name == key));
          if (termItem != null) {
            dataList.add(termItem);
            dataList.addAll(dataMap[key]);
          }
        }
      }
    }

    return dataList;
  }
  List<int> selectedIndices = [];

  @override
  Widget build(BuildContext context) {
    selectedItemsList = widget.selectedItemsList;
    selectedItemsSlugsList = widget.selectedItemsSlugsList ?? [];
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 columns
          crossAxisSpacing: 10.0, // horizontal spacing between items
          mainAxisSpacing: 10.0, // vertical spacing between items
          mainAxisExtent: 77,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: termMetaDataList.length,
        itemBuilder: (context, int index) {
          String item = termMetaDataList[index].name;
          String listItem = UtilityMethods.getLocalizedString(item);
          if (termDataMapKeysList.isNotEmpty && !(termDataMapKeysList.contains(item))) {
            // listItem = " - ${UtilityMethods.getLocalizedString(item)}";
            listItem = UtilityMethods.getLocalizedString(item);
          }

          // Determine whether the item is selected based on selectedItemsList
          bool isSelected = selectedItemsList.contains(item);

          return Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppThemePreferences().appTheme.primaryColor
                  : AppThemePreferences().appTheme.containerBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    // If item is already selected, unselect it
                    selectedItemsList.remove(item);
                    if (selectedItemsSlugsList != null) {
                      selectedItemsSlugsList.remove(termMetaDataList[index].slug);
                    }
                  } else {
                    // If item is not selected, select it
                    selectedItemsList.add(item);
                    if (selectedItemsSlugsList != null) {
                      selectedItemsSlugsList.add(termMetaDataList[index].slug);
                    }
                  }
                });

                // Notify listeners with selected items
                widget.termPickerBoxListener!(selectedItemsList, selectedItemsSlugsList);
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: buildIcon(termMetaDataList[index].slug, isSelected),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    child: GenericTextWidget(
                      UtilityMethods.getLocalizedString(listItem),
                      style: isSelected
                          ? AppThemePreferences().appTheme.subBody05TextStyle
                          : AppThemePreferences().appTheme.subBody01TextStyle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildIcon(String slug, bool isSelected) {
    final icon = UtilityMethods.iconMap[slug];
    if (icon is Widget) {
      return icon;
    } else if (icon is IconData) {
      return Icon(
        icon,
        size: 40,
        color: isSelected ? Colors.white : null,
      );
    } else {
      return Icon(
        AppThemePreferences.homeIconOutlined,
        size: 40,
        color: isSelected ? Colors.white : null,
      );
    }
  }


}
