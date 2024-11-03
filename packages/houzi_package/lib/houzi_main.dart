import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:houzi_package/bloc/blocs/deep_link_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/configurations/app_configurations.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/item_design_files/item_design_notifier.dart';
import 'package:houzi_package/files/theme_service_files/theme_notifier.dart';
import 'package:houzi_package/l10n/features_localization.dart';
import 'package:houzi_package/l10n/l10n.dart';
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/widgets/deep_link_widget.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:houzi_package/push_notif/one_singal_config.dart';

Future<void> main(configurationsFilePath, Map<String, dynamic> hooksMap) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Platform.isAndroid
  //     ? await Firebase.initializeApp(
  //         options: const FirebaseOptions(
  //           apiKey: "YOUR API KEY",
  //           // form google-services.json file
  //           appId: "YOUR APP ID",
  //           // form google-services.json file
  //           messagingSenderId: "YOUR PACKAGE NUMBER",
  //           // form google-services.json file
  //           projectId: "YOUR PACKAGE ID", // form google-services.json file
  //         ))
  //     : await Firebase.initializeApp();
  await Firebase.initializeApp();
  await HiveStorageManager.openHiveBox();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  HooksConfigurations.setHooks(hooksMap);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider<ItemDesignNotifier>(
            create: (_) => ItemDesignNotifier()),
        ChangeNotifierProvider<LocaleProvider>(create: (_) => LocaleProvider()),
        ChangeNotifierProvider<UserLoggedProvider>(
            create: (_) => UserLoggedProvider()),
      ],
      child: MyApp(configurationsFilePath, fontsHook: hooksMap["fonts"]),
    ),
  );
}

typedef FontsHook = String Function(Locale locale);

class MyApp extends StatefulWidget {
  final String configurationsFilePath;
  final FontsHook? fontsHook;

  const MyApp(this.configurationsFilePath, {Key? key, this.fontsHook})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DeepLinkBloc _bloc = DeepLinkBloc();

  @override
  void initState() {
    super.initState();

    AppConfigurations appConfigurations = AppConfigurations(
        filePath: widget.configurationsFilePath,
        appConfigurationsListener: (bool areConfigsIntegrated) {
          if (areConfigsIntegrated) {
            // initialize the oneSignal configurations after the integrations of
            // app configurations
            OneSignalConfig.initPlatformState();
            setState(() {});
          }
        });
    //
    appConfigurations.integrateConfigurations();

    HiveStorageManager.deleteUrl();
    // HiveStorageManager.deleteUrlAuthority();
    // HiveStorageManager.deleteCommunicationProtocol();
    HiveStorageManager.deleteAgentCitiesMetaData();
    HiveStorageManager.deleteAgentCategoriesMetaData();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      HiveStorageManager.storeAppInfo(appInfo: {
        APP_INFO_APP_NAME: appName,
        APP_INFO_APP_PACKAGE_NAME: packageName,
        APP_INFO_APP_VERSION: version,
        APP_INFO_APP_BUILD_NUMBER: buildNumber,
      });
    });

    // platform.setMethodCallHandler(_handleMethodCall);
  }

  // Future<String> startUri() async {
  //   try {
  //     return platform.invokeMethod('initialLink');
  //   } on PlatformException catch (e) {
  //     return "Failed to Invoke: '${e.message}'.";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) {
        return Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
          return MaterialApp(
            title: APP_NAME,
            locale: localeProvider.locale,
            supportedLocales: L10n.getAllLanguagesLocale(),
            localizationsDelegates: [
              // AppLocalizations.delegate,
              CustomLocalisationDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            darkTheme: ThemeData(
              // useMaterial3: false,
              popupMenuTheme: PopupMenuThemeData(
                surfaceTintColor: Colors.transparent,
                color: AppThemePreferences.popupMenuBgColorDark,
              ),
              bottomSheetTheme: BottomSheetThemeData(
                surfaceTintColor: Colors.transparent,
                backgroundColor: AppThemePreferences.bottomSheetBgColorDark,
              ),
              dialogBackgroundColor: AppThemePreferences.dialogBgColorDark,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: AppThemePreferences.appPrimaryColor,
                selectionHandleColor: AppThemePreferences.appPrimaryColor,
                selectionColor: AppThemePreferences.appPrimaryColorSwatch[300],
              ),
              splashColor: AppThemePreferences.selectedItemBackgroundColorDark,
              appBarTheme: AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarBrightness: Brightness.dark)),
              brightness: AppThemePreferences.systemBrightnessDark,
              canvasColor: AppThemePreferences.backgroundColorDark,
              primaryColor: AppThemePreferences.appPrimaryColor,
              primarySwatch: AppThemePreferences.appPrimaryColorSwatch,
              iconTheme: IconThemeData(
                  color: AppThemePreferences.appIconsMasterColorDark),
              scaffoldBackgroundColor: AppThemePreferences.backgroundColorDark,
              cardColor: AppThemePreferences.cardColorDark,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor:
                    AppThemePreferences.bottomNavBarBackgroundColorDark,
                selectedItemColor: AppThemePreferences.bottomNavBarTintColor,
                unselectedItemColor:
                    AppThemePreferences.unSelectedBottomNavBarTintColor,
              ),
              fontFamily: widget.fontsHook!(localeProvider.locale!).isNotEmpty
                  ? widget.fontsHook!(localeProvider.locale!)
                  : checkRTLDirectionality(localeProvider.locale!)
                      ? 'Cairo'
                      : 'Rubik',
              dividerColor: AppThemePreferences.dividerColorDark,
            ),
            theme: ThemeData(
              // useMaterial3: false,
              popupMenuTheme: PopupMenuThemeData(
                surfaceTintColor: Colors.transparent,
                color: AppThemePreferences.popupMenuBgColorLight,
              ),
              bottomSheetTheme: BottomSheetThemeData(
                surfaceTintColor: Colors.transparent,
                backgroundColor: AppThemePreferences.bottomSheetBgColorLight,
              ),
              dialogBackgroundColor: AppThemePreferences.dialogBgColorLight,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: AppThemePreferences.appPrimaryColor,
                selectionHandleColor: AppThemePreferences.appPrimaryColor,
                selectionColor: AppThemePreferences.appPrimaryColorSwatch[300],
              ),
              splashColor: AppThemePreferences.selectedItemBackgroundColorLight,
              inputDecorationTheme: InputDecorationTheme(
                fillColor: AppThemePreferences.appPrimaryColor,
              ),
              appBarTheme: AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarBrightness: Brightness.light)),
              brightness: AppThemePreferences.systemBrightnessLight,
              canvasColor: AppThemePreferences.backgroundColorLight,
              primaryColor: AppThemePreferences.appPrimaryColor,
              primarySwatch: AppThemePreferences.appPrimaryColorSwatch,
              iconTheme: IconThemeData(
                  color: AppThemePreferences.appIconsMasterColorLight),
              scaffoldBackgroundColor: AppThemePreferences.backgroundColorLight,
              fontFamily: widget.fontsHook!(localeProvider.locale!).isNotEmpty
                  ? widget.fontsHook!(localeProvider.locale!)
                  : checkRTLDirectionality(localeProvider.locale!)
                      ? 'Cairo'
                      : 'Rubik',
              dividerColor: AppThemePreferences.dividerColorDark,
            ),
            themeMode: theme.getThemeMode(),
            debugShowCheckedModeBanner: false,
            home: Provider<DeepLinkBloc>(
              create: (context) => _bloc,
              dispose: (context, bloc) => bloc.dispose(),
              child: DeepLinkWidget(),
            ),
            // home: MyHomePage(),
          );
        });
      },
    );
  }

//   Widget iconWidget({
//   IconData iconData,
//   Color color,
// }){
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Icon(iconData, color: color));
//   }
//
//   Widget buttonWidget({
//   String title,
//   void Function() onPressed,
//   Color color,
// }){
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: ElevatedButton(
//         child: Text(title),
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(primary: color),
//       ),
//     );
//   }

  bool checkRTLDirectionality(Locale locale) {
    return Bidi.isRtlLanguage(locale.languageCode);
  }
}
