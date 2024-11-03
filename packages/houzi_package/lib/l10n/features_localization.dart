import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/l10n/l10n.dart';


Map<String, dynamic>? _language;

String? stringBy({String key = ""}) {
  return _language != null ? _language![key] != null  ? _language![key].toString() : key : key;
}

class CustomLocalisationDelegate extends LocalizationsDelegate {
  CustomLocalisationDelegate();



  @override
  bool isSupported(Locale locale) {
    Map<String,String>? langMap = L10n.getLocaleMapFromHook(locale);
    return langMap != null && langMap.isNotEmpty;
  }

  @override
  Future load(Locale locale) async {
    Map<String,String>? languageMap = L10n.getLocaleMapFromHook(locale);
    if (languageMap != null && languageMap.isNotEmpty) {
      String languageCode = languageMap["languageCode"]!;
      String? languageFileName = languageMap["languageFileName"];

      if (languageFileName != null && languageFileName.isNotEmpty) {
        String jsonString = await rootBundle.loadString(
            'assets/localization/$languageFileName');
        _language = jsonDecode(jsonString) as Map<String, dynamic>;
      } else {
        //fallback to lang code localization
        String jsonString = await rootBundle.loadString(
            'assets/localization/${languageCode}_localization.json');
        _language = jsonDecode(jsonString) as Map<String, dynamic>;
      }



      return SynchronousFuture<CustomLocalisationDelegate>(
          CustomLocalisationDelegate());
    }
  }

  @override
  bool shouldReload(CustomLocalisationDelegate old) => true;


}
