import 'package:flutter_test/flutter_test.dart';
import 'package:boros_app/src/utils.dart';

void main() {
  test('Find lang code from currency code test', () {
    const currencyCode = 'IDR';
    late String lang;

    lang = findLang(currencyCode);

    expect(lang, 'id');
  });

  test('Find money sign from currency code', () {
    const currencyCode = 'USD';
    late String sign;

    sign = findSign(currencyCode);

    expect(sign, '\$');
  });
}
