import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/mixins/validation_mixins.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';

import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/realtor_model.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_link_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/drop_down_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

typedef AddNewAgentPageListener = void Function(bool reload);

class AddNewAgentPage extends StatefulWidget {

  final AddNewAgentPageListener? addNewAgentPageListener;
  final Agent? agentDataForEdit;

  const AddNewAgentPage({Key? key, this.addNewAgentPageListener, this.agentDataForEdit}) : super(key: key);

  @override
  _AddNewAgentPageState createState() => _AddNewAgentPageState();
}

class _AddNewAgentPageState extends State<AddNewAgentPage> with ValidationMixin {
  bool isAgree = false;
  bool isInternetConnected = true;
  bool isLoadDataError = false;
  bool isAddAgentError = false;
  bool _showWaitingWidget = false;
  bool sendEmail = false;

  final PropertyBloc _propertyBloc = PropertyBloc();

  Future<List<dynamic>>? _futureCategoryList;
  Future<List<dynamic>>? _futureCityList;

  List<dynamic> _agentCityList = [];
  List<dynamic> _agentCategoryList = [];

  final formKey = GlobalKey<FormState>();

  String sendEmailValue = "no";
  String nonce = "";

  Map<String, dynamic> addAgentInfoMap = {
    agentUserName: "",
    agentEmail: "",
    agentFirstName: "",
    agentLastName: "",
    agentCategory: "",
    agentCity: "",
    agentPassword: "",
    agentSendEmail: "no",
  };

  var _selectedUserTitle;

  @override
  void initState() {
    super.initState();

    if(widget.agentDataForEdit != null) {
      addAgentInfoMap = {
        agentUserName: widget.agentDataForEdit!.agentUserName,
        agencyUserId: widget.agentDataForEdit!.userAgentId, /// Basically agent user Id
        agentEmail: widget.agentDataForEdit!.email,
        agentFirstName: widget.agentDataForEdit!.agentFirstName,
        agentLastName: widget.agentDataForEdit!.agentLastName,
        agentPassword: "",
      };
    }

    loadData();
    fetchNonce();
  }


  Future<List<dynamic>> fetchTermData(String term) async {
    List<dynamic> termData = [];
    termData = await _propertyBloc.fetchTermData(term);
    if(termData != null && termData.isNotEmpty && termData[0].runtimeType == Response){
      if(mounted){
        setState(() {
          isLoadDataError = true;
          isInternetConnected = false;
        });
      }
    }else{
      if(mounted){
        setState(() {
          isLoadDataError = false;
          isInternetConnected = true;
        });
      }
    }

    return termData;
  }

  Future<void> loadData() async {
    List agentCityTermList = HiveStorageManager.readAgentCitiesMetaData();
    List agentCategoriesTermList =
        HiveStorageManager.readAgentCategoriesMetaData();

    if (agentCityTermList.isNotEmpty) {
      // print("Get data from cache");
      _agentCityList = agentCityTermList;
      _agentCategoryList = agentCategoriesTermList;
    } else {
      // print("Getting data from server");

      List tempList = [];
      tempList = await fetchTermData("agent_city");
      if (tempList.isNotEmpty) {
        _agentCityList = tempList;
      } else {
        Term agentMetaDataCity = Term(name: "All Cities", id: null);
        _agentCityList.insert(0, agentMetaDataCity);
      }

      setState(() {});

      tempList = [];
      tempList = await fetchTermData("agent_category");
      if (tempList.isNotEmpty) {
        _agentCategoryList = tempList;
      } else {
        Term agentMetaDataCategory = Term(name: "All Categories", id: null);
        _agentCategoryList.insert(0, agentMetaDataCategory);
      }

      setState(() {});

      HiveStorageManager.storeAgentCitiesMetaData(_agentCityList);
      HiveStorageManager.storeAgentCategoriesMetaData(_agentCategoryList);
    }

    setState(() {
      _showWaitingWidget = false;
    });
  }

  fetchNonce() async {
    ApiResponse response;
    if (widget.agentDataForEdit != null) {
      response = await _propertyBloc.fetchEditAgentNonceResponse();
    } else {
      response = await _propertyBloc.fetchAddAgentNonceResponse();
    }
    if (response.success) {
      nonce = response.result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: widget.agentDataForEdit == null
              ? UtilityMethods.getLocalizedString("add_new_agent")
              : UtilityMethods.getLocalizedString("edit_agent"),
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
                    setValuesInFields(
                        labelText: UtilityMethods.getLocalizedString("user_name")+ " *",
                        hintText: UtilityMethods.getLocalizedString("enter_your_user_name"),
                        key: agentUserName,
                        initialValue: widget.agentDataForEdit != null ? widget.agentDataForEdit!.agentUserName ?? "" : "",
                        validate: true,
                        isFirst: true,
                        enabled: widget.agentDataForEdit != null ? false : true,
                        readOnly: widget.agentDataForEdit != null ? true : false,
                    ),
                    setValuesInFields(
                      labelText: UtilityMethods.getLocalizedString("first_name"),
                      hintText: UtilityMethods.getLocalizedString("enter_first_name"),
                      initialValue: widget.agentDataForEdit != null ? widget.agentDataForEdit!.agentFirstName ?? "" : "",
                      key: agentFirstName,
                    ),
                    setValuesInFields(
                      labelText: UtilityMethods.getLocalizedString("last_name"),
                      hintText: UtilityMethods.getLocalizedString("enter_last_name"),
                      initialValue: widget.agentDataForEdit!=null ? widget.agentDataForEdit!.agentLastName ?? "" : "",
                      key: agentLastName,
                    ),
                    setValuesInFields(
                        labelText: UtilityMethods.getLocalizedString("email")+ " *",
                        hintText: UtilityMethods.getLocalizedString("enter_email_address"),
                        initialValue: widget.agentDataForEdit!=null ? widget.agentDataForEdit!.email ?? "" : "",
                        key: agentEmail,
                        textInputType: TextInputType.emailAddress,
                        validate: false,
                        emailValidation: true
                    ),
                    setValuesInFields(
                        labelText: UtilityMethods.getLocalizedString("password")+ " *",
                        hintText: UtilityMethods.getLocalizedString("enter_your_password"),
                        key: agentPassword,
                        validate: true,
                        isPassword: true
                    ),
                    if(widget.agentDataForEdit == null)
                      _agentCategoryList != null && _agentCategoryList.isNotEmpty
                          ? dropDownWidget(
                          _agentCategoryList,
                          UtilityMethods.getLocalizedString("category"),
                          UtilityMethods.getLocalizedString("all_categories"),
                          agentCategory)
                          : Container(),
                    if(widget.agentDataForEdit == null)
                      _agentCityList != null && _agentCityList.isNotEmpty
                          ? dropDownWidget(
                          _agentCityList,
                          UtilityMethods.getLocalizedString("city"),
                          UtilityMethods.getLocalizedString("all_cities"),
                          agentCity)
                          : Container(),
                    if(widget.agentDataForEdit == null)
                      sendEmailWidget(),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      child: saveButton(),
                    ),
                  ],
                ),
                waitingWidget(),
                bottomActionBarWidget(),
              ],
            ),
            // Build this out in the next steps.
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
              onPressed: (){
                if(isLoadDataError){
                  loadData();
                }else if(isAddAgentError){
                  onSavedButtonPressed();
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
          bottom: BorderSide(color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
    );
  }

  Widget setValuesInFields(
      {required String labelText,
        required String hintText,
        required String key,
        TextInputType textInputType = TextInputType.text,
        String initialValue = "",
        bool isFirst = false,
        bool validate = false,
        bool isPassword = false,
        bool readOnly = false,
        bool enabled = true,
        bool emailValidation = false}
      ) {
    return TextFormFieldWidget(
      labelText: labelText,
      padding: EdgeInsets.fromLTRB(20, isFirst ? 20 : 0, 20, 20),
      hintText: hintText,
      keyboardType: textInputType,
      initialValue: initialValue,
      obscureText: isPassword,
      readOnly: readOnly,
      enabled: enabled,
      validator: emailValidation
          ? (value) => validateEmail(value)
          : validate
          ? (value) {
        if (value == null || value.isEmpty) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
        }
        return null;
      }
          : null,
      onSaved: (String? value) {
        setState(() {
          addAgentInfoMap[key] = value;
        });
      },
    );
  }

  Widget dropDownWidget(List list,String title ,String hintText, String key){
    return GenericStringDropDownWidget(
      padding: const EdgeInsets.fromLTRB(20,0,20,20),
      labelText: title,
      hintText: hintText,
      value: _selectedUserTitle,
      items: list.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          child: GenericTextWidget(
            item.name,
          ),
          value: item.id.toString(),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null && val.isNotEmpty && val != 'null') {
          setState(() {
            addAgentInfoMap[key] = val;
          });
        }
      },
      onSaved: (value) {
        setState(() {
          addAgentInfoMap[key] = value;
        });
      },
    );
  }

  Widget sendEmailWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10,0,10,0),
      child: FormField<bool>(
        builder: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: sendEmail,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (value) {
                      setState(() {
                        sendEmail = value!;
                        if (sendEmail) {
                          sendEmailValue = "yes";
                        } else {
                          sendEmailValue = "no";
                        }
                        addAgentInfoMap[agentSendEmail] = sendEmailValue;
                        state.didChange(value);
                      });
                    },
                  ),
                  Expanded(
                    child: GenericLinkWidget(
                        preLinkText: UtilityMethods.getLocalizedString("send_email_new_user"),
                        linkText: "",
                        onLinkPressed: (){}
                    ),
                  ),
                ],
              ),
              state.errorText == null ? Container(padding: const EdgeInsets.only(bottom: 10),) : Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: GenericTextWidget(
                  state.errorText ?? '',
                  style: AppThemePreferences().appTheme.formFieldErrorTextStyle,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget saveButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ButtonWidget(
        text: widget.agentDataForEdit == null
            ? UtilityMethods.getLocalizedString("add_new_agent")
            : UtilityMethods.getLocalizedString("save"),
        onPressed: () => onSavedButtonPressed(),
      ),
    );
  }

  void onSavedButtonPressed() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        _showWaitingWidget = true;
      });

      var response;

      if(widget.agentDataForEdit == null) {
        if(addAgentInfoMap[agentCategory] == null) {
          addAgentInfoMap[agentCategory] = "";
        }
        if(addAgentInfoMap[agentCity] == null) {
          addAgentInfoMap[agentCity] = "";
        }

        response = await _propertyBloc.fetchAddAgentResponse(addAgentInfoMap, nonce);
      } else {
        addAgentInfoMap.removeWhere((String key, dynamic value)=> value==null || value.isEmpty);
        response = await _propertyBloc.fetchEditAgentResponse(addAgentInfoMap, nonce);

      }

      if(response == null || response.statusCode == null){
        if(mounted){
          setState(() {
            isInternetConnected = false;
            _showWaitingWidget = false;
            isAddAgentError = true;
          });
        }
      }else{
        if(mounted){
          setState(() {
            isInternetConnected = true;
            _showWaitingWidget = false;
            isAddAgentError = false;
          });
        }

        String tempResponseString = response.toString().split("{")[1];
        Map? map = jsonDecode("{${tempResponseString.split("}")[0]}}");

        if (map != null) {
          if (map["success"]) {
            _showToast(context, map["msg"]);
            widget.addNewAgentPageListener!(true);
            Navigator.of(context).pop();
          } else {
            if (map["msg"] != null) {
              _showToast(context, map["msg"]);
            } else if (map["reason"] != null) {
              _showToast(context, map["reason"]);
            } else {
              _showToast(
                  context, UtilityMethods.getLocalizedString("error_occurred"));
            }
          }
        } else {
          _showToast(
              context, UtilityMethods.getLocalizedString("error_occurred"));
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
