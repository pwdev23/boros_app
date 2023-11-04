import 'package:boros_app/src/collections/collections.dart' show Expense;
import 'package:flutter_test/flutter_test.dart';
import 'package:boros_app/src/utils.dart' show getCurrentWeekExpenses;

void main() {
  test('Current week expenses list test', () {
    // Consider to update the index since we are using `DateTime.now()`
    var expenses = <Expense>[
      Expense()
        ..createdAt = DateTime.now()
        ..amount = 1000
    ];
    var currentWeekExpenses = getCurrentWeekExpenses(expenses);
    
    var amount = currentWeekExpenses[5]['amount'];
    expect(amount, 1000);
  });
}
