import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/phone_sign_in_widgets/phone_field_widget.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/generic_link_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';

class UserSignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserSignUpState();
}

class UserSignUpState extends State<UserSignUp> with ValidationMixin {
  
  bool _showWaitingWidget = false;
  bool _isInternetConnected = true;

  List<dynamic> userRoleList = [];

  String? _roleValue;

  String nonce = "";
  String firstName = "";
  String lastName = "";
  String userName = "";
  String email = "";
  String phoneNumber = "";
  String countryDialCode = "";
  bool termsAndConditions = false;
  String termsAndConditionsValue = "off";

  final formKey = GlobalKey<FormState>();
  final PropertyBloc _propertyBloc = PropertyBloc();

  TextEditingController registerPass = TextEditingController();
  TextEditingController registerPassRetype = TextEditingController();

  @override
  void initState() {
    super.initState();
    userRoleList = HiveStorageManager.readUserRoleListData() ?? [];
    if (userRoleList.isNotEmpty && userRoleList.length == 1) {
      Map map = userRoleList[0];
      _roleValue = map["value"];
    }

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
          appBarTitle: UtilityMethods.getLocalizedString("sign_up"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                Padding(
                  padding: (UtilityMethods.showTabletView)
                      ? const EdgeInsets.only(left: 150.0, top: 100, right: 150)
                      : const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Column(
                    children: [
                      addFirstName(context),
                      addLastName(context),
                      addUserName(context),
                      addEmail(context),
                      addPhone(),
                      addPassword(context),
                      reTypePassword(context),
                      dropDownRole(),
                      TermsAndConditionAgreementWidget(
                        areTermsAccepted: termsAndConditions,
                        listener: (areTermsAccepted){
                          if(mounted) {
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
                      AlreadySignedUpTextWidget(onLinkPressed: onLoginLinkPressed),
                    ],
                  ),
                ),
                SignUpWaitingWidget(showWidget: _showWaitingWidget),
                SignUpBottomActionBarWidget(internetConnection: _isInternetConnected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addFirstName(BuildContext context) {
    return !SHOW_SIGNUP_ENTER_FIRST_NAME_FIELD ? Container() : TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 15.0),
      labelText: UtilityMethods.getLocalizedString("first_name"),
      hintText: UtilityMethods.getLocalizedString("enter_first_name"),
      keyboardType: TextInputType.text,
      validator: (value) => validateTextField(value),
      onSaved: (text) {
        firstName = text!;
      },
    );
  }

  Widget addLastName(BuildContext context) {
    return !SHOW_SIGNUP_ENTER_LAST_NAME_FIELD ? Container() : TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 15.0),
      labelText: UtilityMethods.getLocalizedString("last_name"),
      hintText: UtilityMethods.getLocalizedString("enter_last_name"),
      keyboardType: TextInputType.text,
      validator: (value) => validateTextField(value),
      onSaved: (text) {
        lastName = text!;
      },
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
      validator: (value) => validateEmail(value),
      onSaved: (text) {
        email = text!;
      },
    );
  }

  Widget addPhone() {
    // return !SHOW_SIGNUP_ENTER_PHONE_FIELD ? Container() : TextFormFieldWidget(
    // return TextFormFieldWidget(
    //   padding: const EdgeInsets.only(top: 15.0),
    //   labelText: UtilityMethods.getLocalizedString("phone"),
    //   hintText: UtilityMethods.getLocalizedString("enter_your_phone_number"),
    //   keyboardType: TextInputType.phone,
    //   validator: (value) => validatePhoneNumber(value),
    //   onSaved: (text) {
    //     phoneNumber = text!;
    //   },
    // );
    return !SHOW_SIGNUP_ENTER_PHONE_FIELD ? Container() : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        PhoneNumberFieldWidget(
          padding: const EdgeInsets.only(top: 15.0),
          labelText: UtilityMethods.getLocalizedString("phone"),
          hintText: UtilityMethods.getLocalizedString("enter_your_phone_number"),
          listener: (code, num) {
            phoneNumber = num;
            countryDialCode = code;
          },
        ),
      ],
    );
  }

  Widget addPassword(BuildContext context) {
    return !SHOW_SIGNUP_PASSWORD_FIELD ? Container() : TextFormFieldWidget(
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
    return !SHOW_SIGNUP_PASSWORD_FIELD ? Container() : TextFormFieldWidget(
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

  Widget dropDownRole() {
    return userRoleList.isNotEmpty && userRoleList.length == 1 ? Container() : Container(
      margin: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelWidget(UtilityMethods.getLocalizedString("select_your_account_type")),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: DropdownButtonFormField(
              dropdownColor: AppThemePreferences().appTheme.dropdownMenuBgColor,
              icon: Icon(AppThemePreferences.dropDownArrowIcon),
              decoration: AppThemePreferences.formFieldDecoration(
                  hintText: UtilityMethods.getLocalizedString("select")),
              // items: roleOptions.map((description, value) {
              //       return MapEntry(description,
              //           DropdownMenuItem<String>(
              //             value: value,
              //             child: genericTextWidget(description),
              //           ));
              //     }).values.toList(),
              items: userRoleList.map((map) {
                return DropdownMenuItem(
                  child: GenericTextWidget(UtilityMethods.getLocalizedString(map['option'])),
                  value: map['value'],
                );
              }).toList(),
              value: _roleValue,
              onChanged: (value) {
                if(value != null){
                  _roleValue = value.toString();
                }
              },
              validator: (value) {
                if (value == null) {
                  return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
                }
                return null;
              },

            ),
          ),
        ],
      ),
    );
  }

  Widget buttonSignUpWidget() {
    return ButtonWidget(
      text: UtilityMethods.getLocalizedString("sign_up"),
      onPressed: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          if (mounted) {
            setState(() {
              _showWaitingWidget = true;
            });
          }
          Map<String, dynamic> userSignupInfo = {
            "username": userName,
            "useremail": email,
            "term_condition": termsAndConditionsValue,
            "role": _roleValue
          };
          if(SHOW_SIGNUP_ENTER_PHONE_FIELD){
            userSignupInfo["phone_number"] = phoneNumber;
          }
          if(SHOW_SIGNUP_ENTER_FIRST_NAME_FIELD){
            userSignupInfo["first_name"] = firstName;
          }
          if(SHOW_SIGNUP_ENTER_LAST_NAME_FIELD){
            userSignupInfo["last_name"] = lastName;
          }
          if(SHOW_SIGNUP_PASSWORD_FIELD){
            userSignupInfo["register_pass"] = registerPass.text;
            userSignupInfo["register_pass_retype"] = registerPassRetype.text;
          }

          final response = await _propertyBloc.fetchSigupResponse(userSignupInfo, nonce);

          if(response == null || response.statusCode == null){
            if (mounted) {
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
                Route route = MaterialPageRoute(builder: (context) => UserSignIn(
                      (String closeOption) {
                    if (closeOption == CLOSE) {
                      Navigator.pop(context);
                    }
                  },
                ));
                Navigator.pushReplacement(context, route);
              } else if(map['success'] == false){
                _showToastForUserLogin(context, map['msg']);
              } else{
                _showToastForUserLogin(context, map['msg']);
              }
            }else{
              _showToastForUserLogin(context, UtilityMethods.getLocalizedString("error_occurred"));
            }
          }
        }
      },
    );
  }

  onLoginLinkPressed(){
    Route route = MaterialPageRoute(
      builder: (context) => UserSignIn(
            (String closeOption) {
          if (closeOption == CLOSE) {
            Navigator.pop(context);
          }
        },
      ),
    );
    Navigator.pushReplacement(context, route);
  }

  _showToastForUserLogin(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }
}

class AlreadySignedUpTextWidget extends StatelessWidget {
  final void Function() onLinkPressed;

  const AlreadySignedUpTextWidget({
    Key? key,
    required this.onLinkPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: GenericLinkWidget(
        preLinkText: UtilityMethods.getLocalizedString("already_have_an_account"),
        linkText: UtilityMethods.getLocalizedString("login_capital"),
        onLinkPressed: onLinkPressed,
      ),
    );
  }
}

class SignUpWaitingWidget extends StatelessWidget {
  final bool showWidget;

  const SignUpWaitingWidget({
    Key? key,
    required this.showWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(showWidget) return Positioned(
      left: 0, right: 0, top: 0, bottom: 0,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: 80,
            height: 20,
            child: BallBeatLoadingWidget(),
          ),
        ),
      ),
    );

    return Container();
  }
}

class SignUpBottomActionBarWidget extends StatelessWidget {
  final bool internetConnection;

  const SignUpBottomActionBarWidget({
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

                      if(mounted) setState(() {
                        state.didChange(value);
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




