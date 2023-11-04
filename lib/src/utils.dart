import 'collections/collections.dart' show Expense;
import 'common.dart';
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

String findDesc(String title, String locale) {
  var data = kCategorySuggestions;
  late String desc;

  for (var i = 0; i < data.length; i++) {
    if (data[i]['title'] == title) {
      var map = data[i]['desc'] as Map<String, dynamic>;
      desc = map['en'];
      break;
    }
  }

  return desc;
}

String t(BuildContext context, String title) {
  final t = AppLocalizations.of(context)!;
  switch (title) {
    case 'essential-and-utilities':
      return t.essential;
    case 'entertainment':
      return t.entertainment;
    case 'housing':
      return t.housing;
    case 'transportation':
      return t.transportation;
    case 'healthcare':
      return t.healthcare;
    case 'education':
      return t.education;
    case 'savings':
      return t.savings;
    case 'personal-care':
      return t.personalCare;
    case 'travel':
      return t.travel;
    case 'gifts-and-donations':
      return t.gifts;
    case 'miscellaneous':
      return t.misc;
    default:
      return 'n/a';
  }
}

List<Map<String, dynamic>> getCurrentWeekExpenses(List<Expense> expenses) {
  final now = DateTime.now();
  final mon = now.subtract(Duration(days: now.weekday - 1));
  final currentWeekExpenses = List.generate(7, (int i) {
    var data = {'date': mon.add(Duration(days: i)), 'amount': 0};
    return data;
  });

  for (var i = 0; i < currentWeekExpenses.length; i++) {
    String string = '${currentWeekExpenses[i]['date']}';
    var date = DateTime.parse(string);
    for (var e in expenses) {
      if (isSameDay(e.createdAt!, date)) {
        final str = '${currentWeekExpenses[i]['amount']}';
        var amount = double.parse(str);
        amount += e.amount!;
        currentWeekExpenses[i].update('amount', (value) => amount);
      }
    }
  }
  return currentWeekExpenses;
}

bool isSameDay(DateTime dateA, DateTime dateB) {
  return dateA.year == dateB.year &&
      dateA.month == dateB.month &&
      dateA.day == dateB.day;
}
