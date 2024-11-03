import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/widgets/custom_segment_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/choice_chip_widget.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../generic_text_widget.dart';

typedef PropertyTypePickerListener = void Function(String _title, List<dynamic> _listOfPropertyTypesSlugs, List<dynamic> _listOfPropertyTypes);

class PropertyPicker extends StatefulWidget {
  final String propertyTitle;
  final List<dynamic> listOfSelectedPropertyTypeSlugs;
  final List<dynamic> listOfSelectedPropertyTypes;
  final PropertyTypePickerListener propertyTypePickerListener;

  PropertyPicker({
    required this.propertyTitle,
    required this.listOfSelectedPropertyTypeSlugs,
    required this.listOfSelectedPropertyTypes,
    required this.propertyTypePickerListener,
  });

  @override
  State<PropertyPicker> createState() => _PropertyPickerState();
}

class _PropertyPickerState extends State<PropertyPicker> {

  String _propertyTypeSlug = '';
  // int _selectedPropertyTitle = 0;
  int? _selectedPropertyTitle;

  bool showTabBarView = false;
  bool hasNoPropertyType = true;

  List<dynamic> tempTitleList = [];
  List<dynamic> propertyTypesMetaData = [];
  Map<String, dynamic> propertyTypesMap = {};
  List<dynamic> _listOfPropertyTypeSlugs= [];
  List<dynamic> _listOfPropertyTypes= [];

  @override
  void initState() {
    super.initState();

    propertyTypesMap = HiveStorageManager.readPropertyTypesMapData() ?? {};
    propertyTypesMetaData = HiveStorageManager.readPropertyTypesMetaData();

    initializeData(propertyTypesMap, propertyTypesMetaData);

    if(widget.listOfSelectedPropertyTypeSlugs != null){
      setState(() {
        _listOfPropertyTypeSlugs.addAll(widget.listOfSelectedPropertyTypeSlugs);
      });
    }

    if(widget.listOfSelectedPropertyTypes != null){
      setState(() {
        _listOfPropertyTypes.addAll(widget.listOfSelectedPropertyTypes);
      });
    }
  }

  initializeData(Map<String, dynamic> propertyTypesMap, List<dynamic> propertyTypesMetaData){
    if((propertyTypesMap != null && propertyTypesMap.isNotEmpty) ||
        (propertyTypesMetaData != null && propertyTypesMetaData.isNotEmpty)){
      hasNoPropertyType = false;
    }

    if(propertyTypesMap != null && propertyTypesMap.isNotEmpty){
      showTabBarView = true;
      tempTitleList = propertyTypesMap.keys.toList();
      if(widget.propertyTitle != null && widget.propertyTitle.isNotEmpty){
        var index = tempTitleList.indexOf(widget.propertyTitle);
        if(index != null && index != -1){
          _selectedPropertyTitle = index;
          addTitleSlugToList();
        }
      } else if(widget.propertyTitle == null || widget.propertyTitle.isEmpty){
        _selectedPropertyTitle = 0;
        addTitleSlugToList();
      }
    }
  }

  void addTitleSlugToList(){
    if(tempTitleList != null && tempTitleList.isNotEmpty){
      String title = tempTitleList[_selectedPropertyTitle!];
      int index = propertyTypesMetaData.indexWhere((element) => element.name == title);
      if(index != null && index != -1){
        String slug = propertyTypesMetaData[index].slug;
        if(slug != null && slug.isNotEmpty){
          setState(() {
            _listOfPropertyTypeSlugs.add(slug);
            _listOfPropertyTypes.add(title);
          });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    propertyTypesMap = HiveStorageManager.readPropertyTypesMapData() ?? {};
    propertyTypesMetaData = HiveStorageManager.readPropertyTypesMetaData();

    initializeData(propertyTypesMap, propertyTypesMetaData);

    _listOfPropertyTypes = widget.listOfSelectedPropertyTypes;
    _listOfPropertyTypeSlugs = widget.listOfSelectedPropertyTypeSlugs;

    return hasNoPropertyType ? Container() : ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 140,
        maxHeight: 210,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          border: Border(
            top: AppThemePreferences().appTheme.filterPageBorderSide!,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            titleWidget(),
            showTabBarView ? tabBarViewWidget() : nonTabBarViewWidget(),
          ],
        ),
      ),
    );
  }

  Widget titleWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: AppThemePreferences().appTheme.filterPageLocationCityIcon!,
        ),
        Expanded(
          flex: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GenericTextWidget(
                UtilityMethods.getLocalizedString("title_property_types"),
                style: AppThemePreferences().appTheme.filterPageHeadingTitleTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tabBarViewWidget(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        tabBarTitleWidget(),
        tabBarOptionsWidget(),
      ],
    );
  }

  Widget tabBarTitleWidget(){
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: SegmentedControlWidget(
            itemList: tempTitleList,
            selectionIndex: _selectedPropertyTitle!,
            onSegmentChosen: onSegmentChosen,
            padding: EdgeInsets.only(left: 20 ,right: 20),
          )

          // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Row(
        //     // mainAxisAlignment: MainAxisAlignment.start,
        //     // crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       MaterialSegmentedControl(
        //         // horizontalPadding: EdgeInsets.only(left: 5,right: 5),
        //         children: tempTitleList.map((item) {
        //           var index = tempTitleList.indexOf(item);
        //           return Container(
        //             padding:  const EdgeInsets.only(left: 20 ,right: 20),
        //             child: genericTextWidget(
        //             UtilityMethods.getLocalizedString(item),
        //             style: TextStyle(
        //               fontSize: AppThemePreferences.tabBarTitleFontSize,
        //               fontWeight: AppThemePreferences.tabBarTitleFontWeight,
        //               color: _selectedPropertyTitle == index ? AppThemePreferences().appTheme.selectedItemTextColor :
        //               AppThemePreferences.unSelectedItemTextColorLight,
        //             ),),
        //           );
        //         },).toList().asMap(),
        //
        //         selectionIndex: _selectedPropertyTitle,
        //         unselectedColor: AppThemePreferences().appTheme.unSelectedItemBackgroundColor,
        //         selectedColor: AppThemePreferences().appTheme.selectedItemBackgroundColor!,
        //         // borderColor: Colors.transparent,
        //         borderRadius: 5.0,
        //         verticalOffset: 8.0,
        //         onSegmentChosen: (index){
        //           setState(() {
        //             _selectedPropertyTitle = index;
        //             // _listOfPropertyTypeSlugs = [];_listOfPropertyTypes
        //           });
        //           String title = tempTitleList[_selectedPropertyTitle!];
        //           int itemIndex = propertyTypesMetaData.indexWhere((element) => element.name == title);
        //           if(itemIndex != null && itemIndex != -1){
        //             String slug = propertyTypesMetaData[itemIndex].slug;
        //             if(slug != null && slug.isNotEmpty){
        //               setState(() {
        //                 _listOfPropertyTypeSlugs.add(slug);
        //                 _listOfPropertyTypes.add(title);
        //               });
        //             }
        //           }
        //
        //           widget.propertyTypePickerListener(tempTitleList[_selectedPropertyTitle!], _listOfPropertyTypeSlugs, _listOfPropertyTypes);
        //         },
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  onSegmentChosen(int index) {
    setState(() {
      _selectedPropertyTitle = index;
      // _listOfPropertyTypeSlugs = [];_listOfPropertyTypes
    });
    String title = tempTitleList[_selectedPropertyTitle!];
    int itemIndex = propertyTypesMetaData.indexWhere((element) => element.name == title);
    if(itemIndex != null && itemIndex != -1){
      String slug = propertyTypesMetaData[itemIndex].slug;
      if(slug != null && slug.isNotEmpty){
        setState(() {
          _listOfPropertyTypeSlugs.add(slug);
          _listOfPropertyTypes.add(title);
        });
      }
    }

    widget.propertyTypePickerListener(tempTitleList[_selectedPropertyTitle!], _listOfPropertyTypeSlugs, _listOfPropertyTypes);
  }

  Widget tabBarOptionsWidget(){
    String key = tempTitleList[_selectedPropertyTitle!];
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: (propertyTypesMap[key]).map<Widget>((item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ChoiceChipWidget(
                    label: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GenericTextWidget(
                        UtilityMethods.getLocalizedString(item.name),
                        style: AppThemePreferences().appTheme.filterPageChoiceChipTextStyle,
                      ),
                    ),
                    selected: _listOfPropertyTypeSlugs.contains(item.slug),
                    selectedColor: AppThemePreferences().appTheme.selectedItemBackgroundColor,
                    onSelected: (bool selected) {
                      if(selected == true){
                        setState(() {
                          _listOfPropertyTypes.add(item.name);
                          _listOfPropertyTypeSlugs.add(item.slug);
                          _propertyTypeSlug = item.slug;
                        });
                      }if(selected == false){
                        setState(() {
                          _listOfPropertyTypes.remove(item.name);
                          _listOfPropertyTypeSlugs.remove(item.slug);
                        });
                      }
                      widget.propertyTypePickerListener(tempTitleList[_selectedPropertyTitle!], _listOfPropertyTypeSlugs, _listOfPropertyTypes);
                    },
                    backgroundColor: AppThemePreferences().appTheme.unSelectedItemBackgroundColor,
                    labelStyle: TextStyle(
                      color: _listOfPropertyTypeSlugs.contains(item.slug) ? AppThemePreferences().appTheme.selectedItemTextColor : Colors.black,
                    ),
                  ),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nonTabBarViewWidget(){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: propertyTypesMetaData.map<Widget>((item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ChoiceChipWidget(
                    label: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GenericTextWidget(
                        UtilityMethods.getLocalizedString(item.name),
                        style: AppThemePreferences().appTheme.filterPageChoiceChipTextStyle,
                      ),
                    ),
                    selected: _listOfPropertyTypeSlugs.contains(item.slug),
                    selectedColor: AppThemePreferences().appTheme.selectedItemBackgroundColor,
                    onSelected: (bool selected) {
                      if(selected == true){
                        setState(() {
                          _listOfPropertyTypeSlugs.add(item.slug);
                          _listOfPropertyTypes.add(item.name);
                        });
                      }if(selected == false){
                        setState(() {
                          _listOfPropertyTypeSlugs.remove(item.slug);
                          _listOfPropertyTypes.remove(item.name);
                        });
                      }
                      widget.propertyTypePickerListener("", _listOfPropertyTypeSlugs, _listOfPropertyTypes);
                    },
                    backgroundColor: AppThemePreferences().appTheme.unSelectedItemBackgroundColor,
                    labelStyle: TextStyle(
                      color: _listOfPropertyTypeSlugs.contains(item.slug) ? AppThemePreferences().appTheme.selectedItemTextColor : Colors.black,
                    ),
                  ),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
