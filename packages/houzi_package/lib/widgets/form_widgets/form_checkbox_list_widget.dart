import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/term_checkbox_list_widget.dart';

typedef GenericFormCheckboxListFieldWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericFormCheckboxListFieldWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericFormCheckboxListFieldWidgetListener listener;

  const GenericFormCheckboxListFieldWidget({
    Key? key,
    required this.formItem,
    this.infoDataMap,
    this.formItemPadding,
    required this.listener,
  }) : super(key: key);

  @override
  State<GenericFormCheckboxListFieldWidget> createState() => _GenericFormCheckboxListFieldWidgetState();
}

class _GenericFormCheckboxListFieldWidgetState extends State<GenericFormCheckboxListFieldWidget> {

  String? apiKey;
  bool loadingData = false;
  Map<String, dynamic>? infoDataMap;
  Map<String, dynamic>? listenerDataMap;

  List<dynamic> _termDataItemsList = [];
  List<dynamic> selectedDataItemsList = [];

  final PropertyBloc _propertyBloc = PropertyBloc();

  @override
  void initState() {

    loadData(widget.formItem);

    apiKey = widget.formItem.apiKey;
    infoDataMap = widget.infoDataMap;

    if (infoDataMap != null && apiKey != null && apiKey!.isNotEmpty) {
      if (infoDataMap!.containsKey(apiKey)) {
        selectedDataItemsList = infoDataMap![apiKey] ?? [];
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    apiKey = null;
    infoDataMap = null;
    listenerDataMap = null;
    _termDataItemsList = [];
    selectedDataItemsList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loadingData
        ? Container(padding: widget.formItemPadding, child: DataLoadingWidget())
        : TermCheckBoxListWidget(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            comparisonOnTheBasisOf: TERM_ID,
            termDataList: _termDataItemsList,
            selectedDataList: selectedDataItemsList,
            listener: (selectedDataList) {
              selectedDataItemsList = selectedDataList;
              updateData(selectedDataItemsList);
            },
          );
  }

  updateData(List<dynamic> updatedDataItemsList) {
    if (apiKey != null && apiKey!.isNotEmpty) {
      listenerDataMap = { apiKey! : updatedDataItemsList };
      widget.listener(listenerDataMap!);
    }
  }

  loadData (HouziFormItem formItem) {
    if (getTermDataFromStorage(formItem).isNotEmpty) {
      if (mounted) {
        setState(() {
          _termDataItemsList = getTermDataFromStorage(formItem);
        });
      }
    } else {
      getAndStoreTermData(formItem.termType);
    }
  }

  List<dynamic> getTermDataFromStorage (HouziFormItem formItem) {
    switch(formItem.termType) {
      case propertyTypeDataType: {
        return HiveStorageManager.readPropertyTypesMetaData() ?? [];
      }

      case propertyStatusDataType: {
        return HiveStorageManager.readPropertyStatusMetaData() ?? [];
      }

      case propertyLabelDataType: {
        return HiveStorageManager.readPropertyLabelsMetaData() ?? [];
      }

      case propertyAreaDataType: {
        return HiveStorageManager.readPropertyAreaMetaData() ?? [];
      }

      case propertyCityDataType: {
        return HiveStorageManager.readCitiesMetaData() ?? [];
      }

      case propertyStateDataType: {
        return HiveStorageManager.readPropertyStatesMetaData() ?? [];
      }

      case propertyCountryDataType: {
        return HiveStorageManager.readPropertyCountriesMetaData() ?? [];
      }

      case propertyFeatureDataType: {
        return HiveStorageManager.readPropertyFeaturesMetaData() ?? [];
      }

      default: {
        return [];
      }
    }
  }

  getAndStoreTermData(String? term) {
    if(term != null && term.isNotEmpty) {
      fetchTermData(term).then((value) {
        if(value.isNotEmpty){
          if(mounted){
            setState(() {
              List<dynamic> termsMetaData = value;
              if(termsMetaData.isNotEmpty) {
                _termDataItemsList = termsMetaData;
                UtilityMethods.storePropertyMetaDataList(
                  dataType: term,
                  metaDataList: termsMetaData,
                );
              }
            });
          }
        }
        return null;
      });
    }

  }

  Future<List<dynamic>> fetchTermData(String term) async {
    if(mounted){
      setState(() {
        loadingData = true;
      });
    }
    List<dynamic> termData = [];
    List<dynamic> tempTermData = await _propertyBloc.fetchTermData(term);
    if(tempTermData == null ||
        (tempTermData.isNotEmpty && tempTermData[0] == null) ||
        (tempTermData.isNotEmpty && tempTermData[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          loadingData = false;
        });
      }
      return termData;
    }else{
      if (mounted) {
        setState(() {
          loadingData = false;
        });
      }
      if(tempTermData.isNotEmpty){
        termData.addAll(tempTermData);
      }
    }

    return termData;
  }
}
