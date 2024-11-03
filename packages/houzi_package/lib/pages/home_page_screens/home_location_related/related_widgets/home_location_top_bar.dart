import 'package:flutter/material.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/widgets/notifications_widgets/notification-bell-widget.dart';

typedef HomeLocationTopBarWidgetListener = void Function({bool? hideNotificationDot});
class HomeLocationTopBarWidget extends StatefulWidget {
  final bool userLoggedIn;
  final bool receivedNewNotifications;
  final HomeLocationTopBarWidgetListener listener;

  const HomeLocationTopBarWidget({
    Key? key,
    required this.userLoggedIn,
    required this.receivedNewNotifications,
    required this.listener,
  }) : super(key: key);

  @override
  State<HomeLocationTopBarWidget> createState() => _HomeLocationTopBarWidgetState();
}

class _HomeLocationTopBarWidgetState extends State<HomeLocationTopBarWidget> {

  HomeRightBarButtonWidgetHook? rightBarButtonIdWidgetHook = HooksConfigurations.homeRightBarButtonWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // rightBarButtonIdWidgetHook!(context) ?? Container(padding: const EdgeInsets.only(top: 25.0)),
          rightBarButtonIdWidgetHook!(context) ?? Container(
            padding: const EdgeInsets.only(top: 0.0),
            child: NotificationBellWidget(
              userLoggedIn: widget.userLoggedIn,
              showNotificationDot: widget.receivedNewNotifications,
              listener: (hideNotificationDot) {
                widget.listener(hideNotificationDot: hideNotificationDot);
              },
            ),
          ),
        ],
      ),
    );
  }
}