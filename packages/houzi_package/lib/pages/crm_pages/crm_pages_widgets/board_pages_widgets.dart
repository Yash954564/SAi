import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/showModelBottomSheetWidget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

const double crmBottomPadding = 10.0;
const double crmAddGapHeight = 10.0;

class CRMTypeHeadingWidget extends StatelessWidget {
  final String typeHeading;
  final String? timeAgo;

  const CRMTypeHeadingWidget(
    this.typeHeading,
    this.timeAgo, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: crmBottomPadding, top: 3),
      child: Row(
        children: [
          GenericTextWidget(
            UtilityMethods.getLocalizedString(typeHeading).toUpperCase(),
            style: AppThemePreferences().appTheme.crmTypeHeadingTextStyle,
          ),
          if (timeAgo != null && timeAgo!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Icon(AppThemePreferences.dotIcon,
                  size: 5,
                  color:
                      AppThemePreferences().appTheme.crmTypeHeadingTextColor),
            ),
          if (timeAgo != null && timeAgo!.isNotEmpty)
            GenericTextWidget(
              timeAgo!,
              style: AppThemePreferences().appTheme.crmTypeHeadingTextStyle,
            ),
        ],
      ),
    );
  }
}

class CRMHeadingWidget extends StatelessWidget {
  final String? heading;
  final String? secondHeading;

  const CRMHeadingWidget(
    this.heading, {
    this.secondHeading,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: crmBottomPadding),
      child: secondHeading != null && secondHeading!.isNotEmpty
          ? Row(
              children: [
                if (heading != null && heading!.isNotEmpty)
                  GenericTextWidget(
                    UtilityMethods.getLocalizedString(heading!),
                    style: AppThemePreferences().appTheme.crmHeadingTextStyle,
                    overflow: TextOverflow.clip,
                  ),
                if (secondHeading!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Icon(
                      AppThemePreferences.dotIcon,
                      size: 6,
                      color: AppThemePreferences()
                          .appTheme
                          .crmTypeHeadingTextColor,
                    ),
                  ),
                if (secondHeading!.isNotEmpty)
                  GenericTextWidget(
                    UtilityMethods.getLocalizedString(secondHeading!),
                    style: AppThemePreferences().appTheme.crmHeadingTextStyle,
                  ),
              ],
            )
          : heading != null && heading!.isNotEmpty
              ? GenericTextWidget(
                  UtilityMethods.getLocalizedString(heading!),
                  style: AppThemePreferences().appTheme.crmHeadingTextStyle,
                )
              : Container(),
    );
  }
}

class CRMNormalTextWidget extends StatelessWidget {
  final String? message;

  const CRMNormalTextWidget(
    this.message, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return message != null && message!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: crmBottomPadding),
            child: GenericTextWidget(
              UtilityMethods.getLocalizedString(message!),
              style: AppThemePreferences().appTheme.crmNormalTextStyle,
            ),
          )
        : Container();
  }
}

class CRMSubNormalTextWidget extends StatelessWidget {
  final String? message;

  const CRMSubNormalTextWidget(
    this.message, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return message != null && message!.isNotEmpty
        ? Row(
            children: [
              Icon(
                AppThemePreferences.personIcon,
                color: Colors.transparent,
                size: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: crmBottomPadding),
                child: GenericTextWidget(
                  UtilityMethods.getLocalizedString(message!),
                  style: AppThemePreferences().appTheme.crmSubNormalTextStyle,
                ),
              ),
            ],
          )
        : Container();
  }
}

class CRMFeatures extends StatelessWidget {
  final String? bed;
  final String? bath;
  final String? area;
  final String? price;
  final bool addBottomPadding;

  const CRMFeatures(
    this.bed,
    this.bath,
    this.price,
    this.area, {
    this.addBottomPadding = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: addBottomPadding ? crmBottomPadding : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (bed != null && bed!.isNotEmpty)
            CRMIconAndText(
              AppThemePreferences.bedIcon,
              bed,
            ),
          if (bath != null && bath!.isNotEmpty)
            CRMIconAndText(
              AppThemePreferences.bathtubIcon,
              bath,
            ),
          if (area != null && area!.isNotEmpty)
            CRMIconAndText(
              AppThemePreferences.areaSizeIcon,
              area,
            ),
          if (price != null && price!.isNotEmpty)
            CRMIconAndText(
              AppThemePreferences.priceTagIcon,
              UtilityMethods.priceFormatter(price!, "", ""),
            ),
        ],
      ),
    );
  }
}

class CRMIconAndText extends StatelessWidget {
  final IconData icon;
  final String? text;
  final bool addBottomPadding;

  const CRMIconAndText(
    this.icon,
    this.text, {
    this.addBottomPadding = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return text != null && text!.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(
                bottom: addBottomPadding ? crmBottomPadding : 0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: UtilityMethods.isRTL(context) ? 6.0 : 0.0,
                    right: UtilityMethods.isRTL(context) ? 0.0 : 6.0,
                  ),
                  child: Icon(
                    icon,
                    color: AppThemePreferences().appTheme.crmIconColor,
                    size: 20,
                  ),
                ),
                GenericTextWidget(UtilityMethods.getLocalizedString(text!),
                    overflow: TextOverflow.clip,
                    style: AppThemePreferences().appTheme.crmNormalTextStyle)
              ],
            ),
          )
        : Container();
  }
}

class CRMContactDetail extends StatelessWidget {
  final String? name;
  final String? email;
  final String? phone;
  final Function() onTapEmail;
  final Function() onTapPhone;
  final bool addBottomPadding;

  const CRMContactDetail(
    this.name,
    this.email,
    this.phone,
    this.onTapEmail,
    this.onTapPhone, {
    this.addBottomPadding = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return name != null && name!.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(
                bottom: addBottomPadding ? crmBottomPadding : 0),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CRMContactInfo(name, email),
                if (name!.isNotEmpty) const Spacer(),
                if (name!.isNotEmpty)
                  Row(
                    children: [
                      if (email != null && email!.isNotEmpty)
                        CRMClickableIcon(
                          AppThemePreferences.emailIcon,
                          onTapEmail,
                        ),
                      if (phone != null && phone!.isNotEmpty)
                        CRMClickableIcon(
                          AppThemePreferences.phoneIcon,
                          onTapPhone,
                        ),
                    ],
                  )
              ],
            ),
          )
        : Container();
  }
}

class CRMClickableIcon extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;
  final double size;

  const CRMClickableIcon(
    this.icon,
    this.onTap, {
    this.size = 22,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CardWidget(
        elevation: AppThemePreferences.zeroElevation,
        shape: AppThemePreferences.roundedCorners(
          AppThemePreferences.CRMRoundedCornersRadius,
        ),
        color: AppThemePreferences().appTheme.crmIconColor,
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Icon(
            icon,
            color: Colors.white,
            size: size,
          ),
        ),
      ),
    );
  }
}

class CRMContactInfo extends StatelessWidget {
  final String? name;
  final String? email;

  const CRMContactInfo(
    this.name,
    this.email, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        name != null && name!.isNotEmpty
            ? Row(
                children: [
                  Icon(
                    AppThemePreferences.personIcon,
                    color: AppThemePreferences().appTheme.crmIconColor,
                    size: 20,
                  ),
                  GenericTextWidget(
                    name!,
                    overflow: TextOverflow.clip,
                    style: AppThemePreferences().appTheme.crmNormalTextStyle,
                  )
                ],
              )
            : Container(),
        CRMSubNormalTextWidget(email)
      ],
    );
  }
}

class CRMIconBottomText extends StatelessWidget {
  final IconData icon;
  final String type;
  final String? text;

  const CRMIconBottomText(
    this.icon,
    this.type,
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text != null && text!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: crmBottomPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: UtilityMethods.isRTL(context) ? 6.0 : 0.0,
                    right: UtilityMethods.isRTL(context) ? 0.0 : 6.0,
                  ),
                  child: Icon(
                    icon,
                    color: AppThemePreferences().appTheme.crmIconColor,
                    size: 20,
                  ),
                ),
                GenericTextWidget(
                  UtilityMethods.getLocalizedString(type),
                  style: AppThemePreferences().appTheme.crmSubNormalTextStyle,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: GenericTextWidget(
                UtilityMethods.getLocalizedString(text!),
                style: AppThemePreferences().appTheme.crmNormalTextStyle,
              ),
            )
          ],
        ),
      );
    }

    return Container();
  }
}

class CRMDetailGap extends StatelessWidget {
  final double gap;

  const CRMDetailGap({this.gap = crmAddGapHeight, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: gap,
    );
  }
}

String getActivityTypeHeading(CRMActivity activity) {
  if (activity.type == kReview) {
    return "review";
  } else if (activity.type == kLead || activity.type == kLeadContact) {
    if (activity.subtype == kScheduleTour) {
      return "schedule_tour";
    } else {
      return "lead";
    }
  }

  return "lead";
}

// EdgeInsetsGeometry getPadding(BuildContext context) {
//   final EdgeInsetsGeometry padding = EdgeInsets.only(
//     left: UtilityMethods.isRTL(context) ? 5.0 : 5.0,
//     right: UtilityMethods.isRTL(context) ? 5.0 : 0.0,
//   );
//   return padding;
// }

void takeActionBottomSheet(context, bool forCall, String? text) {
  showModelBottomSheetWidget(
    useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 70,
                child: TextButtonWidget(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(
                          text: text != null && text.isNotEmpty ? text : ""),
                    );
                  },
                  child: GenericTextWidget(
                    UtilityMethods.getLocalizedString("copy_text",
                        inputWords: [text]),
                    style: AppThemePreferences().appTheme.heading02TextStyle,
                  ),
                ),
              ),
              SizedBox(
                height: 70,
                width: double.infinity,
                child: TextButtonWidget(
                  onPressed: () async {
                    if (text != null && text.isNotEmpty) {
                      if (forCall) {
                        launchUrl(Uri.parse("tel://$text"));
                      } else {
                        launchUrl(Uri.parse("mailto:$text"));
                      }
                    }
                  },
                  child: GenericTextWidget(
                    forCall
                        ? UtilityMethods.getLocalizedString(
                            "call_text",
                            inputWords: [text],
                          )
                        : UtilityMethods.getLocalizedString(
                            "email_text",
                            inputWords: [text],
                          ),
                    style: AppThemePreferences().appTheme.heading02TextStyle,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

class CRMPaginationLoadingWidget extends StatelessWidget {
  const CRMPaginationLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: const SizedBox(
        width: 60,
        height: 50,
        child: BallRotatingLoadingWidget(),
      ),
    );
  }
}
