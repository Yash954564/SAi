import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/phone_sign_in_widgets/user_get_name_.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:pinput/pinput.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';


class OTPScreen extends StatefulWidget {
  final String phone;
  final String countryDialCode;
  OTPScreen(this.phone, this.countryDialCode);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode = "";
  final TextEditingController _pinPutController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    decoration: BoxDecoration(
      border: Border.all(color: AppThemePreferences.appPrimaryColor),
      borderRadius: BorderRadius.circular(5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("otp_verification"),
      ),

      body: Padding(
        padding: (UtilityMethods.showTabletView)
            ? const EdgeInsets.fromLTRB(150, 100, 150, 0)
            : const EdgeInsets.all(0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: Center(
                child: GenericTextWidget(
                  '${widget.countryDialCode}${widget.phone}',
                  style: AppThemePreferences().appTheme.heading02TextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,

                controller: _pinPutController,

                pinAnimationType: PinAnimationType.fade,
                onSubmitted: (pin) async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                        verificationId: _verificationCode, smsCode: pin))
                        .then((value) async {
                      if (value.user != null) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => UserDisplayName(
                              phoneNumber: widget.phone,
                              uid: value.user!.uid, countryDialCode: widget.countryDialCode,
                            )),
                                (route) => false);
                      }
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));

                  }
                },
              ),
            ),
            buttonForgotPassword(),
          ],
        ),
      ),
    );
  }

  Widget buttonForgotPassword() {
    return Container(
        padding: const EdgeInsets.only(left: 20,top: 5,right: 20),
        child: ButtonWidget(
            text: UtilityMethods.getLocalizedString("submit"),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signInWithCredential(
                    PhoneAuthProvider.credential(
                        verificationId: _verificationCode, smsCode: _pinPutController.text))
                    .then((value) async {
                  if (value.user != null) {
                    print(value.user!.uid);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserDisplayName(
                                phoneNumber: widget.phone,
                                uid: value.user!.uid,
                                countryDialCode: widget.countryDialCode,
                              )),
                    );
                  }
                });
              }on FirebaseAuthException catch (e){
                String errorMessage = e.message.toString();
                print(errorMessage);
                errorMessage = errorMessage.replaceAll(RegExp('\\[.*?\\]'), '');
                print(errorMessage);
                // _showToast(context,errorMessage);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)));
              }
            })

    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+${widget.countryDialCode}${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("credential.smsCode : ${credential.smsCode}");
          if(credential.verificationId != null){
            await FirebaseAuth.instance.signInWithCredential(
                PhoneAuthProvider.credential(
                    verificationId: credential.verificationId!, smsCode: credential.smsCode!))
                .then((value) async {
              if (value.user != null) {
                print(value.user!.uid);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserDisplayName(
                            phoneNumber: widget.phone,
                            uid: value.user!.uid,
                            countryDialCode: widget.countryDialCode,
                          ),
                  ),
                );
              }
            });
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.code);
          String errorMessage = e.message!;
          print(errorMessage);
          errorMessage = errorMessage.replaceAll(RegExp('\\[.*?\\]'), '');
          print(errorMessage);
          _showToast(context,errorMessage);
        },
        codeSent: (String? verficationID, int? resendToken) {
          if (mounted) {
            setState(() {
              _verificationCode = verficationID!;
            });
          }
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          if (mounted) {
            setState(() {
            _verificationCode = verificationID;
          });
          }
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }
}
