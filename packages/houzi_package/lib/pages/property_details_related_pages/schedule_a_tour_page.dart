import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_link_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/drop_down_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

import 'package:houzi_package/widgets/generic_text_widget.dart';

class ScheduleTour extends StatefulWidget {
  final int propertyId;
  final String propertyTitle;
  final String propertyPermalink;
  final String agentEmail;
  final int agentId;

  ScheduleTour({
    required this.agentId,
    required this.agentEmail,
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyPermalink,
});

  @override
  State<StatefulWidget> createState() => ScheduleTourState();
}

class ScheduleTourState extends State<ScheduleTour> with ValidationMixin{

  bool showWaitingWidget = false;

  final formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final PropertyBloc _propertyBloc = PropertyBloc();

  final TextEditingController _textEditingControllerForDate = TextEditingController();

  String _date = "";
  String _time = "";
  String? _name = "";
  String? _email = "";
  String _phone = "";
  String _message = "";
  String _tourType = "";

  bool isAgree = false;
  bool isInternetConnected = true;

  String? _selectedTourType;
  String? _selectedTimeSlot;
  String _scheduleTimeSlot = "";
  String nonce = "";

  List<String> tourTypes = [
    "In Person",
    "Video Chat",
  ];
  List<String> _scheduleTimeSlotsList = [];

  @override
  void initState() {
    super.initState();

    loadData();
    fetchNonce();
  }

  loadData() {
    setState(() {
      _name = HiveStorageManager.getUserName();
      _email = HiveStorageManager.getUserEmail();
      _textEditingControllerForDate.text = "${selectedDate.toLocal()}".split(' ')[0];
      _scheduleTimeSlot = HiveStorageManager.readScheduleTimeSlotsInfoData();
      if(_scheduleTimeSlot != null && _scheduleTimeSlot.isNotEmpty){
        _scheduleTimeSlotsList = _scheduleTimeSlot.split(",");
      }
    });
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchScheduleATourNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: AppThemePreferences().appTheme.backgroundColor,
        appBar:  AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("schedule_a_tour"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    CardWidget(
                      shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                      child: Column(
                        children: [
                          tourInformationTextWidget(),
                          tourType(),
                          timeSlotPicker(),
                          datePickerWidget(),
                        ],
                      ),
                    ),
                    CardWidget(
                      shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                      child: Column(
                        children: [
                          yourInformationTextWidget(),
                          addName(),
                          addEmail(context),
                          addPhone(context),
                          addMessage(context),
                          agreeToTermsAndConditions(),
                          submitButtonWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
                uploadingWaitingWidget(),
                bottomActionBarWidget(),
              ],
            ),
            // Build this out in the next steps.
          ),
        ),
      ),
    );
  }

  Widget headingWidget({required String text}){
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

  Widget tourInformationTextWidget() {
    return headingWidget(text: UtilityMethods.getLocalizedString("tour_information"));
  }

  Widget tourType() {
    return GenericStringDropDownWidget(
        labelText: UtilityMethods.getLocalizedString("tour_type"),
        hintText: UtilityMethods.getLocalizedString("select"),
        value: _selectedTourType,
        validator: (String? value) {
          if (value?.isEmpty ?? true) {
            return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
          }
          return null;
        },
        onSaved: (value) {
          setState(() {
            _tourType = value!;
          });
        },
        items: tourTypes.map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
            child: GenericTextWidget(UtilityMethods.getLocalizedString(item)),
            value: item,
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            _selectedTourType = val;
          });
        },
    );
  }

  Widget timeSlotPicker() {
    return _scheduleTimeSlotsList == null || _scheduleTimeSlotsList.isEmpty ? Container() :
    GenericStringDropDownWidget(
      labelText: UtilityMethods.getLocalizedString("time"),
      hintText: UtilityMethods.getLocalizedString("select"),
      value: _selectedTimeSlot,
      validator: (String? value) {
        if (value?.isEmpty ?? true) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
        }
        return null;
      },
      onSaved: (value){
        setState(() {
          _time = value!;
        });
      },
      items: _scheduleTimeSlotsList.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          child: GenericTextWidget(
            item,
          ),
          value: item,
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          _selectedTimeSlot = val;
        });
      },
    );
  }

  Widget datePickerWidget() {
    return TextFormFieldWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      labelText: UtilityMethods.getLocalizedString("date"),
      hintText: UtilityMethods.getLocalizedString("select_tour_date"),
      validator: (String? value) {
        if (value?.isEmpty ?? true) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
        }
        return null;
      },

      onSaved: (value){
        setState(() {
          _date = value!;
          _textEditingControllerForDate.text = value;
        });
      },

      onChanged: (value){
        setState(() {
          _date = value!;
          _textEditingControllerForDate.text = value;
        });
      },

      onTap: () {
        _selectDate(context);
        String date = "${selectedDate.toLocal()}".split(' ')[0];
        setState(() {
          _textEditingControllerForDate.text = date;
        });
      },
      controller: _textEditingControllerForDate,
      readOnly: true,
    );
  }

  Widget yourInformationTextWidget() {
    return headingWidget(text: UtilityMethods.getLocalizedString("your_information"));
  }

  Widget addName() {
    return TextFormFieldWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("name"),
      hintText: UtilityMethods.getLocalizedString("enter_your_name"),
      validator: (String? value) {
        if (value?.isEmpty ?? true) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
        }
        return null;
      },
      initialValue: _name,
      keyboardType: TextInputType.text,
      onSaved: (value){
        setState(() {
          _name = value!;
        });
      },
    );
  }

  Widget addEmail(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("email"),
      hintText: UtilityMethods.getLocalizedString("enter_your_email_address"),
      keyboardType: TextInputType.emailAddress,
      initialValue: _email,
      validator: (value) => validateEmail(value!),
      onSaved: (value){
        _email = value!;
      },
    );
  }

  Widget addPhone(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("phone"),
      hintText: UtilityMethods.getLocalizedString("enter_your_phone_number"),
      keyboardType: TextInputType.phone,
      validator: (value) => validatePhoneNumber(value!),
      onSaved: (value){
        _phone = value!;
      },
    );
  }

  Widget addMessage(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("message"),
      hintText: UtilityMethods.getLocalizedString("enter_your_msg"),
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      validator: (value) => validateTextField(value!),
      onSaved: (value){
        _message = value!;
      },
    );
  }

  Widget agreeToTermsAndConditions(){
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
      child: FormField<bool>(
        builder: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isAgree,
                    activeColor: AppThemePreferences().appTheme.primaryColor,
                    onChanged: (val) {
                      setState(() {
                        isAgree = val!;
                        state.didChange(val);
                      });
                    },
                  ),
                  Expanded(
                    child: GenericInlineLinkWidget(
                        text: UtilityMethods.getLocalizedString("term_and_agreement_message",inputWords: [UtilityMethods.getLocalizedString("terms_and_conditions")]),
                        linkText: UtilityMethods.getLocalizedString("terms_and_conditions"),
                        onLinkPressed: (){
                          UtilityMethods.navigateToRoute(context: context,
                              builder: (context) => WebPage(APP_TERMS_OF_USE_URL, UtilityMethods.getLocalizedString("terms_of_use")));
                        }
                    ),
                  ),
                ],
              ),
              state.errorText != null && isAgree == false ? Padding(
                padding: const EdgeInsets.only(top: 10,left: 20.0),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: AppThemePreferences.errorColor,
                  ),
                ),
              ) : Container(),
            ],
          );
        },
        validator: (value) {
          if (!isAgree) {
            return UtilityMethods.getLocalizedString("please_accept_terms_of_use");
          }
          return null;
        },
      ),
    );
  }

  Widget submitButtonWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Center(
        child: ButtonWidget(
          text: UtilityMethods.getLocalizedString("submit"),
          onPressed: () => onSubmitPressed(),
        ),
      ),
    );
  }

  onSubmitPressed() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        showWaitingWidget = true;
      });

      Map<String, dynamic> dataMap = {
        "agent_id": "${widget.agentId}",
        "target_email": widget.agentEmail,
        "phone": _phone,
        "name": _name,
        "email": _email,
        "message": _message,
        "listing_id": "${widget.propertyId}",
        "property_title": widget.propertyTitle,
        "property_permalink": widget.propertyPermalink,
        "schedule_tour_type": _tourType,
        "schedule_time": _time,
        "schedule_date" : _date,
      };

      final response = await _propertyBloc.fetchScheduleATourResponse(dataMap,nonce);

      if(response.statusCode == null){
        if(mounted){
          setState(() {
            isInternetConnected = false;
            showWaitingWidget = false;
          });
        }
      }else{
        if(mounted){
          setState(() {
            isInternetConnected = true;
            showWaitingWidget = false;
          });
        }

        if(response == null){
          ShowToastWidget(buildContext: context, text: UtilityMethods.getLocalizedString("error_occurred"));
        }else{
          String tempString = response.toString();
          if(tempString.contains("{")){
            String tempResponseString = response.toString().split("{")[1];
            Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");
            if (map['success']) {
              ShowToastWidget(buildContext: context, text: map['msg']);
              Navigator.pop(context);
            } else {
              if (map["msg"] != null) {
                ShowToastWidget(buildContext: context, text: map['msg']);
              } else if (map["reason"] != null) {
                ShowToastWidget(buildContext: context, text: map['reason']);
              } else {
                ShowToastWidget(buildContext: context, text: UtilityMethods.getLocalizedString("error_occurred"));
              }
            }
          }else{
            ShowToastWidget(buildContext: context, text: UtilityMethods.getLocalizedString("error_occurred"));
          }
        }
      }
    }
  }

  Widget uploadingWaitingWidget(){
    return  showWaitingWidget == true ?Positioned(
      left: 0,
      right: 0,
      top: 0,
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
    ) : Container();
  }

  Widget bottomActionBarWidget() {
    return Positioned(
      bottom: 0.0,
      child: SafeArea(
        child: Column(
          children: [
            if(!isInternetConnected) NoInternetBottomActionBarWidget(onPressed: ()=> onSubmitPressed()),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        _textEditingControllerForDate.text = "${picked.toLocal()}".split(' ')[0];
        selectedDate = picked;
      });
    }
  }
}
