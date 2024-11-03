import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

const String oneSignalNotificationData = "one_signal_notification_data";

const String notificationSavedSearches = "matching_submissions";
const String notificationListingExpired = "listing_expired";
const String notificationListingDisapproved = "listing_disapproved";
const String notificationListingApproved = "listing_approved";

const String notificationNewReview = "review";
const String notificationNewListingSubmission = "admin_free_submission_listing";
const String notificationUpdatedListingSubmission = "admin_update_listing";

const String notificationScheduleTour = "property_schedule_tour";
const String notificationAgentContact = "property_agent_contact";
const String notificationNewInquiry = "inquiry";
const String notificationContactRealtor = "contact_realtor";
const String notificationMessages = "messages";

const String notificationFreeSubmissionListing = "free_submission_listing";
const String notificationPurchaseActivePack = "purchase_activated_pack";


class OneSignalConfig {
  // bool _requireConsent = false;

  static oneSignalInAppMessagingTriggerExamples() async {
    /// Example addTrigger call for IAM
    /// This will add 1 trigger so if there are any IAM satisfying it, it
    /// will be shown to the user
    OneSignal.InAppMessages.addTrigger("trigger_1", "one");

    /// Example addTriggers call for IAM
    /// This will add 2 triggers so if there are any IAM satisfying these, they
    /// will be shown to the user
    Map<String, String> triggers = <String, String>{};
    triggers["trigger_2"] = "two";
    triggers["trigger_3"] = "three";
    OneSignal.InAppMessages.addTriggers(triggers);

    // Removes a trigger by its key so if any future IAM are pulled with
    // these triggers they will not be shown until the trigger is added back
    OneSignal.InAppMessages.removeTrigger("trigger_2");

    // Create a list and bulk remove triggers based on keys supplied
    List<String> keys = ["trigger_1", "trigger_3"];
    OneSignal.InAppMessages.removeTriggers(keys);

    // Toggle pausing (displaying or not) of IAMs
    OneSignal.InAppMessages.paused(true);
    var arePaused = await OneSignal.InAppMessages.arePaused();
    log('Notifications paused $arePaused');
  }

  static oneSignalOutcomeExamples() async {
    OneSignal.Session.addOutcome("normal_1");
    OneSignal.Session.addOutcome("normal_2");

    OneSignal.Session.addUniqueOutcome("unique_1");
    OneSignal.Session.addUniqueOutcome("unique_2");

    OneSignal.Session.addOutcomeWithValue("value_1", 3.2);
    OneSignal.Session.addOutcomeWithValue("value_2", 3.9);
  }

  static void initPlatformState() {
    // if (!mounted) return;
    if (ONE_SIGNAL_APP_ID == null || ONE_SIGNAL_APP_ID.isEmpty ) {
      return;
    }

    GeneralNotifier _generalNotifier = GeneralNotifier();

    if (enableOneSignalLogs) {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    }

    // OneSignal.consentRequired(_requireConsent);

    OneSignal.initialize(ONE_SIGNAL_APP_ID);
    // to remove all notifications
    // OneSignal.Notifications.clearAll();


    OneSignal.Notifications.requestPermission(true).then((allowed) {

    });

    OneSignal.Notifications.addClickListener((event) {

      onesignalPrint('OneSignal: NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');

      HiveStorageManager.saveData(
        key: oneSignalNotificationData,
        data: event.notification.additionalData,
      );

      _generalNotifier.publishChange(GeneralNotifier.notificationClicked);
    });

    OneSignal.InAppMessages.addClickListener((event) {
      // this.setState(() {
      //   _debugLabelString =
      //   "In App Message Clicked: \n${event.result.jsonRepresentation().replaceAll("\\n", "\n")}";
      // });
    });

    OneSignal.User.pushSubscription.addObserver((state) {

        onesignalPrint('OneSignal: ' + OneSignal.User.pushSubscription.optedIn.toString());
        onesignalPrint('OneSignal: ' + OneSignal.User.pushSubscription.id.toString());
        onesignalPrint('OneSignal: ' + OneSignal.User.pushSubscription.token.toString());
        onesignalPrint('OneSignal: ' + state.current.jsonRepresentation());

    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      onesignalPrint('OneSignal: NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');


      /// Display Notification, preventDefault to not display
      event.preventDefault();

      /// Do async work

      // log('OneSignal: ' + event.notification.additionalData.toString());

      /// notification.display() to display after preventing default
      event.notification.display();

      // OneSignal.Notifications.displayNotification(
      //     event.notification.notificationId);
    });

    OneSignal.InAppMessages.addWillDisplayListener((event) {
      onesignalPrint("OneSignal: ON WILL DISPLAY IN APP MESSAGE ${event.message.messageId}");

    });
    OneSignal.InAppMessages.addDidDisplayListener((event) {
      onesignalPrint("OneSignal: ON DID DISPLAY IN APP MESSAGE ${event.message.messageId}");

    });
    OneSignal.InAppMessages.addWillDismissListener((event) {

      onesignalPrint("OneSignal: ON WILL DISMISS IN APP MESSAGE ${event.message.messageId}");

    });
    OneSignal.InAppMessages.addDidDismissListener((event) {

      onesignalPrint("OneSignal: ON DID DISMISS IN APP MESSAGE ${event.message.messageId}");

    });

    // Some examples of how to use In App Messaging public methods with OneSignal SDK
    // oneSignalInAppMessagingTriggerExamples();

    // Some examples of how to use Outcome Events public methods with OneSignal SDK
    // oneSignalOutcomeExamples();

    OneSignal.InAppMessages.paused(true);

    OneSignal.Notifications.addPermissionObserver((state) {

      onesignalPrint("OneSignal: Has permission " + state.toString());


    });
    ensureOneSignalLoginAndInitPlatformState();
  }

  //Old Method
  // static init() {
  // OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
  //   log("Accepted permission: $accepted");
  // });

  // OneSignal.shared.setNotificationWillShowInForegroundHandler(
  //     (OSNotificationReceivedEvent event) {
  //   // Will be called whenever a notification is received in foreground
  //   // Display Notification, pass null param for not displaying the notification
  //
  //   log("OneSignal: notification received: " +
  //       event.notification.rawPayload.toString());
  //   // event.notification.launchUrl = null;
  //
  //   event.complete(event.notification);
  // });

  //===old_method===//
  // OneSignal.shared
  //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //   log('"OneSignal: result: ' + result.notification.rawPayload.toString());
  //
  //   try {
  //     var id = result.notification.additionalData != null
  //         ? result.notification.additionalData!["data_id"]
  //         : result.notification;
  //     log("OneSignal: notification opened: " + id);
  //
  //     /// ToDo: Perform your desired action here.
  //     // e.g.
  //     // if (result.notification.launchUrl != null) {
  //     // Navigator.push(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //     builder: (context) => const SecondScreen(),
  //     //   ),
  //     // );
  //     // }
  //   } catch (e, stacktrace) {
  //     log(e.toString() + ": " + stacktrace.toString());
  //   }
  // });

  //===old_method===//
  // OneSignal.shared.setEmailSubscriptionObserver(
  //     (OSEmailSubscriptionStateChanges emailChanges) {
  //   // Will be called whenever then user's email subscription changes
  //   // (ie. OneSignal.setEmail(email) is called and the user gets registered
  // });
  // }

  /// Call this method right after logging in.
  static loginOneSignal({required String externalUserId}) {

    if (ONE_SIGNAL_APP_ID == null || ONE_SIGNAL_APP_ID.isEmpty ) {
      return;
    }

    String enExternalUserId =
        sha1.convert(utf8.encode(externalUserId)).toString();
    onesignalPrint("OneSignalConfig:: Attempt OneSignal Login: $externalUserId -> $enExternalUserId");

    onesignalPrint("OneSignal: externalUserId: " + enExternalUserId);


    OneSignal.login(enExternalUserId);
    OneSignal.User.addAlias("encrypted_id", enExternalUserId);
  }

  static ensureOneSignalLoginAndInitPlatformState() {
    if (ONE_SIGNAL_APP_ID == null || ONE_SIGNAL_APP_ID.isEmpty ) {
      return;
    }
    onesignalPrint("OneSignalConfig:: Checking User External Id...");

    OneSignal.User.getExternalId().then((externalId){
      if (externalId == null) {
        onesignalPrint("OneSignalConfig:: User External Id is not set");
        onesignalPrint("OneSignalConfig::  user login data and logging in user on OneSignal...");
        Map userLoginData = HiveStorageManager.readUserLoginInfoData() ?? {};
        if (userLoginData.isNotEmpty) {
          oneSignalLoginFunc(userLoginData);
        } else {
          onesignalPrint("OneSignalConfig:: no login data available.");
        }
      } else {
        onesignalPrint("OneSignalConfig:: User External Id already set");
      }
      return null;
    });
  }

  static void oneSignalLoginFunc(Map data) {
    String idItem = '';
    if (data["user_email"] != null && data["user_email"] is String &&
        data["user_email"].isNotEmpty) {
      idItem = data["user_email"];
    } else if (data["user_nicename"] != null && data["user_nicename"] is String &&
        data["user_nicename"].isNotEmpty) {
      idItem = data["user_nicename"];
    }
    if (idItem.isNotEmpty) {
      OneSignalConfig.loginOneSignal(externalUserId: idItem);
    }
  }

  /// Call this method when user is about to log out.
  static logoutOneSignal() {
    if (ONE_SIGNAL_APP_ID == null || ONE_SIGNAL_APP_ID.isEmpty ) {
      return;
    }
    OneSignal.User.removeAlias("encrypted_id");
    OneSignal.logout();
  }

  /// Call this method when user is about to log out.
  static clearGroupedNotificationForGroupId(String groupId) {
    if (ONE_SIGNAL_APP_ID == null || ONE_SIGNAL_APP_ID.isEmpty ) {
      return;
    }
    OneSignal.Notifications.removeGroupedNotifications(groupId);
  }

  static void clearNotificationData() {
    HiveStorageManager.deleteData(key: oneSignalNotificationData);
  }
  static void onesignalPrint(Object? object) {
    if (enableOneSignalLogs) {
      print(object);
    }
  }
}
