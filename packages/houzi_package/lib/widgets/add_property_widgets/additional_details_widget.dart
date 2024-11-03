import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/dynamic_item.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/light_button_widget.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

typedef GenericAdditionalDetailsWidgetListener = void Function(List<DynamicItem> updatedItemsList);

class GenericAdditionalDetailsWidget extends StatefulWidget {
  final List<DynamicItem> itemsList;
  final EdgeInsetsGeometry? buttonPadding;
  final GenericAdditionalDetailsWidgetListener listener;
  
  const GenericAdditionalDetailsWidget({
    Key? key,
    required this.itemsList,
    this.buttonPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    required this.listener,
  }) : super(key: key);

  @override
  State<GenericAdditionalDetailsWidget> createState() => _GenericAdditionalDetailsWidgetState();
}

class _GenericAdditionalDetailsWidgetState extends State<GenericAdditionalDetailsWidget> {

  List<DynamicItem> itemsList = [];

  @override
  void initState() {
    itemsList = widget.itemsList;
    super.initState();
  }

  @override
  void dispose() {
    itemsList = [];
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(itemsList.isNotEmpty) Column(
          children: itemsList.map((dynamicItem) {
            int itemIndex = itemsList.indexOf(dynamicItem);
            return AdditionalDetailsWidgetBody(
              index: itemIndex,
              dataMap: dynamicItem.dataMap!,
              genericAdditionalDetailsWidgetListener: (int index, Map<String, dynamic> itemDataMap, bool removeItem) {
                if (removeItem) {
                  if (mounted) {
                    setState(() {
                      itemsList.removeAt(index);
                    });
                  }
                } else {
                  if (mounted) {
                    setState(() {
                      itemsList[index].dataMap = itemDataMap;
                    });
                  }
                }

                widget.listener(itemsList);
              },
            );
          }).toList(),
        ),
        addNewElevatedButton(),
      ],
    );
  }

  Widget addNewElevatedButton(){
    return Container(
      padding: widget.buttonPadding,
      child: LightButtonWidget(
          text: UtilityMethods.getLocalizedString("add_new"),
          fontSize: AppThemePreferences.buttonFontSize,
          onPressed: (){
            if (mounted) {
              setState(() {
                itemsList.add(DynamicItem(
                  key: itemsList.isNotEmpty ? "Key${itemsList.length}" : "Key0",
                  dataMap: {
                    faveAdditionalFeatureTitle: "",
                    faveAdditionalFeatureValue: "",
                  },
                ));
              });
            }
          }
      ),
    );
  }
}


typedef AdditionalDetailsWidgetBodyListener = void Function(
    int index, Map<String, dynamic> dataMap, bool remove);

class AdditionalDetailsWidgetBody extends StatefulWidget{

  final int index;
  final Map<String, dynamic> dataMap;
  final AdditionalDetailsWidgetBodyListener genericAdditionalDetailsWidgetListener;

  const AdditionalDetailsWidgetBody({
    Key? key,
    required this.index,
    required this.dataMap,
    required this.genericAdditionalDetailsWidgetListener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => GenericAdditionalDetailsWidgetState();

}

class GenericAdditionalDetailsWidgetState extends State<AdditionalDetailsWidgetBody> {

  Map<String, dynamic> tempDataMap = {};

  final _additionalDetailsTitleTextController = TextEditingController();
  final _additionalDetailsValueTextController = TextEditingController();

  @override
  void dispose() {
    _additionalDetailsTitleTextController.dispose();
    _additionalDetailsValueTextController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (widget.dataMap.isNotEmpty && !(mapEquals(widget.dataMap, tempDataMap))) {
      _additionalDetailsTitleTextController.text = widget.dataMap[faveAdditionalFeatureTitle];
      _additionalDetailsValueTextController.text = widget.dataMap[faveAdditionalFeatureValue];
      tempDataMap = widget.dataMap;
    }

    return addAdditionalFeatureInformation();
  }

  Widget addAdditionalFeatureInformation(){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 5, child: addAdditionalFeatureTitle()),
          Expanded(flex: 5, child: addAdditionalFeatureValue()),
        ],
      ),
    );
  }

  Widget addAdditionalFeatureTitle(){
    return TextFormFieldWidget(
      padding: UtilityMethods.isRTL(context)
          ? const EdgeInsets.fromLTRB(10, 20, 20, 0)
          : const EdgeInsets.fromLTRB(20, 20, 10, 0),
      labelText: UtilityMethods.getLocalizedString("title"),
      hintText: UtilityMethods.getLocalizedString("additional_feature_title_hint"),
      controller: _additionalDetailsTitleTextController,
      onChanged: (title){
        widget.dataMap[faveAdditionalFeatureTitle]  = title;
        updateDataMap();
      },
    );
  }

  Widget addAdditionalFeatureValue(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: UtilityMethods.isRTL(context)
              ? const EdgeInsets.fromLTRB(5.0, 0.0, 20.0, 0.0)
              : const EdgeInsets.fromLTRB(20.0, 0.0, 5.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelWidget(UtilityMethods.getLocalizedString("value")),
              IconButton(
                onPressed: (){
                  widget.genericAdditionalDetailsWidgetListener(widget.index, widget.dataMap, true);
                  if(mounted) {
                    setState(() {});
                  }
                },
                padding: const EdgeInsets.all(0.0),
                icon: Icon(
                  Icons.cancel_outlined,
                  color: AppThemePreferences.errorColor,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(0.0),
          child: TextFormFieldWidget(
            textFieldPadding: const EdgeInsets.all(0.0),
            controller: _additionalDetailsValueTextController,
            hintText: UtilityMethods.getLocalizedString("additional_feature_value_hint"),
            onChanged: (value){
              widget.dataMap[faveAdditionalFeatureValue]  = value;
              updateDataMap();
            },
          ),
        ),
      ],
    );
  }

  updateDataMap(){
    widget.genericAdditionalDetailsWidgetListener(
        widget.index, widget.dataMap, false);
  }
}