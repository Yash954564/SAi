import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/mixins/validation_mixins.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';


class ContactDeveloper extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ContactDeveloperState();

}

class ContactDeveloperState extends State<ContactDeveloper> with ValidationMixin{

  bool _showWaitingWidget = false;
  bool isInternetConnected = true;

  String _email = '';
  String _message = '';
  String _fullName = '';
  String _wordpressUrl = '';

  final formKey = GlobalKey<FormState>();
  final PropertyBloc _propertyBloc = PropertyBloc();
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _userEmailTextController = TextEditingController();


  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData(){
    var tempUserName = HiveStorageManager.getUserName();
    if(tempUserName != null && tempUserName.isNotEmpty){
      _userNameTextController.text = tempUserName;
    }
    var tempUserEmail = HiveStorageManager.getUserEmail();
    if(tempUserEmail != null && tempUserEmail.isNotEmpty){
      _userEmailTextController.text = tempUserEmail;
    }
  }


  @override
  void dispose() {
    _userEmailTextController.dispose();
    _userNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("contact_us"),
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
                    fullNameWidget(),
                    emailWidget(),
                    wordpressUrlWidget(),
                    messageWidget(),
                    submitElevatedButtonWidget(),
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

  Widget fullNameWidget() {
    return TextFormFieldWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("name"),
      hintText: UtilityMethods.getLocalizedString("enter_your_name"),
      controller: _userNameTextController,
      keyboardType: TextInputType.name,
      validator: (value) => validateTextField(value!),
      onSaved: (value){
        _fullName = value!;
      },
    );
  }

  Widget emailWidget() {
    return TextFormFieldWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("email_address"),
      hintText: UtilityMethods.getLocalizedString("enter_your_email_address"),
      controller: _userEmailTextController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => validateEmail(value!),
      onSaved: (String? value) {
        setState(() {
          _email = value!;
        });
      },
    );
  }

  Widget wordpressUrlWidget() {
    return TextFormFieldWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("wordpress_url_optional"),
      hintText: UtilityMethods.getLocalizedString("enter_wordpress_url"),
      keyboardType: TextInputType.url,
      onSaved: (value){
        _wordpressUrl = value!;
      },
    );
  }

  Widget messageWidget(){
    return TextFormFieldWidget(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("message"),
      hintText: UtilityMethods.getLocalizedString("your_message"),
      keyboardType: TextInputType.multiline,
      maxLines: 6,
      validator: (value) => validateTextField(value!),
      onSaved: (value){
        setState(() {
          _message = value!;
        });
      },
    );
  }

  Widget submitElevatedButtonWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: ButtonWidget(
        text: UtilityMethods.getLocalizedString("submit"),
        onPressed: ()  => onSubmitPressed(),
      ),
    );
  }

  onSubmitPressed() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _showWaitingWidget = true;
      });

      formKey.currentState!.save();

      Map<String, dynamic> dataMap = {
        "source": '$APP_NAME ${Platform.operatingSystem}',
        "name": _fullName,
        "email": _email,
        "message": _message,
        'website': _wordpressUrl,
      };

      final response = await _propertyBloc.fetchContactDeveloperResponse(dataMap);

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
        if(response.statusCode == 200){
          _showToast(context,UtilityMethods.getLocalizedString("message_sent_successfully"));
          Navigator.pop(context);
        }else{
          _showToast(context,UtilityMethods.getLocalizedString("message_failed_to_send"),);
        }
      }

    }
  }

  Widget waitingWidget(){
    return  _showWaitingWidget == true ? Positioned(
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

  _showToast(BuildContext context, String message) {
    ShowToastWidget(
      buildContext: context,
      text: message,
    );
  }
}