import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:shimmer/shimmer.dart';

typedef TermPickerFullScreenListener = void Function(
  String pickedTerm,
  int? pickedTermId,
  String pickedTermSlug);

class TermPickerFullScreen extends StatefulWidget{
  final String title;
  final List<dynamic> termMetaDataList;
  final Map<String, dynamic> termsDataMap;
  final TermPickerFullScreenListener? termPickerFullScreenListener;
  final String termType;
  final bool addAllinData;
  final bool fromSequential;
  final bool showLoadingWidget;

  const TermPickerFullScreen({
    super.key,
    required this.title,
    required this.termMetaDataList,
    required this.termsDataMap,
    required this.termPickerFullScreenListener,
    required this.termType,
    this.addAllinData = true,
    this.fromSequential = false,
    this.showLoadingWidget = false,
  });

  @override
  State<StatefulWidget> createState() => TermPickerFullScreenState();
}

class TermPickerFullScreenState extends State<TermPickerFullScreen>{

  List<dynamic> termMetaDataList = [];
  List<String> termNamesDataList = [];
  Map<String, dynamic> termsDataMap = {};
  List<String> termDataMapKeysList = [];

  int? _selectedTermId;
  String _selectedTerm = "";
  bool _showList = false;
  bool isDarkMode = false;

  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState> key = GlobalKey();
  GlobalKey<AutoCompleteTextFieldState> countrySuggestionsKey = GlobalKey();
  GlobalKey<AutoCompleteTextFieldState> stateSuggestionsKey = GlobalKey();
  GlobalKey<AutoCompleteTextFieldState> citySuggestionsKey = GlobalKey();
  GlobalKey<AutoCompleteTextFieldState> areaSuggestionsKey = GlobalKey();
  final TextEditingController _controller = TextEditingController();

  Term allTermObject = Term(
    name: "All",
    slug: "all",
    id: null,
  );


  @override
  void initState() {
    super.initState();
    loadData();
  }

  // For suggestions state management purpose
  GlobalKey<AutoCompleteTextFieldState> getKey(String termType) {
    if (widget.fromSequential) {
      if (termType == propertyCountryDataType) {
        return countrySuggestionsKey;
      } else if (termType == propertyStateDataType) {
        return stateSuggestionsKey;
      } else if (termType == propertyCityDataType) {
        return citySuggestionsKey;
      } else if (termType == propertyAreaDataType) {
        return areaSuggestionsKey;
      }
    }
    return key;
  }

  loadData() {
    bool hideEmpty = HooksConfigurations.hideEmptyTerm != null
        ? HooksConfigurations.hideEmptyTerm(widget.termType)
        : false;
    termMetaDataList = [];
    termNamesDataList = [];
    for(int i = 0; i < widget.termMetaDataList.length; i++){
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

    if(termMetaDataList.isNotEmpty){
      if(mounted){
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
      for(int i = 0; i < termMetaDataList.length; i++){
        termNamesDataList.add(termMetaDataList[i].name);
      }

      if (widget.addAllinData) {
        // Addition check: Add 'All' item if not in list
        if(!termNamesDataList.contains("All")){
          termNamesDataList.insert(0, "All");
        }
      }

      termNamesDataList = termNamesDataList.toSet().toList();
    }

    if(widget.termsDataMap.isNotEmpty){
      termsDataMap = widget.termsDataMap;
      termDataMapKeysList = termsDataMap.keys.toList();
    } else {
      if(termMetaDataList.isNotEmpty){
        Map<String, dynamic> tempTermsDataMap = {};
        List< dynamic> tempList = [];
        tempList.addAll(termMetaDataList);

        if(tempList[0].name == "All"){
          tempList.removeAt(0);
        }

        tempTermsDataMap = UtilityMethods.getParentAndChildCategorizedMap(metaDataList: tempList);
        if(tempTermsDataMap.isNotEmpty){
          if (widget.addAllinData) {
            tempTermsDataMap["All"] = [];
          }
          termsDataMap = {};
          termsDataMap.addAll(tempTermsDataMap);
          termDataMapKeysList = termsDataMap.keys.toList();
        }
      }
    }

    if(termsDataMap.isNotEmpty){
      termMetaDataList = reArrangeListAccordingToMap(termsDataMap, termMetaDataList);
    }
    if (widget.addAllinData) {
      // Add 'all' term if not in list
      if(termMetaDataList.contains(allTermObject)){
        termMetaDataList.remove(allTermObject);
      }
      termMetaDataList.insert(0, allTermObject);
    }

    // print("termsDataMap: $termsDataMap");
    // print("termDataMapKeysList: $termDataMapKeysList");
  }

  List<dynamic> reArrangeListAccordingToMap(Map<String, dynamic> dataMap, List<dynamic> metaDataList){
    List<dynamic> dataList = [];
    List<String> mapKeys = dataMap.keys.toList();
    if(mapKeys.isNotEmpty){
      for(var key in mapKeys){
        if (key == "All" && widget.addAllinData) {
          dataList.add(allTermObject);
        } else {
          Term? termItem = metaDataList.firstWhereOrNull((element) => (element is Term && element.name == key));
          if(termItem != null){
            dataList.add(termItem);
            dataList.addAll(dataMap[key]);
          }
        }
      }
    }

    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fromSequential) {
      loadData();
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
          elevation: 0.0,
          appBarTitle: widget.title,
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppThemePreferences().appTheme.primaryColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: AutoCompleteTextField(
                        key: getKey(widget.termType),
                        suggestions: termNamesDataList.toSet().toList(),
                        textInputAction: TextInputAction.search,
                        submitOnSuggestionTap: true,
                        controller: _controller,
                        clearOnSubmit: false,
                        decoration: InputDecoration(
                          hintText: UtilityMethods.getLocalizedString("search"),
                          hintStyle:
                              AppThemePreferences().appTheme.searchBarTextStyle,
                          border: InputBorder.none,
                          suffixIcon: AppThemePreferences()
                              .appTheme
                              .homeScreenSearchBarIcon,
                          contentPadding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                        ),
                        itemBuilder: (context, item) {
                          return Container(
                            color: AppThemePreferences().appTheme.cardColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    child: Container(
                                      decoration: decoration(),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 15.0),
                                      child: GenericTextWidget(
                                        UtilityMethods.getLocalizedString(item),
                                        style: AppThemePreferences()
                                            .appTheme
                                            .subBody01TextStyle,
                                      ),
                                    ),
                                    onTap: () {
                                      if (item == "All") {
                                        widget.termPickerFullScreenListener!(
                                            "All", null, "all");
                                      } else {
                                        _selectedTerm = item;
                                        int index = termNamesDataList
                                            .indexOf(_selectedTerm);
                                        if (index != -1) {
                                          _selectedTermId =
                                              termMetaDataList[index].id;
                                          String termSlug =
                                              termMetaDataList[index].slug;
                                          widget.termPickerFullScreenListener!(
                                              _selectedTerm,
                                              _selectedTermId!,
                                              termSlug);
                                        }
                                      }

                                      if (!widget.fromSequential) {
                                        Navigator.of(context).pop();
                                      } else {
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        _controller.text = "";
                                        loadData();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemSorter: (a, b) {
                          return a.compareTo(b);
                        },
                        itemFilter: (item, query) {
                          return item
                              .toLowerCase()
                              .startsWith(query.toLowerCase());
                        },
                        textChanged: (text) {
                          if (text.isNotEmpty) {
                            if (mounted)
                              setState(() {
                                _showList = false;
                              });
                          } else if (text.isEmpty) {
                            if (mounted)
                              setState(() {
                                _showList = true;
                              });
                          }
                        },
                        textSubmitted: (text) {
                          // print("text: $text");
                        },
                        itemSubmitted: (item) {
                          // print("Submitted");
                          // print("item: $item");
                          //
                          // searchTextField.textField.controller.text = item;
                        },
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color:
                      AppThemePreferences().appTheme.searchBarBackgroundColor,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ),

            widget.showLoadingWidget
                ? LoadingWidget()
                : _showList
                    ? Flexible(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: termMetaDataList.length,
                          itemBuilder: (context, int index) {
                            String item = termMetaDataList[index].name;
                            String listItem =
                                UtilityMethods.getLocalizedString(item);
                            if (termDataMapKeysList.isNotEmpty &&
                                !(termDataMapKeysList.contains(item))) {
                              listItem =
                                  " - ${UtilityMethods.getLocalizedString(item)}";
                            }

                            return InkWell(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 15.0),
                                child: GenericTextWidget(
                                  UtilityMethods.getLocalizedString(listItem),
                                  style: AppThemePreferences()
                                      .appTheme
                                      .subBody01TextStyle,
                                ),
                                decoration: decoration(),
                              ),
                              onTap: () {
                                if (termMetaDataList[index].name == "All") {
                                  widget.termPickerFullScreenListener!(
                                      "All", null, "all");
                                } else {
                                  _selectedTerm = termMetaDataList[index].name;
                                  _selectedTermId = termMetaDataList[index].id;
                                  String termSlug =
                                      termMetaDataList[index].slug;
                                  widget.termPickerFullScreenListener!(
                                      _selectedTerm,
                                      _selectedTermId!,
                                      termSlug);
                                }

                                if (!widget.fromSequential) {
                                  Navigator.of(context).pop();
                                }
                              },
                            );
                          },
                        ),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }

  Decoration decoration(){
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: AppThemePreferences().appTheme.dividerColor!,
        ),
      ),
    );
  }

}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
      child: SizedBox(
        height: 300,
        child: Shimmer.fromColors(
          baseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor!,
          highlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor!,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                children: [
                  LoadingWidgetContainer(),
                  LoadingWidgetContainer(),
                  LoadingWidgetContainer(),
                ],
              ),
            ),
            itemCount: 1,
          ),
        ),
      ),
    );
  }
}

class LoadingWidgetContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;

  const LoadingWidgetContainer({
    super.key,
    this.width = double.infinity,
    this.height = 50,
    this.decoration,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: padding,
          width: width,
          height: height,
          decoration: decoration ?? BoxDecoration(
            color: AppThemePreferences.shimmerLoadingWidgetContainerColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Padding(padding: padding ?? const EdgeInsets.only(bottom: 30.0)),
      ],
    );
  }
}

