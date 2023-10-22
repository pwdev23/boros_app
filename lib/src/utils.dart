import 'currency_code.dart';
import 'constants.dart' show kCategorySuggestions;

String findLang(String code) {
  late String lang;

  for (var e in kCurrencyCode) {
    if (e['code'] == code) {
      lang = e['langCode']!;
      break;
    }
  }

  return lang;
}

String findSign(String code) {
  late String sign;

  for (var e in kCurrencyCode) {
    if (e['code'] == code) {
      sign = e['sign']!;
      break;
    }
  }

  return sign;
}

String findHintText(String title, String locale) {
  var data = kCategorySuggestions;
  late String hintText;

  for (var i = 0; i < data.length; i++) {
    if (data[i]['title'] == title) {
      var map = data[i]['hintText'] as Map<String, dynamic>;
      hintText = map['en'];
      break;
    }
  }

  return hintText;
}
