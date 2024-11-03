import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/widgets/add_property_widgets/gdpr_agreement_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_link_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';

class PropertyGDPRAgreementPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PropertyGDPRAgreementPageState();
  final GlobalKey<FormState>? formKey;
  final bool isPropertyForUpdate;

  PropertyGDPRAgreementPage({
    this.formKey,
    this.isPropertyForUpdate = false
  });

}

class PropertyGDPRAgreementPageState extends State<PropertyGDPRAgreementPage> {

  bool isAgree = false;
  final gdprAgreementTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (ADD_PROP_GDPR_ENABLED == "0" || widget.isPropertyForUpdate) {
      isAgree = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            CardWidget(
              color: AppThemePreferences().appTheme.backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gDPRAgreementTextWidget(),
                  GDPRAgreementWidget(
                    isAgree: isAgree,
                    listener: (isAgreed) {
                      if(mounted) setState(() {
                        isAgree = isAgreed;
                      });
                    },
                  ),
                  // gdprAgreementLink(),
                ],
              ),
              // child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     gDPRAgreementTextWidget(),
              //     gdprAgreementCheckBoxWidget(),
              //     // gdprAgreementLink(),
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gDPRAgreementTextWidget() {
    return HeaderWidget(
      text: UtilityMethods.getLocalizedString("gdpr_agreement")+" *",
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
    );
  }

  Widget gdprAgreementCheckBoxWidget(){
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: FormField<bool>(
        builder: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isAgree,
                    activeColor: AppThemePreferences().appTheme.primaryColor,
                    onChanged: (val) {
                      setState(() {
                        isAgree = val!;
                        state.didChange(val);
                      });
                    },
                  ),
                  Expanded(
                    child: GenericLinkWidget(
                      preLinkText: UtilityMethods.getLocalizedString("i_consent_to_having_this_website_to_store_my_submitted_information_read_more_information"),
                      linkText: UtilityMethods.getLocalizedString("gdpr_agreement"),
                      onLinkPressed: (){
                        UtilityMethods.navigateToRoute(context: context,
                            builder: (context) => WebPage(WORDPRESS_URL_GDPR_AGREEMENT, UtilityMethods.getLocalizedString("gdpr_agreement")));
                      }
                    ),
                  ),
                ],
              ),
              state.errorText != null ? Padding(
                padding: const EdgeInsets.only(top: 10,left: 20.0),
                child: GenericTextWidget(
                  state.errorText!,
                  style: TextStyle(
                    color: AppThemePreferences.errorColor,
                  ),
                ),
              ) : Container(),
            ],
          );
        },
        validator: (value) {
          if (!isAgree) {
            return UtilityMethods.getLocalizedString("please_accept_the_gdpr_agreement");
          }
          return null;
        },
      ),
    );
  }
}