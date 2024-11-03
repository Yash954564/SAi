import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/mixins/validation_mixins.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/pages/crm_pages/crm_webservices_manager/crm_repository.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/drop_down_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

typedef AddNewLeadPageListener = void Function(bool reload);

class AddNewLeadPage extends StatefulWidget {

  final AddNewLeadPageListener? addNewLeadPageListener;
  final CRMDealsAndLeads? leads;
  final bool forEditLead;


  const AddNewLeadPage({
    super.key,
    this.addNewLeadPageListener,
    this.leads,
    this.forEditLead = false,
  });

  @override
  _AddNewLeadPageState createState() => _AddNewLeadPageState();
}

class _AddNewLeadPageState extends State<AddNewLeadPage> with ValidationMixin {
  final CRMRepository _crmRepository = CRMRepository();
  final formKey = GlobalKey<FormState>();

  List<dynamic> _userSourceList = [];
  List<dynamic> _userTitleList = [];

  bool isAgree = false;
  bool isInternetConnected = true;
  bool _showWaitingWidget = false;

  Map<String, dynamic> addLeadInfoMap = {
    addLeadEmail: "",
    addLeadPrefix: "",
    addLeadFirstName: "",
    addLeadLastName: "",
    addLeadName: "",
    addLeadMobile: "",
    addLeadHomePhone: "",
    addLeadWorkPhone: "",
    addLeadUserType: "",
    addLeadAddress: "",
    addLeadCountry: "",
    addLeadCity: "",
    addLeadState: "",
    addLeadZip: "",
    addLeadSource: "",
    addLeadPrivateNote: "",
    "dashboard_lead": "yes",
  };

  String? name = "";
  String? email = "";

  @override
  void initState() {
    super.initState();
    name = HiveStorageManager.getUserName();
    email = HiveStorageManager.getUserEmail();
    loadData();
  }

  loadData() {
    String? leadPrefixList = HiveStorageManager.readLeadPrefixInfoData() ?? "";
    if (leadPrefixList != null && leadPrefixList.isNotEmpty) {
      List tempList = leadPrefixList.split(', ');
      for (var item in tempList) {
        _userTitleList.add(UtilityMethods.cleanContent(item));
      }
    }
    if (_userTitleList.isEmpty) {
      _userTitleList = ['Mr', 'Mrs', 'Ms', 'Miss', 'Dr', 'Prof', 'Mr & Mrs'];
    }

    String? leadSourceList = HiveStorageManager.readLeadSourceInfoData() ?? "";
    if (leadSourceList != null && leadSourceList.isNotEmpty) {
      _userSourceList = leadSourceList.split(', ');
    }
    if (_userSourceList.isEmpty) {
      _userSourceList = ['Website', 'Newspaper', 'Friend', 'Google', 'Facebook'];
    }

    if (widget.forEditLead) {
      if (!_userSourceList.contains(widget.leads?.source)) {
        widget.leads?.source = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("lead_form"),
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
                                headerTextWidget(UtilityMethods.getLocalizedString("information")),
                                dropDownWidget(
                                  label: "title",
                                  key: addLeadPrefix,
                                  list: _userTitleList,
                                  initialValue: widget.leads?.prefix!,
                                  validate: true
                                ),
                                // inquiryUserTitleWidget(),
                                setValuesInFields(
                                  labelText: UtilityMethods.getLocalizedString("first_name")+ " *",
                                  hintText: UtilityMethods.getLocalizedString("enter_first_name"),
                                  key: addLeadFirstName,
                                  initialValue: widget.forEditLead ? widget.leads?.firstName : name,
                                  validate: true
                                ),
                                setValuesInFields(
                                  labelText: UtilityMethods.getLocalizedString("last_name")+ " *",
                                  hintText: UtilityMethods.getLocalizedString("enter_last_name"),
                                  key: addLeadLastName,
                                  initialValue: widget.leads?.lastName,
                                  validate: true
                                ),
                                setValuesInFields(
                                  labelText: UtilityMethods.getLocalizedString("type"),
                                  hintText: UtilityMethods.getLocalizedString("enter_user_type"),
                                  key: addLeadUserType,
                                  initialValue: widget.leads?.type,
                                ),
                              ],
                            ),
                          ),
                          CardWidget(
                            shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                            child: Column(
                              children: [
                                headerTextWidget(UtilityMethods.getLocalizedString("contact")),
                                setValuesInFields(
                                    labelText: UtilityMethods.getLocalizedString("email")+ " *",
                                    hintText: UtilityMethods.getLocalizedString("enter_email_address"),
                                    key: addLeadEmail,
                                    initialValue: widget.forEditLead ? widget.leads?.email : email,
                                    textInputType: TextInputType.emailAddress,
                                    isFirst: true,
                                    validate: false,
                                    emailValidation: true
                                ),
                                setValuesInFields(
                                    labelText: UtilityMethods.getLocalizedString("mobile"),
                                    hintText: UtilityMethods.getLocalizedString("enter_mobile_address"),
                                    key: addLeadMobile,
                                    initialValue: widget.leads?.mobile,
                                    textInputType: TextInputType.number,
                                ),
                                setValuesInFields(
                                    labelText: UtilityMethods.getLocalizedString("home_number"),
                                    hintText: UtilityMethods.getLocalizedString("enter_home_number"),
                                    key: addLeadHomePhone,
                                    initialValue: widget.leads?.homePhone,
                                    textInputType: TextInputType.number,
                                ),
                                setValuesInFields(
                                    labelText: UtilityMethods.getLocalizedString("work_number"),
                                    hintText: UtilityMethods.getLocalizedString("enter_work_number"),
                                    key: addLeadWorkPhone,
                                    initialValue: widget.leads?.workPhone,
                                    textInputType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          CardWidget(
                            shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                            child: Column(
                              children: [
                                headerTextWidget(UtilityMethods.getLocalizedString("address"),),
                                setValuesInFields(
                                  labelText: UtilityMethods.getLocalizedString("address"),
                                  hintText: UtilityMethods.getLocalizedString("enter_the_address"),
                                  key: addLeadAddress,
                                  initialValue: widget.leads?.address,
                                  isFirst: true
                                ),
                                setValuesInFields(
                                  labelText: UtilityMethods.getLocalizedString("country"),
                                  hintText: UtilityMethods.getLocalizedString("enter_the_country"),
                                  key: addLeadCountry,
                                  initialValue: widget.leads?.country,
                                ),
                                setValuesInFields(
                                  labelText: UtilityMethods.getLocalizedString("city"),
                                  hintText: UtilityMethods.getLocalizedString("enter_the_city"),
                                  key: addLeadCity,
                                  initialValue: widget.leads?.city,
                                ),
                                setValuesInFields(
                                  labelText: UtilityMethods.getLocalizedString("states"),
                                  hintText: UtilityMethods.getLocalizedString("enter_the_states"),
                                  key: addLeadState,
                                  initialValue: widget.leads?.state,
                                ),
                                setValuesInFields(
                                  labelText: UtilityMethods.getLocalizedString("zip_code"),
                                  hintText: UtilityMethods.getLocalizedString("enter_the_zip_code"),
                                  key: addLeadZip,
                                  initialValue: widget.leads?.zipcode,
                                ),
                              ],
                            ),
                          ),
                          CardWidget(
                            shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                            child: Column(
                              children: [
                                headerTextWidget(UtilityMethods.getLocalizedString("source"),),
                                dropDownWidget(
                                    label: "source",
                                    key: addLeadSource,
                                    list: _userSourceList,
                                    initialValue: widget.leads?.source,
                                ),
                                // inquirySourceWidget(),
                              ],
                            ),
                          ),
                          CardWidget(
                            shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                            child: Column(
                              children: [
                                headerTextWidget(UtilityMethods.getLocalizedString("social")),
                                setValuesInFields(
                                    labelText: UtilityMethods.getLocalizedString("facebook"),
                                    hintText: UtilityMethods.getLocalizedString("enter_facebook_profile_url"),
                                    key: addLeadFacebook,
                                    initialValue: widget.leads?.facebookUrl,
                                    isFirst: true
                                ),

                                setValuesInFields(
                                    labelText: UtilityMethods.getLocalizedString("twitter"),
                                    hintText: UtilityMethods.getLocalizedString("enter_twitter_profile_url"),
                                    key: addLeadTwitter,
                                    initialValue: widget.leads?.twitterUrl,
                                ),

                                setValuesInFields(
                                    labelText: UtilityMethods.getLocalizedString("linkedIn"),
                                    hintText: UtilityMethods.getLocalizedString("enter_linkedIn_profile_url"),
                                    key: addLeadLinkedIn,
                                    initialValue: widget.leads?.linkedinUrl,
                                ),
                              ],
                            ),
                          ),
                          CardWidget(
                            shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                            child: Column(
                              children: [
                                headerTextWidget(UtilityMethods.getLocalizedString("private_note")),
                                setValuesInFields(
                                    labelText: UtilityMethods.getLocalizedString("private_note"),
                                    hintText: "",
                                    key: addLeadPrivateNote,
                                    initialValue: widget.leads?.leadPrivateNote,
                                    isFirst: true,
                                ),
                                // privateNoteWidget(),
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
      {String labelText = "",
        String hintText = "",
        String key = "",
        TextInputType textInputType = TextInputType.text,
        String? initialValue,
        bool isFirst = false,
        bool validate = false,
        bool emailValidation = false}) {
    return TextFormFieldWidget(
      labelText: labelText,
      padding: EdgeInsets.fromLTRB(20, isFirst ? 20 : 0, 20, 20),
      hintText: hintText,
      keyboardType: textInputType,
      initialValue: initialValue,
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
      onSaved: (String? value) {
        setState(() {
          addLeadInfoMap[key] = value;
        });
      },
    );
  }

  Widget dropDownWidget({
    required String label,
    required String key,
    required List list,
    String? initialValue,
    bool validate = false,
  }) {
    String necessary = validate ? " *" : "";
    return GenericStringDropDownWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      labelText: UtilityMethods.getLocalizedString(label) + necessary,
      hintText: UtilityMethods.getLocalizedString("select"),
      value: initialValue == "" ? null : initialValue,
      validator: validate
          ? (value) {
              if (value == null || value.isEmpty) {
                return UtilityMethods.getLocalizedString(
                    "this_field_cannot_be_empty");
              }
              return null;
            }
          : null,
      onSaved: (value) {
        setState(() {
          addLeadInfoMap[key] = value;
        });
      },
      items: list.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          child: GenericTextWidget(UtilityMethods.getLocalizedString(item)),
          value: item,
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          addLeadInfoMap[key] = val;
        });
      },
    );
  }

  Widget saveButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ButtonWidget(
        text: widget.forEditLead
            ? UtilityMethods.getLocalizedString("edit_lead")
            : UtilityMethods.getLocalizedString("add_new_lead"),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();

            setState(() {
              _showWaitingWidget = true;
            });
            addLeadInfoMap[addLeadName] = "${addLeadInfoMap[addLeadFirstName]} ${addLeadInfoMap[addLeadLastName]}";

            if (widget.forEditLead) {
              addLeadInfoMap[addLeadId] = widget.leads!.leadLeadId!;
            }

            final response = await _crmRepository.fetchAddLeadResponse(addLeadInfoMap);

            if(response == null || response.statusCode == null){
              if(mounted){
                setState(() {
                  isInternetConnected = false;
                  _showWaitingWidget = false;
                });
              }
            }else{
              if(mounted){
                setState(() {
                  isInternetConnected = true;
                  _showWaitingWidget = false;
                });
              }

              String tempResponseString = response.toString().split("{")[1];
              Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");

              if(map["success"] == true){
                _showToast(context, map["msg"]);
                widget.addNewLeadPageListener!(true);
                Navigator.of(context).pop();
              }
              else {
                _showToast(context, map["msg"]);
              }
            }
          }
        },
      ),
    );
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  Widget bottomActionBarWidget() {
    return Positioned(
      bottom: 0.0,
      child: SafeArea(
        child: Column(
          children: [
            if(!isInternetConnected) const NoInternetBottomActionBarWidget(showRetryButton: false),
          ],
        ),
      ),
    );
  }
}
