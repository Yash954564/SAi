import UIKit
import Flutter
import GoogleMaps
import OneSignalFramework

import google_mobile_ads

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    // Enter your OneSignal App ID here
    private var ONE_SIGNAL_APP_ID = ""

    private var methodChannel: FlutterMethodChannel?
    private let linkStreamHandler = LinkStreamHandler()
    private var eventChannel:FlutterEventChannel?

    override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        if (!ONE_SIGNAL_APP_ID.isEmpty) {
            // Remove this method to stop OneSignal Debugging
            // OneSignal.Debug.setLogLevel(.LL_VERBOSE)

            // OneSignal initialization
            OneSignal.initialize(ONE_SIGNAL_APP_ID, withLaunchOptions: launchOptions)

            // requestPermission will show the native iOS notification permission prompt.
            OneSignal.Notifications.requestPermission({ accepted in
                print("User accepted notifications: \(accepted)")
            }, fallbackToSettings: true)
        }

        //DEEP LINKING RELATED CODE
        let controller = window.rootViewController as! FlutterViewController

        methodChannel = FlutterMethodChannel(name: "houzi_link_channel/channel", binaryMessenger: controller.binaryMessenger)

        eventChannel = FlutterEventChannel(name: "houzi_link_channel/events", binaryMessenger: controller as! FlutterBinaryMessenger)


        methodChannel?.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) in
              guard call.method == "initialLink" else {
                      guard call.method == "pushNotification" else {
                          result(FlutterMethodNotImplemented)
                          return
                      }
                      return
                    }
        })
        //DEEP LINKING RELATED CODE END

        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }

        GeneratedPluginRegistrant.register(with: self)
        // TODO: Add your API key
        GMSServices.provideAPIKey("AIzaSyBqQMpR73ry257vNlpmgigNJ73qcKCpuOk")

        //Mobile Ads - uncomment if ads required.
        let listTileFactory = ListTileNativeAdViewFactory()
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(

            self, factoryId: "listTile", nativeAdFactory: listTileFactory)

        let homeTileFactory = HomeNativeAdViewFactory()
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "homeNativeAd", nativeAdFactory: homeTileFactory)

        eventChannel?.setStreamHandler(linkStreamHandler)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        eventChannel?.setStreamHandler(linkStreamHandler)
        print("url \(url)");
        return linkStreamHandler.handleLink(url.absoluteString)
    }

    override func application(_ application: UIApplication,
                              continue userActivity: NSUserActivity,
                              restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if let url = userActivity.webpageURL  {
            eventChannel?.setStreamHandler(linkStreamHandler)
            return linkStreamHandler.handleLink(url.absoluteString)
        }
        return false;
    }
}


class LinkStreamHandler:NSObject, FlutterStreamHandler {

    var eventSink: FlutterEventSink?

    // links will be added to this queue until the sink is ready to process them
    var queuedLinks = [String]()

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        queuedLinks.forEach({ events($0) })
        queuedLinks.removeAll()
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    func handleLink(_ link: String) -> Bool {
        guard let eventSink = eventSink else {
            queuedLinks.append(link)
            return false
        }
        eventSink(link)
        return true
    }
}

