import 'package:flutter/material.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/l10n/l10n.dart';


class LocaleProvider extends ChangeNotifier {

  Locale? _locale;
  Locale? get locale => _locale;

  static LocaleProvider? _localeProvider;

  factory LocaleProvider() {
    _localeProvider ??= LocaleProvider._internal();
    return _localeProvider!;
  }

  LocaleProvider._internal(){
    DefaultLanguageCodeHook defaultLanguageCodeHook = HooksConfigurations.defaultLanguageCode;
    String defaultLanguage = defaultLanguageCodeHook();


    _locale = HiveStorageManager.readLanguageSelectionLocale() ?? Locale(defaultLanguage);
    HiveStorageManager.storeLanguageSelection(locale: _locale!);
    notifyListeners();
  }

  void setLocale(Locale locale) {
    if (!L10n.getAllLanguagesLocale().contains(locale)) return;
    _locale = locale;
    HiveStorageManager.storeLanguageSelection(locale: _locale!);
    notifyListeners();
  }
}
