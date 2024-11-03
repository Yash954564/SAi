import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/widgets/generic_link_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';

typedef GDPRAgreementWidgetListener = Function(bool isAgreed);

class GDPRAgreementWidget extends StatelessWidget {
  final bool isAgree;
  final EdgeInsetsGeometry? padding;
  final GDPRAgreementWidgetListener listener;

  const GDPRAgreementWidget({
    Key? key,
    this.isAgree = false,
    this.padding = const EdgeInsets.fromLTRB(10, 20, 10, 10),
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GDPRAgreementBodyWidget(
          bodyPadding: padding,
          isAgree: isAgree,
          listener: listener,
        ),
      ],
    );
  }
}

class GDPRAgreementBodyWidget extends StatefulWidget {
  final bool isAgree;
  final EdgeInsetsGeometry? bodyPadding;
  final GDPRAgreementWidgetListener listener;

  const GDPRAgreementBodyWidget({
    Key? key,
    this.isAgree = false,
    this.bodyPadding,
    required this.listener,
  }) : super(key: key);

  @override
  State<GDPRAgreementBodyWidget> createState() => _GDPRAgreementBodyWidgetState();
}

class _GDPRAgreementBodyWidgetState extends State<GDPRAgreementBodyWidget> {

  bool isAgree = false;

  @override
  void initState() {
    isAgree = widget.isAgree;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.bodyPadding,
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
                      if (mounted) {
                        setState(() {
                          isAgree = val!;
                          state.didChange(val);
                          widget.listener(isAgree);
                        });
                      }
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
                padding: EdgeInsets.only(
                    top: 10,
                    left: UtilityMethods.isRTL(context) ? 0.0 : 20.0,
                    right: UtilityMethods.isRTL(context) ? 20.0 : 0.0,
                ),
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


