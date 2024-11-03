import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class FeatureList extends StatefulWidget{
  final List<dynamic> featuresList;

  FeatureList({
    required this.featuresList,
  });

  @override
  State<StatefulWidget> createState() => FeatureListState();
}

class FeatureListState extends State<FeatureList>{

  List<dynamic> featuresList = [];

  bool _showList = true;
  bool isDarkMode = false;

  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState> key = GlobalKey();
  final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    featuresList = widget.featuresList;
    featuresList = featuresList.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
          elevation: 0.0,
          appBarTitle: UtilityMethods.getLocalizedString("features"),
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
                                      // if(item == "All"){
                                      //   widget.cityPickerListener("All", null, "all");
                                      // }else{
                                      //   _selectedCity = item;
                                      //   int index = cityNamesDataList.indexOf(_selectedCity);
                                      //   _selectedCityId = featuresList[index].id;
                                      //   String citySlug = featuresList[index].slug;
                                      //   widget.cityPickerListener(_selectedCity, _selectedCityId, citySlug);
                                      // }

                                      // Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        key: key,
                        suggestions: featuresList,
                        itemSorter: (a,b){
                          return a.compareTo(b);
                        },
                        itemFilter: (item, query){
                          return item
                              .toLowerCase()
                              .startsWith(query.toLowerCase());
                        },
                        textChanged: (text){
                          if(text != "" || text != null){
                            setState(() {
                              _showList = false;
                            });
                          }
                          if(text == "" || text == null){
                            setState(() {
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
                itemCount: featuresList.length,
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
                                UtilityMethods.getLocalizedString(featuresList[index]),
                                style: AppThemePreferences().appTheme.subBody01TextStyle,
                              ),
                              decoration: decoration(),
                            ),
                            onTap: (){
                              // if(featuresList[index].name == "All"){
                              //   widget.cityPickerListener("All", null, "all");
                              // }else{
                              //   _selectedCity = featuresList[index].name; //widget.citiesMetaDataMap[index].name;
                              //   _selectedCityId = featuresList[index].id;
                              //   String citySlug = featuresList[index].slug;
                              //   widget.cityPickerListener(_selectedCity, _selectedCityId, citySlug);
                              // }
                              // Navigator.of(context).pop();
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