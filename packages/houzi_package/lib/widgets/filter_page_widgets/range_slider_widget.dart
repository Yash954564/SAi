import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/custom_widgets/showModelBottomSheetWidget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef RangePickerListener = void Function(String _conversionUnit, String maxRangeValue, String minRangeValue);

class RangePickerWidget extends StatefulWidget {
  final String pickerTitle;
  final Icon pickerIcon;
  final String pickerType;
  final double minRange;
  final double maxRange;
  final double selectedMinRange;
  final double selectedMaxRange;
  final String pickerSelectedSymbol;
  final String bottomSheetMenuTitle;
  final Map<String, String>? mapOfBottomSheetMenu;
  final RangePickerListener rangePickerListener;
  final int? divisions;

  const RangePickerWidget({
    Key? key,
    required this.pickerTitle,
    required this.pickerIcon,
    required this.pickerType,
    this.minRange = 0.0,
    this.maxRange = 1000000.0,
    this.bottomSheetMenuTitle = "",
    this.mapOfBottomSheetMenu,
    required this.selectedMinRange,
    required this.selectedMaxRange,
    required this.pickerSelectedSymbol,
    required this.rangePickerListener,
    this.divisions,
  }) : super(key: key);


  @override
  State<StatefulWidget> createState() => _RangePickerWidgetState();
}

class _RangePickerWidgetState  extends State<RangePickerWidget>{

  double? _min;
  double? _max;
  int _div = 1000;
  int _bottomRadioValue = 0;
  String _conversionUnit = "";
  String _startingRangeValue = "";
  String _endingRangeValue = "";

  double? _startingValue;
  double? _endingValue;


  final TextEditingController _startingValueController = TextEditingController();
  final TextEditingController _endingValueController = TextEditingController();

  var numberFormat;

  @override
  void initState() {
    if (widget.divisions != null) {
      _div = widget.divisions!;
    }

    _min = widget.minRange;
    _max = widget.maxRange;

    if(_min != null){
      _startingValueController.addListener(_setStartValue);
    }

    if(_max != null){
      _endingValueController.addListener(_setEndValue);
    }

    numberFormat = UtilityMethods.getNumberFormat();

    if (widget.pickerSelectedSymbol.isNotEmpty) {
      _conversionUnit = widget.pickerSelectedSymbol;
      if (widget.mapOfBottomSheetMenu != null &&
          widget.mapOfBottomSheetMenu!.isNotEmpty) {
        _bottomRadioValue = widget.mapOfBottomSheetMenu!.entries
            .map((e) => e.value)
            .toList()
            .indexWhere((element) => widget.pickerSelectedSymbol == element);
      }
    } else {
      if (widget.mapOfBottomSheetMenu != null &&
          widget.mapOfBottomSheetMenu!.isNotEmpty) {
        String key = widget.mapOfBottomSheetMenu!.keys.elementAt(0);
        _conversionUnit = widget.mapOfBottomSheetMenu![key]!;
        _bottomRadioValue = 0;
      }
    }

    _startingValue = widget.selectedMinRange;
    _endingValue = widget.selectedMaxRange;

    setMinMaxValuesToField(_startingValue!, _endingValue!);

    super.initState();
  }

  @override
  void dispose() {
    /// Clean up the controller when the widget is removed from the widget tree.
    /// This also removes the _printLatestValue listener.
    _startingValueController.dispose();
    _endingValueController.dispose();
    super.dispose();
  }

  _setStartValue() {
    _handleFieldValuesChanged();
  }

  _setEndValue() {
    _handleFieldValuesChanged();
  }
  _handleFieldValuesChanged() {
    String _startValue =  _startingValueController.text;
    String _endValue = _endingValueController.text;

    _startValue = cleanPrice(_startValue);
    _endValue = cleanPrice(_endValue);

    double _startDoubleTemp = _startValue.isNotEmpty ? double.parse(_startValue) : 0;
    double _endDoubleTemp = _endValue.isNotEmpty ? double.parse(_endValue) : 0;

    double _startDouble = min(_startDoubleTemp, _endDoubleTemp);
    double _endDouble = max(_startDoubleTemp, _endDoubleTemp);

    _startDouble = max(_startDouble, _min!);
    _endDouble = min(_max!, _endDouble);


    if (mounted) {
      setState(() {
        _startingValue = _startDouble;
        _endingValue = _endDouble;
        setMinMaxValuesToField(max(_startDoubleTemp, _min!), min(_max!, _endDoubleTemp));
      });
    }
  }

  setMinMaxValuesToField(double _startDoubleTemp, double _endDoubleTemp) {

    String _startingValueString = _startDoubleTemp.round().toString();
    String _endingValueString = _endDoubleTemp.round().toString();

    if (numberFormat != null) {
      _startingValueString = numberFormat.format(_startDoubleTemp.round()).toString();
      _endingValueString = numberFormat.format(_endDoubleTemp.round()).toString();
    }

    TextSelection startSelection = TextSelection.fromPosition(TextPosition(offset: _startingValueString.length));
    _startingValueController.value = TextEditingValue(
      text: _startingValueString,
      selection: startSelection,
    );

    TextSelection selection = TextSelection.fromPosition(TextPosition(offset: _endingValueString.length));
    _endingValueController.value = TextEditingValue(
      text: _endingValueString,
      selection: selection,
    );
  }

  @override
  Widget build(BuildContext context) {

    if (widget.divisions != null) {
      _div = widget.divisions!;
    }

    _min = widget.minRange;
    _max = widget.maxRange;


    if ((widget.selectedMinRange != _startingValue)
        || (widget.selectedMaxRange != _endingValue)) {

      _startingValue = widget.selectedMinRange;
      _endingValue = widget.selectedMaxRange;
      setMinMaxValuesToField(_startingValue!, _endingValue!);
    }

    return Container(
      height: 220,
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        border: Border(
          top: AppThemePreferences().appTheme.filterPageBorderSide!,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleBarWidget(),
          rangeSliderWidget(),
        ],
      ),
    );
  }

  Widget titleBarWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: widget.pickerIcon,
        ),

        // Title of Widget
        Expanded(
          flex: 6,
          child:  GenericTextWidget(
            widget.pickerTitle,
            style: AppThemePreferences().appTheme.filterPageHeadingTitleTextStyle,
          ),
        ),

        /// CONVERSION UNIT TITLE
        Expanded(
          flex: 0,
          child: GestureDetector(
            child: GenericTextWidget(
              _conversionUnit,
              style: AppThemePreferences().appTheme.rangeSliderWidgetConversionUnitTextStyle,
            ),
            onTap: (){
              if(widget.mapOfBottomSheetMenu != null &&
                  widget.mapOfBottomSheetMenu!.isNotEmpty){
                _bottomMenu(context);
              }

            },
          ),
        ),

        /// CONVERSION UNIT DROP DOWN MENU
        SHOW_DEMO_CONFIGURATIONS && widget.bottomSheetMenuTitle.isNotEmpty &&
            widget.mapOfBottomSheetMenu != null &&
            widget.mapOfBottomSheetMenu!.isNotEmpty
            ? Expanded(
                flex: 2,
                child: IconButton(
                  icon: AppThemePreferences()
                      .appTheme
                      .filterPageArrowDropDownIcon!,
                  onPressed: () {
                    if (widget.mapOfBottomSheetMenu != null &&
                        widget.mapOfBottomSheetMenu!.isNotEmpty) {
                      _bottomMenu(context);
                    }
                  },
                ),
              )
            : Expanded(
                flex: 2,
                child: Container(),
              ),
      ],
    );
  }

  Widget rangeSliderWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rangeInNumbersWidget(),
        sliderWidget(),
      ],
    );
  }

  Widget rangeInNumbersWidget(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex:4,
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _startingValueController,
                onChanged: (text) {
                  //_setStartValue();

                  widget.rangePickerListener(_conversionUnit, _startingValue!.round().toString(),
                      _endingValue!.round().toString());
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(),
                  ),
                  contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  hintText: UtilityMethods.getLocalizedString("zero"),
                ),
                keyboardType: TextInputType.number, inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ], // Only numbers can be entered
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: GenericTextWidget(
                UtilityMethods.getLocalizedString("to"),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            flex:4,
            child: SizedBox(
              height: 40,
              child: TextField(

                controller: _endingValueController,
                onChanged: (text) {
                  //_setEndValue();
                  widget.rangePickerListener(
                      _conversionUnit,
                      _startingValue!.round().toString(),
                      _endingValue!.round().toString(),
                  );
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(),
                  ),
                  contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  hintText: UtilityMethods.getLocalizedString("any"),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ], // Only numbers can be entered
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sliderWidget(){
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SliderTheme(
        data: SliderThemeData(
            trackHeight: 2.5,//5.0
            activeTrackColor: AppThemePreferences.sliderTintColor,
            inactiveTrackColor: AppThemePreferences.sliderTintColor.withOpacity(0.3),
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
            thumbColor: AppThemePreferences.sliderTintColor,
            overlayColor: AppThemePreferences.sliderTintColor.withOpacity(0.3),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
            valueIndicatorColor: AppThemePreferences.sliderTintColor.withOpacity(0.3),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorTextStyle: TextStyle(
              color: AppThemePreferences.sliderTintColor,
            )
        ),
        // data: SliderThemeData(
        //     trackHeight: 5.0,
        //     activeTrackColor: AppThemePreferences().appTheme.selectedItemTextColor,
        //     inactiveTrackColor: AppThemePreferences().appTheme.selectedItemBackgroundColor,
        //     // inactiveTrackColor: Colors.grey.shade400,
        //     activeTickMarkColor: Colors.transparent,
        //     inactiveTickMarkColor: Colors.transparent,
        //     thumbColor: AppThemePreferences().appTheme.selectedItemTextColor,
        //     overlayColor: AppThemePreferences().appTheme.selectedItemTextColor.withAlpha(32),
        //     overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
        //     valueIndicatorColor: AppThemePreferences().appTheme.selectedItemBackgroundColor,
        //     // valueIndicatorColor: Theme.of(context).primaryColor,
        //     valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        //     valueIndicatorTextStyle: TextStyle(
        //       color: AppThemePreferences().appTheme.selectedItemTextColor,
        //       // color: Colors.white,
        //     )
        // ),
        child: RangeSlider(
          // values: RangeValues(widget.minRange, widget.maxRange),
          // min: widget.minRange,
          // max: widget.maxRange,
          // divisions: 1000,
          values: RangeValues(_startingValue!, _endingValue!),
          min: _min!,
          max: _max!,
          // min: widget.minRange,
          // max: widget.maxRange,
          divisions: _div,
          labels: RangeLabels(
            '$_conversionUnit ${numberFormat != null
                ? numberFormat.format(_startingValue!.round())
                : _startingValue!.round()}',
            '$_conversionUnit ${numberFormat != null
                ? numberFormat.format(_endingValue!.round())
                : _endingValue!.round()}',
          ),
          onChanged: (RangeValues values) {
            if(mounted) setState(() {
              _startingValue = values.start;
              _endingValue = values.end;
              setMinMaxValuesToField(_startingValue!, _endingValue!);
            });
            widget.rangePickerListener(
                _conversionUnit,
                _startingValue!.round().toString(),
                _endingValue!.round().toString(),
            );
          },
        ),
      ),
    );
  }

  void _bottomMenu(BuildContext context){
    showModelBottomSheetWidget(
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: AppThemePreferences().appTheme.bottomNavigationMenuColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 20, 25, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// DROP DOWN MENU TITLE
                          Expanded(
                            flex: 9,
                            child: GenericTextWidget(
                              widget.bottomSheetMenuTitle,
                              style: AppThemePreferences().appTheme.bottomSheetMenuTitleTextStyle,
                            ),
                          ),

                          // ICON: TICK MARK => DONE
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: AppThemePreferences().appTheme.bottomNavigationMenuIcon!,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// DROP DOWN MENU GENERATION
                    Container(
                      decoration: BoxDecoration(
                        color: AppThemePreferences().appTheme.bottomNavigationMenuColor,
                        border: Border(
                          top: AppThemePreferences().appTheme.bottomNavigationMenuBorderSide!,
                        ),
                      ),

                      padding: const EdgeInsets.only(top: 15, left: 20, bottom: 0, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        widget.mapOfBottomSheetMenu!.entries.map<Widget>((item)=> Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: GestureDetector(
                                child: GenericTextWidget(
                                  item.key, // KEY CONTAINS THE OPTION
                                  style: AppThemePreferences().appTheme.bottomNavigationMenuItemsTextStyle,
                                ),
                                onTap: (){
                                  if(mounted) setState(() {
                                    _conversionUnit = item.value;
                                    _bottomRadioValue = widget
                                            .mapOfBottomSheetMenu!.entries
                                            .map((e) => e.value)
                                            .toList()
                                            .indexWhere((element) =>
                                                item.value == element);
                                      });
                                  state((){
                                    _bottomRadioValue = widget
                                            .mapOfBottomSheetMenu!.entries
                                            .map((e) => e.value)
                                            .toList()
                                            .indexWhere((element) =>
                                                item.value == element);
                                      });

                                  /// RETURNING CONVERSION UNIT AS CALL BACK
                                  widget.rangePickerListener(_conversionUnit, _startingRangeValue, _endingRangeValue);
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child:Radio(
                                activeColor: AppThemePreferences().appTheme.primaryColor,
                                value: widget.mapOfBottomSheetMenu!.entries.map((e) => e.value).toList().
                                indexWhere((element) => item.value == element),
                                groupValue: _bottomRadioValue,
                                onChanged: (value) {
                                  if(mounted) setState(() {
                                    _conversionUnit = item.value;
                                          _bottomRadioValue = widget
                                              .mapOfBottomSheetMenu!.entries
                                              .map((e) => e.value)
                                              .toList()
                                              .indexWhere((element) =>
                                                  item.value == element);
                                        });
                                  state((){
                                    _bottomRadioValue = widget
                                            .mapOfBottomSheetMenu!.entries
                                            .map((e) => e.value)
                                            .toList()
                                            .indexWhere((element) =>
                                                item.value == element);
                                      });

                                  /// RETURNING CONVERSION UNIT AS CALL BACK
                                  widget.rangePickerListener(
                                        _conversionUnit,
                                        _startingRangeValue,
                                        _endingRangeValue,
                                  );
                                },
                              ),
                            ),
                          ],
                        )).toList(),
                      ),
                    ),
                  ],
                );
              }),
        );
      },
    );
  }

  String cleanPrice(String value) {
    if(value.contains(",")){
      value = value.replaceAll(",", "");
    }
    if(value.contains(".")){
      value = value.replaceAll(".", "");
    }
    if(value.contains("\u{202F}")){
      value = value.replaceAll("\u{202F}", "");
    }
    return value;
  }
}