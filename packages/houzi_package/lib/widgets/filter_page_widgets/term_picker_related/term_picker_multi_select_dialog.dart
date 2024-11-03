import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/custom_widgets/alert_dialog_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';

typedef MultiSelectDialogWidgetListener = void Function(
  List<dynamic> listOfSelectedItems,
  List<dynamic> listOfSelectedItemsSlugs,
);

class MultiSelectDialogWidget extends StatefulWidget{

  final String title;
  final String? objDataType;
  final List<dynamic> dataItemsList;
  final List<dynamic> selectedItemsList;
  final List<dynamic>? selectedItemsSlugsList;
  final MultiSelectDialogWidgetListener multiSelectDialogWidgetListener;
  
  final bool showSearchBar;
  final bool fromCustomFields;
  final bool fromAddProperty;
  final bool fromSearchPage;
  final bool addAllinData;

  MultiSelectDialogWidget({
    Key? key,
    required this.title,
    this.objDataType,
    required this.dataItemsList,
    required this.selectedItemsList,
    this.selectedItemsSlugsList,
    required this.multiSelectDialogWidgetListener,
    this.showSearchBar = false,
    this.fromCustomFields = false,
    this.fromAddProperty = false,
    this.fromSearchPage = false,
    this.addAllinData = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MultiSelectDialogWidgetState();

}

class MultiSelectDialogWidgetState extends State<MultiSelectDialogWidget> {

  List<dynamic> dataItemsList = [];
  List<dynamic> selectedItemsList = [];
  List<dynamic> selectedItemsSlugsList = [];

  List<dynamic> _parentChildFormatList = [];

  List<String> _suggestionsList = [];

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
    if(widget.dataItemsList != null && widget.dataItemsList.isNotEmpty){
      dataItemsList = [];
      dataItemsList.addAll(widget.dataItemsList);
      if (dataItemsList.isNotEmpty && dataItemsList[0] is Term) {
        for (Term item in dataItemsList) {
          _suggestionsList.add(item.name!);
        }
      }
    }

    if(widget.selectedItemsList != null && widget.selectedItemsList.isNotEmpty){
      selectedItemsList = [];
      selectedItemsList.addAll(widget.selectedItemsList);
    }

    if(widget.selectedItemsSlugsList != null && widget.selectedItemsSlugsList!.isNotEmpty){
      selectedItemsSlugsList = [];
      selectedItemsSlugsList.addAll(widget.selectedItemsSlugsList!);
    }

    if (widget.fromCustomFields) {
      _parentChildFormatList = dataItemsList;
    } else {
      if (dataItemsList != null && dataItemsList.isNotEmpty) {
        List<dynamic> tempList = [];
        List<dynamic> tempList01 = [];
        for (int i = 0; i < dataItemsList.length; i++) {
          if (dataItemsList[i].parent == 0) {
            tempList.add(dataItemsList[i]);
          }
        }

        for (int i = 0; i < tempList.length; i++) {
          for (int j = 0; j < dataItemsList.length; j++) {
            if (tempList[i].id == dataItemsList[j].parent) {
              tempList01.add(dataItemsList[j]);
            }
          }
          _parentChildFormatList.add(tempList[i]);
          _parentChildFormatList.addAll(tempList01);
          tempList01 = [];
        }
      }
    }

    if (widget.addAllinData) {
      // Add 'all' term if not in list
      if (_parentChildFormatList.contains(allTermObject)) {
        _parentChildFormatList.remove(allTermObject);
      }
      _parentChildFormatList.insert(0, allTermObject);
    }
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialogWidget(
      title: GenericTextWidget(widget.title),
      titlePadding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
      contentPadding: const EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // color: AppThemePreferences().appTheme.primaryColor,
                border: Border(
                  bottom: BorderSide(
                    color: AppThemePreferences().appTheme.dividerColor!,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    !widget.showSearchBar ? Container() : Expanded(
                      child: AutoCompleteTextField(
                        textInputAction: TextInputAction.search,
                        submitOnSuggestionTap: true,
                        controller: _controller,
                        clearOnSubmit: true,
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
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: AppThemePreferences().appTheme.dividerColor!,
                                          ),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                      child: GenericTextWidget(
                                        UtilityMethods.getLocalizedString(item),
                                        style: AppThemePreferences().appTheme.subBody01TextStyle,
                                      ),
                                    ),
                                    onTap: (){
                                      Term? obj = UtilityMethods.getPropertyMetaDataObjectWithItemName(
                                          dataType: widget.objDataType!, name: item);

                                      String title = widget.fromCustomFields
                                          ? obj!.parent.toString() : obj!.name!;

                                      final checked = widget.fromSearchPage
                                          ? selectedItemsList.contains(item.name)
                                          : selectedItemsList.contains(title);

                                      _onItemCheckedChange(obj, !checked);

                                      // if(item == "All"){
                                      //   widget.termPickerFullScreenListener!("All", null, "all");
                                      // }else{
                                      //   _selectedTerm = item;
                                      //   int index = termNamesDataList.indexOf(_selectedTerm);
                                      //   if(index != -1){
                                      //     _selectedTermId = termMetaDataList[index].id;
                                      //     String termSlug = termMetaDataList[index].slug;
                                      //     widget.termPickerFullScreenListener!(_selectedTerm, _selectedTermId!, termSlug);
                                      //   }
                                      // }
                                      //
                                      // Navigator.of(context).pop();
                                      setState(() {
                                        _controller.text = "";
                                      });

                                      FocusScope.of(context).requestFocus(FocusNode());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        key: key,
                        suggestions: _suggestionsList, //termNamesDataList,
                        itemSorter: (a,b){
                          return a.compareTo(b);
                        },
                        itemFilter: (item, query){
                          return item
                              .toLowerCase()
                              .startsWith(query.toLowerCase());
                        },
                        textChanged: (text) {
                          // if(text.isNotEmpty){
                          //   if(mounted) setState(() {
                          //     _showList = false;
                          //   });
                          // } else if(text.isEmpty){
                          //   if(mounted) setState(() {
                          //     _showList = true;
                          //   });
                          // }
                        },
                        textSubmitted: (text){
                          // print("text: $text");
                        },
                        itemSubmitted: (item){
                          print("Submitted");
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
                  color: AppThemePreferences().appTheme.containerBackgroundColor,
                  border: Border.all(
                      color:
                      AppThemePreferences().appTheme.containerBackgroundColor!,
                      width: 0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            ListTileTheme(
              child: ListBody(
                children: _parentChildFormatList.map((item) {
                  String title = widget.fromCustomFields ? item.parent : item.name;
                  final checked = widget.fromSearchPage ?
                  selectedItemsList.contains(item.name) : selectedItemsList.contains(title);

                  return CheckboxListTile(
                    activeColor: AppThemePreferences().appTheme.primaryColor,
                    value: checked,
                    title: GenericTextWidget(widget.fromCustomFields
                        ? UtilityMethods.getLocalizedString(title)
                        : item.parent == 0
                        ? UtilityMethods.getLocalizedString(title)
                        :'- ${UtilityMethods.getLocalizedString(title)}',
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (checked) => _onItemCheckedChange(item, checked!),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.fromLTRB(24, 0, 24, 10),
      actions: <Widget>[
        TextButtonWidget(
          child: GenericTextWidget(UtilityMethods.getLocalizedString("cancel")),
          onPressed: ()=> Navigator.pop(context),
        ),
        TextButtonWidget(
          child: GenericTextWidget(UtilityMethods.getLocalizedString("ok")),
          onPressed: () {
            widget.multiSelectDialogWidgetListener(selectedItemsList, selectedItemsSlugsList);
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  void _onItemCheckedChange(dynamic item, bool checked) {
    if (mounted) {
      setState(() {
        if (checked) {
          if (widget.fromCustomFields) {
            selectedItemsList.add(item.parent);
            if (widget.fromSearchPage) {
              selectedItemsSlugsList.add(item.name);
            }
          } else if (widget.fromAddProperty) {
            selectedItemsList.add(item.name);
            selectedItemsSlugsList.add(item.id);
          } else {
            selectedItemsList.add(item.name);
            selectedItemsSlugsList.add(item.slug);
          }
        } else {
          if (widget.fromCustomFields) {
            selectedItemsList.remove(item.parent);
          } else if (widget.fromAddProperty) {
            selectedItemsList.remove(item.name);
            selectedItemsSlugsList.remove(item.id);
          } else {
            selectedItemsList.remove(item.name);
            selectedItemsSlugsList.remove(item.slug);
          }
        }
      });
    }
  }
}