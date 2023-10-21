import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'collections/collections.dart';

Future<void> addExpense({required Expense expense}) async =>
    await openIsarInstance().then((isar) {
      isar.writeTxn(() => isar.expenses.put(expense));
    });

Future<void> addInstallment({required Installment installment}) async =>
    await openIsarInstance().then((isar) {
      isar.writeTxn(() => isar.installments.put(installment));
    });

Future<void> addDebt({required Debt debt}) async =>
    await openIsarInstance().then((isar) {
      isar.writeTxn(() async {
        await isar.debts.put(debt);
      });
    });

Future<void> addIncome({required Income income}) async =>
    await openIsarInstance().then((isar) {
      isar.writeTxn(() => isar.incomes.put(income));
    });

Future<void> deleteExpenses({required List<Id> ids}) async =>
    await openIsarInstance().then((isar) {
      isar.writeTxn(() => isar.expenses.deleteAll(ids));
    });

Future<void> deleteInstallments({required List<Id> ids}) async =>
    await openIsarInstance().then((isar) {
      isar.writeTxn(() => isar.installments.deleteAll(ids));
    });

Future<void> deleteDebts({required List<Id> ids}) async =>
    await openIsarInstance().then((isar) {
      isar.writeTxn(() => isar.debts.deleteAll(ids));
    });

Future<void> deleteIncomes({required List<Id> ids}) async =>
    await openIsarInstance().then((isar) {
      isar.writeTxn(() => isar.incomes.deleteAll(ids));
    });

Future<IsarCollection<Expense>> getExpenses() async =>
    await openIsarInstance().then((isar) {
      return isar.collection<Expense>();
    });

Future<IsarCollection<Installment>> getInstallments() async =>
    await openIsarInstance().then((isar) {
      return isar.collection<Installment>();
    });

Future<IsarCollection<Debt>> getDebts() async =>
    await openIsarInstance().then((isar) {
      return isar.collection<Debt>();
    });

Future<IsarCollection<Income>> getIncomes() async =>
    await openIsarInstance().then((isar) {
      return isar.collection<Income>();
    });

Future<Isar> openIsarInstance() async {
  if (Isar.instanceNames.isEmpty) {
    final dir = await getApplicationCacheDirectory();
    return await Isar.open(
      [ExpenseSchema, InstallmentSchema, DebtSchema, IncomeSchema],
      directory: dir.path,
    );
  }

  return Future.value(Isar.getInstance());
}
