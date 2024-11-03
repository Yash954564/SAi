import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

import 'package:houzi_package/common/constants.dart';

typedef CityPickerListener = void Function(String pickedCity, int? pickedCityId, String pickedCitySlug);

class CityPicker extends StatefulWidget{
  final List<dynamic> citiesMetaDataList;
  final CityPickerListener? cityPickerListener;

  CityPicker({
    required this.citiesMetaDataList,
    required this.cityPickerListener,
  }) : assert(citiesMetaDataList != null);

  @override
  State<StatefulWidget> createState() => CityPickerState();
}

class CityPickerState extends State<CityPicker>{
  
  List<dynamic> cityDataList = [];
  List<String> cityNamesDataList = [];

  int? _selectedCityId;
  String _selectedCity = "";
  bool _showList = false;
  bool isDarkMode = false;

  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState> key = GlobalKey();
  final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    bool hideEmpty = HooksConfigurations.hideEmptyTerm != null
        ? HooksConfigurations.hideEmptyTerm(propertyCityDataType)
        : false;
    for(int i = 0; i < widget.citiesMetaDataList.length; i++){
      //if we shouldn't hide empty, add without checking.
      if (!hideEmpty) {
        cityDataList.add(widget.citiesMetaDataList[i]);
      } else {
        //if we should hide empty, then do check listing count and then add.
        if(widget.citiesMetaDataList[i].totalPropertiesCount != null &&
            widget.citiesMetaDataList[i].totalPropertiesCount > 0){
          cityDataList.add(widget.citiesMetaDataList[i]);
        }
      }

    }

    if(cityDataList.isNotEmpty){
      if(mounted){
        setState(() {
          _showList = true;
        });
      }
      Term allCityObject = Term(
        name: "All",
        slug: "all",
        id: null,
      );

      if(!cityDataList.contains(allCityObject)){
        cityDataList.insert(0, allCityObject);
      }

      for(int i = 0; i < cityDataList.length; i++){
        cityNamesDataList.add(cityDataList[i].name);
      }

      if(!cityNamesDataList.contains("All")){
        cityNamesDataList.insert(0, "All");
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
            elevation: 0.0,
            appBarTitle: UtilityMethods.getLocalizedString("select_location"),
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppThemePreferences().appTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: searchTextField = AutoCompleteTextField(
                        textInputAction: TextInputAction.search,
                        submitOnSuggestionTap: true,
                        controller: _controller,
                        clearOnSubmit: false,
                        decoration: InputDecoration(
                          hintText: UtilityMethods.getLocalizedString("search"),
                          hintStyle: AppThemePreferences().appTheme.searchBarTextStyle,
                          border: InputBorder.none,
                          suffixIcon: AppThemePreferences().appTheme.homeScreenSearchBarIcon,
                          contentPadding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                        ),

                        itemBuilder: (context, item){
                          return Container(
                            color: AppThemePreferences().appTheme.cardColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    child: Container(
                                      decoration: decoration(),
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                      child: GenericTextWidget(
                                        UtilityMethods.getLocalizedString(item),
                                        style: AppThemePreferences().appTheme.subBody01TextStyle,
                                      ),
                                    ),
                                    onTap: (){
                                      if(item == "All"){
                                        widget.cityPickerListener!("All", 0, "all");
                                      }else{
                                        _selectedCity = item;
                                        int index = cityNamesDataList.indexOf(_selectedCity);
                                        if(index != -1){
                                          _selectedCityId = cityDataList[index].id;
                                          String citySlug = cityDataList[index].slug;
                                          widget.cityPickerListener!(_selectedCity, _selectedCityId!, citySlug);
                                        }
                                      }

                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        key: key,
                        suggestions: cityNamesDataList,
                        itemSorter: (a,b){
                          return a.compareTo(b);
                        },
                        itemFilter: (item, query){
                          return item
                              .toLowerCase()
                              .startsWith(query.toLowerCase());
                        },
                        textChanged: (text){
                          if(text.isNotEmpty){
                            if(mounted) setState(() {
                              _showList = false;
                            });
                          }
                          if(text.isEmpty){
                            if(mounted) setState(() {
                              _showList = true;
                            });
                          }
                        },
                        textSubmitted: (text){
                          // print("text: $text");
                        },
                        itemSubmitted: (item){
                          // print("Submitted");
                          // print("item: $item");
                          //
                          // searchTextField.textField.controller.text = item;

                        },
                      ),
                    ),
                    // child:
                  ],
                ),
                decoration: BoxDecoration(
                  color: AppThemePreferences().appTheme.searchBarBackgroundColor,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ),

            _showList ?
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: cityDataList.length,
                itemBuilder: (context, int index) {
                  return Container(
                    color: AppThemePreferences().appTheme.cardColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                              child: GenericTextWidget(
                                UtilityMethods.getLocalizedString(cityDataList[index].name),
                                style: AppThemePreferences().appTheme.subBody01TextStyle,
                              ),
                              decoration: decoration(),
                            ),
                            onTap: (){
                              if(cityDataList[index].name == "All"){
                                widget.cityPickerListener!("All", null, "all");
                              }else{
                                _selectedCity = cityDataList[index].name; //widget.citiesMetaDataMap[index].name;
                                _selectedCityId = cityDataList[index].id;
                                String citySlug = cityDataList[index].slug;
                                widget.cityPickerListener!(_selectedCity, _selectedCityId!, citySlug);
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
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