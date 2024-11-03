import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/change_password_page.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/edit_pofile.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/manage_profile_widgets/bottom_action_widget.dart';
import 'package:houzi_package/widgets/manage_profile_widgets/delete_account_widget.dart';
import 'package:houzi_package/widgets/manage_profile_widgets/user_image_widget.dart';
import 'package:houzi_package/widgets/manage_profile_widgets/user_info_widget.dart';
import 'package:houzi_package/widgets/manage_profile_widgets/waiting_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:image_picker/image_picker.dart';

import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_settings_row_widget.dart';
import 'package:houzi_package/pages/main_screen_pages/my_home_page.dart';

class ManageProfile extends StatefulWidget {

  @override
  _ManageProfileState createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> with ValidationMixin {

  File? imageFile;

  final picker = ImagePicker();

  bool _isInternetConnected = true;
  bool _showWaitingWidget = false;
  bool _showWaitingWidgetForPicUpload = false;
  bool _showUploadPhotoButton = false;

  String userRole = "";
  String userEmail = "";
  String userName = "";
  String userAvatar = "";

  VoidCallback? generalNotifierLister;

  final PropertyBloc _propertyBloc = PropertyBloc();

  @override
  void initState() {
    super.initState();
    fetchUserData();
    generalNotifierLister = () {
      if (GeneralNotifier().change == GeneralNotifier.USER_PROFILE_UPDATE) {
        fetchUserData();
      }
    };

    GeneralNotifier().addListener(generalNotifierLister!);
  }

  fetchUserData(){
    if(mounted) setState(() {
      userEmail = HiveStorageManager.getUserEmail() ?? "";
      userName = HiveStorageManager.getUserName() ?? "";
      userAvatar = HiveStorageManager.getUserAvatar() ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("manage_profile"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ManageProfileUserImageWidget(
                        userAvatar: userAvatar,
                        showWaitingWidgetForPicUpload: _showWaitingWidgetForPicUpload,
                        listener: (bool showUploadPhotoButton, File? imgFile){
                          if(mounted) setState(() {
                            _showUploadPhotoButton = true;
                            imageFile = imgFile;
                          });
                        },
                      ),
                      UserInfoWidget(
                        userName: userName,
                        userEmail: userEmail,
                        imageFile: imageFile,
                        showUploadPhotoButton: _showUploadPhotoButton,
                        listener: ({isInternetConnected, showUploadPhotoButton, showWaitingWidgetForPicUpload}) {
                          if(mounted){
                            setState(() {
                              if(isInternetConnected != null){
                                _isInternetConnected = isInternetConnected;
                              }
                              if(showUploadPhotoButton != null){
                                _showUploadPhotoButton = showUploadPhotoButton;
                              }
                              if(showWaitingWidgetForPicUpload != null){
                                _showWaitingWidgetForPicUpload = showWaitingWidgetForPicUpload;
                              }
                            });
                          }
                        },
                      ),
                      GenericWidgetRow(
                        iconData: AppThemePreferences.editIcon,
                        text: UtilityMethods.getLocalizedString("edit_profile"),
                        onTap: onEditProfileTap,
                      ),
                      GenericWidgetRow(
                        iconData: AppThemePreferences.changePassword,
                        text: UtilityMethods.getLocalizedString("change_password"),
                        onTap: onChangePasswordTap,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: DeleteAccountButtonWidget(onPressed: onPositiveButtonPressed),
                ),
              ),
              WaitingWidget(showWaitingWidget: _showWaitingWidget),
              BottomActionBarWidget(isInternetConnected: _isInternetConnected),
            ],
          ),
        ),
      ),
    );
  }

  navigateToRoute(WidgetBuilder builder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: builder,
      ),
    );
  }

  void onChangePasswordTap() {
    navigateToRoute((context) => const ChangePassword());
  }

  void onEditProfileTap() {
    navigateToRoute((context) => EditProfile());
  }

  Future<void> onPositiveButtonPressed() async {
    Navigator.of(context).pop();
    if(mounted) setState(() {
      _showWaitingWidget = true;
    });
    final response = await _propertyBloc.fetchDeleteUserAccountResponse();

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
      String tempResponseString = response.toString().split("{")[1];
      Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");
      if(map["success"] == true){
        UtilityMethods.userLogOut(
          context: context,
          builder: (context) => const MyHomePage(),
        );
      }else{
        ShowToastWidget(
          buildContext: context,
          text: map["msg"],
        );
      }
    }
  }
}