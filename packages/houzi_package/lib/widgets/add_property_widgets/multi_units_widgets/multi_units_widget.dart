import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/dynamic_item.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/light_button_widget.dart';

typedef GenericMultiUnitsWidgetListener = void Function(List<DynamicItem> updatedItemsList);

class GenericMultiUnitsWidget extends StatefulWidget {
  final List<DynamicItem> itemsList;
  final EdgeInsetsGeometry? buttonPadding;
  final GenericMultiUnitsWidgetListener listener;

  const GenericMultiUnitsWidget({
    Key? key,
    required this.itemsList,
    this.buttonPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    required this.listener,
  }) : super(key: key);

  @override
  State<GenericMultiUnitsWidget> createState() => _GenericMultiUnitsWidgetState();
}

class _GenericMultiUnitsWidgetState extends State<GenericMultiUnitsWidget> {

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
            return GenericMultiUnitsWidgetBody(
              index: itemIndex,
              dataMap: dynamicItem.dataMap!,
              genericMultiUnitsWidgetBodyListener: (int index, Map<String, dynamic> itemDataMap, bool removeItem) {
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
            if(mounted) {
              setState(() {
                itemsList.add(DynamicItem(
                  key: itemsList.isNotEmpty ? "Key${itemsList.length}" : "Key0",
                  dataMap: {
                    faveMUTitle: "",
                    faveMUPrice: "",
                    faveMUPricePostfix: "",
                    faveMUBeds: "",
                    faveMUBaths: "",
                    faveMUSize: "",
                    faveMUSizePostfix: "",
                    faveMUType: "",
                    faveMUAvailabilityDate: "",
                  },
                ));
              });
            }
          }
      ),
    );
  }
}


typedef GenericMultiUnitsWidgetBodyListener = void Function(
    int index, Map<String, dynamic> dataMap, bool remove);

class GenericMultiUnitsWidgetBody extends StatefulWidget{

  final int index;
  final Map<String, dynamic> dataMap;
  final GenericMultiUnitsWidgetBodyListener genericMultiUnitsWidgetBodyListener;

  const GenericMultiUnitsWidgetBody({
    Key? key,
    required this.index,
    required this.dataMap,
    required this.genericMultiUnitsWidgetBodyListener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => GenericMultiUnitsWidgetBodyState();

}

class GenericMultiUnitsWidgetBodyState extends State<GenericMultiUnitsWidgetBody> {

  Map<String, dynamic> tempDataMap = {};

  int _bedrooms = 0;
  int _bathrooms = 0;

  final _titleTextController = TextEditingController();
  final _bedroomsTextController = TextEditingController();
  final _bathroomsTextController = TextEditingController();
  final _sizeTextController = TextEditingController();
  final _sizePostfixTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  final _pricePostfixTextController = TextEditingController();
  final _typeTextController = TextEditingController();
  final _availabilityDateTextController = TextEditingController();

  @override
  void dispose() {
    tempDataMap = {};
    _bedrooms = 0;
    _bathrooms = 0;
    _titleTextController.dispose();
    _bedroomsTextController.dispose();
    _bathroomsTextController.dispose();
    _sizeTextController.dispose();
    _sizePostfixTextController.dispose();
    _priceTextController.dispose();
    _pricePostfixTextController.dispose();
    _typeTextController.dispose();
    _availabilityDateTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (widget.dataMap.isNotEmpty && !(mapEquals(widget.dataMap, tempDataMap))) {
      _titleTextController.text = widget.dataMap[faveMUTitle];
      _bedroomsTextController.text = widget.dataMap[faveMUBeds];
      _bathroomsTextController.text = widget.dataMap[faveMUBaths];
      _sizeTextController.text = widget.dataMap[faveMUSize];
      _sizePostfixTextController.text = widget.dataMap[faveMUSizePostfix];
      _priceTextController.text = widget.dataMap[faveMUPrice];
      _pricePostfixTextController.text = widget.dataMap[faveMUPricePostfix];
      _typeTextController.text = widget.dataMap[faveMUType];
      _availabilityDateTextController.text = widget.dataMap[faveMUAvailabilityDate];

      if (_bedroomsTextController.text.isNotEmpty) {
        _bedrooms = int.parse(_bedroomsTextController.text);
      }

      if (_bathroomsTextController.text.isNotEmpty) {
        _bathrooms = int.parse(_bathroomsTextController.text);
      }

      tempDataMap = widget.dataMap;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: CardWidget(
        shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
        child: Column(
          children: [
            addPropertyTitle(),
            addRoomsInformation(),
            addPropertySizeInformation(),
            addPropertyPriceInformation(),
            addPropertyRelatedInformation(),
            const Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 20)),
          ],
        ),
      ),
    );
  }

  updateDataMap(){
    widget.genericMultiUnitsWidgetBodyListener(
        widget.index, widget.dataMap, false);
  }

  Widget addPropertyTitle(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: UtilityMethods.isRTL(context) ? 10 : 20,
            right: UtilityMethods.isRTL(context) ? 20 : 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              labelWidget(UtilityMethods.getLocalizedString("plan_title")),
              IconButton(
                onPressed: (){
                  widget.genericMultiUnitsWidgetBodyListener(widget.index, widget.dataMap, true);
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
            hintText: UtilityMethods.getLocalizedString("enter_your_property_title"),
            keyboardType: TextInputType.text,
            controller: _titleTextController,
            onChanged: (title){
              widget.dataMap[faveMUTitle]  = title;
              updateDataMap();
            },
          ),
        ),
      ],
    );
  }

  Widget addRoomsInformation(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: addNumberOfBedrooms()),
        Expanded(flex: 5, child: addNumberOfBathrooms()),
      ],
    );
  }

  Widget labelWidget(String text){
    return GenericTextWidget(
      text,
      style: AppThemePreferences().appTheme.labelTextStyle,
    );
  }

  Widget addNumberOfBedrooms(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: labelWidget(UtilityMethods.getLocalizedString("bedrooms")),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 15,
            left: UtilityMethods.isRTL(context) ? 0 : 10,
            right: UtilityMethods.isRTL(context) ? 10 : 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                iconSize: AppThemePreferences.addPropertyDetailsIconButtonSize,
                icon: Icon(AppThemePreferences.removeCircleOutlinedIcon),
                onPressed: (){
                  if(_bedrooms > 0){
                    _bedrooms -= 1;
                    _bedroomsTextController.text = _bedrooms.toString();
                    widget.dataMap[faveMUBeds]  = _bedroomsTextController.text;
                    updateDataMap();
                  }
                },
              ),
              SizedBox(
                width: 55,
                height: 50,
                child: TextFormField(
                  decoration: AppThemePreferences.formFieldDecoration(),
                  controller: _bedroomsTextController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value){
                    _bedrooms = int.parse(value);
                    widget.dataMap[faveMUBeds]  = value;
                    updateDataMap();
                  },
                ),
              ),
              IconButton(
                iconSize: AppThemePreferences.addPropertyDetailsIconButtonSize,
                icon: Icon(AppThemePreferences.addCircleOutlinedIcon),
                onPressed: (){
                  if(_bedrooms >= 0){
                    _bedrooms += 1;
                    _bedroomsTextController.text = _bedrooms.toString();
                    widget.dataMap[faveMUBeds]  = _bedroomsTextController.text;
                    updateDataMap();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget addNumberOfBathrooms(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: labelWidget(UtilityMethods.getLocalizedString("bathrooms")),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 15,
            left: UtilityMethods.isRTL(context) ? 0 : 10,
            right: UtilityMethods.isRTL(context) ? 10 : 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                iconSize: AppThemePreferences.addPropertyDetailsIconButtonSize,
                icon: Icon(AppThemePreferences.removeCircleOutlinedIcon),
                onPressed: (){
                  if(_bathrooms > 0){
                    _bathrooms -= 1;
                    _bathroomsTextController.text = _bathrooms.toString();
                    widget.dataMap[faveMUBaths]  = _bathroomsTextController.text;
                    updateDataMap();
                  }
                },
              ),
              SizedBox(
                width: 55,
                height: 50,
                child: TextFormField(
                  decoration: AppThemePreferences.formFieldDecoration(),
                  controller: _bathroomsTextController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value){
                    _bathrooms = int.parse(value);
                    widget.dataMap[faveMUBaths]  = _bathrooms;
                    updateDataMap();
                  },
                ),
              ),
              IconButton(
                iconSize: AppThemePreferences.addPropertyDetailsIconButtonSize,
                icon: Icon(AppThemePreferences.addCircleOutlinedIcon),
                onPressed: (){
                  if(_bathrooms >= 0){
                    _bathrooms += 1;
                    _bathroomsTextController.text = _bathrooms.toString();
                    widget.dataMap[faveMUBaths]  = _bathroomsTextController.text;
                    updateDataMap();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget addPropertySizeInformation(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: addPropertySize()),
        Expanded(flex: 5, child: addSizePostfix()),
      ],
    );
  }

  Widget addPropertySize(){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("property_size"),
        hintText: UtilityMethods.getLocalizedString("enter_area_size"),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        controller: _sizeTextController,
        onChanged: (size){
          widget.dataMap[faveMUSize]  = size;
          updateDataMap();
        },
      ),
    );
  }

  Widget addSizePostfix(){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("size_postfix"),
        hintText: UtilityMethods.getLocalizedString("enter_size_postfix"),
        controller: _sizePostfixTextController,
        onChanged: (value){
          widget.dataMap[faveMUSizePostfix]  = value;
          updateDataMap();
        },
      ),
    );
  }

  Widget addPropertyPriceInformation(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: addPrice()),
        Expanded(flex: 5, child: addPricePostfix()),
      ],
    );
  }

  Widget addPrice(){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("price"),
        hintText: UtilityMethods.getLocalizedString("enter_the_price"),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        controller: _priceTextController,
        onChanged: (value){
          widget.dataMap[faveMUPrice]  = value;
          updateDataMap();
        },
      ),
    );
  }

  Widget addPricePostfix(){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("price_postfix"),
        hintText: UtilityMethods.getLocalizedString("enter_price_postfix"),
        controller: _pricePostfixTextController,
        onChanged: (value){
          widget.dataMap[faveMUPricePostfix]  = value;
          updateDataMap();
        },
      ),
    );
  }

  Widget addPropertyRelatedInformation(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: addPropertyType()),
        Expanded(flex: 5, child: addPropertyAvailabilityDate()),
      ],
    );
  }

  Widget addPropertyType(){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("property_type"),
        hintText: UtilityMethods.getLocalizedString("enter_property_type"),
        controller: _typeTextController,
        onChanged: (value){
          widget.dataMap[faveMUType]  = value;
          updateDataMap();
        },
      ),
    );
  }

  Widget addPropertyAvailabilityDate(){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("availability_date"),
        hintText: UtilityMethods.getLocalizedString("enter_the_date"),
        keyboardType: TextInputType.text,
        controller: _availabilityDateTextController,
        onChanged: (value){
          widget.dataMap[faveMUAvailabilityDate]  = value;
          updateDataMap();
        },
      ),
    );
  }
}