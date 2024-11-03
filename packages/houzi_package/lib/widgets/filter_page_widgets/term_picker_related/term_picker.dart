import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/widgets/custom_segment_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/choice_chip_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_box.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_full_screen.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_multi_select_dialog.dart';

import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';


typedef TermPickerPickerListener = Function(
  List<dynamic> selectedTermsSlugList,
  List<dynamic> selectedTermsNameList,
);

class TermPicker extends StatefulWidget {
  final bool showDivider;
  final bool? showSearchBar;
  final Icon pickerIcon;
  final String objDataType;
  final String pickerTitle;
  final String pickerType;
  final Map<String, dynamic> filterDataMap;
  final List<dynamic> selectedTermsSlugsList;
  final List<dynamic> selectedTermsList;
  final TermPickerPickerListener termPickerListener;

  const TermPicker({
    Key? key,
    required this.objDataType,
    required this.pickerTitle,
    required this.pickerIcon,
    required this.pickerType,
    required this.selectedTermsSlugsList,
    required this.selectedTermsList,
    required this.filterDataMap,
    required this.termPickerListener,
    this.showDivider = true,
    this.showSearchBar = false,
  }) : super(key: key);

  @override
  State<TermPicker> createState() => _TermPickerState();
}

class _TermPickerState extends State<TermPicker> {

  int _selectedTermTitle = 0;

  bool hasNoTerms = true;
  bool loadingData = false;
  bool tabBarOptionsAvailable = false;
  bool showDataByParentTerm = false;

  List<String> selectParentTermName =  [];

  String selectedTerm = PLEASE_SELECT;

  Map<String, dynamic> _termsMap = {};
  Map<String, dynamic> tempDataHolderMap = {};

  List<dynamic> _tempTitleList = [];
  List<dynamic> _termsMetaData = [];
  List<dynamic> _listOfSelectedTermSlugs= [];
  List<dynamic> _listOfSelectedTerms = [];

  final PropertyBloc _propertyBloc = PropertyBloc();

  final dropDownTextController = TextEditingController();

  VoidCallback? generalNotifierLister;

  Function deepEq = const DeepCollectionEquality().equals;
  bool hideEmpty = false;


  @override
  void initState() {
    hideEmpty = HooksConfigurations.hideEmptyTerm != null
        ? HooksConfigurations.hideEmptyTerm(widget.objDataType)
        : false;
    readTermData();
    generalNotifierLister = () {
      if (shouldChangeBasedOnParentTerm() && showDataByParentTerm) {
        bool parentSelectionChanged = false;
        if ((isDataTypePropertyArea() && GeneralNotifier().change == GeneralNotifier.CITY_DATA_UPDATE)
            || (isDataTypePropertyCity() && GeneralNotifier().change == GeneralNotifier.STATE_DATA_UPDATE)
            || (isDataTypePropertyState() && GeneralNotifier().change == GeneralNotifier.COUNTRY_DATA_UPDATE)) {

          List<String> parentTermName = [];

          List selectedTermNameSlug = getSelectedParentTermNameAndSlug();
          parentTermName = selectedTermNameSlug.first;

          if(!deepEq(selectParentTermName, parentTermName)){
            parentSelectionChanged = true;
          }

          // if(isDataTypePropertyArea() && GeneralNotifier().change == GeneralNotifier.CITY_DATA_UPDATE){
          //   print("City has changed...");
          //   print("ParentTermList: $parentTermName SelectParentTermList: $selectParentTermName");
          //   print("Should Update Property Area: $parentSelectionChanged\n");
          // }

          if(isDataTypePropertyCity() && GeneralNotifier().change == GeneralNotifier.STATE_DATA_UPDATE){
            // print("State has changed...");
            // print("ParentTermList: $parentTermName SelectParentTermList: $selectParentTermName");
            // print("Should Update Property City: $parentSelectionChanged\n");

            if(deepEq(selectParentTermName, parentTermName) && selectParentTermName.isEmpty && selectedTerm != PLEASE_SELECT){
              // print("States are empty so resetting the City Data...");
              parentSelectionChanged = true;
            }

          }

          // if(isDataTypePropertyState() && GeneralNotifier().change == GeneralNotifier.COUNTRY_DATA_UPDATE){
          //   print("Country has changed...");
          //   print("ParentTermList: $parentTermName SelectParentTermList: $selectParentTermName");
          //   print("Should Update Property State: $parentSelectionChanged\n");
          // }
        }

        if (parentSelectionChanged) {
          selectedTerm = PLEASE_SELECT;
          _listOfSelectedTermSlugs.clear();
          _listOfSelectedTerms.clear();
          widget.termPickerListener([], []);
          if (mounted) setState(() {});
          readTermData();
        }

      }


      if((isDataTypePropertyCity() || isDataTypePropertyState() || isDataTypePropertyArea()) &&
          GeneralNotifier().change == GeneralNotifier.RESET_FILTER_DATA) {
        selectedTerm = PLEASE_SELECT;
        _listOfSelectedTermSlugs.clear();
        _listOfSelectedTerms.clear();
        if (mounted) setState(() {});
        readTermData();
      }
    };

    GeneralNotifier().addListener(generalNotifierLister!);

    super.initState();
  }

  initializeData(){
    if (widget.selectedTermsSlugsList.isNotEmpty) {
      _listOfSelectedTermSlugs.clear();
      _listOfSelectedTermSlugs.addAll(widget.selectedTermsSlugsList);
    }

    if (widget.selectedTermsList.isNotEmpty) {
      _listOfSelectedTerms.addAll(widget.selectedTermsList.toSet().toList());
    }

    if(_listOfSelectedTerms.isNotEmpty){
      selectedTerm = _listOfSelectedTerms.toSet().toList().join(", ");
    }

    if(_termsMap.isNotEmpty || _termsMetaData.isNotEmpty) {
      hasNoTerms = false;
    }


    if (shouldChangeBasedOnParentTerm()) {
      for(Term item in _termsMetaData){
        if(item.parentTerm != null){
          showDataByParentTerm = true;
          break;
        }
      }

      if(showDataByParentTerm){
        List<String> parentTermName =  [];
        List<String> parentTermSlug =  [];

        List selectedTermNameSlug = getSelectedParentTermNameAndSlug();
        parentTermName = selectedTermNameSlug.first;
        parentTermSlug = selectedTermNameSlug.last;
        selectParentTermName = parentTermName;

        if (parentTermName.isNotEmpty && parentTermName[0] != PLEASE_SELECT &&
            _termsMetaData.isNotEmpty) {

          List updatedTermsMetaData = getDataAccordingToParentTerm(parentTermName, parentTermSlug);
          if (updatedTermsMetaData.isNotEmpty) {
            _termsMetaData.clear();

            for (int i = 0; i < updatedTermsMetaData.length; i++) {
              //if we shouldn't hide empty, add without checking.
              if (!hideEmpty) {
                _termsMetaData.add(updatedTermsMetaData[i]);
              } else {
                //if we should hide empty, then do check listing count and then add.
                if (updatedTermsMetaData[i].totalPropertiesCount != null &&
                    updatedTermsMetaData[i].totalPropertiesCount > 0) {
                  _termsMetaData.add(updatedTermsMetaData[i]);
                }
              }
            }
            if(_termsMetaData[0].name != allCapString) {
              _termsMetaData.insert(0, Term(name: allCapString, slug: allString, parent: 0));
            }
          } else {
            _termsMetaData = [Term(name: allCapString, slug: allString, parent: 0)];
            // hasNoTerms = true;
          }

          if (_termsMetaData.isEmpty) {
            _termsMetaData = [Term(name: allCapString, slug: allString, parent: 0)];
            // hasNoTerms = true;
          }


        }
      }
    }
    if(_termsMap.isNotEmpty){
      tabBarOptionsAvailable = true;
      _tempTitleList = _termsMap.keys.toList();
      if (_listOfSelectedTerms.isNotEmpty) {
        var index = _tempTitleList.indexOf(_listOfSelectedTerms.first);
        if (index != -1) {
          _selectedTermTitle = index;
          //addTitleSlugToList();
        }
      } else if (_listOfSelectedTermSlugs.isNotEmpty) {

        //make map based on slugs, so we can get the selected index.

        //first get the slugs of parent categories
        List<dynamic> termSlugKeyList = [];
        for (var element in _termsMetaData) {
          if(element.parent == 0){
            termSlugKeyList.add(element.slug);
          }
        }

        var index = termSlugKeyList.indexOf(_listOfSelectedTermSlugs.first);
        if (index != -1) {
          _selectedTermTitle = index;
          //addTitleSlugToList();
        }
      }
    }
    if(!tabBarOptionsAvailable){
      if(_listOfSelectedTerms.isNotEmpty){
        String title = _listOfSelectedTerms[0];
        int index = _termsMetaData.indexWhere((element) => element.name == title);
        if(index != -1){
          String slug = _termsMetaData[index].slug ?? "";
          if(slug.isNotEmpty){
            if(mounted) setState(() {
              _selectedTermTitle = index;
              _listOfSelectedTermSlugs.add(slug);
              _listOfSelectedTerms.add(title);
            });
          }
        }
      }
    }
    if(mounted) {
      setState(() {});
    }
  }

  List<List<String>> getSelectedParentTermNameAndSlug() {
    String mapKeyName = "";
    String mapKeySlug = "";
    List<String> parentTermName =  [];
    List<String> parentTermSlug =  [];
    Map<String, dynamic> selectedTermMap = {};

    if (isDataTypePropertyArea()) {
      //area rely on city
      mapKeyName = CITY;
      mapKeySlug = CITY_SLUG;
      if (widget.filterDataMap.containsKey(CITY)) {
        selectedTermMap = widget.filterDataMap;
      } else {
        selectedTermMap = HiveStorageManager.readSelectedCityInfo();
      }
    } else if (isDataTypePropertyCity()) {
      //city rely on state
      mapKeyName = PROPERTY_STATE;
      mapKeySlug = PROPERTY_STATE_SLUG;
      if (widget.filterDataMap.containsKey(PROPERTY_STATE)) {
        selectedTermMap = widget.filterDataMap;
      }
    } else if (isDataTypePropertyState()) {
      //states rely on country
      mapKeyName = PROPERTY_COUNTRY;
      mapKeySlug = PROPERTY_COUNTRY_SLUG;
      if (widget.filterDataMap.containsKey(PROPERTY_COUNTRY)) {
        selectedTermMap = widget.filterDataMap;
      }
    }

    if (selectedTermMap.isNotEmpty) {
      var selectedTerm = selectedTermMap[mapKeyName];
      var selectedTermSlug = selectedTermMap[mapKeySlug];

      if (selectedTerm is List && selectedTermSlug is List) {
        for (int index = 0; index < selectedTerm.length; index++) {
          if (selectedTerm[index] == allCapString) continue;
          parentTermName.add(selectedTerm[index].toString().toLowerCase());
        }
        for (int index = 0; index < selectedTermSlug.length; index++) {
          if (selectedTermSlug[index] == allString) continue;
          parentTermSlug.add(selectedTermSlug[index].toString().toLowerCase());
        }
      } else if (selectedTerm is String && selectedTermSlug is String) {
        if (selectedTerm != allCapString) {
          parentTermName = [selectedTerm];
          parentTermSlug = [selectedTermSlug];
        }
      }
    }
    return [parentTermName, parentTermSlug];
  }

  getDataAccordingToParentTerm(List<String> parentName, List<String> parentSlug) {
    List updatedTermsMetaData = [];
    if (parentName.length == 0) {
      updatedTermsMetaData.addAll(_termsMetaData);
      return updatedTermsMetaData;
    }
    for (Term item in _termsMetaData) {
      if (item.parentTerm != null &&
          (parentName.contains(item.parentTerm!.toLowerCase()) || parentSlug.contains(item.parentTerm!.toLowerCase())) ) {
        updatedTermsMetaData.add(item);
      }
    }
    return updatedTermsMetaData;
  }

  void addTitleSlugToList(){
    if(_tempTitleList.isNotEmpty){
      String title = _tempTitleList[_selectedTermTitle] ?? "";
      int index = _termsMetaData.indexWhere((element) => element.name == title);
      if(index != -1){
        String? slug = _termsMetaData[index].slug;
        if(slug != null && slug.isNotEmpty){
          setState(() {
            _listOfSelectedTermSlugs.add(slug);
            _listOfSelectedTerms.add(title);
          });
        }
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
    dropDownTextController.dispose();
    if (generalNotifierLister != null) {
      GeneralNotifier().removeListener(generalNotifierLister!);
    }
  }

  @override
  Widget build(BuildContext context) {

    _listOfSelectedTerms = widget.selectedTermsList;
    _listOfSelectedTermSlugs = widget.selectedTermsSlugsList;

    if (widget.pickerType == dropDownPicker) {
      if (_listOfSelectedTerms.isNotEmpty &&
          _listOfSelectedTerms.toSet().toList().length == 1) {
        dropDownTextController.text =
            "${UtilityMethods.getLocalizedString(_listOfSelectedTerms.toSet().toList().first)}";
      } else if (_listOfSelectedTerms.isNotEmpty &&
          _listOfSelectedTerms.toSet().toList().length > 1) {
        dropDownTextController.text = UtilityMethods.getLocalizedString(
            "multi_select_drop_down_item_selected",
            inputWords: [
              (_listOfSelectedTerms.toSet().toList().length.toString())
            ]);
      }else if(_listOfSelectedTerms.isEmpty){
        dropDownTextController.text = UtilityMethods.getLocalizedString(allCapString);
      }
    }

    if(_listOfSelectedTerms.isEmpty && _listOfSelectedTermSlugs.isEmpty){
      _selectedTermTitle = 0;
      selectedTerm = PLEASE_SELECT;
    }

    // if(isDataTypePropertyCity()){
    //   print("_listOfSelectedTerms: $_listOfSelectedTerms");
    //   print("_listOfSelectedTermSlugs: $_listOfSelectedTermSlugs");
    // }

    return GenericTermPickerWidget(
      objDataType: widget.objDataType,
      showDivider: widget.showDivider,
      loadingData: loadingData,
      hasNoTerms: hasNoTerms,
      pickerTitle: widget.pickerTitle,
      pickerType: widget.pickerType,
      pickerIcon: widget.pickerIcon,
      tabBarOptionsAvailable: tabBarOptionsAvailable,
      termsMetaData: _termsMetaData,
      selectedTermTitle: _selectedTermTitle,
      dropDownTextController: dropDownTextController,
      selectedTerm: selectedTerm,
      listOfSelectedTerms: _listOfSelectedTerms,
      listOfSelectedTermSlugs: _listOfSelectedTermSlugs,
      tempTitleList: _tempTitleList,
      onFullScreenTypeItemTap: ()=> termPickerFullScreenOnItemPressed(),
      termsDataMap: _termsMap,
      showSearchBar: widget.showSearchBar,
      listener: ({selectedItemsList, selectedItemsSlugsList, selectedTab}) {
        if(mounted) setState(() {

          //onSegmentChosen
          if(selectedTab != null){
            onSegmentChosen(
                selectedTab,
                tabBarOptionsAvailable
                    ? _tempTitleList
                    : _termsMetaData,
            );
          }

          if(selectedItemsList != null && selectedItemsSlugsList != null){
            _listOfSelectedTerms = selectedItemsList;
            _listOfSelectedTermSlugs = selectedItemsSlugsList;
            widget.termPickerListener(selectedItemsSlugsList, selectedItemsList);
          }

        });
      },
    );
  }

  void termPickerFullScreenOnItemPressed(){
    if(_termsMetaData.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => TermPickerFullScreen(
          title: "${UtilityMethods.getLocalizedString("select")} "
              "${UtilityMethods.getLocalizedString(widget.pickerTitle)}",
          termType: widget.objDataType,
          termMetaDataList: _termsMetaData,
          termsDataMap: _termsMap,
          termPickerFullScreenListener: (String pickedTerm, int? pickedTermId, String pickedTermSlug){
            if(mounted) {
              setState(() {
                if (pickedTerm.isNotEmpty) {
                  selectedTerm = pickedTerm;
                  _listOfSelectedTerms = [pickedTerm];
                }

                if (pickedTermSlug.isNotEmpty) {
                  _listOfSelectedTermSlugs = [pickedTermSlug];
                }
              });
            }
            widget.termPickerListener(_listOfSelectedTermSlugs, _listOfSelectedTerms);
          },
        ),
      ),
      );
    }
  }

  onSegmentChosen(int index, List<dynamic> dataList) {
    if(mounted) setState(() {
      _selectedTermTitle = index;
    });

    _listOfSelectedTerms.clear();
    _listOfSelectedTermSlugs.clear();

    String slug = "";
    String title = "";

    if(dataList[_selectedTermTitle].runtimeType == Term){
      title = dataList[_selectedTermTitle].name ?? "";
      slug = dataList[_selectedTermTitle].slug ?? "";
    }else{
      title = dataList[_selectedTermTitle] ?? "";
      int itemIndex = _termsMetaData.indexWhere((element) => element.name == title);
      if(itemIndex != -1){
        slug = _termsMetaData[itemIndex].slug ?? "";
      }
    }


    if(mounted) {
      setState(() {
        if (title.isNotEmpty) {
          _listOfSelectedTerms.add(title);
        }

        if (slug.isNotEmpty) {
          _listOfSelectedTermSlugs.add(slug);
        }
      });
    }
    widget.termPickerListener(_listOfSelectedTermSlugs, _listOfSelectedTerms);
  }

  bool shouldChangeBasedOnParentTerm() {
    if (widget.objDataType == propertyStateDataType
        || widget.objDataType == propertyCityDataType
        || widget.objDataType == propertyAreaDataType) {
      return true;
    }
    return false;
  }

  bool isDataTypePropertyStatus() {
    if (widget.objDataType == propertyStatusDataType) {
      return true;
    }
    return false;
  }
  bool isDataTypePropertyType() {
    if (widget.objDataType == propertyTypeDataType) {
      return true;
    }
    return false;
  }
  bool isDataTypePropertyLabel() {
    if (widget.objDataType == propertyLabelDataType) {
      return true;
    }
    return false;
  }
  bool isDataTypePropertyState() {
    if (widget.objDataType == propertyStateDataType) {
      return true;
    }
    return false;
  }
  bool isDataTypePropertyCountry() {
    if (widget.objDataType == propertyCountryDataType) {
      return true;
    }
    return false;
  }
  bool isDataTypePropertyFeature() {
    if (widget.objDataType == propertyFeatureDataType) {
      return true;
    }
    return false;
  }
  bool isDataTypePropertyCity() {
    if (widget.objDataType == propertyCityDataType) {
      return true;
    }
    return false;
  }
  bool isDataTypePropertyArea() {
    if (widget.objDataType == propertyAreaDataType) {
      return true;
    }
    return false;
  }

  readTermData() {
    List<dynamic> termsMetaData = [];
    if (isDataTypePropertyStatus()){
      tempDataHolderMap.clear();
      tempDataHolderMap = HiveStorageManager.readPropertyStatusMapData() ?? {};
      termsMetaData = HiveStorageManager.readPropertyStatusMetaData() ?? [];
    }

    if (isDataTypePropertyType()){
      tempDataHolderMap.clear();
      tempDataHolderMap = HiveStorageManager.readPropertyTypesMapData() ?? {};
      termsMetaData = HiveStorageManager.readPropertyTypesMetaData() ?? [];
    }

    if (isDataTypePropertyLabel()){
      termsMetaData = HiveStorageManager.readPropertyLabelsMetaData() ?? [];
    }

    if (isDataTypePropertyState()){
      termsMetaData = HiveStorageManager.readPropertyStatesMetaData() ?? [];
    }

    if (isDataTypePropertyCountry()){
      termsMetaData = HiveStorageManager.readPropertyCountriesMetaData() ?? [];
    }

    if (isDataTypePropertyFeature()){
      termsMetaData = HiveStorageManager.readPropertyFeaturesMetaData() ?? [];
    }

    if (isDataTypePropertyCity()){
      termsMetaData = HiveStorageManager.readCitiesMetaData() ?? [];
    }

    if (isDataTypePropertyArea()){
      termsMetaData = HiveStorageManager.readPropertyAreaMetaData() ?? [];
    }

    if(tempDataHolderMap.isNotEmpty){
      _termsMap.clear();
      if(!_termsMap.containsKey(allCapString)){
        _termsMap[allCapString] = [];
      }
      _termsMap.addAll(tempDataHolderMap);
    }

    if(termsMetaData.isNotEmpty){

      _termsMetaData.clear();

      for (int i = 0; i < termsMetaData.length; i++) {
        //if we shouldn't hide empty, add without checking.
        if (!hideEmpty) {
          _termsMetaData.add(termsMetaData[i]);
        } else {
          //if we should hide empty, then do check listing count and then add.
          if (termsMetaData[i].totalPropertiesCount != null &&
              termsMetaData[i].totalPropertiesCount > 0) {
            _termsMetaData.add(termsMetaData[i]);
          }
        }
      }
      if(_termsMetaData[0].name != allCapString) {
        _termsMetaData.insert(0, Term(name: allCapString, slug: allString, parent: 0));
      }
      initializeData();
    }else{
      getAndStoreTermData();
    }

    // Clear the Temp Map Memory
    tempDataHolderMap.clear();
  }

  getAndStoreTermData(){
    fetchTermData(widget.objDataType).then((value) {
      if(value.isNotEmpty){
        if(mounted){
          setState(() {
            List<dynamic> termsMetaData = value;

            if(termsMetaData.isNotEmpty){
              UtilityMethods.storePropertyMetaDataList(
                dataType: widget.objDataType,
                metaDataList: termsMetaData,
                metaDataMap: _termsMap,
              );
              tempDataHolderMap.clear();
              _termsMetaData.clear();

              for (int i = 0; i < termsMetaData.length; i++) {
                //if we shouldn't hide empty, add without checking.
                if (!hideEmpty) {
                  _termsMetaData.add(termsMetaData[i]);
                } else {
                  //if we should hide empty, then do check listing count and then add.
                  if (termsMetaData[i].totalPropertiesCount != null &&
                      termsMetaData[i].totalPropertiesCount > 0) {
                    _termsMetaData.add(termsMetaData[i]);
                  }
                }
              }

              tempDataHolderMap = UtilityMethods.getParentAndChildCategorizedMap(metaDataList: _termsMetaData);
              if(tempDataHolderMap.isNotEmpty){
                _termsMap.clear();
                if(!_termsMap.containsKey(allCapString)){
                  _termsMap[allCapString] = [];
                }
                _termsMap.addAll(tempDataHolderMap);
                tempDataHolderMap.clear();
              }
            }
          });
        }

        initializeData();
      }
      return null;
    });
  }

  Future<List<dynamic>> fetchTermData(String term) async {
    if(mounted){
      setState(() {
        loadingData = true;
        hasNoTerms = false;
      });
    }
    List<dynamic> termData = [];
    List<dynamic> tempTermData = await _propertyBloc.fetchTermData(term);
    if(tempTermData == null ||
        (tempTermData.isNotEmpty && tempTermData[0] == null) ||
        (tempTermData.isNotEmpty && tempTermData[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          loadingData = false;
          hasNoTerms = true;
        });
      }
      return termData;
    }else{
      if (mounted) {
        setState(() {
          loadingData = false;
          hasNoTerms = false;
        });
      }
      if(tempTermData.isNotEmpty){
        termData.addAll(tempTermData);
      }
    }

    return termData;
  }

}

typedef GenericTermPickerWidgetListener = Function({
  int? selectedTab,
  List<dynamic>? selectedItemsList,
  List<dynamic>? selectedItemsSlugsList,
});

class GenericTermPickerWidget extends StatefulWidget {
  final bool hasNoTerms;
  final bool showDivider;
  final bool loadingData;
  final String pickerType;
  final Icon pickerIcon;
  final String pickerTitle;
  final String selectedTerm;
  final String? objDataType;
  final List<dynamic> termsMetaData;
  final void Function()? onFullScreenTypeItemTap;
  final TextEditingController dropDownTextController;
  final List<dynamic> listOfSelectedTerms;
  final List<dynamic> listOfSelectedTermSlugs;
  final bool tabBarOptionsAvailable;
  final List<dynamic> tempTitleList;
  final int selectedTermTitle;
  final Map<String, dynamic> termsDataMap;
  final GenericTermPickerWidgetListener listener;
  final bool? showSearchBar;

  const GenericTermPickerWidget({
    Key? key,
    required this.hasNoTerms,
    required this.loadingData,
    required this.pickerType,
    required this.pickerIcon,
    required this.pickerTitle,
    required this.selectedTerm,
    required this.termsMetaData,
    required this.onFullScreenTypeItemTap,
    required this.dropDownTextController,
    required this.listOfSelectedTerms,
    required this.listOfSelectedTermSlugs,
    required this.tabBarOptionsAvailable,
    required this.tempTitleList,
    required this.selectedTermTitle,
    required this.termsDataMap,
    required this.listener,
    this.objDataType,
    this.showSearchBar = false,
    this.showDivider = true,
  }) : super(key: key);

  @override
  State<GenericTermPickerWidget> createState() => _GenericTermPickerWidgetState();
}

class _GenericTermPickerWidgetState extends State<GenericTermPickerWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.hasNoTerms
        ? Container()
        : Container(
            padding: widget.pickerType == fullScreenTermPicker
                ? const EdgeInsets.symmetric(vertical: 10)
                : const EdgeInsets.symmetric(vertical: 20),
            decoration: widget.showDivider
                ? BoxDecoration(
              border: Border(
                top: AppThemePreferences().appTheme.filterPageBorderSide!,
              ),
            )
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: widget.pickerType == fullScreenTermPicker
                      ? const EdgeInsets.only(top: 10)
                      : const EdgeInsets.only(top: 0),
                  child: TermPickerHeaderWidget(
                    pickerIcon: widget.pickerIcon,
                    pickerTitle: widget.pickerTitle,
                  ),
                ),
                widget.loadingData
                    ? DataLoadingWidget()
                    : Column(
                        children: [
                          if (widget.pickerType == fullScreenTermPicker)
                            FullScreenViewWidget(
                              onFullScreenTypeItemTap: widget.onFullScreenTypeItemTap,
                              selectedTerm: widget.selectedTerm,
                              termsMetaData: widget.termsMetaData,
                            )
                          else if (widget.pickerType == boxTermPicker)
                            TermPickerBox(
                              title: 'TermPickerBox',
                              termMetaDataList: widget.termsMetaData,
                              termsDataMap: widget.termsDataMap,
                              termType: widget.objDataType!,
                              selectedItemsList: widget.listOfSelectedTerms,
                              selectedItemsSlugsList: widget.listOfSelectedTermSlugs,
                              addAllinData: true,
                              termPickerBoxListener: (selectedItems, selectedItemsSlugs) {
                                widget.listener(
                                  selectedItemsList: selectedItems,
                                  selectedItemsSlugsList: selectedItemsSlugs,
                                );
                              },
                            )
                          else
                            widget.pickerType == dropDownPicker
                                ? DropDownViewWidget(
                                    termsMetaData: widget.termsMetaData,
                                    dropDownTextController: widget.dropDownTextController,
                                    listOfSelectedTerms: widget.listOfSelectedTerms,
                                    listOfSelectedTermSlugs: widget.listOfSelectedTermSlugs,
                                    objDataType: widget.objDataType,
                                    showSearchBar: widget.showSearchBar,
                                    listener: (selectedItems, selectedItemsSlugs) {
                                      widget.listener(
                                        selectedItemsList: selectedItems,
                                        selectedItemsSlugsList: selectedItemsSlugs,
                                      );

                                    },
                                  )
                                : TabBarWidget(
                                    termsMetaData: widget.termsMetaData,
                                    selectedTermTitle: widget.selectedTermTitle,
                                    tabBarOptionsAvailable: widget.tabBarOptionsAvailable,
                                    tempTitleList: widget.tempTitleList,
                                    termsDataMap: widget.termsDataMap,
                                    listOfSelectedTerm: widget.listOfSelectedTerms,
                                    listOfSelectedTermSlugs: widget.listOfSelectedTermSlugs,
                                    listener: widget.listener,
                                  ),
                        ],
                      ),
              ],
            ),
          );
  }
}

class TermPickerHeaderWidget extends StatefulWidget {
  final Icon pickerIcon;
  final String pickerTitle;

  const TermPickerHeaderWidget({
    Key? key,
    required this.pickerIcon,
    required this.pickerTitle,
  }) : super(key: key);

  @override
  State<TermPickerHeaderWidget> createState() => _TermPickerHeaderWidgetState();
}

class _TermPickerHeaderWidgetState extends State<TermPickerHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: widget.pickerIcon,
        ),
        Expanded(
          flex: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GenericTextWidget(
                widget.pickerTitle,
                style: AppThemePreferences().appTheme.filterPageHeadingTitleTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FullScreenViewWidget extends StatefulWidget {
  final String selectedTerm;
  final List<dynamic> termsMetaData;
  final void Function()? onFullScreenTypeItemTap;

  const FullScreenViewWidget({
    Key? key,
    required this.selectedTerm,
    required this.termsMetaData,
    required this.onFullScreenTypeItemTap,
  }) : super(key: key);

  @override
  State<FullScreenViewWidget> createState() => _FullScreenViewWidgetState();
}

class _FullScreenViewWidgetState extends State<FullScreenViewWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.termsMetaData.isEmpty
        ? Container()
        : InkWell(
            onTap: widget.onFullScreenTypeItemTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: GenericTextWidget(
                              widget.selectedTerm == PLEASE_SELECT
                                  ? UtilityMethods.getLocalizedString(
                                      "please_select")
                                  : UtilityMethods.getLocalizedString(
                                      widget.selectedTerm),
                              style: AppThemePreferences()
                                  .appTheme
                                  .filterPageTempTextPlaceHolderTextStyle,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: AppThemePreferences()
                            .appTheme
                            .filterPageArrowForwardIcon!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

typedef DropDownViewWidgetListener = Function(
  List<dynamic> selectedItems,
  List<dynamic> selectedItemsSlugs,
);

class DropDownViewWidget extends StatelessWidget {
  final TextEditingController dropDownTextController;
  final DropDownViewWidgetListener listener;
  final List<dynamic> termsMetaData;
  final List<dynamic> listOfSelectedTerms;
  final List<dynamic> listOfSelectedTermSlugs;
  final String? objDataType;
  final bool? showSearchBar;

  DropDownViewWidget({
    Key? key,
    this.objDataType,
    required this.dropDownTextController,
    required this.listener,
    required this.termsMetaData,
    required this.listOfSelectedTerms,
    required this.listOfSelectedTermSlugs,
    this.showSearchBar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: TextFormField(
            controller: dropDownTextController,
            decoration: AppThemePreferences.formFieldDecoration(
              hintText: UtilityMethods.getLocalizedString("select"),
              suffixIcon: Icon(AppThemePreferences.dropDownArrowIcon),
            ),
            readOnly: true,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              _showMultiSelect(context);
            },
          ),
        ),
      ],
    );
  }

  void _showMultiSelect(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialogWidget(
          title: UtilityMethods.getLocalizedString("select"),
          showSearchBar: showSearchBar ?? false,
          objDataType: objDataType,
          dataItemsList: termsMetaData,
          selectedItemsList: listOfSelectedTerms,
          selectedItemsSlugsList: listOfSelectedTermSlugs,
          multiSelectDialogWidgetListener: (listOfSelectedItems, listOfSelectedItemsSlugs) {
            listener(listOfSelectedItems, listOfSelectedItemsSlugs);
          },
        );
      },
    );
  }
}

typedef TabBarWidgetListener = Function({
  int? selectedTab,
  List<dynamic>? selectedItemsList,
  List<dynamic>? selectedItemsSlugsList,
});

class TabBarWidget extends StatelessWidget {
  final bool tabBarOptionsAvailable;
  final List<dynamic> termsMetaData;
  final List<dynamic> tempTitleList;
  final int selectedTermTitle;
  final Map<String, dynamic> termsDataMap;
  final List<dynamic> listOfSelectedTermSlugs;
  final List<dynamic> listOfSelectedTerm;
  final TabBarWidgetListener listener;

  const TabBarWidget({
    Key? key,
    required this.tabBarOptionsAvailable,
    required this.termsMetaData,
    required this.tempTitleList,
    required this.selectedTermTitle,
    required this.termsDataMap,
    required this.listOfSelectedTerm,
    required this.listOfSelectedTermSlugs,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tabBarOptionsAvailable
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabsHeaderWidget(
                dataList: tempTitleList,
                selectedTermTitle: selectedTermTitle,
                listener: (selectedTabIndex) => listener(selectedTab: selectedTabIndex),
              ),
              TabBarOptionsWidget(
                dataList: tempTitleList,
                selectedTermIndex: selectedTermTitle,
                termsDataMap: termsDataMap,
                listOfSelectedTerm: listOfSelectedTerm,
                listOfSelectedTermSlugs: listOfSelectedTermSlugs,
                listener: (selectedItems, selectedItemsSlugs) {
                  listener(
                    selectedItemsList: selectedItems,
                    selectedItemsSlugsList: selectedItemsSlugs,
                  );
                },
              ),
            ],
          )
        : TabsHeaderWidget(
            dataList: termsMetaData,
            selectedTermTitle: selectedTermTitle,
            listener: (selectedTabIndex) => listener(selectedTab: selectedTabIndex),
          );
  }
}

typedef TabsHeaderWidgetListener = Function(int selectedTabIndex);

class TabsHeaderWidget extends StatelessWidget {
  final int selectedTermTitle;
  final List<dynamic> dataList;
  final TabsHeaderWidgetListener listener;

  const TabsHeaderWidget({
    Key? key,
    required this.selectedTermTitle,
    required this.dataList,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: SegmentedControlWidget(
          itemList: dataList,
          selectionIndex: selectedTermTitle,
          padding: EdgeInsets.only(left: 10, right: 10),
          onSegmentChosen: listener,
        )

      // SingleChildScrollView(
      //   scrollDirection: Axis.horizontal,
      //   child: Row(
      //     children: [
      //       MaterialSegmentedControl(
      //         children: dataList.map((item) {
      //           var index = dataList.indexOf(item);
      //           return Container(
      //             padding:  const EdgeInsets.only(left: 10, right: 10),
      //             child: genericTextWidget(
      //               item.runtimeType == Term ?
      //               UtilityMethods.getLocalizedString(item.name) : UtilityMethods.getLocalizedString(item),
      //               style: TextStyle(
      //                 fontSize: AppThemePreferences.tabBarTitleFontSize,
      //                 fontWeight: AppThemePreferences.tabBarTitleFontWeight,
      //                 color: _selectedTermTitle == index ? AppThemePreferences().appTheme.selectedItemTextColor :
      //                 AppThemePreferences.unSelectedItemTextColorLight,
      //               ),),
      //           );
      //         },).toList().asMap(),
      //
      //         selectionIndex: _selectedTermTitle,
      //         unselectedColor: AppThemePreferences().appTheme.unSelectedItemBackgroundColor,
      //         selectedColor: AppThemePreferences().appTheme.selectedItemBackgroundColor!,
      //         borderRadius: 5.0,
      //         verticalOffset: 8.0,
      //         onSegmentChosen: (index){
      //           setState(() {
      //             _selectedTermTitle = index;
      //           });
      //
      //           _listOfSelectedTerms.clear();
      //           _listOfSelectedTermSlugs.clear();
      //
      //           String slug = "";
      //           String title = "";
      //
      //           if(dataList[_selectedTermTitle].runtimeType == Term){
      //             title = dataList[_selectedTermTitle].name;
      //             slug = dataList[_selectedTermTitle].slug;
      //           }else{
      //             title = dataList[_selectedTermTitle];
      //             int itemIndex = _termsMetaData.indexWhere((element) => element.name == title);
      //             if(itemIndex != null && itemIndex != -1){
      //               slug = _termsMetaData[itemIndex].slug;
      //             }
      //           }
      //
      //
      //           if(mounted) {
      //             setState(() {
      //               if (title != null && title.isNotEmpty) {
      //                 _listOfSelectedTerms.add(title);
      //               }
      //
      //               if (slug != null && slug.isNotEmpty) {
      //                 _listOfSelectedTermSlugs.add(slug);
      //               }
      //             });
      //           }
      //           widget.termPickerListener(_listOfSelectedTermSlugs, _listOfSelectedTerms);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

typedef TabBarOptionsWidgetListener = Function(
  List<dynamic> selectedItems,
  List<dynamic> selectedItemsSlugs,
);

class TabBarOptionsWidget extends StatelessWidget {
  final List<dynamic> dataList;
  final int selectedTermIndex;
  final Map<String, dynamic> termsDataMap;
  final List<dynamic> listOfSelectedTermSlugs;
  final List<dynamic> listOfSelectedTerm;
  final TabBarOptionsWidgetListener listener;

  TabBarOptionsWidget({
    Key? key,
    required this.dataList,
    required this.selectedTermIndex,
    required this.termsDataMap,
    required this.listOfSelectedTerm,
    required this.listOfSelectedTermSlugs,
    required this.listener,
  }) : super(key: key);

  String itemKey = "";
  List<dynamic> selectedItems = [];
  List<dynamic> selectedItemsSlugs = [];

  @override
  Widget build(BuildContext context) {
    itemKey = dataList[selectedTermIndex] ?? "";
    selectedItems = listOfSelectedTerm;
    selectedItemsSlugs = listOfSelectedTermSlugs;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Wrap(
        children: (termsDataMap[itemKey]).map<Widget>((item) =>
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ChoiceChipWidget(
                label: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GenericTextWidget(
                    UtilityMethods.getLocalizedString(item.name),
                    style: AppThemePreferences().appTheme
                        .filterPageChoiceChipTextStyle,
                  ),
                ),
                selected: listOfSelectedTermSlugs.contains(item.slug),
                selectedColor: AppThemePreferences().appTheme
                    .selectedItemBackgroundColor,
                onSelected: (bool selected) {
                  if (selected == true) {
                    selectedItems.add(item.name);
                    selectedItemsSlugs.add(item.slug);
                  }
                  if (selected == false) {
                    selectedItems.remove(item.name);
                    selectedItemsSlugs.remove(item.slug);
                  }

                  listener(selectedItems, selectedItemsSlugs);
                },

                labelStyle: TextStyle(
                  color: listOfSelectedTermSlugs.contains(item.slug)
                      ? AppThemePreferences().appTheme.selectedItemTextColor
                      : Colors.black,
                ),
                backgroundColor: AppThemePreferences().appTheme
                    .unSelectedItemBackgroundColor,
                // backgroundColor: AppThemePreferences().appTheme.searchPageChoiceChipsBackgroundColor,
                shape: AppThemePreferences.roundedCorners(AppThemePreferences
                    .searchPageChoiceChipsRoundedCornersRadius),
              ),
            )).toList(),
      ),
    );
  }
}

