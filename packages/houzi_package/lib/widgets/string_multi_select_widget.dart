import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/custom_widgets/alert_dialog_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef StringMultiSelectWidgetListener = Function(List<String> selectedItems);

class StringMultiSelectWidget extends StatefulWidget {

  final List<String> dataList;
  final List<String> selectedDataList;
  final StringMultiSelectWidgetListener listener;
  final EdgeInsetsGeometry? padding;

  const StringMultiSelectWidget({
    Key? key,
    required this.dataList,
    required this.selectedDataList,
    required this.listener,
    this.padding = const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
  }) : super(key: key);

  @override
  State<StringMultiSelectWidget> createState() => _StringMultiSelectWidgetState();
}

class _StringMultiSelectWidgetState extends State<StringMultiSelectWidget> {

  final TextEditingController dropDownTextController = TextEditingController();


  // @override
  // void initState() {
  //   setTextFieldValue(widget.selectedDataList);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    setTextFieldValue(widget.selectedDataList);
    return Column(
      children: [
        Container(
          padding: widget.padding,
          child: TextFormField(
            controller: dropDownTextController,
            decoration: AppThemePreferences.formFieldDecoration(
              hintText: UtilityMethods.getLocalizedString("select"),
              suffixIcon: Icon(AppThemePreferences.dropDownArrowIcon),
            ),
            readOnly: true,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              _showMultiSelectWidgetDialog(context);
            },
          ),
        ),
      ],
    );
  }

  void _showMultiSelectWidgetDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StringMultiSelectDialogWidget(
          title: UtilityMethods.getLocalizedString("select"),
          dataList: widget.dataList,
          selectedDataList: widget.selectedDataList,
          // listener: listener,
          listener: (itemsList) {
            if (mounted) {
              setState(() {
                widget.listener(itemsList);
                setTextFieldValue(itemsList);
              });
            }
          },
        );
      },
    );
  }

  setTextFieldValue(List<String> itemsList) {
    if (itemsList.isNotEmpty) {
      int listLength = itemsList.toSet().toList().length;

      if (listLength == 1) {
        dropDownTextController.text = UtilityMethods.getLocalizedString(itemsList.toSet().toList().first);
      } else {
        dropDownTextController.text = UtilityMethods.getLocalizedString(
          "multi_select_drop_down_item_selected",
          inputWords: [(listLength.toString())],
        );
      }
    } else {
      dropDownTextController.text = "";
    }
  }
}

typedef StringMultiSelectDialogWidgetListener = void Function(List<String> listOfSelectedItems);

class StringMultiSelectDialogWidget extends StatefulWidget {
  final String title;
  final List<String> dataList;
  final List<String> selectedDataList;
  final StringMultiSelectDialogWidgetListener listener;

  const StringMultiSelectDialogWidget({
    Key? key,
    required this.title,
    required this.dataList,
    required this.selectedDataList,
    required this.listener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => StringMultiSelectDialogWidgetState();

}

class StringMultiSelectDialogWidgetState extends State<StringMultiSelectDialogWidget> {

  List<String> _dataItemsList = [];
  List<String> _selectedItemsList = [];


  @override
  void initState() {
    _dataItemsList = widget.dataList;
    _selectedItemsList = widget.selectedDataList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialogWidget(
      title: GenericTextWidget(UtilityMethods.getLocalizedString(widget.title)),
      contentPadding: const EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          child: ListBody(
            children: _dataItemsList.map((item) {
              final checked = _selectedItemsList.contains(item);

              return CheckboxListTile(
                activeColor: AppThemePreferences().appTheme.primaryColor,
                value: checked,
                title: GenericTextWidget(UtilityMethods.getLocalizedString(item)),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (checked) => _onItemCheckedChange(item, checked ?? false),
              );
            }).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        TextButtonWidget(
          child: GenericTextWidget(UtilityMethods.getLocalizedString("cancel")),
          onPressed: ()=> Navigator.pop(context),
        ),
        TextButtonWidget(
          child: GenericTextWidget(UtilityMethods.getLocalizedString("ok")),
          onPressed: () {
            widget.listener(_selectedItemsList);
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  void _onItemCheckedChange(String item, bool checked) {
    if (mounted) {
      setState(() {
        if (checked) {
          _selectedItemsList.add(item);
        } else {
          _selectedItemsList.remove(item);
        }
      });
    }
  }
}