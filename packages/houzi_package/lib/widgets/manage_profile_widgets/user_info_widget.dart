import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

typedef UserInfoWidgetListener = Function({
bool? showWaitingWidgetForPicUpload,
bool? showUploadPhotoButton,
bool? isInternetConnected,
});

class UserInfoWidget extends StatelessWidget {
  final String userName;
  final String userEmail;
  final bool showUploadPhotoButton;
  final UserInfoWidgetListener listener;
  final File? imageFile;

  const UserInfoWidget({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.showUploadPhotoButton,
    required this.listener,
    required this.imageFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          UpdateProfileImageButtonWidget(
            imageFile: imageFile,
            showUploadPhotoButton: showUploadPhotoButton,
            listener: listener,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                GenericTextWidget(
                  userName,
                  style: AppThemePreferences().appTheme.heading01TextStyle,
                ),
                Divider(thickness: 0,color: AppThemePreferences.homeScreenDrawerTextColorDark,),
                GenericTextWidget(
                  userEmail,
                  style: AppThemePreferences().appTheme.heading01TextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: AppThemePreferences.dividerDecoration(),
    );
  }
}

typedef UpdateProfileImageButtonWidgetListener = Function({
bool? showWaitingWidgetForPicUpload,
bool? showUploadPhotoButton,
bool? isInternetConnected,
});

class UpdateProfileImageButtonWidget extends StatefulWidget {
  final bool showUploadPhotoButton;
  final File? imageFile;
  final UpdateProfileImageButtonWidgetListener listener;


  UpdateProfileImageButtonWidget({
    Key? key,
    required this.showUploadPhotoButton,
    this.imageFile,
    required this.listener,
  }) : super(key: key);

  @override
  State<UpdateProfileImageButtonWidget> createState() => _UpdateProfileImageButtonWidgetState();
}

class _UpdateProfileImageButtonWidgetState extends State<UpdateProfileImageButtonWidget> {
  final PropertyBloc _propertyBloc = PropertyBloc();

  String nonce = "";

  @override
  void initState() {
    super.initState();
    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchUpdateProfileImageNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showUploadPhotoButton) {
      return ButtonWidget(
        text: UtilityMethods.getLocalizedString("upload_photo"),
        onPressed: () {
          widget.listener(showWaitingWidgetForPicUpload: true);
          uploadPhoto(context);
        },
      );
    }

    return Container();
  }

  Future<void> uploadPhoto(BuildContext context) async {
    Map<String, dynamic> userInfo = {
      "imagepath": widget.imageFile!.path,
    };

    final response = await _propertyBloc.fetchUpdateUserProfileImageResponse(userInfo, nonce);

    if(response == null || response.statusCode == null){
      widget.listener(
        showWaitingWidgetForPicUpload: false,
        isInternetConnected: false,
        showUploadPhotoButton: false,
      );
    }else{
      widget.listener(
        isInternetConnected: true,
        showUploadPhotoButton: false,
      );
      String tempResponseString = response.toString().split("{")[1];
      Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");
      if (response.statusCode == 200) {
        if (map["success"] == true) {
          final url = map["url"];
          HiveStorageManager.setUserAvatar(url);
          //profile = url;
          widget.listener(showUploadPhotoButton: false);
          GeneralNotifier().publishChange(GeneralNotifier.USER_PROFILE_UPDATE);

          widget.listener(showWaitingWidgetForPicUpload: false);
        }
        ShowToastWidget(
            buildContext: context,
            text: UtilityMethods.getLocalizedString("profile_updated_successfully"),
        );
      } else {
        widget.listener(showWaitingWidgetForPicUpload: false);
        ShowToastWidget(
            buildContext: context,
            text: map["message"] ?? map["reason"] ?? UtilityMethods.getLocalizedString("error_occurred"),
        );
      }

    }
  }
}

