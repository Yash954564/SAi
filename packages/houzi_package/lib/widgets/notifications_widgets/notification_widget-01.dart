import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/notifications/notifications.dart';
import 'package:houzi_package/push_notif/one_singal_config.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class NotificationWidget01 extends StatefulWidget {
  final NotificationItem notificationItem;
  final void Function() onTap;
  final void Function() onCloseTap;

  const NotificationWidget01({
    super.key,
    required this.onTap,
    required this.onCloseTap,
    required this.notificationItem,
  });

  @override
  State<NotificationWidget01> createState() => _NotificationWidget01State();
}

class _NotificationWidget01State extends State<NotificationWidget01> {

  var isShowingAll = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: CardWidget(
            color: AppThemePreferences().appTheme.notificationWidgetBgColor,
            shape: AppThemePreferences.roundedCorners(
                AppThemePreferences.notificationWidgetRoundedCornersRadius),
            elevation: AppThemePreferences.notificationWidgetElevation,
            child: InkWell(
              onTap: ()=> widget.onTap(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: NotificationIconWidget(notificationItem: widget.notificationItem)),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NotificationTitleAndCloseWidget(
                            notificationItem: widget.notificationItem,
                            onCloseTap: ()=> widget.onCloseTap(),
                            overflow: TextOverflow.ellipsis,
                            padding: const EdgeInsets.only(top: 0),
                          ),

                          NotificationDescriptionWidget(
                            notificationItem: widget.notificationItem,
                            overflow: TextOverflow.ellipsis,
                            padding: const EdgeInsets.only(top: 0),
                            isShowingAll: isShowingAll,
                          ),

                          Row(
                            children: [
                              NotificationTimeInfoWidget(notificationItem: widget.notificationItem),
                              Expanded(child: Container()),
                              ShowAllWidget(
                                  isShowingAll: isShowingAll,
                                  listener: (show) {
                                    setState(() {
                                      isShowingAll = !isShowingAll;
                                    });
                                  })
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationIconWidget extends StatelessWidget {
  final NotificationItem notificationItem;
  final double? width;
  final double? height;

  const NotificationIconWidget({
    super.key,
    required this.notificationItem,
    this.height = 80,
    this.width = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: Container(
          color: AppThemePreferences().appTheme.backgroundColor,
          // color: AppThemePreferences.notificationWidgetIconBgColor,
          child: Icon(
            getIconData(notificationItem),
            color: AppThemePreferences.notificationWidgetIconColor,
            size: AppThemePreferences.notificationWidgetIconSize,
          ),
        ),
      ),
    );
  }

  IconData getIconData(NotificationItem item) {
    switch(item.type) {
      case notificationNewReview: {
        return AppThemePreferences.notificationReviewIcon;
      }
      case notificationScheduleTour: {
        return AppThemePreferences.emailIcon;
      }
      case notificationAgentContact: {
        return AppThemePreferences.emailIcon;
      }
      case notificationMessages: {
        return AppThemePreferences.messageIcon;
      }
      default: {
        return AppThemePreferences.notificationIcon;
      }
    }
  }
}

class NotificationTitleAndCloseWidget extends StatelessWidget {
  final NotificationItem notificationItem;
  final void Function() onCloseTap;
  final int? maxLines;
  final EdgeInsetsGeometry? padding;
  final TextOverflow? overflow;

  const NotificationTitleAndCloseWidget({
    super.key,
    required this.notificationItem,
    required this.onCloseTap,
    this.maxLines = 3,
    this.overflow = TextOverflow.clip,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: NotificationTitleWidget(
            notificationItem: notificationItem,
            overflow: overflow,
            padding: padding,
          ),
        ),
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: ()=> onCloseTap(),
              child: Icon(
                AppThemePreferences.closeIcon,
                color: AppThemePreferences().appTheme.hintColor,
              ),
            )),
      ],
    );
  }
}


class NotificationTitleWidget extends StatelessWidget {
  final NotificationItem notificationItem;
  final int? maxLines;
  final EdgeInsetsGeometry? padding;
  final TextOverflow? overflow;

  const NotificationTitleWidget({
    super.key,
    required this.notificationItem,
    this.maxLines = 3,
    this.overflow = TextOverflow.clip,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: GenericTextWidget(
        notificationItem.title ?? "",
        maxLines: maxLines,
        overflow: overflow,
        strutStyle: const StrutStyle(
            forceStrutHeight: true,
            height: 1.7
        ),
        // style: AppThemePreferences().appTheme.titleTextStyle,
        style: AppThemePreferences().appTheme.headingTextStyle!,
      ),
    );
  }
}

class NotificationDescriptionWidget extends StatelessWidget {
  final NotificationItem notificationItem;
  final int? maxLines;
  final EdgeInsetsGeometry? padding;
  final TextOverflow? overflow;
  final bool isShowingAll;
  const NotificationDescriptionWidget({
    super.key,
    required this.notificationItem,
    this.maxLines = 3,
    this.overflow = TextOverflow.clip,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0),
    this.isShowingAll = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: GenericTextWidget(
        isShowingAll ? notificationItem.descriptionPlainWithNewLines ?? "" : notificationItem.descriptionPlain ?? "",
        maxLines: isShowingAll ? null : maxLines,
        overflow: isShowingAll ? null : overflow,
        strutStyle: StrutStyle(height: AppThemePreferences.bodyTextHeight),
        style: AppThemePreferences().appTheme.bodyTextStyle,
        textAlign: TextAlign.left,
      ),
    );
  }
}

class NotificationTimeInfoWidget extends StatelessWidget {
  final NotificationItem notificationItem;

  const NotificationTimeInfoWidget({
    super.key,
    required this.notificationItem,
  });

  @override
  Widget build(BuildContext context) {
    String time = notificationItem.dateInTimeAgoFormat ?? "";
    if (time.isNotEmpty) {
      return GenericTextWidget(
        time,
        strutStyle: StrutStyle(height: AppThemePreferences.bodyTextHeight),
        style: AppThemePreferences().appTheme.bodyTextStyle,
      );
    }
    return Container();
  }
}
typedef ShowAllWidgetListener = void Function(bool readMorePressed);
class ShowAllWidget extends StatelessWidget {
  final bool isShowingAll;
  final ShowAllWidgetListener listener;

  const ShowAllWidget({
    super.key,
    required this.isShowingAll,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => listener(isShowingAll),
      child: Icon(
        isShowingAll ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        color: AppThemePreferences().appTheme.hintColor,
        size: 30,
      ),
    );
  }
}