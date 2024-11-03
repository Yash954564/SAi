import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/radio_item.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/radio_button_widget.dart';

typedef PropertySettingsPageListener = void Function(Map<String, dynamic> dataMap);

class PropertySettingsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PropertySettingsPageState();

  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic>? propertyInfoMap;
  final bool updateProperty;
  final PropertySettingsPageListener? propertySettingsPageListener;

  PropertySettingsPage({
    Key? key,
    this.formKey,
    this.propertyInfoMap,
    this.updateProperty = false,
    this.propertySettingsPageListener,
  });
}

class PropertySettingsPageState extends State<PropertySettingsPage> {

  Map<String, dynamic> dataMap = {};
  // int _groupValueForFeaturedOption = 0;
  // int _groupValueForLoggingOption = 0;

  dynamic userLoginSelectedOption;
  dynamic makePropertyFeaturedSelectedOption;

  List<RadioItem> userLoginOptionsList = [];
  List<RadioItem> makePropertyFeaturedOptionsList = [];

  final TextEditingController _propertyDisclaimerTextController = TextEditingController();

  @override
  void initState() {

    userLoginOptionsList = [
      RadioItem(value: "0", label: "No"),
      RadioItem(value: "1", label: "Yes"),
    ];

    makePropertyFeaturedOptionsList = [
      RadioItem(value: "0", label: "No"),
      RadioItem(value: "1", label: "Yes"),
    ];

    Map? tempMap = widget.propertyInfoMap;
    if(tempMap != null){
      String? tempValue;

      if(tempMap.containsKey(ADD_PROPERTY_PROPERTY_FEATURED)){
        tempValue = tempMap[ADD_PROPERTY_PROPERTY_FEATURED];
        if(tempValue != null) {
          makePropertyFeaturedSelectedOption = tempValue;
          // _groupValueForFeaturedOption = int.tryParse(tempValue) ?? 0;
        }
      }

      if(tempMap.containsKey(ADD_PROPERTY_LOGGED_IN_REQUIRED)){
        tempValue = tempMap[ADD_PROPERTY_LOGGED_IN_REQUIRED];
        if(tempValue != null) {
          userLoginSelectedOption = tempValue;
          // _groupValueForLoggingOption = int.tryParse(tempValue) ?? 0;
        }
      }

      if(tempMap.containsKey(ADD_PROPERTY_DISCLAIMER)){
        _propertyDisclaimerTextController.text = tempMap[ADD_PROPERTY_DISCLAIMER] ?? "";
      }
    }

    userLoginSelectedOption ??= userLoginOptionsList[0].value;
    makePropertyFeaturedSelectedOption ??= makePropertyFeaturedOptionsList[0].value;

    super.initState();
  }

  @override
  void dispose() {
    _propertyDisclaimerTextController.dispose();
    dataMap = {};
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              CardWidget(
                child: Column(
                  children: [
                    propertySettingsTextWidget(),
                    RadioButtonWidget(
                      label: "do_you_want_to_mark_this_property_as_featured",
                      selectedValue: makePropertyFeaturedSelectedOption,
                      itemsList: makePropertyFeaturedOptionsList,
                      listener: (value) {
                        makePropertyFeaturedSelectedOption = value;
                        dataMap[ADD_PROPERTY_PROPERTY_FEATURED] = makePropertyFeaturedSelectedOption;
                        widget.propertySettingsPageListener!(dataMap);
                      },
                    ),
                    RadioButtonWidget(
                      label: "the_user_must_be_logged_in_to_view_this_property",
                      selectedValue: userLoginSelectedOption,
                      itemsList: userLoginOptionsList,
                      listener: (value) {
                        userLoginSelectedOption = value;
                        dataMap[ADD_PROPERTY_LOGGED_IN_REQUIRED] = userLoginSelectedOption;
                        widget.propertySettingsPageListener!(dataMap);
                      },
                    ),
                    addDisclaimer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget propertySettingsTextWidget() {
    return HeaderWidget(
      text: UtilityMethods.getLocalizedString("property_settings"),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      alignment: Alignment.topLeft,
      decoration: AppThemePreferences.dividerDecoration(),
    );
  }

  Widget addDisclaimer(){
    return Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("disclaimer"),
        hintText: UtilityMethods.getLocalizedString("disclaimer"),
        keyboardType: TextInputType.multiline,
        maxLines: 7,
        controller: _propertyDisclaimerTextController,
        validator: (String? value) {
          if (value != null && value.isNotEmpty) {
            if (mounted) {
              setState(() {
                dataMap[ADD_PROPERTY_DISCLAIMER] = value;
              });
            }
            widget.propertySettingsPageListener!(dataMap);
          }
          return null;
        },
      ),
    );
  }

//   Widget labelWidget(String text){
//     return  GenericTextWidget(
//       text,
//       style: AppThemePreferences().appTheme.labelTextStyle,
//     );
//   }
//
//   Widget makePropertyFeaturedTextWidget() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
//             child: labelWidget(UtilityMethods.getLocalizedString("do_you_want_to_mark_this_property_as_featured")),
//           ),
//           Container(
//             padding: const EdgeInsets.only(left: 5.0, bottom: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 userChoiceFromRadioButton(
//                   value: 0,
//                   groupValue: _groupValueForFeaturedOption,
//                   onChanged: (value){
//                     if(value != null){
//                       if (mounted) {
//                         setState(() {
//                           _groupValueForFeaturedOption = value;
//                           dataMap[ADD_PROPERTY_PROPERTY_FEATURED] =
//                               "$_groupValueForFeaturedOption";
//                           widget.propertySettingsPageListener!(dataMap);
//                         });
//                       }
//                     }
//                   },
//                   optionText: UtilityMethods.getLocalizedString("no"),
//                   // optionText: optionsList[0],
//                 ),
//                 userChoiceFromRadioButton(
//                   value: 1,
//                   groupValue: _groupValueForFeaturedOption,
//                   onChanged: (value){
//                     if (mounted && value != null) {
//                       setState(() {
//                         _groupValueForFeaturedOption = value;
//                       });
//                       dataMap[ADD_PROPERTY_PROPERTY_FEATURED] =
//                           "$_groupValueForFeaturedOption";
//                       widget.propertySettingsPageListener!(dataMap);
//                     }
//                   },
//                   optionText: UtilityMethods.getLocalizedString("yes"),
//                   // optionText: optionsList[1],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       decoration: AppThemePreferences.dividerDecoration(),
//     );
//   }
//
//   Widget userChoiceFromRadioButton({
//     required int value,
//     required int groupValue,
//     required void Function(int?) onChanged,
//     required String optionText,
// }){
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Radio(
//           activeColor: AppThemePreferences().appTheme.primaryColor,
//           value: value,
//           groupValue: groupValue,
//           onChanged: onChanged,
//         ),
//         GenericTextWidget(
//           optionText,
//           style: AppThemePreferences().appTheme.label01TextStyle,
//         ),
//       ],
//     );
//   }
//
//   Widget userMustLoggedInTextWidget() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
//             child: labelWidget(UtilityMethods.getLocalizedString("the_user_must_be_logged_in_to_view_this_property")),
//           ),
//           Container(
//             padding: const EdgeInsets.only(left: 5.0, bottom: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 userChoiceFromRadioButton(
//                   value: 0,
//                   groupValue: _groupValueForLoggingOption,
//                   onChanged: (value){
//                     if(value != null){
//                       if (mounted) {
//                         setState(() {
//                           _groupValueForLoggingOption = value;
//                         });
//                       }
//                       dataMap[ADD_PROPERTY_LOGGED_IN_REQUIRED] = "$_groupValueForLoggingOption";
//                       widget.propertySettingsPageListener!(dataMap);
//                     }
//                   },
//                   optionText: UtilityMethods.getLocalizedString("no"),
//                   // optionText: optionsList[0],
//                 ),
//                 userChoiceFromRadioButton(
//                   value: 1,
//                   groupValue: _groupValueForLoggingOption,
//                   onChanged: (value){
//                     if(value != null){
//                       if (mounted) {
//                         setState(() {
//                           _groupValueForLoggingOption = value;
//                         });
//                       }
//                       dataMap[ADD_PROPERTY_LOGGED_IN_REQUIRED] = "$_groupValueForLoggingOption";
//                       widget.propertySettingsPageListener!(dataMap);
//                     }
//                   },
//                   optionText: UtilityMethods.getLocalizedString("yes"),
//                   // optionText: optionsList[1],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       decoration: AppThemePreferences.dividerDecoration(),
//     );
//   }
}

