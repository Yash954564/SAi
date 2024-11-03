import 'package:flutter/material.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:collection/collection.dart';


class L10n {
  static List<Locale> all = getAllLanguagesLocale();

  static String getLanguageName(Locale locale) {

    Map<String,String>? languageMap = L10n.getLocaleMapFromHook(locale);
    if (languageMap != null && languageMap.isNotEmpty) {
          return languageMap["languageName"]!;
    }
    return "";
  }

  static getAllLanguagesLocale() {
    LanguageHook languageHook = HooksConfigurations.languageNameAndCode;
    List<Locale> localeList = [
      // const Locale('en'),
    ];

    List<dynamic> languageList = languageHook();
    for (Map languageMap in languageList) {
      languageMap.removeWhere((key, value) => value == null || value.isEmpty);
      if (languageMap.isEmpty) {
        continue;
      }
      String? languageCode = languageMap["languageCode"];
      String? scriptCode = languageMap["scriptCode"];
      String? countryCode = languageMap["countryCode"];
      if (languageCode != null && languageCode.isNotEmpty) {
        if (scriptCode != null && scriptCode.isNotEmpty) {
          if (countryCode != null && countryCode.isNotEmpty) {
            localeList.add(
                Locale.fromSubtags(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode)
            );
            continue;
          }
          localeList.add(
              Locale.fromSubtags(languageCode: languageCode, scriptCode: scriptCode)
          );
          continue;
        }
        localeList.add(Locale(languageCode));

      }

    }

    return localeList;
  }

  static String findFromLanguageHook(String code) {
    LanguageHook languageHook = HooksConfigurations.languageNameAndCode;
    List<dynamic> languageList = languageHook();
    Map<String, dynamic>? map = languageList.firstWhereOrNull(
        (element) => element["languageCode"] == code);
    if (map != null) {
      return map["languageName"];
    }

    return "";
  }
  static Map<String,String>? getLocaleMapFromHook(Locale locale) {
    LanguageHook languageHook = HooksConfigurations.languageNameAndCode;
    List<dynamic> languageList = languageHook();
    for (Map languageMap in languageList) {
      languageMap.removeWhere((key, value) => value == null || value.isEmpty);
      if (languageMap.isEmpty) {
        continue;
      }
      String languageCode = languageMap["languageCode"];
      String? scriptCode = languageMap["scriptCode"];
      String? countryCode = languageMap["countryCode"];
      if (locale.languageCode == languageCode) {
        if (scriptCode != null &&  locale.scriptCode != null && scriptCode != locale.scriptCode) {
          continue; //this can be another script 'zh-Hant' vs 'zh-Hans'
        }
        if (countryCode != null && locale.countryCode != null && countryCode != locale.countryCode) {
          continue; //this can be another country 'zh-Hant-TW' vs 'zh-Hant-HK'
        }
        return Map<String,String>.from(languageMap);
      }
    }
    return null;
  }
}
