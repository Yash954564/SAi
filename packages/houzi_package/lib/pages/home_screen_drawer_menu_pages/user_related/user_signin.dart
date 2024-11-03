import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/phone_sign_in_widgets/user_get_phone_number.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_forget_password.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signup.dart';
import 'package:houzi_package/pages/main_screen_pages/my_home_page.dart';
import 'package:houzi_package/push_notif/one_singal_config.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_link_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:houzi_package/widgets/user_sign_in_widgets/social_sign_on_widgets.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';

typedef UserSignInPageListener = void Function(String closeOption);

class UserSignIn extends StatefulWidget {
  final bool fromBottomNavigator;
  final UserSignInPageListener userSignInPageListener;

  UserSignIn(this.userSignInPageListener, {this.fromBottomNavigator = false});

  @override
  State<StatefulWidget> createState() => UserSignInState();
}

class UserSignInState extends State<UserSignIn> with ValidationMixin {
  bool obscure = true;
  bool _isLoggedIn = false;
  bool _showWaitingWidget = false;
  bool isInternetConnected = true;

  String password = '';
  String username = '';
  String usernameEmail = '';

  final formKey = GlobalKey<FormState>();

  final PropertyBloc _propertyBloc = PropertyBloc();

  final TextEditingController controller = TextEditingController();

  String nonce = "";

  String _dummyDomain = "subdomain.domain.com";

  bool isiOSConditionsFulfilled = false;

  @override
  void initState() {
    super.initState();
    isiOSSignInAvailable();

    if (WORDPRESS_URL_DOMAIN != _dummyDomain) {
      fetchNonce();
    }
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchSignInNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  isiOSSignInAvailable() async {
    bool isAvailable = await SignInWithApple.isAvailable();
    if (Platform.isIOS && SHOW_LOGIN_WITH_APPLE && isAvailable) {
      isiOSConditionsFulfilled = true;
      setState(() {});
    }
  }

  void onBackPressed() {
    widget.userSignInPageListener(CLOSE);
  }

  @override
  Widget build(BuildContext context) {
    if (nonce.isEmpty && WORDPRESS_URL_DOMAIN != _dummyDomain) {
      fetchNonce();
    }
    return WillPopScope(
      onWillPop: () {
        widget.userSignInPageListener(CLOSE);
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBarWidget(
            onBackPressed: onBackPressed,
            automaticallyImplyLeading:
                widget.fromBottomNavigator ? false : true,
            appBarTitle: UtilityMethods.getLocalizedString("login"),
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
                        : const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: AutofillGroup(
                      child: Column(
                        children: [
                          addEmail(),
                          addPassword(),
                          buttonSignInWidget(),
                          DoNotHaveAnAccountTextWidget(),
                          ForgotPasswordTextWidget(),
                          SocialSignOnButtonsWidget(
                            onAppleButtonPressed: _signInWithApple,
                            onFaceBookButtonPressed: _facebookSignOnMethod,
                            onGoogleButtonPressed: _googleSignOnMethod,
                            onPhoneButtonPressed: navigateToPhoneNumberScreen,
                            isiOSConditionsFulfilled: isiOSConditionsFulfilled,
                          ),
                        ],
                      ),
                    ),
                  ),
                  LoginWaitingWidget(showWidget: _showWaitingWidget),
                  LoginBottomActionBarWidget(
                      internetConnection: isInternetConnected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  navigateToPhoneNumberScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPhoneNumberPage(),
      ),
    );
  }

  Widget addEmail() {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 15),
      labelText: UtilityMethods.getLocalizedString("user_name_email"),
      hintText: UtilityMethods.getLocalizedString(
          "enter_the_email_address_or_user_name"),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return UtilityMethods.getLocalizedString(
              "this_field_cannot_be_empty");
        }
        return null;
      },
      autofillHints: const [AutofillHints.username],
      onSaved: (String? value) {
        if (mounted)
          setState(() {
            usernameEmail = value!;
          });
      },
    );
  }

  Widget addPassword() {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 15),
      labelText: UtilityMethods.getLocalizedString("password"),
      hintText: UtilityMethods.getLocalizedString("enter_your_password"),
      obscureText: obscure,
      validator: (value) => validatePassword(value),
      suffixIcon: GestureDetector(
        onTap: () {
          if (mounted)
            setState(() {
              obscure = !obscure;
            });
        },
        child: Icon(
          obscure
              ? AppThemePreferences.visibilityIcon
              : AppThemePreferences.invisibilityIcon,
        ),
      ),
      autofillHints: const [AutofillHints.password],
      onSaved: (String? value) {
        if (mounted)
          setState(() {
            password = value!;
          });
      },
    );
  }

  Widget buttonSignInWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: ButtonWidget(
          text: UtilityMethods.getLocalizedString("login"),
          onPressed: () {
            TextInput.finishAutofillContext();
            if (HooksConfigurations.userLoginActionHook != null) {
              HooksConfigurations.userLoginActionHook(
                context: context,
                formKey: formKey,
                usernameEmail: usernameEmail,
                password: password,
                loginNonce: nonce,
                defaultLoginFunc: () => onSignInPressed(),
              );
            } else {
              onSignInPressed();
            }
          }),
    );
  }

  Future<void> onSignInPressed() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (formKey.currentState!.validate()) {
      setState(() {
        _showWaitingWidget = true;
      });
      formKey.currentState!.save();

      Map<String, String> userInfo = {
        USER_NAME: usernameEmail,
        PASSWORD: password,
        API_NONCE: nonce
      };

      final response = await _propertyBloc.fetchLoginResponse(userInfo);

      if (response == null || response.statusCode == null) {
        if (mounted) {
          setState(() {
            isInternetConnected = false;
            _showWaitingWidget = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isInternetConnected = true;
            _showWaitingWidget = false;
          });
        }
      }

      bool canLogin = false;
      if (response.toString().contains("token")) {
        canLogin = true;
      }

      if (response.statusCode != 200) {
        if (response.statusCode == 403 && response.data is Map) {
          Map? map = response.data;

          if (map != null &&
              map.containsKey("reason") &&
              map["reason"] != null) {
            _showToast(context, UtilityMethods.cleanContent(map["reason"]));
            return;
          }
          if (map != null &&
              map.containsKey("message") &&
              map["message"] != null) {
            _showToast(context, UtilityMethods.cleanContent(map["message"]));
            return;
          }
          if (map != null && map.containsKey("code") && map["code"] != null) {
            String code = map["code"];
            if (code.contains("incorrect_password")) {
              _showToast(context,
                  UtilityMethods.getLocalizedString("user_login_failed"));
              return;
            }
          }
          _showToast(
              context, UtilityMethods.getLocalizedString("user_login_failed"));
        } else {
          _showToast(
              context,
              "(${response.statusCode}) " +
                  UtilityMethods.getLocalizedString("user_login_failed"));
        }
      } else if (response.statusCode == 200 && canLogin) {
        if (mounted) {
          setState(() {
            _isLoggedIn = true;
          });
        }
        _showToastForUserLogin(context);
        HiveStorageManager.storeUserLoginInfoData(response.data);
        Map<String, dynamic> userInfo = {
          USER_NAME: usernameEmail,
          PASSWORD: password,
          API_NONCE: nonce
        };
        HiveStorageManager.storeUserCredentials(userInfo);

        GeneralNotifier().publishChange(GeneralNotifier.USER_LOGGED_IN);

        Provider.of<UserLoggedProvider>(context, listen: false).loggedIn();

        // print("userData ${response.data.toString()}");

        String? userEmail = response.data["user_email"];

        oneSignalLoginFunc(userEmail);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MyHomePage()),
            (Route<dynamic> route) => false);
      } else {
        _showToast(
            context, UtilityMethods.cleanContent(response.data["message"]));
      }

      if (mounted) {
        setState(() {
          _showWaitingWidget = false;
        });
      }
    }
  }

  void oneSignalLoginFunc(String? email) {
    if (email != null && email.isNotEmpty) {
      OneSignalConfig.loginOneSignal(externalUserId: email);
    }
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(buildContext: context, text: msg);
  }

  _showToastForUserLogin(BuildContext context) {
    String text = _isLoggedIn == true
        ? UtilityMethods.getLocalizedString("user_Login_successfully")
        : UtilityMethods.getLocalizedString("user_login_failed");

    ShowToastWidget(
      buildContext: context,
      text: text,
    );
  }

  Future<void> _googleSignOnMethod() async {
    try {
      if (mounted)
        setState(() {
          _showWaitingWidget = true;
        });
      GoogleSignIn _googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        if (mounted)
          setState(() {
            _showWaitingWidget = false;
          });
        //_showToast(context, "CANCELLED_SIGN_IN");
        return Future.error("CANCELLED_SIGN_IN");
      }

      //GoogleSignInAuthentication googleAuth = await googleUser?.authentication;
      //String token = googleAuth?.idToken;

      Map<String, dynamic> userInfo = {
        USER_SOCIAL_EMAIL: googleUser.email,
        USER_SOCIAL_ID: googleUser.id,
        USER_SOCIAL_PLATFORM: SOCIAL_PLATFORM_GOOGLE,
        USER_SOCIAL_DISPLAY_NAME: googleUser.displayName,
        USER_SOCIAL_PROFILE_URL: googleUser.photoUrl ?? ""
      };

      _signOnMethod(userInfo);
    } catch (error) {
      if (mounted)
        setState(() {
          _showWaitingWidget = false;
        });
      // print ("Google Sign-in Error: $error");
      _showToast(context, UtilityMethods.getLocalizedString("error_occurred"));
      // switch (error.code.toString()) {
      //   case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
      //     _showToast(context, "Account already exists with a different credential.");
      //     break;
      //   case "ERROR_INVALID_CREDENTIAL":
      //     _showToast(context, "Invalid credential.");
      //     break;
      //   case "ERROR_INVALID_EMAIL":
      //     _showToast(context, "Your email address appears to be malformed.");
      //     break;
      //   case "ERROR_WRONG_PASSWORD":
      //     _showToast(context, "Your password is wrong.");
      //     break;
      //   case "ERROR_USER_NOT_FOUND":
      //     _showToast(context, "User with this email doesn't exist.");
      //     break;
      //   case "ERROR_USER_DISABLED":
      //     _showToast(context, "User with this email has been disabled.");
      //     break;
      //   case "ERROR_TOO_MANY_REQUESTS":
      //     _showToast(context, "Too many requests. Try again later.");
      //     break;
      //   case "ERROR_OPERATION_NOT_ALLOWED":
      //     _showToast(context, "Signing in with Email and Password is not enabled.");
      //     break;
      //   default:
      //
      // }
    }
  }

  Future<void> _facebookSignOnMethod() async {
    if (mounted)
      setState(() {
        _showWaitingWidget = true;
      });
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
      loginBehavior: LoginBehavior.nativeWithFallback,
    );
    if (result.status == LoginStatus.success) {
      //final AccessToken accessToken = result.accessToken;

      final userData = await FacebookAuth.instance.getUserData();

      Map<String, dynamic> userInfo = {
        USER_SOCIAL_EMAIL: userData["email"],
        USER_SOCIAL_ID: userData["id"],
        USER_SOCIAL_PLATFORM: SOCIAL_PLATFORM_FACEBOOK,
        USER_SOCIAL_DISPLAY_NAME: userData["name"],
        USER_SOCIAL_PROFILE_URL: userData["picture"]["data"]["url"] ?? "",
      };

      _signOnMethod(userInfo);
    } else {
      if (mounted)
        setState(() {
          _showWaitingWidget = false;
        });
      if (kDebugMode) {
        print(result.status);
        print(result.message);
      }
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _signInWithApple() async {
    if (mounted) {
      setState(() {
        _showWaitingWidget = true;
      });
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
          clientId: APPLE_SIGN_ON_CLIENT_ID,
          redirectUri: Uri.parse(APPLE_SIGN_ON_REDIRECT_URI),
        ),
        nonce: nonce,
      );
      //print("Apple[Credentials]: $appleCredential");
      if (appleCredential.userIdentifier != null &&
          appleCredential.userIdentifier!.isNotEmpty) {
        Map<String, dynamic> userInfo = {
          USER_SOCIAL_EMAIL: appleCredential.email ?? "",
          USER_SOCIAL_ID: appleCredential.userIdentifier,
          USER_SOCIAL_PLATFORM: SOCIAL_PLATFORM_APPLE,
          USER_SOCIAL_DISPLAY_NAME: appleCredential.givenName ?? "",
          USER_SOCIAL_PROFILE_URL: "",
        };

        _signOnMethod(userInfo);
      } else {
        if (mounted) {
          setState(() {
            _showWaitingWidget = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _showWaitingWidget = false;
        });
      }
      // _showToast(context, UtilityMethods.getLocalizedString("error_occurred"));
      // _showToast(context, e.toString());
    }
  }

  Future<void> _signOnMethod(Map<String, dynamic> userInfo) async {
    if (kDebugMode) {
      print("info $userInfo");
    }
    userInfo[API_NONCE] = nonce;
    final response = await _propertyBloc.fetchSocialSignOnResponse(userInfo);
    //print("response $response");
    if (response == null || response.statusCode == null) {
      if (mounted) {
        if (mounted) {
          setState(() {
            isInternetConnected = false;
            _showWaitingWidget = false;
          });
        }
      }
    } else {
      if (mounted) {
        if (mounted) {
          setState(() {
            isInternetConnected = true;
            _showWaitingWidget = false;
          });
        }
      }
    }

    if (response == null || response.statusCode != 200) {
      if (response.statusCode == 403 && response.data is Map) {
        Map responseMap = response.data;

        if (responseMap != null &&
            responseMap.containsKey("reason") &&
            responseMap["reason"] != null) {
          _showToast(context, responseMap["reason"]);
        }
      } else {
        _showToast(context, response.toString());
      }
    } else if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          _isLoggedIn = true;
        });
      }
      _showToast(context,
          UtilityMethods.getLocalizedString("user_Login_successfully"));
      // _showToastForUserLogin(context);
      Map loggedInUserData = response.data;
      HiveStorageManager.storeUserLoginInfoData(loggedInUserData);
      HiveStorageManager.storeUserCredentials(userInfo);

      Provider.of<UserLoggedProvider>(context, listen: false).loggedIn();

      GeneralNotifier().publishChange(GeneralNotifier.USER_LOGGED_IN);

      String? userEmail = response.data["user_email"];
      oneSignalLoginFunc(userEmail);

      UtilityMethods.navigateToRouteByPushAndRemoveUntil(
          context: context, builder: (context) => MyHomePage());
    }
  }
}

class DoNotHaveAnAccountTextWidget extends StatelessWidget {
  const DoNotHaveAnAccountTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: GenericLinkWidget(
        preLinkText:
            UtilityMethods.getLocalizedString("do_not_have_an_account"),
        linkText: UtilityMethods.getLocalizedString("sign_up_capital"),
        onLinkPressed: () {
          Route route = MaterialPageRoute(builder: (context) => UserSignUp());
          Navigator.pushReplacement(context, route);
        },
      ),
    );
  }
}

class ForgotPasswordTextWidget extends StatelessWidget {
  const ForgotPasswordTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: GenericLinkWidget(
        linkText: UtilityMethods.getLocalizedString(
            "forgot_password_with_question_mark"),
        onLinkPressed: () {
          UtilityMethods.navigateToRoute(
            context: context,
            builder: (context) => UserForgetPassword(),
          );
        },
      ),
    );
  }
}

class LoginWaitingWidget extends StatelessWidget {
  final bool showWidget;

  const LoginWaitingWidget({
    Key? key,
    required this.showWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showWidget) {
      return Positioned(
        left: 0,
        right: 0,
        top: 90,
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

class LoginBottomActionBarWidget extends StatelessWidget {
  final bool internetConnection;

  const LoginBottomActionBarWidget({
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
            if (!internetConnection)
              const NoInternetBottomActionBarWidget(showRetryButton: false),
          ],
        ),
      ),
    );
  }
}
