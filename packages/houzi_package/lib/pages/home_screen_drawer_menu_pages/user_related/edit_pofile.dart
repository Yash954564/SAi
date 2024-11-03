import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/user.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:image_picker/image_picker.dart';

import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/header_widget.dart';

class EditProfile extends StatefulWidget {

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> with ValidationMixin {
  
  final formKey = GlobalKey<FormState>();
  
  final PropertyBloc _propertyBloc = PropertyBloc();

  TextEditingController registerPass = TextEditingController();
  TextEditingController registerPassRetype = TextEditingController();

  Map<String,dynamic> userInfoMap = {
    FIRST_NAME : "",
    LAST_NAME : "",
    USER_LANGS : "",
    USER_TITLE : "",
    DESCRIPTION : "",
    USER_COMPANY : "",
    USER_PHONE : "",
    USER_MOBILE : "",
    FAX_NUMBER : "",
    SERVICE_AREA : "",
    SPECIALITIES : "",
    LICENSE : "",
    TAX_NUMBER : "",
    USER_ADDRESS : "",
    FACEBOOK : "",
    TWITTER : "",
    LINKEDIN : "",
    INSTAGRAM : "",
    YOUTUBE : "",
    PINTEREST : "",
    VIMEO : "",
    SKYPE : "",
    WEBSITE : "",
    PICTURE_ID : ""
  };


  User? _userInfo;
  
  final picker = ImagePicker();

  List<dynamic> userInfoList = [];
  List<dynamic> displayNameOptionsList = [];

  bool isInternetConnected = true;
  bool _showWaitingWidget = false;
  bool showFields = false;

  String id = "";
  String? _displayName;
  String profile = "";
  String nonce = "";

  String? selectedDisplayName;

  @override
  void initState() {
    super.initState();
    loadData();
    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchUpdateProfileNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  checkInternet() {
    loadData();
  }

  void loadData() {
    if(mounted){
      setState(() {
        _showWaitingWidget = true;
      });
    }
    
    fetchUserInfo().then((value) {
      if((value.isNotEmpty && value[0] == null) || (value.isNotEmpty && value[0].runtimeType == Response)){
        if(mounted){
          setState(() {
            isInternetConnected = false;
            _showWaitingWidget = false;
          });
        }
      }else{
        if (mounted) {
          setState(() {
            isInternetConnected = true;
            _showWaitingWidget = false;
          });
        }
        if(value.isNotEmpty){
          userInfoList = value;
          _userInfo = userInfoList[0];
          if(mounted){
            setState(() {
              userInfoMap[USER_NAME] = _userInfo!.username ?? "";
              userInfoMap[FIRST_NAME] = _userInfo!.firstName ?? "";
              userInfoMap[LAST_NAME] = _userInfo!.lastName ?? "";
              userInfoMap[USER_LANGS] = _userInfo!.userlangs ?? "";
              userInfoMap[USER_TITLE] = _userInfo!.userTitle ?? "";
              userInfoMap[USER_COMPANY] = _userInfo!.userCompany ?? "";
              userInfoMap[USER_PHONE] = _userInfo!.userPhone ?? "";
              userInfoMap[USER_MOBILE] = _userInfo!.userMobile ?? "";
              userInfoMap[FAX_NUMBER] = _userInfo!.faxNumber ?? "";
              userInfoMap[SERVICE_AREA] = _userInfo!.serviceAreas ?? "";
              userInfoMap[SPECIALITIES] = _userInfo!.specialties ?? "";
              userInfoMap[LICENSE] = _userInfo!.license ?? "";
              userInfoMap[TAX_NUMBER] = _userInfo!.taxNumber ?? "";
              userInfoMap[USER_ADDRESS] = _userInfo!.userAddress ?? "";
              userInfoMap[DISPLAY_NAME] = _userInfo!.displayName ?? "";
              userInfoMap[USER_EMAIL] = _userInfo!.userEmail ?? "";
              userInfoMap[USER_WHATSAPP] = _userInfo!.userWhatsapp ?? "";
              userInfoMap[DESCRIPTION] = _userInfo!.description ?? "";
              userInfoMap[FACEBOOK] = _userInfo!.facebook ?? "";
              userInfoMap[TWITTER] = _userInfo!.twitter ?? "";
              userInfoMap[INSTAGRAM] = _userInfo!.instagram ?? "";
              userInfoMap[LINKEDIN] = _userInfo!.linkedin ?? "";
              userInfoMap[YOUTUBE] = _userInfo!.youtube ?? "";
              userInfoMap[PINTEREST] = _userInfo!.pinterest ?? "";
              userInfoMap[VIMEO] = _userInfo!.vimeo ?? "";
              userInfoMap[SKYPE] = _userInfo!.skype ?? "";
              userInfoMap[WEBSITE] = _userInfo!.website ?? "";
              userInfoMap[LINE_ID] = _userInfo!.lineId ?? "";
              userInfoMap[TELEGRAM] = _userInfo!.telegram ?? "";
              userInfoMap[PICTURE_ID] = _userInfo!.pictureId ?? "";

              var nameForDisplay = _userInfo!.displayNameOptions;
              if(nameForDisplay != null && nameForDisplay.isNotEmpty){
                displayNameOptionsList = nameForDisplay.toSet().toList();
              }

              id = _userInfo!.id ?? "";
              _displayName = _userInfo!.displayName;
              profile = _userInfo!.profile ?? "";

              showFields = true;
            });
          }
        }
      }

      return null;
    });
  }

  Future<List<dynamic>> fetchUserInfo() async {
    userInfoList = await _propertyBloc.fetchUserInfo();
    return userInfoList;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("edit_profile"),
        ),
        body: isInternetConnected == false
            ? Align(
                alignment: Alignment.topCenter,
                child: NoInternetConnectionErrorWidget(onPressed: () {
                  checkInternet();
                }),
              )
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: showUserInfo(context),
              ),
      ),
    );
  }

  Widget showUserInfo(BuildContext context) {
    return Stack(
      children: [
        showFields ? SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  setValuesInFields(labelText: "user_name", initialValue: userInfoMap[USER_NAME], key: USER_NAME, readOnly: true, enabled: false),
                  setValuesInFields(labelText: "first_name", initialValue: userInfoMap[FIRST_NAME], key: FIRST_NAME),
                  setValuesInFields(labelText: "last_name", initialValue: userInfoMap[LAST_NAME], key: LAST_NAME),
                  setValuesInFields(labelText: "email", initialValue: userInfoMap[USER_EMAIL], keyboardType: TextInputType.emailAddress, key: USER_EMAIL),
                  displayNameWidget(context),
                  setValuesInFields(labelText: "title_position", initialValue: userInfoMap[USER_TITLE], key: USER_TITLE),
                  setValuesInFields(labelText: "license", initialValue: userInfoMap[LICENSE], key: LICENSE),
                  setValuesInFields(labelText: "mobile", initialValue: userInfoMap[USER_MOBILE], keyboardType: TextInputType.phone, key: USER_MOBILE),
                  setValuesInFields(labelText: "whatsApp", initialValue: userInfoMap[USER_WHATSAPP], keyboardType: TextInputType.phone, key: USER_WHATSAPP),
                  setValuesInFields(labelText: "line id", initialValue: userInfoMap[LINE_ID], key: LINE_ID),
                  setValuesInFields(labelText: "telegram", initialValue: userInfoMap[TELEGRAM], key: TELEGRAM),
                  setValuesInFields(labelText: "tax_number", initialValue: userInfoMap[TAX_NUMBER], key: TAX_NUMBER),
                  setValuesInFields(labelText: "phone", initialValue: userInfoMap[USER_PHONE], keyboardType: TextInputType.phone, key: USER_PHONE),
                  setValuesInFields(labelText: "fax_number", initialValue: userInfoMap[FAX_NUMBER], keyboardType: TextInputType.phone, key: FAX_NUMBER),
                  setValuesInFields(labelText: "language_label", initialValue: userInfoMap[USER_LANGS], key: USER_LANGS),
                  setValuesInFields(labelText: "company_name", initialValue: userInfoMap[USER_COMPANY], key: USER_COMPANY),
                  setValuesInFields(labelText: "address", initialValue: userInfoMap[USER_ADDRESS], key: USER_ADDRESS),
                  setValuesInFields(labelText: "service_areas", initialValue: userInfoMap[SERVICE_AREA], key: SERVICE_AREA),
                  setValuesInFields(labelText: "specialties", initialValue: userInfoMap[SPECIALITIES], key: SPECIALITIES),
                  setValuesInFields(labelText: "about_me", initialValue: userInfoMap[DESCRIPTION], key: DESCRIPTION, maxLines: 5),
                  headerTextWidget(UtilityMethods.getLocalizedString("social")),
                  setValuesInFields(labelText: "facebook", initialValue: userInfoMap[FACEBOOK], key: FACEBOOK),
                  setValuesInFields(labelText: "twitter", initialValue: userInfoMap[TWITTER], key: TWITTER),
                  setValuesInFields(labelText: "linkedIn", initialValue: userInfoMap[LINKEDIN], key: LINKEDIN),
                  setValuesInFields(labelText: "instagram", initialValue: userInfoMap[INSTAGRAM], key: INSTAGRAM),
                  setValuesInFields(labelText: "youtube", initialValue: userInfoMap[YOUTUBE], key: YOUTUBE),
                  setValuesInFields(labelText: "pinterest", initialValue: userInfoMap[PINTEREST], key: PINTEREST),
                  setValuesInFields(labelText: "vimeo", initialValue: userInfoMap[VIMEO], key: VIMEO),
                  setValuesInFields(labelText: "skype", initialValue: userInfoMap[SKYPE], key: SKYPE),
                  setValuesInFields(labelText: "website", initialValue: userInfoMap[WEBSITE], key: WEBSITE),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: updateProfileButtonWidget(context),
                  ),
                ],
              ),
            ),
          ),
        ) : Container(),
        waitingWidget(),
      ],
    );
  }

  Widget setValuesInFields({
    required String labelText,
    required String initialValue,
    required String key,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    bool enabled = true,
  }) {
    return EditProfileFormFieldWidget(
      mapKey: key,
      labelText: labelText,
      initialValue: initialValue,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      listener: (map) {
        if(mounted) {
          setState(() {
          userInfoMap.addAll(map);
        });
        }
      },
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

  Widget displayNameWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericTextWidget(UtilityMethods.getLocalizedString("display_name"),
              style: AppThemePreferences().appTheme.labelTextStyle),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: DropdownButtonFormField(
              dropdownColor: AppThemePreferences().appTheme.dropdownMenuBgColor,
              icon: Icon(AppThemePreferences.dropDownArrowIcon),
              decoration: AppThemePreferences.formFieldDecoration(hintText: UtilityMethods.getLocalizedString("display_name")),
              value: _displayName,
              onSaved: (val) {
                setState(() {
                  selectedDisplayName = val;
                  userInfoMap[DISPLAY_NAME] = val;
                });
              },
              items: displayNameOptionsList.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  child: GenericTextWidget(
                    item,
                  ),
                  value: item,
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedDisplayName = val;
                  userInfoMap[DISPLAY_NAME] = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
  

  Widget updateProfileButtonWidget(BuildContext context) {
    return ButtonWidget(
      text: UtilityMethods.getLocalizedString("update_profile"),
      onPressed: () async {
        setState(() {
          _showWaitingWidget = true;
        });

        formKey.currentState!.save();

        // Make sure that the map contains the picture id
        if (!userInfoMap.containsKey(PICTURE_ID)){
          userInfoMap[PICTURE_ID] = "";
        }

        if(NEED_TO_FIX_PROFILE_PIC == 0){
          final response = await _propertyBloc.fetchUpdateUserProfileResponse(userInfoMap, nonce);

          if(mounted){
            setState(() {
              _showWaitingWidget = false;
            });
          }
          if (response.statusCode == 200) {
            HiveStorageManager.setUserDisplayName(userInfoMap[DISPLAY_NAME]);
            HiveStorageManager.setUserEmail(userInfoMap[USER_EMAIL]);
            GeneralNotifier().publishChange(GeneralNotifier.USER_PROFILE_UPDATE);
            _showToast(context,UtilityMethods.getLocalizedString("profile_updated_successfully"));
            Navigator.pop(context);
          } else {
            _showToast(context, UtilityMethods.getLocalizedString("error_occurred"));
          }
          /// If need to fix agent profile image
        }else if(NEED_TO_FIX_PROFILE_PIC == 1){
          if(mounted){
            setState(() {
              _showWaitingWidget = false;
            });
          }

          _propertyBloc.fetchUpdateUserProfileResponse(userInfoMap, nonce).then((value) async {
            String tempResponseString = value.toString().split("{")[1];
            Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");

            if (map["success"] == true) {
              final responseForFix = await _propertyBloc.fetchFixProfileImageResponse();
              bool success = false;
              if (responseForFix.data != null) {
                Map dataMap = jsonDecode(responseForFix.data);
                if (dataMap.containsKey("success") && dataMap["success"] == true) {
                  success = true;
                }
              }
              
              if (success) {
                HiveStorageManager.setUserDisplayName(userInfoMap[DISPLAY_NAME]);
                HiveStorageManager.setUserEmail(userInfoMap[USER_EMAIL]);
                GeneralNotifier().publishChange(GeneralNotifier.USER_PROFILE_UPDATE);
                _showToast(context, UtilityMethods.getLocalizedString("profile_updated_successfully"));
                Navigator.pop(context);
              } else{
                _showToast(context, UtilityMethods.getLocalizedString("error_occurred"));
              }
            }

            return null;
          });
        }
      },
    );
  }

  Widget waitingWidget() {
    return _showWaitingWidget == true
        ? Positioned(
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
          )
        : Container();
  }

  _showToast(BuildContext context, String text) {
    ShowToastWidget(
      buildContext: context,
      text: text,
    );
  }

}

typedef EditProfileFormFieldWidgetListener = Function(Map<String, dynamic> map);
class EditProfileFormFieldWidget extends StatelessWidget {
  final String labelText;
  final String initialValue; 
  final String mapKey; 
  final TextInputType keyboardType;
  final int maxLines;
  final bool readOnly;
  final bool enabled;
  final EditProfileFormFieldWidgetListener listener;
  
  const EditProfileFormFieldWidget({
    Key? key,
    required this.labelText,
    required this.initialValue,
    required this.mapKey,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled = false,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString(labelText),
        initialValue: initialValue,
        enabled: enabled,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onSaved: (String? value) {
          listener({mapKey : value ?? ""});
        },
      ),
    );
  }
}



