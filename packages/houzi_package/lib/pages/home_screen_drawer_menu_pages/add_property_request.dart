import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/mixins/validation_mixins.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/drop_down_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/generic_add_room_widget.dart';

class AddPropertyRequest extends StatefulWidget {
  @override
  _AddPropertyRequestState createState() => _AddPropertyRequestState();
}

class _AddPropertyRequestState extends State<AddPropertyRequest> with ValidationMixin {
  final PropertyBloc _propertyBloc = PropertyBloc();
  bool isAgree = false;
  bool _showWaitingWidget = false;
  bool isInternetConnected = true;
  bool isDataLoadError = false;
  bool isSubmitButtonError = false;

  int _beds = 0;
  int _baths = 0;
  int perPage = 10;

  List<dynamic> _inquiryTypesList = [];
  List<dynamic> _locationsList = [];
  List<dynamic> _propertyTypesList = [];
  List<dynamic> _propertyTypeMetaDataList = [];
  List<dynamic> _countryList = [];
  List<dynamic> _statesList = [];
  List<dynamic> _areaMetaDataList = [];
  List<dynamic> _areaList = [];
  List<dynamic> inquiriesFromBoardList = [];
  List<Map> contactList = [];

  Map<String, dynamic> addRequestPropertyInfoMap = {};
  final formKey = GlobalKey<FormState>();

  final _bedroomsTextController = TextEditingController();
  final _bathroomsTextController = TextEditingController();

  String? name = "";
  String? email = "";

  String? _country;
  String? _state;
  String? _city;
  String? _area;

  @override
  void initState() {
    super.initState();
    name = HiveStorageManager.getUserName();
    email = HiveStorageManager.getUserEmail();
    loadData();
  }

  loadData() async {
    String inquiryTypes = HiveStorageManager.readInquiryTypeInfoData();
    _inquiryTypesList = inquiryTypes.split(', ');

    var cityData = HiveStorageManager.readCitiesMetaData();
    _propertyTypeMetaDataList = HiveStorageManager.readPropertyTypesMetaData();
    if (cityData != null && cityData.isNotEmpty) {
      _locationsList = cityData;
    }

    var countryData = HiveStorageManager.readPropertyCountriesMetaData();
    if (countryData != null && countryData.isNotEmpty) {
      _countryList = countryData;
    }

    var statusData = HiveStorageManager.readPropertyStatesMetaData();
    if (statusData != null && statusData.isNotEmpty) {
      _statesList = statusData;
    }

    if (_propertyTypeMetaDataList != null &&
        _propertyTypeMetaDataList.isNotEmpty) {
      List<dynamic> tempList = [];
      List<dynamic> tempList01 = [];
      for (int i = 0; i < _propertyTypeMetaDataList.length; i++) {
        if (_propertyTypeMetaDataList[i].parent == 0) {
          tempList.add(_propertyTypeMetaDataList[i]);
        }
      }

      for (int i = 0; i < tempList.length; i++) {
        for (int j = 0; j < _propertyTypeMetaDataList.length; j++) {
          if (tempList[i].id == _propertyTypeMetaDataList[j].parent) {
            tempList01.add(_propertyTypeMetaDataList[j]);
          }
        }
        _propertyTypesList.add(tempList[i]);
        _propertyTypesList.addAll(tempList01);
        tempList01 = [];
      }
    }

    _areaMetaDataList = await fetchTermData("property_area");
    if (_areaMetaDataList.isNotEmpty) {
      setState(() {
        _areaList = _areaMetaDataList;
      });
    }

    addRequestPropertyInfoMap = {
      INQUIRY_LEAD_ID: "",
      INQUIRY_ENQUIRY_TYPE: "",
      INQUIRY_PROPERTY_TYPE: "",
      INQUIRY_PRICE: "",
      INQUIRY_BEDS: "",
      INQUIRY_BATHS: "",
      INQUIRY_AREA_SIZE: "",
      INQUIRY_COUNTRY: "",
      INQUIRY_STATE: "",
      INQUIRY_CITY: "",
      INQUIRY_AREA: "",
      INQUIRY_ZIP_CODE: "",
      INQUIRY_MSG: "",
      INQUIRY_FIRST_NAME: "",
      INQUIRY_LAST_NAME: "",
      INQUIRY_EMAIL: "",
      INQUIRY_MOBILE: "",
    };

    if (ADD_PROP_GDPR_ENABLED == "1") {
      addRequestPropertyInfoMap[INQUIRY_GDPR] = "1";
    }
  }

  Future<List<dynamic>> fetchTermData(String term) async {
    List<dynamic> termData = [];
    termData = await _propertyBloc.fetchTermData(term);
    if(termData != null && termData.isNotEmpty && termData[0].runtimeType == Response){
      if(mounted){
        setState(() {
          isInternetConnected = false;
          isDataLoadError = true;
        });
      }
    }else{
      if(mounted){
        setState(() {
          isInternetConnected = true;
          isDataLoadError = false;
        });
      }
    }

    return termData;
  }

  @override
  void dispose() {
    _bedroomsTextController.dispose();
    _bathroomsTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("request_property"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardWidget(
                      shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                      child: Column(
                        children: [
                          headerTextWidget(UtilityMethods.getLocalizedString("contact")),
                          setValuesInFields(
                              UtilityMethods.getLocalizedString("first_name") + " *",
                              UtilityMethods.getLocalizedString("enter_first_name"),
                              TextInputType.text,
                              INQUIRY_FIRST_NAME,
                              validate: true,
                              giveTopPadding: true,
                              initialValue: name
                          ),
                          setValuesInFields(
                            UtilityMethods.getLocalizedString("last_name") + " *",
                            UtilityMethods.getLocalizedString("enter_last_name"),
                            TextInputType.text,
                            INQUIRY_LAST_NAME,
                            validate: true,
                          ),
                          setValuesInFields(
                              UtilityMethods.getLocalizedString("email") + " *",
                              UtilityMethods.getLocalizedString("enter_email_address"),
                              TextInputType.emailAddress,
                              INQUIRY_EMAIL,
                              emailValidation: true,
                              initialValue: email
                          ),
                          setValuesInFields(
                            UtilityMethods.getLocalizedString("mobile") + " *",
                            UtilityMethods.getLocalizedString("enter_mobile_address"),
                            TextInputType.phone,
                            INQUIRY_MOBILE,
                            validate: true,
                          ),
                        ],
                      ),
                    ),
                    CardWidget(
                      child: Column(
                        children: [
                          headerTextWidget(UtilityMethods.getLocalizedString("information")),
                          dropDownWidget(
                            UtilityMethods.getLocalizedString("type") + " *",
                            _inquiryTypesList,
                            INQUIRY_ENQUIRY_TYPE,
                            null,
                            validate: true,
                          ),
                          dropDownWidget(
                            UtilityMethods.getLocalizedString("property_type") + " *",
                            _propertyTypesList,
                            INQUIRY_PROPERTY_TYPE,
                            null,
                            validate: true,
                          ),
                          setValuesInFields(
                              UtilityMethods.getLocalizedString("max_price"),
                              UtilityMethods.getLocalizedString("enter_the_max_price"),
                              TextInputType.number,
                              INQUIRY_PRICE,
                              giveTopPadding: true
                          ),
                          addRoomsInformation(context),
                          setValuesInFields(
                            UtilityMethods.getLocalizedString("minimum_size"),
                            UtilityMethods.getLocalizedString("enter_the_min_size"),
                            TextInputType.number,
                            INQUIRY_AREA_SIZE,
                            giveTopPadding: true,
                          ),
                        ],
                      ),
                    ),
                    CardWidget(
                      shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                      child: Column(
                        children: [
                          headerTextWidget(UtilityMethods.getLocalizedString("address")),
                          dropDownWidget(
                            UtilityMethods.getLocalizedString("country") + " *",
                            _countryList,
                            INQUIRY_COUNTRY,
                            _country,
                            validate: true,
                          ),
                          dropDownWidget(
                              UtilityMethods.getLocalizedString("states"),
                              _statesList,
                              INQUIRY_STATE,
                              _state
                          ),
                          dropDownWidget(
                            UtilityMethods.getLocalizedString("city") + " *",
                            _locationsList,
                            INQUIRY_CITY,
                            _city,
                            validate: true,
                          ),
                          dropDownWidget(
                              UtilityMethods.getLocalizedString("area"),
                              _areaList,
                              INQUIRY_AREA,
                              _area
                          ),
                          setValuesInFields(
                            UtilityMethods.getLocalizedString("zip_code"),
                            UtilityMethods.getLocalizedString("enter_the_zip_code"),
                            TextInputType.number,
                            INQUIRY_ZIP_CODE,
                            giveTopPadding: true,
                          ),
                        ],
                      ),
                    ),
                    CardWidget(
                      shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                      child: Column(
                        children: [
                          headerTextWidget(UtilityMethods.getLocalizedString("message")),
                          setValuesInFields(
                            UtilityMethods.getLocalizedString("message"),
                            "",
                            TextInputType.text,
                            INQUIRY_MSG,
                            giveTopPadding: true,
                          ),
                        ],
                      ),
                    ),
                    CardWidget(
                      shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: saveButton(),
                      ),
                    ),
                  ],
                ),
                waitingWidget(),
                bottomActionBarWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget waitingWidget() {
    return _showWaitingWidget == true
        ? Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 100,
      child: Center(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: const SizedBox(
            // padding: EdgeInsets.only(top: 50),
            width: 80,
            height: 20,
            child: BallBeatLoadingWidget(),
          ),
        ),
      ),
    )
        : Container();
  }

  Widget bottomActionBarWidget() {
    return Positioned(
      bottom: 0.0,
      child: SafeArea(
        child: Column(
          children: [
            if(!isInternetConnected) NoInternetBottomActionBarWidget(
              onPressed: () {
                if(isDataLoadError){
                  loadData();
                }else if(isSubmitButtonError){
                  onSavePressed();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget headerTextWidget(String text) {
    return HeaderWidget(
      text: text,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom:
          BorderSide(color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
    );
  }

  Widget setValuesInFields(
      String labelText,
      String hintText,
      TextInputType textInputType,
      String key,
      {
        String? initialValue,
        emailValidation = false,
        bool validate = false,
        bool giveTopPadding = false
      }) {
    return Padding(
      padding: EdgeInsets.only(top: giveTopPadding ? 20 : 0, bottom:  20),
      child: TextFormFieldWidget(
        labelText: labelText,
        keyboardType: textInputType,
        hintText: hintText,
        initialValue: initialValue,
        maxLines: key == INQUIRY_MSG ? 5 : 1,
        onSaved: (String? value) {
          setState(() {
            addRequestPropertyInfoMap[key] = value;
          });
        },
        validator: emailValidation
            ? (value) => validateEmail(value!)
            : validate
            ? (value) {
          if (value == null || value.isEmpty) {
            return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
          }
          return null;
        }
            : null,
      ),
    );
  }

  Widget dropDownWidget(String text, List? list, String key, String? initialValue, {bool validate = false}) {
    return list != null && list.isNotEmpty
        ? GenericStringDropDownWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      labelText: text,
      value: initialValue == "" ? null : initialValue,
      hintText: UtilityMethods.getLocalizedString("select"),
      validator: validate
          ? (String? value) {
        if (value?.isEmpty ?? true) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty"); //AppLocalizations.of(context).;
        }
        return null;
      }
          : null,
      items: list.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          child: GenericTextWidget(
            key == INQUIRY_ENQUIRY_TYPE ? item : item.name,
          ),
          value: key == INQUIRY_ENQUIRY_TYPE ? item : item.name,
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          updateAddressRelatedFields(key, val);
          // addRequestPropertyInfoMap[key] = val;
        });
      },
      onSaved: (val) {
        setState(() {
          updateAddressRelatedFields(key, val);
          // addRequestPropertyInfoMap[key] = val;
        });
      },
      // onChanged: (val) {
      //   setState(() {
      //     addRequestPropertyInfoMap[key] = val;
      //   });
      // },
    )
        : Container();
  }

  updateAddressRelatedFields(String key, String? value) {
    if (key == INQUIRY_COUNTRY && addRequestPropertyInfoMap[key] != value) {
      _country = value;
      addRequestPropertyInfoMap[key] = value;
      // Reset sub fields
      _state = "";
      _city = "";
      _area = "";
      resetStatesList(_country);
    } else if (key == INQUIRY_STATE && addRequestPropertyInfoMap[key] != value) {
      _state = value;
      addRequestPropertyInfoMap[key] = value;
      // Reset sub fields
      _city = "";
      _area = "";
      resetCitiesList(_state);
    } else if (key == INQUIRY_CITY && addRequestPropertyInfoMap[key] != value) {
      _city = value;
      addRequestPropertyInfoMap[key] = value;
      // Reset sub field
      _area = "";
      resetAreasList(_city);
    }
    else if (key == INQUIRY_AREA && addRequestPropertyInfoMap[key] != value) {
      _area = value;
      addRequestPropertyInfoMap[key] = value;
    } else {
      addRequestPropertyInfoMap[key] = value;
    }
  }

  resetStatesList(String? country) {
    // print("resetting states List...");
    if (country != null && country.isNotEmpty) {
      _statesList = [];

      var statesData = HiveStorageManager.readPropertyStatesMetaData();

      Term? countryItem = UtilityMethods.getPropertyMetaDataObjectWithItemName(
          dataType: propertyCountryDataType, name: country);

      if (countryItem == null && statesData is List) {
        _statesList = statesData;
      } else if (statesData != null && statesData.isNotEmpty && statesData is List) {
        for (var state in statesData) {
          if (state.parentTerm.toLowerCase() == countryItem!.slug!.toLowerCase() || state.parentTerm.toLowerCase() == countryItem.name!.toLowerCase()) {
            _statesList.add(state);
          }
        }
        if (_statesList.isEmpty) {
          _locationsList = [];
          _areaList = [];
        }
      } else {
        _statesList = statesData ?? [];
      }
    }
  }

  resetCitiesList(String? state) {
    // print("resetting cities List...");
    if (state != null && state.isNotEmpty) {
      _locationsList = [];
      var cityData = HiveStorageManager.readCitiesMetaData();

      Term? stateItem = UtilityMethods.getPropertyMetaDataObjectWithItemName(
          dataType: propertyStateDataType, name: state);
      if (stateItem == null && cityData is List) {
        _locationsList = cityData;
      } else if (cityData != null && cityData.isNotEmpty && cityData is List) {
        for (var city in cityData) {
          if (city.parentTerm.toLowerCase() == stateItem!.slug!.toLowerCase() || city.parentTerm.toLowerCase() == stateItem.name!.toLowerCase()) {
            _locationsList.add(city);
          }
        }
        if (_locationsList.isEmpty) {
          _areaList = [];
        }
      } else {
        _locationsList = cityData ?? [];
      }
    }
  }

  resetAreasList(String? city) {
    // print("resetting areas List...");
    if (city != null && city.isNotEmpty) {
      _areaList = [];
      var areaData = HiveStorageManager.readPropertyAreaMetaData();

      Term? cityItem = UtilityMethods.getPropertyMetaDataObjectWithItemName(
          dataType: propertyCityDataType, name: city);
      if (cityItem == null && areaData is List) {
        _areaList = areaData;
      } else if (areaData != null && areaData.isNotEmpty && areaData is List) {
        for (var city in areaData) {
          if (city.parentTerm.toLowerCase() == cityItem!.slug!.toLowerCase() || city.parentTerm.toLowerCase() == cityItem.name!.toLowerCase()) {
            _areaList.add(city);
          }
        }
      } else {
        _areaList = areaData ?? [];
      }
    }
  }

  Widget inquiryTypeWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericTextWidget(UtilityMethods.getLocalizedString("type") + " *",
              style: AppThemePreferences().appTheme.labelTextStyle),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: DropdownButtonFormField(
              dropdownColor: AppThemePreferences().appTheme.dropdownMenuBgColor,
              icon: Icon(AppThemePreferences.dropDownArrowIcon),
              decoration: AppThemePreferences.formFieldDecoration(
                  hintText: UtilityMethods.getLocalizedString("select")
              ),
              validator: (String? value) {
                if (value?.isEmpty ?? true) {
                  return UtilityMethods.getLocalizedString("this_field_cannot_be_empty"); //;
                }
                return null;
              },
              items: _inquiryTypesList.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: GenericTextWidget(
                      item,
                    ),
                  ),
                  value: item,
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  addRequestPropertyInfoMap[INQUIRY_ENQUIRY_TYPE] = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget addRoomsInformation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: addNumberOfBedrooms()),
        Expanded(flex: 5, child: addNumberOfBathrooms()),
      ],
    );
  }

  Widget addNumberOfBedrooms() {
    return GenericStepperWidget(
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("bedrooms"),
      controller: _bedroomsTextController,
      onRemovePressed: () {
        if (_beds > 0) {
          setState(() {
            _beds -= 1;
            _bedroomsTextController.text = _beds.toString();
            addRequestPropertyInfoMap[INQUIRY_BEDS] = _beds.toString();
          });
        }
      },
      onAddPressed: () {
        if (_beds >= 0) {
          setState(() {
            _beds += 1;
            _bedroomsTextController.text = _beds.toString();
            addRequestPropertyInfoMap[INQUIRY_BEDS] = _beds.toString();
          });
        }
      },
      onChanged: (value) {
        setState(() {
          _beds = int.parse(value);
        });
      },
      validator: (String? value) {
        return null;
      },
    );
  }

  Widget addNumberOfBathrooms() {
    return GenericStepperWidget(
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("bathrooms"),
      controller: _bathroomsTextController,
      onRemovePressed: () {
        if (_baths > 0) {
          setState(() {
            _baths -= 1;
            _bathroomsTextController.text = _baths.toString();

            addRequestPropertyInfoMap[INQUIRY_BATHS] = _baths.toString();
          });
        }
      },
      onAddPressed: () {
        if (_baths >= 0) {
          setState(() {
            _baths += 1;
            _bathroomsTextController.text = _baths.toString();
            addRequestPropertyInfoMap[INQUIRY_BATHS] = _baths.toString();
          });
        }
      },
      onChanged: (value) {
        setState(() {
          _baths = int.parse(value);
        });
      },
      validator: (String? value) {
        return null;
      },
    );
  }

  Widget saveButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ButtonWidget(
        text: UtilityMethods.getLocalizedString("request_property"),
        onPressed: ()=> onSavePressed(),
      ),
    );
  }

  onSavePressed() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        _showWaitingWidget = true;
      });

      final response = await _propertyBloc.fetchAddRequestPropertyResponse(addRequestPropertyInfoMap);

      if(response == null || response.statusCode == null){
        if(mounted){
          setState(() {
            isInternetConnected = false;
            _showWaitingWidget = false;
            isSubmitButtonError = true;
          });
        }
      }else{
        if(mounted){
          setState(() {
            isInternetConnected = true;
            _showWaitingWidget = false;
            isSubmitButtonError = false;
          });
        }

        String tempResponseString = response.toString().split("{")[1];
        Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");

        if (map["success"] == true) {
          _showToast(context, map["msg"]);
          Navigator.of(context).pop();
        } else {
          _showToast(context, map["msg"]);
        }
      }
    }
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }
}
