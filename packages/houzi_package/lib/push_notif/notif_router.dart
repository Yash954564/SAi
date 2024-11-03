import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/pages/crm_pages/crm_activities/activities_from_board.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/properties.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/saved_searches.dart';
import 'package:houzi_package/pages/messages_pages/all_messages.dart';
import 'package:houzi_package/pages/messages_pages/all_threads.dart';
import 'package:houzi_package/pages/notifications_page/all_notifications.dart';
import 'package:houzi_package/push_notif/one_singal_config.dart';
import 'package:houzi_package/widgets/review_related_widgets/all_reviews_page.dart';

class NotificationRouter {
  static initNotificationRouter(BuildContext context, Function setState) {
    Map data = HiveStorageManager.readData(key: oneSignalNotificationData) ?? {};
    notificationRouterFunc(context, data);
    OneSignalConfig.clearNotificationData();
  }

  static void notificationRouterFunc(BuildContext context, Map data, {bool? fromAllNotifications}) {
    if (data.isEmpty) {
      return;
    }

    switch (data['type']) {
      case notificationSavedSearches:
          UtilityMethods.navigateToRoute(
            context: context,
            builder: (context) => SavedSearches(
              showAppBar: true,
              url: data['search_url'],
            ),
          );
        break;

      case notificationNewReview:
        log(data.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllReviews(
              id: data['listing_id'] is int ? data['listing_id']
                  : data['listing_id'] is String ? int.parse(data['listing_id']) : null,
              fromProperty:
              data['review_post_type'] == "property" ? true : false,
              reviewPostType: data['review_post_type'],
              title: data['listing_title'],
              listingTitle: data['listing_title'],
            ),
          ),
        );
        break;

      case notificationListingExpired:
      case notificationListingDisapproved:
      case notificationListingApproved:
      case notificationNewListingSubmission:
      case notificationUpdatedListingSubmission:
      case notificationFreeSubmissionListing:
        navigateToProperties(context);
        break;

      case notificationScheduleTour:
      case notificationAgentContact:
      case notificationNewInquiry:
      case notificationContactRealtor:
        navigateToActivities(context);
        break;

      case notificationMessages:
        navigateToMessages(context, data);
        break;

      case notificationPurchaseActivePack:
        UtilityMethods.navigateToMembershipPlanPage(context);
        break;

      default:
        if (fromAllNotifications == true) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AllNotificationsPage(),
          ),
        );
        break;
    }
  }

  static void navigateToProperties(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Properties(),
      ),
    );
  }

  static void navigateToActivities(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ActivitiesFromBoard(),
      ),
    );
  }

  static void navigateToMessages(BuildContext context, Map data) {
    String? thread_id = data['thread_id'];
    if (thread_id != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllMessagesPage(
            threadId: thread_id ?? "",
            propertyTitle: data['property_title'] ?? "",
            propertyId: data['property_id'] ?? "",
            senderId: data['sender_id'] ?? "",
            senderDisplayName: data['sender_display_name'] ?? "",
            senderPictureUrl: data['sender_picture'] ?? "",
            receiverId: data['receiver_id'] ?? "",
            receiverDisplayName: data['receiver_display_name'] ?? "",
            receiverPictureUrl: data['receiver_picture'] ?? "",
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AllThreadsPage(),
        ),
      );
    }
  }
}