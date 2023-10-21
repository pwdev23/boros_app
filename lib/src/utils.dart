import 'currency_code.dart';

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
    }
  }

  return sign;
}
