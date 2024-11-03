import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';

typedef PropertyVirtualTourLinkPageListener = void Function(Map<String, dynamic> _dataMap);

class PropertyVirtualTourLinkPage extends StatefulWidget{

  final PropertyVirtualTourLinkPageListener? propertyVirtualTourLinkPageListener;
  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic>? propertyInfoMap;

  PropertyVirtualTourLinkPage({
    this.formKey,
    this.propertyInfoMap,
    this.propertyVirtualTourLinkPageListener,
  });

  @override
  State<StatefulWidget> createState() => PropertyVirtualTourLinkPageState();
}

class PropertyVirtualTourLinkPageState extends State<PropertyVirtualTourLinkPage> {

  Map<String, dynamic> dataMap = {};
  final _virtualTourLinkTextController = TextEditingController();


  @override
  void initState() {
    Map? tempMap = widget.propertyInfoMap;
    if(tempMap != null){
      if(tempMap.containsKey(ADD_PROPERTY_VIRTUAL_TOUR)){
        _virtualTourLinkTextController.text = tempMap[ADD_PROPERTY_VIRTUAL_TOUR];
      }
    }
    super.initState();
  }


  @override
  void dispose() {
    _virtualTourLinkTextController.dispose();
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
                    virtualTourTextWidget(),
                    addVirtualTourLink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget virtualTourTextWidget() {
    return HeaderWidget(
      text: UtilityMethods.getLocalizedString("virtual_tour"),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
    );
  }

  Widget addVirtualTourLink(){
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
      child: TextFormFieldWidget(
        hintText: UtilityMethods.getLocalizedString("enter_virtual_tour_iframe_embedded_code"),
        controller: _virtualTourLinkTextController,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        validator: (String? value) {
          if (value != null && value.isNotEmpty) {
            if (mounted) {
              setState(() {
                dataMap[ADD_PROPERTY_VIRTUAL_TOUR] = value;
              });
            }
            widget.propertyVirtualTourLinkPageListener!(dataMap);
          }
          return null;
        },
      ),
    );
  }
}