import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/bloc/api_providers/houzez_api_provider.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/main_screen_pages/my_home_page.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_settings_row_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

typedef DemoConfigWidgetListener = Function(bool showLoadingWidget);

class DemoConfigWidget extends StatefulWidget {
  final DemoConfigWidgetListener? listener;

  const DemoConfigWidget({
    Key? key,
    this.listener,
  }) : super(key: key);

  @override
  State<DemoConfigWidget> createState() => _DemoConfigWidgetState();
}

class _DemoConfigWidgetState extends State<DemoConfigWidget> {

  String _wordpressUrl = '';
  String _wordpressUrlAuthority = '';

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return !SHOW_DEMO_CONFIGURATIONS
        ? Container()
        : GenericSettingsWidget(
            headingText: UtilityMethods.getLocalizedString("demo_configuration"),
            headingSubTitleText: UtilityMethods.getLocalizedString("enter_your_own_wordpress"),
            body: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextFormFieldWidget(
                additionalHintText: UtilityMethods.getLocalizedString("web_example"),
                ignorePadding: true,
                readOnly: true,
                hintText: UtilityMethods.getLocalizedString("enter_your_wordpress_url"),
                suffixIcon: Icon(
                  AppThemePreferences.linkIcon,
                  color: AppThemePreferences().appTheme.hintColor,
                ),
                onTap: () {
                  ShowEnterUrlDialog(context);
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
    );
  }


  Future ShowEnterUrlDialog(BuildContext context){
    return ShowDialogBoxWidget(
      context,
      title: UtilityMethods.getLocalizedString("enter_your_wordpress_url"),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      content: Form(
        key: formKey,
        child: TextFormField(
          textInputAction: TextInputAction.search,
          validator: (value){
            if(!value!.contains(HTTP) && !value.contains(HTTPS)){
              return UtilityMethods.getLocalizedString("please_enter_a_complete_url");
            }
            return null;
          },
          onSaved: (value){
            if(mounted) setState(() {
              _wordpressUrl = value!;
            });
          },
          onFieldSubmitted: (value){
            if(mounted) setState(() {
              _wordpressUrl = value;
            });
          },
          decoration: InputDecoration(
            hintText: DEMO_URL,
            // hintText: HiveStorageManager.readUrl() ?? DEMO_URL,
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(24.0),),
              borderSide: BorderSide(color: Theme.of(context).primaryColor,),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(24.0),),
              borderSide: BorderSide(color: Colors.grey.shade300,),
            ),
            contentPadding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          ),

          keyboardType: TextInputType.url,
        ),
      ),
      actions: <Widget>[
        DialogButtonWidget(
          label: UtilityMethods.getLocalizedString("reset"),
          labelStyle: TextStyle(color: AppThemePreferences.errorColor),
          onPressed: ()=> onResetButtonPressed(),
        ),
        DialogButtonWidget(
          label: UtilityMethods.getLocalizedString("cancel"),
          onPressed: () => Navigator.of(context).pop(),
          padding: const EdgeInsets.only(left: 10),
        ),
        DialogButtonWidget(
          label: UtilityMethods.getLocalizedString("save"),
          onPressed: () => onSavedButtonPressed(),
          padding: const EdgeInsets.only(left: 10),
        ),
      ],
    );
  }

  onResetButtonPressed(){
    //Need to remove login data, because new website cannot work with previous webiste token.
    HiveStorageManager.deleteUserLoginInfoData();
    HiveStorageManager.deleteAllData();
    String communicationProtocol = '';
    _wordpressUrl = DEMO_URL;
    _wordpressUrlAuthority = WORDPRESS_URL_DOMAIN;
    communicationProtocol = HTTP;
    HiveStorageManager.storeUrl(url: _wordpressUrl);
    HiveStorageManager.storeUrlAuthority(authority: _wordpressUrlAuthority);
    HiveStorageManager.storeCommunicationProtocol(protocol: communicationProtocol);
    UtilityMethods.navigateToRouteByPushAndRemoveUntil(context: context, builder: (context) => const MyHomePage());
  }
  
  onSavedButtonPressed() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();

      widget.listener!(true);

      String communicationProtocol = '';
      if(_wordpressUrl.contains('http://')){
        communicationProtocol = 'http';
      }else if(_wordpressUrl.contains('https://')){
        communicationProtocol = 'https';
      }

      String temp = _wordpressUrl.split('//')[1];
      _wordpressUrlAuthority = temp;

      if(_wordpressUrlAuthority.contains('/')){
        temp = _wordpressUrlAuthority.split('/')[0];
        _wordpressUrlAuthority = temp;
      }


      // WORDPRESS_URL_DOMAIN = _wordpressUrlAuthority;

      Dio dio = Dio();
      var queryParameters = {
        'app_version':"${1}",
      };
      try{
        Uri? uri;

        if(communicationProtocol == HTTP){
          uri = Uri.http(_wordpressUrlAuthority, HOUZEZ_META_DATA_PATH, queryParameters);
        }else if(communicationProtocol == HTTPS){
          uri = Uri.https(_wordpressUrlAuthority, HOUZEZ_META_DATA_PATH, queryParameters);
        }

        var response = await dio.getUri(uri!);
        if(response.statusCode == 200){

          widget.listener!(false);

          //Need to remove login data, because new website cannot work with previous webiste token.
          HiveStorageManager.deleteUserLoginInfoData();
          HiveStorageManager.deleteAllData();
          HiveStorageManager.storeUrl(url: _wordpressUrl);
          HiveStorageManager.storeUrlAuthority(authority: _wordpressUrlAuthority);
          HiveStorageManager.storeCommunicationProtocol(protocol: communicationProtocol);
          UtilityMethods.navigateToRouteByPushAndRemoveUntil(context: context, builder: (context) => const MyHomePage());
          // GenericMethods.navigateToRouteByPushAndRemoveUntil(context: context, builder: (context) => MyApp());
        }else{
          widget.listener!(false);
          responseErrorDialog(context);
        }
      }on DioError catch (e) {
        widget.listener!(false);
        Navigator.of(context).pop();
        responseErrorDialog(context);
        print("Demo Config Property Meta: ${e.response!.statusCode!}");
        print("Demo Config Property Meta: ${e.message}");
      }
    }
  }

  Future responseErrorDialog(BuildContext context){
    return ShowDialogBoxWidget(
      context,
      title: UtilityMethods.getLocalizedString("this_app_requires_plugin"),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
      actions: <Widget>[
        TextButtonWidget(
          onPressed: () => launchUrl(Uri.parse(HOUZI_URL_PLUG_IN)),
          child: GenericTextWidget(UtilityMethods.getLocalizedString("plug_in_text")),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: TextButtonWidget(
            onPressed: () => Navigator.of(context).pop(),
            child: GenericTextWidget(UtilityMethods.getLocalizedString("ok")),
          ),
        ),
      ],
    );
  }
}

class DialogButtonWidget extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;

  const DialogButtonWidget({
    Key? key,
    required this.label,
    this.labelStyle,
    this.onPressed,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: TextButtonWidget(
        onPressed: onPressed,
        child: GenericTextWidget(
          label,
          style: labelStyle,
        ),
      ),
    );
  }
}

