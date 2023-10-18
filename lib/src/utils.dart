import 'currency_code.dart';

String findLang(String code) {
  late String lang;

  for (var v in kCurrencyCode) {
    if (v['code'] == code) {
      lang = v['langCode']!;
      break;
    }
  }

  return lang;
}
