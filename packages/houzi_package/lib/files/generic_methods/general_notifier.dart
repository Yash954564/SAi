import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A dirty general notifier

class GeneralNotifier with ChangeNotifier {
  static const String USER_PROFILE_UPDATE = 'user_profile';
  static const String AREA_DATA_UPDATE = 'area_data';
  static const String CITY_DATA_UPDATE = 'city_data';
  static const String STATE_DATA_UPDATE = 'state_data';
  static const String COUNTRY_DATA_UPDATE = 'country_data;.';
  static const String RECENT_DATA_UPDATE = 'recent_data';
  static const String RESET_FILTER_DATA = 'reset_filter_data';
  static const String LATEST_ARTICLE_DATA = 'latest_article_data';
  static const String FILTER_DATA_LOADING_COMPLETE =
      'filter_data_loading_complete';
  static const String USER_LOGGED_IN = 'user_logged_in';
  static const String USER_LOGGED_OUT = 'user_logged_out';
  static const String NEW_FAV_ADDED_REMOVED = 'fav_added_removed';
  static const String NEW_SAVED_SEARCH_ADDED = 'save_search_added';
  static const String DEEP_LINK_RECEIVED = 'deep_link_recieved';
  static const String LATEST_REALTOR_DATA = 'latest_realtor_data';
  static const String CHANGE_LOCALIZATION = 'change_localization';
  static const String APP_CONFIGURATIONS_UPDATED = 'app_configurations_updated';
  static const String HOME_DESIGN_MODIFIED = 'home_design_modified';
  static const String TOUCH_BASE_DATA_LOADED = 'touch_base_data_loaded';
  static const String PROPERTY_DETAILS_RELOADED = 'property_details_reloaded';
  static const String USER_PAYMENT_STATUS_UPDATED = 'payment_status';
  static const String notificationClicked = 'notification_clicked';
  static const String NAVBAR_DESIGN_MODIFIED = 'navbar_design_modified';
  static const String RESULTS_ITEM_DESIGN_MODIFIED = 'results_item_design_modified';


  static GeneralNotifier? _generalNotifier;
  factory GeneralNotifier() {
    _generalNotifier ??= GeneralNotifier._internal();
    // if (_generalNotifier == null) {
    //   _generalNotifier = GeneralNotifier._internal();
    // }
    return _generalNotifier!;
  }
  String? change;

  ///
  /// Initializer of Class GeneralNotifier
  ///
  GeneralNotifier._internal() {
    // print("Instance created!" );
  }
  void publishChange(String event) {
    change = event;
    notifyListeners();
    change = null;
  }
}
