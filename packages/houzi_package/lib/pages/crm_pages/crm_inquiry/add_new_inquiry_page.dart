import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/mixins/validation_mixins.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/pages/crm_pages/crm_webservices_manager/crm_repository.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/drop_down_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/generic_add_room_widget.dart';

typedef AddNewInquiryPageListener = void Function(bool reload);

class AddNewInquiry extends StatefulWidget {
  final CRMInquiries? inquiries;
  final bool forInquiryEdit;
  final AddNewInquiryPageListener addNewInquiryPageListener;

  const AddNewInquiry({
    super.key,
    required this.addNewInquiryPageListener,
    this.inquiries,
    required this.forInquiryEdit,
  });

  @override
  _AddNewInquiryState createState() => _AddNewInquiryState();
}

class _AddNewInquiryState extends State<AddNewInquiry> with ValidationMixin {
  bool isAgree = false;
  bool _showWaitingWidget = false;
  bool isInternetConnected = true;
  final CRMRepository _crmRepository = CRMRepository();

  int _beds = 0;
  int _baths = 0;
  int perPage = 100;

  String? _selectedInquiryType;
  String? _selectedContactName;

  String? _country;
  String? _state;
  String? _city;
  String? _area;

  List<String> _inquiryTypesList = [];
  List<dynamic> _locationsList = [];
  final List<dynamic> _propertyTypesList = [];
  List<dynamic> _propertyTypeMetaDataList = [];
  List<dynamic> _countryList = [];
  List<dynamic> _statesList = [];
  List<dynamic> _areaList = [];
  List<dynamic> leadsFromBoardList = [];
  List<Map> contactList = [];

  Map<String, dynamic> addInquiryInfoMap = {};
  final formKey = GlobalKey<FormState>();

  final _bedroomsTextController = TextEditingController();
  final _bathroomsTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    String? bed = widget.inquiries?.minBeds!;
    if (bed != null && bed.isNotEmpty) {
      _bedroomsTextController.text = bed;
    }
    String? bath = widget.inquiries?.minBeds!;
    if (bath != null && bath.isNotEmpty) {
      _bathroomsTextController.text = bath;
    }

    loadData();
  }

  checkInternetAndLoadData() {
    loadData();
  }

  loadData() async {
    leadsFromBoardList = await fetchLeadsFromBoard(1, perPage);
    CRMDealsAndLeads dealsAndLeads;
    if (leadsFromBoardList.isNotEmpty) {
      for (int i = 0; i < leadsFromBoardList.length; i++) {
        Map<String, dynamic> userInfoMap = {};
        dealsAndLeads = leadsFromBoardList[i];
        userInfoMap["id"] = dealsAndLeads.resultLeadId;
        userInfoMap["displayName"] = dealsAndLeads.displayName;
        contactList.add(userInfoMap);
      }

      if (widget.forInquiryEdit) {
        String? leadId = widget.inquiries?.leadId!;
        if (leadId != null && leadId.isNotEmpty) {
          Map map = contactList.firstWhere((element) => element["id"] == leadId, orElse: () => {});
          if (map.isNotEmpty) {
            _selectedContactName = map["id"];
          }
        }
      }

      if (mounted) {
        setState(() {});
      }
    }

    _areaList = await fetchTermData("property_area");

    String? inquiryTypes = HiveStorageManager.readInquiryTypeInfoData() ?? "";
    if (inquiryTypes != null && inquiryTypes.isNotEmpty) {
      _inquiryTypesList = inquiryTypes.split(', ');
    }

    _selectedInquiryType = widget.inquiries?.enquiryType!;

    var cityData = HiveStorageManager.readCitiesMetaData();

    if (cityData != null && cityData.isNotEmpty) {
      _locationsList = cityData;
    }

    var countryData = HiveStorageManager.readPropertyCountriesMetaData();
    if (countryData != null && countryData.isNotEmpty) {
      _countryList = countryData;
    }

    var statesData = HiveStorageManager.readPropertyStatesMetaData();
    if (statesData != null && statesData.isNotEmpty) {
      _statesList = statesData;
    }

    _propertyTypeMetaDataList = HiveStorageManager.readPropertyTypesMetaData();
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

    _country = widget.inquiries?.countryTypeName;
    _state = widget.inquiries?.stateTypeName;
    _city = widget.inquiries?.cityTypeName;
    _area = widget.inquiries?.areaTypeName;

    setState(() {});
  }

  Future<List<dynamic>> fetchLeadsFromBoard(int page, int perPage) async {
    List tempList = [];
    do {
      tempList = await _crmRepository.fetchLeadsFromBoard(page, perPage);
      if (tempList == null ||
          (tempList.isNotEmpty && tempList[0] == null) ||
          (tempList.isNotEmpty && tempList[0].runtimeType == Response)) {
        if (mounted) {
          setState(() {
            isInternetConnected = false;
          });
        }
        break;
      } else {
        if (!isInternetConnected && mounted) {
          setState(() {
            isInternetConnected = true;
          });
        }
        leadsFromBoardList.addAll(tempList);
        page++;
      }
    } while (tempList.length >= perPage);
    return leadsFromBoardList;
  }

  Future<List<dynamic>> fetchTermData(String term) async {
    List<dynamic> termData = [];
    List<dynamic> tempTermData = await _crmRepository.fetchTermData(term);
    if (tempTermData == null ||
        (tempTermData.isNotEmpty && tempTermData[0] == null) ||
        (tempTermData.isNotEmpty && tempTermData[0].runtimeType == Response)) {
      if (mounted) {
        setState(() {
          isInternetConnected = false;
        });
      }
      return termData;
    } else {
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }
      if (tempTermData.isNotEmpty) {
        termData.addAll(tempTermData);
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
          appBarTitle: UtilityMethods.getLocalizedString("inquiry_form"),
        ),
        body: isInternetConnected == false
            ? Align(
          alignment: Alignment.topCenter,
          child: NoInternetConnectionErrorWidget(onPressed: () {
            checkInternetAndLoadData();
          }),
        )
            : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  contactList.isEmpty
                      ? Container()
                      : CardWidget(
                    shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                    child: Column(
                      children: [
                        headerTextWidget(
                          UtilityMethods.getLocalizedString("contact"),
                        ),
                        dropDownContactName(),
                      ],
                    ),
                  ),
                  CardWidget(
                    shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                    child: Column(
                      children: [
                        headerTextWidget(
                          UtilityMethods.getLocalizedString("information"),
                        ),
                        inquiryTypeWidget(),
                        dropDownWidget(
                          UtilityMethods.getLocalizedString("property_type") + " *",
                          _propertyTypesList,
                          INQUIRY_PROPERTY_TYPE,
                          widget.inquiries?.propertyTypeName,
                        ),
                        setValuesInFields(
                          UtilityMethods.getLocalizedString("price"),
                          UtilityMethods.getLocalizedString("enter_the_price"),
                          TextInputType.number,
                          INQUIRY_MIN_PRICE,
                          widget.inquiries?.minPrice,
                        ),
                        addRoomsInformation(context),
                        setValuesInFields(
                          UtilityMethods.getLocalizedString("minimum_size"),
                          UtilityMethods.getLocalizedString("enter_the_min_size"),
                          TextInputType.number,
                          INQUIRY_MIN_AREA,
                          widget.inquiries?.minArea,
                        ),
                      ],
                    ),
                  ),
                  CardWidget(
                    shape: AppThemePreferences.roundedCorners(
                        AppThemePreferences.globalRoundedCornersRadius),
                    child: Column(
                      children: [
                        headerTextWidget(UtilityMethods.getLocalizedString("address")),
                        if (_countryList.isNotEmpty)
                          dropDownWidget(
                              UtilityMethods.getLocalizedString("country"),
                              _countryList,
                              INQUIRY_COUNTRY,
                              _country),
                        if (_statesList.isNotEmpty)
                          dropDownWidget(
                              UtilityMethods.getLocalizedString("states"),
                              _statesList,
                              INQUIRY_STATE,
                              _state),
                        if (_locationsList.isNotEmpty)
                          dropDownWidget(
                              UtilityMethods.getLocalizedString("city"),
                              _locationsList,
                              INQUIRY_CITY,
                              _city),
                        if (_areaList.isNotEmpty)
                          dropDownWidget(
                              UtilityMethods.getLocalizedString("area"),
                              _areaList,
                              INQUIRY_AREA,
                              _area),
                        setValuesInFields(
                          UtilityMethods.getLocalizedString("zip_code"),
                          UtilityMethods.getLocalizedString(
                              "enter_the_zip_code"),
                          TextInputType.number,
                          INQUIRY_ZIP_CODE,
                          widget.inquiries?.zipcode,
                        ),
                      ],
                    ),
                  ),
                  CardWidget(
                    shape: AppThemePreferences.roundedCorners(
                        AppThemePreferences.globalRoundedCornersRadius),
                    child: Column(
                      children: [
                        headerTextWidget(UtilityMethods.getLocalizedString("private_note")),
                        setValuesInFields(
                            UtilityMethods.getLocalizedString("private_note"),
                            "",
                            TextInputType.text,
                            PRIVATE_NOTE,
                            widget.inquiries?.privateNote),
                      ],
                    ),
                  ),
                  CardWidget(
                    shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: saveButton(),
                    ),
                  ),
                ],
              ),
              waitingWidget(),
            ]
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
            width: 80,
            height: 20,
            child: BallBeatLoadingWidget(),
          ),
        ),
      ),
    )
        : Container();
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

  Widget dropDownContactName() {
    return contactList.isEmpty ? Container() : Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericTextWidget(
              UtilityMethods.getLocalizedString("contact_name") + " *",
              style: AppThemePreferences().appTheme.labelTextStyle),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: DropdownButtonFormField(
              icon: Icon(AppThemePreferences.dropDownArrowIcon),
              decoration: AppThemePreferences.formFieldDecoration(
                  hintText: UtilityMethods.getLocalizedString("select")),
              items: contactList.map((map) {
                return DropdownMenuItem(
                  child: GenericTextWidget(UtilityMethods.getLocalizedString(map['displayName'] ?? "")),
                  value: map['id'],
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return UtilityMethods.getLocalizedString(
                      "this_field_cannot_be_empty"); //;
                }
                return null;
              },
              value: _selectedContactName == "" ? null : _selectedContactName,
              onChanged: (value) {
                setState(() {
                  addInquiryInfoMap[INQUIRY_LEAD_ID] = value;
                });
              },
              onSaved: (value) {
                setState(() {
                  addInquiryInfoMap[INQUIRY_LEAD_ID] = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget setValuesInFields(String labelText, String hintText,
      TextInputType textInputType, String key, String? initialValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, top: 20),
      child: TextFormFieldWidget(
        labelText: labelText,
        keyboardType: textInputType,
        hintText: hintText,
        initialValue: initialValue,
        onSaved: (String? value) {
          setState(() {
            addInquiryInfoMap[key] = value;
          });
        },
      ),
    );
  }

  Widget dropDownWidget(String text, List list, String key, String? initialValue) {
    return list.isNotEmpty ? GenericStringDropDownWidget(
      hintText: UtilityMethods.getLocalizedString("select"),
      labelText: text,
      value: initialValue == "" ? null : initialValue,
      validator: key == INQUIRY_PROPERTY_TYPE
          ? (String? value) {
        if (value?.isEmpty ?? true) {
          return UtilityMethods.getLocalizedString(
              "this_field_cannot_be_empty"); //AppLocalizations.of(context).;
        }
        return null;
      }
          : null,
      items: list.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          child: GenericTextWidget(
              UtilityMethods.getLocalizedString(item.name)
          ),
          value: item.name,
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          updateAddressRelatedFields(key, val);
          // addInquiryInfoMap[key] = val;
        });
      },
      onSaved: (val) {
        setState(() {
          updateAddressRelatedFields(key, val);
          // addInquiryInfoMap[key] = val;
        });
      },
    ) : Container();
  }

  Widget inquiryTypeWidget() {
    return _inquiryTypesList.isEmpty ? Container() : Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericTextWidget(UtilityMethods.getLocalizedString("type") + " *",
              style: AppThemePreferences().appTheme.labelTextStyle),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: DropdownButtonFormField(
              icon: Icon(AppThemePreferences.dropDownArrowIcon),
              decoration: AppThemePreferences.formFieldDecoration(
                  hintText: UtilityMethods.getLocalizedString("select")),
              //focusColor: Colors.white,
              value: _selectedInquiryType == "" ? null : _selectedInquiryType,
              validator: (String? value) {
                if (value?.isEmpty ?? true) {
                  return UtilityMethods.getLocalizedString(
                      "this_field_cannot_be_empty"); //;
                }
                return null;
              },
              items: _inquiryTypesList.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  child: GenericTextWidget(
                      UtilityMethods.getLocalizedString(item)
                  ),
                  value: item,
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  addInquiryInfoMap[INQUIRY_ENQUIRY_TYPE] = val;
                });
              },
              onSaved: (val) {
                setState(() {
                  addInquiryInfoMap[INQUIRY_ENQUIRY_TYPE] = val;
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
            addInquiryInfoMap[INQUIRY_MIN_BEDS] = _beds.toString();
          });
        }
      },
      onAddPressed: () {
        if (_beds >= 0) {
          setState(() {
            _beds += 1;
            _bedroomsTextController.text = _beds.toString();
            addInquiryInfoMap[INQUIRY_MIN_BEDS] = _beds.toString();
          });
        }
      },
      onChanged: (value) {
        setState(() {
          _beds = int.parse(value);
        });
      },
      onSaved: (value) {
        setState(() {
          if (value != null && value.isNotEmpty) {
            _beds = int.parse(value);
            addInquiryInfoMap[INQUIRY_MIN_BEDS] = value;
          }
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

            addInquiryInfoMap[INQUIRY_MIN_BATHS] = _baths.toString();
          });
        }
      },
      onAddPressed: () {
        if (_baths >= 0) {
          setState(() {
            _baths += 1;
            _bathroomsTextController.text = _baths.toString();
            addInquiryInfoMap[INQUIRY_MIN_BATHS] = _baths.toString();
          });
        }
      },
      onChanged: (value) {
        setState(() {
          _baths = int.parse(value);
        });
      },
      onSaved: (value) {
        setState(() {
          if (value != null && value.isNotEmpty) {
            _baths = int.parse(value);
            addInquiryInfoMap[INQUIRY_MIN_BATHS] = value;
          }

        });
      },
      validator: (String? value) {
        return null;
      },
    );
  }

  Widget saveButton() {
    return ButtonWidget(
        text: widget.forInquiryEdit
            ? UtilityMethods.getLocalizedString("edit_inquiry")
            : UtilityMethods.getLocalizedString("add_new_inquiry"),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            setState(() {
              _showWaitingWidget = true;
            });

            if (widget.forInquiryEdit) {
              addInquiryInfoMap[UPDATE_INQUIRY_ID] = widget.inquiries!.enquiryId!;
            } else {
              addInquiryInfoMap[INQUIRY_ACTION] = INQUIRY_ACTION_ADD_NEW;
            }

            final response = await _crmRepository.fetchAddInquiryResponse(addInquiryInfoMap);

            String tempResponseString = response.toString().split("{")[1];
            Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");

            if (map["success"] == true) {
              setState(() {
                _showWaitingWidget = false;
              });
              _showToast(context, map["msg"]);
              widget.addNewInquiryPageListener(true);
              Navigator.of(context).pop();
            } else {
              setState(() {
                _showWaitingWidget = false;
              });
              _showToast(context, map["msg"]);
            }
          }
        });
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  updateAddressRelatedFields(String key, String? value) {
    if (key == INQUIRY_COUNTRY && addInquiryInfoMap[key] != value) {
      _country = value;
      addInquiryInfoMap[key] = value;
      // Reset sub fields
      _state = "";
      _city = "";
      _area = "";
      resetStatesList(_country);
    } else if (key == INQUIRY_STATE && addInquiryInfoMap[key] != value) {
      _state = value;
      addInquiryInfoMap[key] = value;
      // Reset sub fields
      _city = "";
      _area = "";
      resetCitiesList(_state);
    } else if (key == INQUIRY_CITY && addInquiryInfoMap[key] != value) {
      _city = value;
      addInquiryInfoMap[key] = value;
      // Reset sub field
      _area = "";
      resetAreasList(_city);
    }
    else if (key == INQUIRY_AREA && addInquiryInfoMap[key] != value) {
      _area = value;
      addInquiryInfoMap[key] = value;
    } else {
      addInquiryInfoMap[key] = value;
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
}
