import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../collections/collections.dart';
import '../isar_services.dart';

part 'providers.g.dart';

@riverpod
Future<List<Income>> incomes(IncomesRef ref) async {
  final incomesCollection = await getIncomes();
  final incomes = await incomesCollection.where().findAll();
  return incomes;
}

@riverpod
Future<List<Expense>> expenses(ExpensesRef ref) async {
  final expensesCollection = await getExpenses();
  final expenses = await expensesCollection.where().findAll();
  return expenses;
}

@riverpod
Future<List<Installment>> installments(InstallmentsRef ref) async {
  final installmentsCollection = await getInstallments();
  final installments = await installmentsCollection.where().findAll();
  return installments;
}

@riverpod
Future<List<Debt>> debts(DebtsRef ref) async {
  final debtsCollection = await getDebts();
  final debts = await debtsCollection.where().findAll();
  return debts;
}
