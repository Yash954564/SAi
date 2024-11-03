import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/main_screen_pages/my_home_page.dart';
import 'package:houzi_package/push_notif/one_singal_config.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:provider/provider.dart';

import 'package:houzi_package/providers/state_providers/user_log_provider.dart';


class UserDisplayName extends StatefulWidget {
  final String phoneNumber;
  final String uid;
  final String countryDialCode;
   UserDisplayName({required this.phoneNumber, required this.uid, required this.countryDialCode,Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserDisplayNameState();
}

class UserDisplayNameState extends State<UserDisplayName>
    with ValidationMixin {
  final formKey = GlobalKey<FormState>();
  final PropertyBloc _propertyBloc = PropertyBloc();

  String username = '';
  bool _showWaitingWidget = false;
  bool isInternetConnected = true;

  String nonce = "";

  @override
  void initState() {
    super.initState();
    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchSignInNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("name"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: (UtilityMethods.showTabletView)
                          ? const EdgeInsets.only(left: 150.0, top: 100, right: 150)
                          : const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                        children: [
                          textEnterAssociatedEmail(),
                          addEmail(),
                          submitButton(),
                        ],
                      ),
                    ),
                  ],
                ),
                loginWaitingWidget(),
                bottomActionBarWidget(),
              ],
            ),
          ),
        ),
      );
  }

  Widget textEnterAssociatedEmail() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: GenericTextWidget(
        UtilityMethods.getLocalizedString("enter_your_name"),
        style: AppThemePreferences().appTheme.heading02TextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget addEmail() {
    return TextFormFieldWidget(
      ignorePadding: true,
      labelText: UtilityMethods.getLocalizedString(""),
      hintText:  UtilityMethods.getLocalizedString("enter_your_name"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
        }
        return null;
      },
      onSaved: (String? value) {
        username = value!;
      },
    );
  }

  Widget submitButton() {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: ButtonWidget(
        text: UtilityMethods.getLocalizedString("submit"),
        onPressed: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();

            String cc = widget.countryDialCode;
            if (cc.contains("+")) {
              cc = cc.replaceAll("+", "");
            }
            Map<String, dynamic> userInfo = {
              "source": PLATFORM_PHONE,
              "username": cc+widget.phoneNumber,
              "display_name": username,
              "user_id": widget.uid,
            };
            setState(() {
              _showWaitingWidget = true;
            });

            _signOnMethod(userInfo);
          }
        }
      )
    );
  }

  Future<void> _signOnMethod(Map<String, dynamic> userInfo) async {
    if (kDebugMode) {
      print("info $userInfo");
    }
    userInfo[API_NONCE] = nonce;
    final response = await _propertyBloc.fetchSocialSignOnResponse(userInfo);
    //print("response $response");
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
    }

    if (response == null || response.statusCode != 200) {
      if (response.statusCode == 403 && response.data is Map) {
        Map? map = response.data;

        if (map != null && map.containsKey("reason") &&
            map["reason"] != null) {
          _showToast(context, map["reason"]);
        }
      } else {
        _showToast(context, response.toString());
      }
    } else if (response.statusCode == 200) {

      _showToast(context,UtilityMethods.getLocalizedString("user_Login_successfully"));
      // _showToastForUserLogin(context);
      Map loggedInUserData = response.data;
      HiveStorageManager.storeUserLoginInfoData(loggedInUserData);
      HiveStorageManager.storeUserCredentials(userInfo);

      Provider.of<UserLoggedProvider>(context,listen: false).loggedIn();

      GeneralNotifier().publishChange(GeneralNotifier.USER_LOGGED_IN);

      OneSignalConfig.oneSignalLoginFunc(response.data);

      UtilityMethods.navigateToRouteByPushAndRemoveUntil(context: context, builder: (context) => MyHomePage());
    }
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  Widget bottomActionBarWidget() {
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

  Widget loginWaitingWidget() {
    return _showWaitingWidget == true
        ? Positioned(
            left: 0,
            right: 0,
            top: 90,
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
          )
        : Container();
  }
}
