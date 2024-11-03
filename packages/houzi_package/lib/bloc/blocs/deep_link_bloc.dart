import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/push_notif/one_singal_config.dart';

abstract class Bloc {
  void dispose();
}

class DeepLinkBloc extends Bloc {

  //Event Channel creation
  static const stream = const EventChannel('houzi_link_channel/events');

  //Method channel creation
  static const platform = const MethodChannel('houzi_link_channel/channel');

  StreamController<String> _stateController = StreamController();

  Stream<String> get state {
    return _stateController.stream;
  }

  Sink<String> get stateSink => _stateController.sink;


  //Adding the listener into contructor
  DeepLinkBloc() {
    //Checking application start by deep link
    startUri().then(_onRedirected);
    //Checking broadcast stream, if deep link was clicked in opened appication
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));

    invokePushNotificationsChannel().then(handleBackgroundPushNotification);
  }

  _onRedirected(dynamic uri) {
    // Here can be any uri analysis, checking tokens etc, if it's necessary
    // Throw deep link URI into the BloC's stream

    // check if we should handle this uri. for example firebaseauth vs booleanbites.com
    // don't open if its not our domain

    print("found deep link uri: "+uri);
    String host = Uri.parse(uri).host;
    if(host == WORDPRESS_URL_DOMAIN) {
      stateSink.add(uri);
    } else {
      print("shouldn't handle deep link uri: "+host);
    }
  }

  void handleBackgroundPushNotification(dynamic pushAdditionalData) {
    if (pushAdditionalData is String) {
      // print("[Deep Link Bloc] : pushAdditionalData is of String type............");
      // print("[Deep Link Bloc] : pushAdditionalData is being converted to Map............");
      // convert json to map
      Map additionalData = jsonDecode(pushAdditionalData);

      // print("[Deep Link Bloc] : additionalData: $additionalData");
      // print("[Deep Link Bloc] : additionalData is  being saved to Hive............");
      HiveStorageManager.saveData(
        key: oneSignalNotificationData,
        data: additionalData,
      );

      // print("[Deep Link Bloc] : Calling General Notifier()............");
      //
      // GeneralNotifier().publishChange(GeneralNotifier.notificationClicked);
    } else {
      // print("[Deep Link Bloc] : pushAdditionalData is of the type: ${pushAdditionalData.runtimeType}");
    }

  }


  @override
  void dispose() {
    _stateController.close();
  }


  Future<dynamic> startUri() async {
    try {
      return platform.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }

  Future<dynamic> invokePushNotificationsChannel() async {
    try {
      return platform.invokeMethod('pushNotification');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }
}