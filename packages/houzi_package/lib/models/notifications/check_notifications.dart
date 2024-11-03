class CheckNotifications {
  bool? success;
  bool? hasNotification;
  int? numNotification;
  DateTime? lastCheckedNotificationDateTime;
  String? lastCheckedNotificationString;

  CheckNotifications({
    this.success,
    this.hasNotification,
    this.numNotification,
    this.lastCheckedNotificationDateTime,
    this.lastCheckedNotificationString,
  });
}