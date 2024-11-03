import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';

typedef PropertyPrivateNotePageListener = void Function(Map<String, dynamic> _dataMap);

class PropertyPrivateNotePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PropertyPrivateNotePageState();

  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic>? propertyInfoMap;
  final PropertyPrivateNotePageListener? propertyPrivateNotePageListener;

  PropertyPrivateNotePage({
    Key? key,
    this.formKey,
    this.propertyInfoMap,
    this.propertyPrivateNotePageListener,
  });

}

class PropertyPrivateNotePageState extends State<PropertyPrivateNotePage> {

  Map<String, dynamic> dataMap = {};
  final TextEditingController _privateNoteTextController = TextEditingController();


  @override
  void initState() {
    super.initState();

    Map<String, dynamic>? tempMap = widget.propertyInfoMap;

    if (tempMap != null && tempMap.isNotEmpty) {
      if (tempMap.containsKey(ADD_PROPERTY_PRIVATE_NOTE)) {
        _privateNoteTextController.text = tempMap[ADD_PROPERTY_PRIVATE_NOTE] ?? "";
      }
    }
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
                    privateNoteTextWidget(),
                    addPrivateNote(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget privateNoteTextWidget() {
    return HeaderWidget(
      text: UtilityMethods.getLocalizedString("private_note"),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
    );
  }

  Widget addPrivateNote(){
    return Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("write_private_note_for_this_property_it_will_not_display_for_public"),
        hintText: UtilityMethods.getLocalizedString("enter_the_note_here"),
        keyboardType: TextInputType.multiline,
        maxLines: 7,
        controller: _privateNoteTextController,
        validator: (String? value) {
          if (value != null && value.isNotEmpty) {
            if (mounted) {
              setState(() {
                dataMap[ADD_PROPERTY_PRIVATE_NOTE] = value;
              });
            }
            widget.propertyPrivateNotePageListener!(dataMap);
          }

          return null;
        },
      ),
    );
  }
}