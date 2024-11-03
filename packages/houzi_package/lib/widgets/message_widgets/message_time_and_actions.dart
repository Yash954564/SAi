import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/board_pages_widgets.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class MessageTimeAndActionsWidget extends StatelessWidget {
  final String? time;
  final bool showCompleteMessage;
  final bool showSeeMore;
  final void Function() onShowMoreTap;
  final void Function() onReplyTap;
  final void Function() onDeleteTap;

  const MessageTimeAndActionsWidget({
    super.key,
    required this.showSeeMore,
    required this.time,
    required this.showCompleteMessage,
    required this.onShowMoreTap,
    required this.onReplyTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          MessageTimeInfoWidget(time: time),
          const Spacer(),
          MessageActionButtonsWidget(
            showSeeMore: showSeeMore,
            showCompleteMessage: showCompleteMessage,
            onShowMoreTap: ()=> onShowMoreTap(),
            onReplyTap: () => onReplyTap(),
            onDeleteTap: () => onDeleteTap(),
          ),
        ],
      ),
    );
  }
}

class MessageTimeInfoWidget extends StatelessWidget {
  final String? time;
  final MainAxisAlignment? mainAxisAlignment;

  const MessageTimeInfoWidget({
    super.key,
    required this.time,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    if (time != null && time!.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.only(top: 0),
        child: Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
          children: [
            Icon(
              AppThemePreferences.timeIcon,
              size: 16,
              color: AppThemePreferences.messageTimeIconColor,
            ),
            const SizedBox(width: 10),
            GenericTextWidget(
              time!,
              style: AppThemePreferences().appTheme.crmTypeHeadingTextStyle,
            ),
          ],
        ),
      );
    }

    return Container();

  }
}

class MessageActionButtonsWidget extends StatelessWidget {
  final bool showSeeMore;
  final bool showCompleteMessage;
  final void Function() onShowMoreTap;
  final void Function() onReplyTap;
  final void Function() onDeleteTap;

  const MessageActionButtonsWidget({
    super.key,
    required this.showCompleteMessage,
    required this.onShowMoreTap,
    required this.onReplyTap,
    required this.onDeleteTap,
    required this.showSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showSeeMore) CRMClickableIcon(
          showCompleteMessage
            ? Icons.keyboard_arrow_up
            : Icons.keyboard_arrow_down,
            () => onShowMoreTap(),
          size: 24,
        ),
        CRMClickableIcon(
          AppThemePreferences.replyOutlined,
          ()=> onReplyTap(),
        ),
        CRMClickableIcon(
          AppThemePreferences.deleteIcon,
          ()=> onDeleteTap(),
        )
      ],
    );
  }
}


class MessageTimeAndSeeFullMessageWidget extends StatelessWidget {
  final String? time;
  final bool showSeeMore;
  final bool showCompleteMessage;
  final void Function() onShowMoreTap;

  const MessageTimeAndSeeFullMessageWidget({
    super.key,
    required this.showSeeMore,
    required this.time,
    required this.showCompleteMessage,
    required this.onShowMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          MessageTimeInfoWidget(time: time),
          if (showSeeMore) const Spacer(),
          if (showSeeMore) InkWell(
            onTap: ()=> onShowMoreTap(),
            child: Icon(
              showCompleteMessage
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: AppThemePreferences.messageTimeIconColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
