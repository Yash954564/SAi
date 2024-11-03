import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_multi_select_dialog.dart';
import 'package:houzi_package/widgets/generic_link_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

import '../home_screen_drawer_menu_pages/user_related/user_signup.dart';


class ReportProperty extends StatefulWidget {
  final Map<String, dynamic> informationMap;

  @override
  State<StatefulWidget> createState() => ReportPropertyState();

  const ReportProperty({
    super.key,
    required this.informationMap,
  });
}

class ReportPropertyState extends State<ReportProperty> with ValidationMixin {

  int? listingId;
  String propertyName = '';
  String propertyLink = '';
  String message = '';
  String nonce = "";
  String? name = '';
  String? email = '';
  String? phoneNumber = '';
  String selectedOption = "";

  final PropertyBloc _propertyBloc = PropertyBloc();

  bool termsAndConditions = false;
  bool isInternetConnected = true;
  bool _showWaitingWidget = false;

  final formKey = GlobalKey<FormState>();

  TextEditingController textEditingController = TextEditingController();
  TextEditingController reportTextController = TextEditingController();

  List<dynamic> reportItemsList = [];
  List<dynamic> selectedReportItemsList = [];
  List<dynamic> selectedReportSlugItemsList = [];

  @override
  void initState() {
    super.initState();
    loadData();
    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchReportContentNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  loadData() async {
    reportItemsList = [
      Term(id: 1, name: "Property already sold/rented", slug: "Property already sold/rented", parent: 0,),
      Term(id: 2, name: "Incorrect price", slug: "Incorrect price", parent: 0,),
      Term(id: 3, name: "Incorrect plot size", slug: "Incorrect plot size", parent: 0,),
      Term(id: 4, name: "Incorrect location information", slug: "Incorrect location information", parent: 0,),
      Term(id: 5, name: "Invalid/incorrect contact number", slug: "Invalid/incorrect contact number", parent: 0,),
      Term(id: 6, name: "Property is for rent, not for sale", slug: "Property is for rent, not for sale", parent: 0,),
      Term(id: 7, name: "The property shown here does not exist", slug:"The property shown here does not exist", parent: 0,),
      Term(id: 8, name: "Incorrect number of bedrooms or rooms", slug: "Incorrect number of bedrooms or rooms", parent: 0,),
      Term(id: 9, name: "Incorrect images", slug: "Incorrect images",),
      Term(id: 10, name: "Switched off/Unreachable/ No answer", slug: "Switched off/Unreachable/ No answer", parent: 0,),
      Term(id: 11, name: "Seller behaved improperly", slug: "Seller behaved improperly", parent: 0,),
      Term(id: 12, name: "Others", slug: "Others", parent: 0,),
    ];
    name = HiveStorageManager.getUserName();
    email = HiveStorageManager.getUserEmail();

    if (widget.informationMap.containsKey(SEND_EMAIL_LISTING_ID)) {
      listingId = widget.informationMap[SEND_EMAIL_LISTING_ID];
    }
    if (widget.informationMap.containsKey(SEND_EMAIL_LISTING_LINK)) {
      propertyLink = widget.informationMap[SEND_EMAIL_LISTING_LINK];
    }
    if (widget.informationMap.containsKey(SEND_EMAIL_LISTING_NAME)) {
      propertyName = widget.informationMap[SEND_EMAIL_LISTING_NAME];
    }
    message = "${UtilityMethods.getLocalizedString("Hello, The abuse report relates to")} $propertyName $propertyLink";
    textEditingController.text = "${UtilityMethods.getLocalizedString("Hello, The abuse report relates to")} $propertyName $propertyLink";

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("Report an Abuse"),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: formKey,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelWidget(UtilityMethods.getLocalizedString("Getting these information's will allow us to give you a feedback about this report.")),
                      const SizedBox(height: 10,),
                      LabelWidget(UtilityMethods.getLocalizedString("Type of abuse")),
                      multiSelectReportWidget(),
                      addName(context),
                      addPhone(),
                      addEmail(context),
                      addMessage(context),
                      TermsAndConditionAgreementWidget(
                        areTermsAccepted: termsAndConditions,
                        listener: (areTermsAccepted){
                          if (mounted) {
                            setState(() {
                              termsAndConditions = areTermsAccepted;
                              // if (termsAndConditions) {
                              //   termsAndConditionsValue = "on";
                              // }else{
                              //   termsAndConditionsValue = "off";
                              // }
                            });
                          }
                        },
                      ),
                      submitButtonWidget(context),
                    ],
                  ),
                  waitingWidget(),
                  bottomActionBarWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget multiSelectReportWidget() {
    if (selectedReportItemsList.isNotEmpty &&
        selectedReportItemsList.toSet().toList().length == 1) {
      reportTextController.text =
      "${selectedReportItemsList.toSet().toList().first}";
    } else if (selectedReportItemsList.isNotEmpty &&
        selectedReportItemsList.toSet().toList().length > 1) {
      reportTextController.text = UtilityMethods.getLocalizedString(
          "multi_select_drop_down_item_selected",
          inputWords: [
            (selectedReportItemsList.toSet().toList().length.toString())
          ]);
    } else {
      reportTextController.text = "";
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        controller: reportTextController,
        decoration: AppThemePreferences.formFieldDecoration(
          hintText:
          UtilityMethods.getLocalizedString("select"),
          suffixIcon:
          Icon(AppThemePreferences.dropDownArrowIcon),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
          }
          return null;
        },
        readOnly: true,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return MultiSelectDialogWidget(
                title: UtilityMethods.getLocalizedString("select"),
                dataItemsList: reportItemsList,
                selectedItemsList: selectedReportItemsList,
                selectedItemsSlugsList: selectedReportSlugItemsList,
                multiSelectDialogWidgetListener: (List<dynamic> _selectedItemsList, List<dynamic> _selectedReportSlugItemsList) {
                  selectedReportItemsList = _selectedItemsList;
                  selectedReportSlugItemsList = _selectedReportSlugItemsList;
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget addName(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 15),
      labelText: UtilityMethods.getLocalizedString("your_name"),
      hintText: UtilityMethods.getLocalizedString("enter_your_name"),
      keyboardType: TextInputType.name,
      initialValue: name,
      validator: (value) => validateTextField(value!),
      onSaved: (value) {
        setState(() {
          name = value!;
        });
      },
    );
  }

  Widget addEmail(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 10.0),
      labelText: UtilityMethods.getLocalizedString("email"),
      hintText: UtilityMethods.getLocalizedString("enter_email_address"),
      keyboardType: TextInputType.emailAddress,
      initialValue: email,
      validator: (value) => validateEmail(value!),
      onSaved: (value) {
        setState(() {
          email = value!;
        });
      },
    );
  }

  Widget addPhone() {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 15.0),
      labelText: UtilityMethods.getLocalizedString("phone"),
      hintText: UtilityMethods.getLocalizedString("enter_your_phone_number"),
      keyboardType: TextInputType.phone,
      validator: (value) => validatePhoneNumber(value),
      onSaved: (text) {
        phoneNumber = text!;
      },
    );
  }

  Widget addMessage(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 20.0),
      labelText: UtilityMethods.getLocalizedString("message"),
      hintText: UtilityMethods.getLocalizedString("enter_your_msg"),
      controller: textEditingController,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      validator: (value) => validateTextField(value!),
      onSaved: (value) {
        setState(() {
          message = value!;
        });
      },
    );
  }

  Widget submitButtonWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, bottom: 10),
      child: Center(
        child: ButtonWidget(
          text: UtilityMethods.getLocalizedString("submit"),
          onPressed: () => onSubmitPressed(),
        ),
      ),
    );
  }

  onSubmitPressed() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (mounted) {
        setState(() {
          _showWaitingWidget = true;
        });
      }
      sendEmail();
    }
  }

  sendEmail() async {
    selectedOption = selectedReportItemsList.join(', ');
    Map<String, dynamic> dataMap = {
      "message": message,
      "name": name,
      "email": email,
      "phone": phoneNumber,
      "reason": selectedOption,
      // "prop_title": widget.informationMap[SEND_EMAIL_LISTING_NAME],
      // "prop_link": widget.informationMap[SEND_EMAIL_LISTING_LINK],
      "content_id": widget.informationMap[SEND_EMAIL_LISTING_ID].toString(),
      "content_type": "Property",
      "report-security": nonce,
    };

    final response = await _propertyBloc.fetchReportContentResponse(dataMap, nonce);
    if(mounted){
      setState(() {
        _showWaitingWidget = false;
      });
    }
    if(response == null){
      _showToast(context, UtilityMethods.getLocalizedString("error_occurred"));
    }else{
      String tempString = response.toString();
      if(tempString.contains("{")){
        String tempResponseString = response.toString().split("{")[1];
        Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");

        if (map['success']) {
          _showToast(context, UtilityMethods.getLocalizedString(map['message']));
          Navigator.of(context).pop();
        } else {
          if (map["message"] != null) {
            _showToast(context, UtilityMethods.getLocalizedString(map['message']));
          } else if (map["reason"] != null) {
            _showToast(context, UtilityMethods.getLocalizedString(map['reason']));
          } else {
            _showToast(
                context, UtilityMethods.getLocalizedString("error_occurred"));
          }
        }
      }else{
        _showToast(context, UtilityMethods.getLocalizedString("error_occurred"));
      }
    }

  }

  Widget bottomActionBarWidget() {
    return Positioned(
      bottom: 0.0,
      child: SafeArea(
        child: Column(
          children: [
            if(!isInternetConnected) NoInternetBottomActionBarWidget(
              onPressed: ()=> onSubmitPressed(),
            ),
          ],
        ),
      ),
    );
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  Widget waitingWidget() {
    return _showWaitingWidget == true
        ? Positioned(
            left: 0,
            right: 0,
            top: 90,
            bottom: 0,
            child: Center(
              child: Container(
                alignment: Alignment.center,
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
}
