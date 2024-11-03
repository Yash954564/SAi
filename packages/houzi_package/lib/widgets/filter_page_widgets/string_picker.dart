import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/custom_segment_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/choice_chip_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef StringPickerListener = void Function(List<dynamic> selectedItemsList);

class StringPicker extends StatefulWidget{
  final String pickerTitle;
  final Icon pickerIcon;
  final String pickerType;
  final List<String> pickerDataList;
  final List<dynamic> selectedItemsList;
  final StringPickerListener stringPickerListener;
  
  const StringPicker({
    Key? key,
    required this.pickerTitle,
    required this.pickerIcon,
    required this.pickerType,
    required this.pickerDataList,
    required this.selectedItemsList,
    required this.stringPickerListener
  }) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _StringPickerState();
  
}

class _StringPickerState extends State<StringPicker> {

  int? _selectedTermTitle;
  List<dynamic> _selectedItemsList = [];


  @override
  Widget build(BuildContext context) {

    _selectedItemsList = widget.selectedItemsList;
    if(widget.pickerType == tabsStringPicker && _selectedItemsList.isNotEmpty){
      _selectedTermTitle = widget.pickerDataList.indexOf(_selectedItemsList.first);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        border: Border(
          top: AppThemePreferences().appTheme.filterPageBorderSide!,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Wrap(
          children:[
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: widget.pickerIcon,
                    ),
                    Expanded(
                      flex: 8,
                      child: GenericTextWidget(
                        UtilityMethods.getLocalizedString(widget.pickerTitle),
                        style: AppThemePreferences().appTheme.filterPageHeadingTitleTextStyle,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                  child: widget.pickerType == tabsStringPicker
                      ? tabsTypeWidget()
                      : choiceChipsTypeWidget(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget choiceChipsTypeWidget(){
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 5.0,
            runSpacing: 6.0,
            children: widget.pickerDataList.map<Widget>((item)=> ChoiceChipWidget(
              label: Padding(
                padding: const EdgeInsets.all(5.0),
                child: GenericTextWidget(
                  UtilityMethods.getLocalizedString(item),
                  style: AppThemePreferences().appTheme.filterPageChoiceChipTextStyle,
                ),
              ),

              selected: widget.selectedItemsList.isNotEmpty
                  ? widget.selectedItemsList.contains(item)
                  : _selectedItemsList.contains(item),

              selectedColor: AppThemePreferences().appTheme.selectedItemBackgroundColor,
              onSelected: (bool selected) {
                if(selected){
                  _selectedItemsList.add(item);
                }else{
                  _selectedItemsList.remove(item);
                }
                setState(() {});
                widget.stringPickerListener(_selectedItemsList);
              },
              backgroundColor: AppThemePreferences().appTheme.unSelectedItemBackgroundColor,
              shape: AppThemePreferences.roundedCorners(
                AppThemePreferences.searchPageChoiceChipsRoundedCornersRadius,
              ),
              labelStyle: TextStyle(
                color: _selectedItemsList.contains(item) ?
                AppThemePreferences().appTheme.selectedItemTextColor :
                AppThemePreferences().appTheme.unSelectedItemTextColor,
              ),
            )).toList(),
          ),
        )
      ],
    );
  }

  Widget tabsTypeWidget(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
        child: SegmentedControlWidget(
          itemList: widget.pickerDataList,
          selectionIndex: _selectedTermTitle!,
          onSegmentChosen: onSegmentChosen,
          padding: EdgeInsets.only(left: 20 ,right: 20),
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          borderRadius: 0.0,
        )
      // MaterialSegmentedControl(
      //   children: widget.pickerDataList.map((item) {
      //     var index = widget.pickerDataList.indexOf(item);
      //     return Container(
      //       padding:  const EdgeInsets.only(left: 20 ,right: 20),
      //       child: genericTextWidget(
      //         UtilityMethods.getLocalizedString(item),
      //         style: TextStyle(
      //           fontSize: 16.0,
      //           fontWeight: FontWeight.w500,
      //           color: _selectedTermTitle == index ? AppThemePreferences().appTheme.selectedItemTextColor :
      //           AppThemePreferences.unSelectedItemTextColorLight,
      //         ),),
      //     );
      //   },).toList().asMap(),
      //
      //   selectionIndex: _selectedTermTitle,
      //   unselectedColor: AppThemePreferences().appTheme.unSelectedItemBackgroundColor,
      //   selectedColor: AppThemePreferences().appTheme.selectedItemBackgroundColor!,
      //   borderRadius: 0.0,
      //   verticalOffset: 8.0,
      //   onSegmentChosen: (int index){
      //     if(_selectedTermTitle != index || (!_selectedItemsList.contains(widget.pickerDataList[index]))){
      //         _selectedTermTitle = index;
      //         _selectedItemsList = [widget.pickerDataList[index]];
      //         widget.stringPickerListener(_selectedItemsList);
      //         setState(() {});
      //       }
      //     },
      // ),
    );
  }

  onSegmentChosen(int index) {
    if (_selectedTermTitle != index ||
        (!_selectedItemsList.contains(widget.pickerDataList[index]))) {
      _selectedTermTitle = index;
      _selectedItemsList = [widget.pickerDataList[index]];
      widget.stringPickerListener(_selectedItemsList);
      if(mounted) setState(() {});
    }
  }

}