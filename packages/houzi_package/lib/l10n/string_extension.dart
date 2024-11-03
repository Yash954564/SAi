import 'features_localization.dart';

extension Localisation on String {
  String? localisedString(List? inputWords) {
    String translated = stringBy(key: this) ?? this;
    if (inputWords != null && inputWords.isNotEmpty) {
      final regex = RegExp('\\{.*?\\}');
      for (var words in inputWords) {
        var needToConvertWord = regex.stringMatch(translated) ?? "";
        if (translated != null) {
          translated = translated.replaceAll(needToConvertWord, words);
        }
      }
    }

    return translated;
  }
}
