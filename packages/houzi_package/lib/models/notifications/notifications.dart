import 'package:houzi_package/common/constants.dart';

class AllNotifications {
  bool? success;
  List<NotificationItem>? notificationsList;
  int? total;

  AllNotifications({
    this.success,
    this.notificationsList,
    this.total,
  });
}

class NotificationItem {
  int? id;
  String? title;
  String? description;
  String? _descriptionPlain;
  String? _descriptionPlainNewLines;
  String? type;
  Map? extraDataMap;
  String? userEmail;
  String? date;
  String? dateInTimeAgoFormat;

  NotificationItem({
    this.id,
    this.title,
    this.description,
    this.type,
    this.extraDataMap,
    this.userEmail,
    this.date,
    this.dateInTimeAgoFormat,
  });
  String? get descriptionPlain {
    if (_descriptionPlain == null && description != null) {
      _descriptionPlain = description?.trim().replaceAll("\n", " ");
      _descriptionPlain = _descriptionPlain?.replaceAll("on https://"+WORDPRESS_URL_DOMAIN, "on "+APP_NAME);
      _descriptionPlain = _descriptionPlain?.replaceAll("on http://"+WORDPRESS_URL_DOMAIN, "on "+APP_NAME);
    }
    return _descriptionPlain;
  }
  String? get descriptionPlainWithNewLines {
    if (_descriptionPlainNewLines == null && description != null) {
      _descriptionPlainNewLines = description?.trim().replaceAll("on https://"+WORDPRESS_URL_DOMAIN, "on "+APP_NAME);
      _descriptionPlainNewLines = _descriptionPlainNewLines?.replaceAll("on http://"+WORDPRESS_URL_DOMAIN, "on "+APP_NAME);
    }
    return _descriptionPlainNewLines;
  }
}

class ExtraData {
  String? type;
  String? searchUrl;
  int? listingId;
  String? listingTitle;
  String? listingUrl;
  String? reviewPostType;
  String? threadId;
  String? senderId;
  String? senderDisplayName;
  String? senderPicture;
  String? receiverId;
  String? receiverDisplayName;
  String? receiverPicture;
  String? propertyId;
  String? propertyTitle;

  ExtraData({
    this.type,
    this.searchUrl,
    this.listingId,
    this.listingTitle,
    this.listingUrl,
    this.reviewPostType,
    this.threadId,
    this.senderId,
    this.senderDisplayName,
    this.senderPicture,
    this.receiverId,
    this.receiverDisplayName,
    this.receiverPicture,
    this.propertyId,
    this.propertyTitle,
  });
}