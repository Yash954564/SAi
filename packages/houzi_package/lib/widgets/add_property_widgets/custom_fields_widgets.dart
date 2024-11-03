import 'package:flutter/material.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/custom_fields.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_multi_select_dialog.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/generic_add_room_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef CustomFieldsPageListener = void Function(Map<String, dynamic> _dataMap);

class CustomFieldsWidget extends StatefulWidget {
  final customFieldData;
  final propertyInfoMap;
  final bool fromFilterPage;
  final EdgeInsetsGeometry? padding;
  final CustomFieldsPageListener customFieldsPageListener;
  final int? formItemIndex;

  CustomFieldsWidget({
    required this.customFieldData,
    required this.propertyInfoMap,
    this.fromFilterPage = false,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 0),
    required this.customFieldsPageListener,
    this.formItemIndex,
  });

  @override
  State<CustomFieldsWidget> createState() => _CustomFieldsWidgetState();
}

class _CustomFieldsWidgetState extends State<CustomFieldsWidget> {

  String textValue = "";

  Map customFieldMap = {};
  Map propertyInfoMap = {};
  Map selectMap = {};
  Map multiSelectMap = {};
  Map<String,dynamic> customFieldDataPropertyInfoMap = {};

  int numberValue = 0;
  int selectedRadioButton = -1;

  List<dynamic> multiSelectList = [];
  List<dynamic> selectedMultiSelectList = [];

  var dropDownValue;
  var numberController = TextEditingController();

  final multiSelectTextController = TextEditingController();
  final textFieldTextController = TextEditingController();

  VoidCallback? generalNotifierLister;

  @override
  void initState() {
    super.initState();

    customFieldMap = widget.customFieldData.toJson();
    
    if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_SELECT) {
      selectMap = customFieldMap[CUSTOM_FIELDS_VALUES];
    }
    if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_MULTI_SELECT) {
      multiSelectMap = customFieldMap[CUSTOM_FIELDS_VALUES];
      multiSelectMap.forEach((k, v) => multiSelectList.add(CustomFieldModel(k, v)));
    }

    if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_CHECKBOX_LIST) {
      List<dynamic> tempList = customFieldMap[CUSTOM_FIELDS_VALUES];
      for(var item in tempList){
        multiSelectList.add(CustomFieldModel(item, item));
      }
    }

    propertyInfoMap = widget.propertyInfoMap;


    /// Initialization Work.......
    if (propertyInfoMap.isNotEmpty) {
      if(propertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]] != null &&
          propertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]].isNotEmpty){
        if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_NUMBER) {
          var value = propertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]];
          if(value is List){
            numberController.text = value[0];
          }else {
            numberController.text = value.toString();
          }
          numberValue = int.tryParse(numberController.text) ?? 0;
        }

        if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_TEXT ||
            customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_TEXT_AREA) {
          var value = propertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]];
          if(value is List){
            textValue = value[0];
          }else{
            textValue = value.toString();
          }
          textFieldTextController.text = textValue;
        }

        if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_SELECT) {
          var value = propertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]];
          if(value is List){
            dropDownValue = value[0];
          }else{
            dropDownValue = value.toString();
          }

        }

        if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_MULTI_SELECT ||
            customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_CHECKBOX_LIST) {
          var data = propertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]];
          if(data is List){
            selectedMultiSelectList = data;
          }else{
            data.forEach((key, value) {
              if(widget.fromFilterPage){
                selectedMultiSelectList.add(key);
              }else{
                selectedMultiSelectList.add(value);
              }
            });
          }
        }

        if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_RADIO ) {
          var value = propertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]];
          if(value is List){
            value = value[0];
          }
          getIndexForRadioButton(value);
        }
      }
    }

    generalNotifierLister = () {
      if (GeneralNotifier().change == GeneralNotifier.RESET_FILTER_DATA) {
        resetData();
      }
    };
    GeneralNotifier().addListener(generalNotifierLister!);

  }

  getIndexForRadioButton(String value) {
    var data = HiveStorageManager.readCustomFieldsDataMaps();
    final custom = customFromJson(data);
    var fieldList = [];

    for (var data in custom.customFields!) {
      if (data.fieldId == customFieldMap[CUSTOM_FIELDS_ID]) {
        fieldList.add(data.fvalues);
        var tempList = fieldList[0];
        for (var data in tempList) {
          if (data == value) {
            String selectedRadioButtonStr = data;

            for (int i = 0; i < customFieldMap[CUSTOM_FIELDS_VALUES].length; i++) {
              if (customFieldMap[CUSTOM_FIELDS_VALUES][i] == selectedRadioButtonStr) {
                selectedRadioButton = i;
              }
            }
          }
        }
      }
    }
  }

  void resetData(){
    if(mounted){
      setState(() {
        selectedRadioButton = -1;
        selectedMultiSelectList.clear();
        numberController.text = "";
        numberValue = 0;
        dropDownValue = null;
        multiSelectTextController.text = "";
        textFieldTextController.text = "";
        textValue = "";
      });
    }
  }

  @override
  void dispose() {
    multiSelectTextController.dispose();
    textFieldTextController.dispose();
    if (generalNotifierLister != null) {
      GeneralNotifier().removeListener(generalNotifierLister!);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_MULTI_SELECT ||
        customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_CHECKBOX_LIST) {
      if (selectedMultiSelectList.isNotEmpty &&
          selectedMultiSelectList.toSet().toList().length == 1) {
        multiSelectTextController.text =
            "${UtilityMethods.getLocalizedString(selectedMultiSelectList.toSet().toList().first)}";
      } else if (selectedMultiSelectList.isNotEmpty &&
          selectedMultiSelectList.toSet().toList().length > 1) {
        multiSelectTextController.text = UtilityMethods.getLocalizedString(
            "multi_select_drop_down_item_selected",
            inputWords: [
              (selectedMultiSelectList.toSet().toList().length.toString())
            ]);
      } else {
        multiSelectTextController.text = "";
      }
    }

    return Container(
      decoration: widget.formItemIndex == 0 ? null : AppThemePreferences.dividerDecoration(top: true),
      margin: widget.formItemIndex == 0 ? null : const EdgeInsets.only(top: 20),
      padding: widget.padding,
      child: getGenericCustomFieldsWidget(),
    );
  }
  
  Widget getGenericCustomFieldsWidget(){
    TextStyle? filterPageHeadingTitleTextStyle =
        AppThemePreferences().appTheme.filterPageHeadingTitleTextStyle;

    if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_TEXT){
      return textWidget(
        labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
      );
    } else if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_RADIO){
      return radioButtonWidgets(
        labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
      );
    } else if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_SELECT){
      return dropDownViewWidget(
        labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
      );
    } else if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_NUMBER){
      return numberWidget(
        labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
      );
    } else if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_TEXT_AREA){
      return textWidget(
        maxLines: 5,
        labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
      );
    } else if (customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_MULTI_SELECT ||
        customFieldMap[CUSTOM_FIELDS_TYPE] == CUSTOM_FIELDS_TYPE_CHECKBOX_LIST){
      return multiSelectDropDownViewWidget(
        multiSelectList,
        labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
      );
    }
    
    return textWidget(
      labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
    );
  }

  Widget radioButtonWidgets({TextStyle? labelTextStyle}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (customFieldMap[CUSTOM_FIELDS_LABEL] != null &&
            customFieldMap[CUSTOM_FIELDS_LABEL].isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: LabelWidget(
              customFieldMap[CUSTOM_FIELDS_LABEL],
              labelTextStyle: labelTextStyle,
            ),
          ),
        Padding(
          padding: UtilityMethods.isRTL(context)
              ? const EdgeInsets.only(right: 5.0)
              : const EdgeInsets.only(left: 5.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: customFieldMap[CUSTOM_FIELDS_VALUES].length,
            itemBuilder: (BuildContext context, int index) {
              return userChoiceFromRadioButton(
                value: index,
                groupValue: selectedRadioButton,
                onChanged: (value) {
                  setState(() {
                    selectedRadioButton = value!;
                    customFieldDataPropertyInfoMap["selectedRadioButton"] = value;
                    customFieldDataPropertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]] = customFieldMap[CUSTOM_FIELDS_VALUES][index];
                  });
                  widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
                },
                optionText: customFieldMap[CUSTOM_FIELDS_VALUES][index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget userChoiceFromRadioButton({
    required int value,
    required int groupValue,
    required void Function(int?) onChanged,
    required String optionText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
          activeColor: AppThemePreferences().appTheme.primaryColor,
          value: value,
          groupValue: groupValue,
          onChanged: onChanged
        ),
        GenericTextWidget(
          optionText,
          style: AppThemePreferences().appTheme.label01TextStyle,
        ),
      ],
    );
  }

  Widget dropDownViewWidget({TextStyle? labelTextStyle}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(customFieldMap[CUSTOM_FIELDS_LABEL] != null && customFieldMap[CUSTOM_FIELDS_LABEL].isNotEmpty) Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: LabelWidget(
            customFieldMap[CUSTOM_FIELDS_LABEL],
            labelTextStyle: labelTextStyle,
          ),
        ),
        DropdownButtonFormField(
          dropdownColor: AppThemePreferences().appTheme.dropdownMenuBgColor,
          icon: Icon(AppThemePreferences.dropDownArrowIcon),
          decoration: AppThemePreferences.formFieldDecoration(hintText: customFieldMap[CUSTOM_FIELDS_PLACEHOLDER]),
          items: selectMap.map((key, value) {
            return MapEntry(
                key,
                DropdownMenuItem<String>(
                  value: key,
                  child: GenericTextWidget(value),
                ));
            // return MapEntry(
            //     value,
            //     DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     ));
          }).values.toList(),
          value: dropDownValue,
          onChanged: (value) {
            if(value != null){
              customFieldDataPropertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]] = value;
              widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
            }
          },
          validator: (val) {
            // String value = val.toString();
            // if (val != null && value.isNotEmpty) {
            if (val != null) {
              String value = val.toString();
              customFieldDataPropertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]] = value;
              widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget numberWidget({TextStyle? labelTextStyle}) {
    return GenericStepperWidget(
      labelTextStyle: labelTextStyle,
      givenWidth: 230, // 250
      textAlign: TextAlign.center,
      padding: EdgeInsets.zero,
      labelText: customFieldMap[CUSTOM_FIELDS_LABEL],
      labelTextPadding: EdgeInsets.zero,
      controller: numberController,
      onRemovePressed: () {
        if (numberValue > 0) {
          setState(() {
            numberValue -= 1;
            numberController.text = numberValue.toString();
            customFieldDataPropertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]] = numberValue.toString();
          });
          widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
        }
      },
      onAddPressed: () {
        if (numberValue >= 0) {
          setState(() {
            numberValue += 1;
            numberController.text = numberValue.toString();
            customFieldDataPropertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]] = numberValue.toString();
          });
          widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
        }
      },
      onChanged: (value) {
        setState(() {
          numberValue = int.parse(value);
          customFieldDataPropertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]] = value;
        });
        widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
      },
      validator: (String? value) {
        if (value != null && value.isNotEmpty) {
          setState(() {
            customFieldDataPropertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]] = value;
          });
          widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
        }
        return null;
      },
    );
  }

  Widget textWidget({int maxLines = 1, TextStyle? labelTextStyle}) {
    return TextFormFieldWidget(
      maxLines: maxLines,
      labelTextStyle: labelTextStyle,
      padding: EdgeInsets.zero,
      labelText: customFieldMap[CUSTOM_FIELDS_LABEL],
      hintText: customFieldMap[CUSTOM_FIELDS_PLACEHOLDER],
      controller: textFieldTextController,
      validator: (String? value) {
        if (value != null && value.isNotEmpty) {
          setState(() {
            customFieldDataPropertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]] = value;
          });
          widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
        }
        return null;
      },
      onChanged: (value){
        setState(() {
          customFieldDataPropertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]] = value;
        });
        widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
      },
      // initialValue: textValue,
    );
  }

  Widget multiSelectDropDownViewWidget(List dataList, {TextStyle? labelTextStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(customFieldMap[CUSTOM_FIELDS_LABEL] != null && customFieldMap[CUSTOM_FIELDS_LABEL].isNotEmpty)Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: LabelWidget(
            customFieldMap[CUSTOM_FIELDS_LABEL],
            labelTextStyle: labelTextStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.zero,
          child: TextFormField(
            controller: multiSelectTextController,
            decoration: AppThemePreferences.formFieldDecoration(
              hintText: UtilityMethods.getLocalizedString("select"),
              suffixIcon: Icon(AppThemePreferences.dropDownArrowIcon),
            ),
            readOnly: true,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _showMultiSelect(context, dataList);
            },
            validator: (String? value) {
              if (value != null && value.isNotEmpty) {
                // setState(() {
                //   customFieldDataPropertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]] = value;
                // });
                // widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  void _showMultiSelect(BuildContext context, List dataList) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialogWidget(
          selectedItemsList: selectedMultiSelectList,
          fromCustomFields: true,
          fromSearchPage: widget.fromFilterPage,
//           title: selectedMultiSelectList != null &&
//               selectedMultiSelectList.isNotEmpty &&
//               selectedMultiSelectList.length > 1
//               ? selectedMultiSelectList.length.toString() + " " + GenericMethods.getLocalizedString("selected")
//               : GenericMethods.getLocalizedString("select"),
//           dataItemsList: multiSelectMap,
          title: UtilityMethods.getLocalizedString("select"),
          dataItemsList: dataList,
          multiSelectDialogWidgetListener: (List<dynamic> selectedItemsList, List<dynamic> listOfSelectedItemsSlugs) {
            Map map = {};
            if(widget.fromFilterPage){
              Map tempMap = {for (var item in listOfSelectedItemsSlugs) '$item' : '$item'};
              map.addAll(tempMap);
            }else{
              Map tempMap = {for (var item in selectedItemsList) '$item' : '$item'};
              map.addAll(tempMap);
            }
            customFieldDataPropertyInfoMap[customFieldMap[CUSTOM_FIELDS_ID]] = map;
            selectedMultiSelectList = selectedItemsList;
            widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
          },
        );
      },
    );
  }
}
