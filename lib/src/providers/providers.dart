import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../collections/collections.dart';
import '../isar_services.dart';
import '../utils.dart' show getCurrentWeekExpenses;

part 'providers.g.dart';

@riverpod
Future<List<Income>> incomes(IncomesRef ref) async {
  final incomesCollection = await getIncomes();
  return incomesCollection.where().findAll();
}

@riverpod
Future<List<Expense>> expenses(ExpensesRef ref) async {
  final expensesCollection = await getExpenses();
  return expensesCollection.where().findAll();
}

@riverpod
Future<List<Installment>> installments(InstallmentsRef ref) async {
  final installmentsCollection = await getInstallments();
  return installmentsCollection.where().findAll();
}

@riverpod
Future<List<Debt>> debts(DebtsRef ref) async {
  final debtsCollection = await getDebts();
  return debtsCollection.where().findAll();
}

@riverpod
Future<double> idleMoney(IdleMoneyRef ref) async {
  final idleMoney = await getIdleMoney();
  return idleMoney;
}

@riverpod
Future<List<Map<String, dynamic>>> weekExpenses(WeekExpensesRef ref) async {
  late List<Map<String, dynamic>> weekExpenses;
  final expensesCollection = await getExpenses();
  final expenses = await expensesCollection.where().findAll();
  weekExpenses = getCurrentWeekExpenses(expenses);
  return weekExpenses;
}
