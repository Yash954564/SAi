import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_link_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/drop_down_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';

typedef AdminUserSignUpPageListener = void Function(bool refresh);

class AdminUserSignUp extends StatefulWidget {

  final AdminUserSignUpPageListener adminUserSignUpPageListener;

  AdminUserSignUp({required this.adminUserSignUpPageListener});

  @override
  State<StatefulWidget> createState() => AdminUserSignUpState();
}

class AdminUserSignUpState extends State<AdminUserSignUp> with ValidationMixin {
  final formKey = GlobalKey<FormState>();
  final PropertyBloc _propertyBloc = PropertyBloc();

  TextEditingController registerPass = TextEditingController();
  TextEditingController registerPassRetype = TextEditingController();

  bool _showWaitingWidget = false;

  String nonce = "";
  String userName = "";
  String email = "";
  String phoneNumber = "";
  bool termsAndConditions = false;
  String termsAndConditionsValue = "off";

  bool _isInternetConnected = true;

  var userRoleList = [];
  String? _roleValue;

  @override
  void initState() {
    super.initState();
    userRoleList = HiveStorageManager.readAdminUserRoleListData() ?? [];

    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchSignUpNonceResponse();
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
          appBarTitle: UtilityMethods.getLocalizedString("add_user"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Column(
                    children: [
                      addUserName(context),
                      addEmail(context),
                      addPhone(),
                      addPassword(context),
                      reTypePassword(context),
                      dropDownRole(userRoleList, UtilityMethods.getLocalizedString("select_your_account_type"), UtilityMethods.getLocalizedString("select")),
                      TermsAndConditionAgreementWidget(
                        areTermsAccepted: termsAndConditions,
                        listener: (areTermsAccepted){
                          if (mounted) {
                            setState(() {
                              termsAndConditions = areTermsAccepted;
                              if (termsAndConditions) {
                                termsAndConditionsValue = "on";
                              } else {
                                termsAndConditionsValue = "off";
                              }
                            });
                          }
                        },
                      ),
                      buttonSignUpWidget(),
                    ],
                  ),
                ),
                AdminSignUpWaitingWidget(showWidget: _showWaitingWidget),
                AdminSignUpBottomActionBarWidget(internetConnection: _isInternetConnected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addUserName(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 15.0),
      labelText: UtilityMethods.getLocalizedString("user_name"),
      hintText: UtilityMethods.getLocalizedString("enter_your_user_name"),
      keyboardType: TextInputType.text,
      validator: (value) => validateUserName(value),
      onSaved: (text) {
        userName = text!;
      },
    );
  }

  Widget addEmail(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 15.0),
      labelText: UtilityMethods.getLocalizedString("email"),
      hintText: UtilityMethods.getLocalizedString("enter_email_address"),
      keyboardType: TextInputType.emailAddress,
      validator: (value) => validateEmail(value!),
      onSaved: (text) {
        email = text!;
      },
    );
  }

  Widget addPhone() {
    return !SHOW_SIGNUP_ENTER_PHONE_FIELD ? Container() : TextFormFieldWidget(
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

  Widget addPassword(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 15.0),
      labelText: UtilityMethods.getLocalizedString("password"),
      hintText: UtilityMethods.getLocalizedString("enter_your_password"),
      controller: registerPass,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) => validatePassword(value),
    );
  }

  Widget reTypePassword(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 15.0),
      labelText: UtilityMethods.getLocalizedString("confirm_password"),
      hintText: UtilityMethods.getLocalizedString("confirm_your_password"),
      obscureText: true,
      controller: registerPassRetype,
      keyboardType: TextInputType.visiblePassword,
      validator: (String? value) {
        if (value!.length < 8) {
          return UtilityMethods.getLocalizedString("password_length_at_least_eight");
        }
        if (value.isEmpty) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
        }

        if (registerPass.text != registerPassRetype.text) {
          return UtilityMethods.getLocalizedString("password_does_not_match");
        }
        return null;
      },
    );
  }

  Widget dropDownRole(List list, String title, String hintText){
    return GenericStringDropDownWidget(
      padding: const EdgeInsets.fromLTRB(0,15,0,0),
      labelText: title,
      hintText: hintText,
      value: _roleValue,
      items: list.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              item,
            ),
          ),
          value: item
        );
      }).toList(),
      onChanged: (value) {
        _roleValue = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
        }
        return null;
      },
    );
  }

  Widget buttonSignUpWidget() {
    return ButtonWidget(
      text: UtilityMethods.getLocalizedString("sign_up"),
      onPressed: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          setState(() {
            _showWaitingWidget = true;
          });
          Map<String, dynamic> userSignupInfo = {
            "username": userName,
            "useremail": email,
            "register_pass": registerPass.text,
            "register_pass_retype": registerPassRetype.text,
            "term_condition": termsAndConditionsValue,
            "role": _roleValue
          };

          final response = await _propertyBloc.fetchAdminAddUserResponse(userSignupInfo, nonce);

          if(response == null || response.statusCode == null){
            if(mounted){
              setState(() {
                _isInternetConnected = false;
                _showWaitingWidget = false;
              });
            }
          }else{
            if(mounted){
              setState(() {
                _isInternetConnected = true;
                _showWaitingWidget = false;
              });
            }
          }

          if(response == null){
            _showToastForUserLogin(context, UtilityMethods.getLocalizedString("error_occurred"));
          }else{
            String tempString = response.toString();
            if(tempString.contains("{")){
              String tempResponseString = response.toString().split("{")[1];
              Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");
              if (map['success'] == true) {
                _showToastForUserLogin(context, map['msg']);
                widget.adminUserSignUpPageListener(true);
                Navigator.pop(context);

              } else {
                if (map["msg"] != null) {
                  _showToastForUserLogin(context, map["msg"]);
                } else if (map["reason"] != null) {
                  _showToastForUserLogin(context, map["reason"]);
                } else {
                  _showToastForUserLogin(
                      context, UtilityMethods.getLocalizedString("error_occurred"));
                }
              }
            }else{
              _showToastForUserLogin(context, UtilityMethods.getLocalizedString("error_occurred"));
            }
          }
        }
      },
    );
  }

  _showToastForUserLogin(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }
}

class AdminSignUpWaitingWidget extends StatelessWidget {
  final bool showWidget;

  const AdminSignUpWaitingWidget({
    Key? key,
    required this.showWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showWidget) {
      return Positioned(
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
      );
    }

    return Container();
  }
}

class AdminSignUpBottomActionBarWidget extends StatelessWidget {
  final bool internetConnection;

  const AdminSignUpBottomActionBarWidget({
    Key? key,
    required this.internetConnection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      child: SafeArea(
        child: Column(
          children: [
            if(!internetConnection) NoInternetBottomActionBarWidget(showRetryButton: false),
          ],
        ),
      ),
    );
  }
}

typedef TermsAndConditionAgreementWidgetListener = Function(bool areTermsAccepted);

class TermsAndConditionAgreementWidget extends StatefulWidget {
  final bool areTermsAccepted;
  final TermsAndConditionAgreementWidgetListener listener;

  const TermsAndConditionAgreementWidget({
    Key? key,
    required this.areTermsAccepted,
    required this.listener,
  }) : super(key: key);

  @override
  State<TermsAndConditionAgreementWidget> createState() => _TermsAndConditionAgreementWidgetState();
}

class _TermsAndConditionAgreementWidgetState extends State<TermsAndConditionAgreementWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: FormField<bool>(
        builder: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: widget.areTermsAccepted,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (value) {
                      if(value != null){
                        widget.listener(value);
                      }

                      if (mounted) {
                        setState(() {
                          state.didChange(value);
                        });
                      }
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
        validator: (value) {
          if (!widget.areTermsAccepted) {
            return UtilityMethods.getLocalizedString("please_accept_terms_text");
          }
          return null;
        },
      ),
    );
  }
}
