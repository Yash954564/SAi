import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/string_multi_select_widget.dart';

typedef  FilterStringMultiSelectWidgetListener = void Function(List<String> selectedItems);

class FilterStringMultiSelectWidget extends StatefulWidget {
  final String pickerTitle;
  final Icon pickerIcon;
  final List<String> dataList;
  final List<String> selectedDataList;
  final FilterStringMultiSelectWidgetListener listener;

  const FilterStringMultiSelectWidget({
    Key? key,
    required this.pickerTitle,
    required this.pickerIcon,
    required this.dataList,
    required this.selectedDataList,
    required this.listener,
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => _FilterStringMultiSelectWidgetState();

}

class _FilterStringMultiSelectWidgetState extends State<FilterStringMultiSelectWidget> {

  List<String> _dataList = [];
  List<String> _selectedDataList = [];

  @override
  void initState() {
    _dataList = widget.dataList;
    _selectedDataList = widget.selectedDataList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _selectedDataList = widget.selectedDataList;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: AppThemePreferences().appTheme.dividerColor!),
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
                StringMultiSelectWidget(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                  dataList: _dataList,
                  selectedDataList: _selectedDataList,
                  listener: (selectedItems) {
                    if (mounted) {
                      setState(() {
                        _selectedDataList = selectedItems;
                        widget.listener(_selectedDataList);
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}