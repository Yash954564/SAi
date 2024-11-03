
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> with ValidationMixin {

  String nonce = "";

  bool _isInternetConnected = true;
  bool _showWaitingWidget = false;

  final formKey = GlobalKey<FormState>();

  final PropertyBloc _propertyBloc = PropertyBloc();

  TextEditingController registerPass = TextEditingController();
  TextEditingController registerPassRetype = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchUpdatePasswordNonceResponse();
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
          appBarTitle: UtilityMethods.getLocalizedString("change_password"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        addPassword(context),
                        reTypePassword(context),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: updatePasswordButtonWidget(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ChangePasswordWaitingWidget(showWaitingWidget: _showWaitingWidget),
              ChangePasswordBottomActionBarWidget(isInternetConnected: _isInternetConnected),
            ],
          ),
        ),
      ),
    );
  }

  Widget addPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("password"),
        hintText: UtilityMethods.getLocalizedString("enter_your_password"),
        controller: registerPass,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        validator: (value) => validatePassword(value),
      ),
    );
  }

  Widget reTypePassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
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
      ),
    );
  }

  Widget updatePasswordButtonWidget(BuildContext context) {
    return ButtonWidget(
      text: UtilityMethods.getLocalizedString("update_password"),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          if(mounted){
            setState(() {
              _showWaitingWidget = true;
            });
          }

          Map<String, dynamic> userInfo = {
            "newpass": registerPass.text,
            "confirmpass": registerPassRetype.text,
          };

          final response = await _propertyBloc.fetchUpdateUserPasswordResponse(userInfo, nonce);

          if(response.statusCode == null){
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

            if(response == null){
              ShowToastWidget(
                  buildContext: context,
                  text: UtilityMethods.getLocalizedString("error_occurred"),
              );
            }else{
              String tempString = response.toString();
              if(tempString.contains("{")){
                String tempResponseString = response.toString().split("{")[1];
                Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");
                if(map["success"] == true){
                  ShowToastWidget(
                    buildContext: context,
                    text: map["msg"],
                  );

                  Map userInfoMapFromStorage = HiveStorageManager.readUserCredentials();
                  Map<String, dynamic> userInfo = {
                    USER_NAME: userInfoMapFromStorage["username"],
                    PASSWORD: registerPass.text,
                  };
                  HiveStorageManager.storeUserCredentials(userInfo);
                  Navigator.of(context).pop();
                }else{
                  if (map["msg"] != null) {
                    ShowToastWidget(
                      buildContext: context,
                      text: map["msg"],
                    );
                  } else if (map["reason"] != null) {
                    ShowToastWidget(
                      buildContext: context,
                      text: map["reason"],
                    );
                  } else {
                    ShowToastWidget(
                      buildContext: context,
                      text: UtilityMethods.getLocalizedString("error_occurred"),
                    );
                  }
                  ShowToastWidget(
                      buildContext: context,
                      text: map["msg"],
                  );
                }
              }else{
                ShowToastWidget(
                    buildContext: context,
                    text: UtilityMethods.getLocalizedString("error_occurred"),
                );
              }

            }
          }
        }
      },
    );
  }
}

class ChangePasswordWaitingWidget extends StatelessWidget {
  final bool showWaitingWidget;
  
  const ChangePasswordWaitingWidget({
    Key? key,
    required this.showWaitingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(showWaitingWidget) return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
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

class ChangePasswordBottomActionBarWidget extends StatelessWidget {
  final bool isInternetConnected;
  
  const ChangePasswordBottomActionBarWidget({
    Key? key,
    required this.isInternetConnected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      child: SafeArea(
        child: Column(
          children: [
            if(!isInternetConnected) NoInternetBottomActionBarWidget(showRetryButton: false),
          ],
        ),
      ),
    );
  }
}

