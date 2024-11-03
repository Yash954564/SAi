import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/user_profile_related/user_avatar_widget.dart';
import 'package:houzi_package/widgets/user_profile_related/user_name_widget.dart';
import 'package:houzi_package/widgets/user_profile_related/user_related_actions_widget.dart';
import 'package:provider/provider.dart';

typedef UserProfilePageListener = void Function(String closeOption);

class UserProfile extends StatefulWidget {
  final UserProfilePageListener? userProfilePageListener;
  final bool fromBottomNavigator;

  UserProfile({
    this.userProfilePageListener,
    this.fromBottomNavigator = false,
  });

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String userRole = "";
  String userEmail = "";
  String userName = "";
  String userAvatar = "";
  String appVersion = "";
  String appName = "";
  String paymentStatus = "";

  bool isLoggedIn = false;

  VoidCallback? generalNotifierLister;

  ProfileHook? profileHook = HooksConfigurations.profileItem;

  @override
  void initState() {

    userRole = HiveStorageManager.getUserRole() ?? "";
    userEmail = HiveStorageManager.getUserEmail() ?? "";
    userName = HiveStorageManager.getUserName() ?? "";
    userAvatar = HiveStorageManager.getUserAvatar() ?? "";
    appVersion = HiveStorageManager.readAppInfo()[APP_INFO_APP_VERSION] ?? "";
    appName = HiveStorageManager.readAppInfo()[APP_INFO_APP_NAME] ?? "";
    paymentStatus = HiveStorageManager.readUserPaymentStatus()["enable_paid_submission"] ?? "";

    generalNotifierLister = () {
      if (GeneralNotifier().change == GeneralNotifier.USER_PROFILE_UPDATE) {
        setState(() {
          userRole = UtilityMethods.chkRoleValueAndConvertToOption(HiveStorageManager.getUserRole()) ?? "";
          userEmail = HiveStorageManager.getUserEmail() ?? "";
          userName = HiveStorageManager.getUserName() ?? "";
          userAvatar = HiveStorageManager.getUserAvatar() ?? "";
        });
      }
      if (GeneralNotifier().change == GeneralNotifier.APP_CONFIGURATIONS_UPDATED) {

        if(mounted) {
          setState(() {});
        }
      }
      if (GeneralNotifier().change == GeneralNotifier.USER_PAYMENT_STATUS_UPDATED) {
        if(mounted) {
          setState(() {
            paymentStatus = HiveStorageManager.readUserPaymentStatus()[enablePaidSubmissionKey] ?? "";
          });
        }
      }
    };

    GeneralNotifier().addListener(generalNotifierLister!);
    super.initState();
  }


  @override
  void dispose() {

    if (generalNotifierLister != null) {
      GeneralNotifier().removeListener(generalNotifierLister!);
    }
    super.dispose();
  }

  void onBackPressed() {
    widget.userProfilePageListener!(CLOSE);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        widget.userProfilePageListener!(CLOSE);
        return Future.value(false);
      },
      child: Consumer<UserLoggedProvider>(
        builder: (context, login, child) {
          isLoggedIn = login.isLoggedIn ?? false;
          return Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            appBar: AppBarWidget(
              onBackPressed: onBackPressed,
              automaticallyImplyLeading: widget.fromBottomNavigator ? false : true,
              appBarTitle: UtilityMethods.getLocalizedString("user_profile"),
            ),
            body: SafeArea(
              bottom: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: (UtilityMethods.showTabletView)
                      ? const EdgeInsets.fromLTRB(150, 100, 150, 0)
                      : const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UserAvatarWidget(
                        isUserLogged: isLoggedIn,
                        userAvatarUrl: userAvatar,
                      ),
                      UserNameWidget(
                        isUserLogged: isLoggedIn,
                        userName: userName,
                      ),
                      UserRelatedActionsWidget(
                        isUserLogged: isLoggedIn,
                        userRole: userRole,
                        appName: appName,
                        appVersion: appVersion,
                        profileHook: profileHook,
                        paymentStatus: paymentStatus
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}



