import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/widgets/add_property_widgets/multi_units_widgets/multi_units_property_picker.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/light_button_widget.dart';

typedef MultiUnitsListingsIdsWidgetListener = void Function(String selectedIDs);

class MultiUnitsListingsIdsWidget extends StatefulWidget {
  final String selectedListingsIDs;
  final MultiUnitsListingsIdsWidgetListener listener;

  const MultiUnitsListingsIdsWidget({
    Key? key,
    required this.selectedListingsIDs,
    required this.listener,
  }) : super(key: key);

  @override
  State<MultiUnitsListingsIdsWidget> createState() => _MultiUnitsListingsIdsWidgetState();
}

class _MultiUnitsListingsIdsWidgetState extends State<MultiUnitsListingsIdsWidget> {

  String selectedListingsIDs = "";
  final _listingIDsTextController = TextEditingController();


  @override
  void initState() {

    checkCompatibleHouzezVersion();
    selectedListingsIDs = widget.selectedListingsIDs;
    _listingIDsTextController.text = selectedListingsIDs;

    super.initState();
  }


  @override
  void dispose() {
    selectedListingsIDs = "";
    _listingIDsTextController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return !SHOW_MULTI_UNITS_ID_FIELD
        ? Container()
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          child: TextFormFieldWidget(
            textFieldPadding: const EdgeInsets.only(bottom: 10),
            labelText: UtilityMethods.getLocalizedString("Listing IDs"),
            hintText:
            UtilityMethods.getLocalizedString("Listing IDs Hint"),
            additionalHintText: UtilityMethods.getLocalizedString("Listing IDs Additional Hint"),
            keyboardType: TextInputType.text,
            controller: _listingIDsTextController,
            onChanged: (listingIDs) {
              if (mounted && listingIDs != null) {
                setState(() {
                  selectedListingsIDs = listingIDs;
                  if (selectedListingsIDs.contains(" ")) {
                    selectedListingsIDs = selectedListingsIDs.replaceAll(" ", "");
                  }
                });
                updateDataMap();
              }
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: LightButtonWidget(
              text:
              UtilityMethods.getLocalizedString("Select Properties"),
              fontSize: AppThemePreferences.buttonFontSize,
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PropertyPickerMultiSelectDialogWidget(
                      title: UtilityMethods.getLocalizedString("select"),
                      selectedItems: selectedListingsIDs,
                      propertyPickerMultiSelectDialogWidgetListener: (List<String> _selectedItemsList) {
                        if (_selectedItemsList.isNotEmpty) {
                          String tempSelectedListingsIDs = "";
                          for (var item in _selectedItemsList) {
                            if (tempSelectedListingsIDs.isEmpty) {
                              tempSelectedListingsIDs = item;
                            } else {
                              tempSelectedListingsIDs = tempSelectedListingsIDs + "," + item;
                            }
                          }
                          if (tempSelectedListingsIDs.isNotEmpty) {
                            setState(() {
                              selectedListingsIDs = tempSelectedListingsIDs.replaceAll(" ", "");
                              _listingIDsTextController.text = selectedListingsIDs;
                            });
                            updateDataMap();
                          }
                        }
                      },
                    );
                  },
                );
              }),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 20),
                decoration:
                AppThemePreferences.dividerDecoration(bottom: true),
                child: Center(child: LabelWidget("OR")),
              ),
            ),
          ],
        ),
      ],
    );
  }

  updateDataMap(){
    widget.listener(selectedListingsIDs);
  }

  checkCompatibleHouzezVersion() {
    String houzez_version = HiveStorageManager.readHouzezVersion() ?? "";
    if(houzez_version.isNotEmpty){
      // Remove '.' from version (2.6.1 => 261)
      if(houzez_version.contains(".")){
        houzez_version = houzez_version.replaceAll(".", "");
      }

      int temp_houzez_version = int.tryParse(houzez_version) ?? -1;
      if(temp_houzez_version != -1 && temp_houzez_version >= 260){
        if(mounted){
          setState(() {
            SHOW_MULTI_UNITS_ID_FIELD = true;
          });
        }
      }
    }
  }
}
