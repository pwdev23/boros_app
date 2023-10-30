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

Future<double> getIdleMoney() async =>
    await openIsarInstance().then((isar) async {
      double idleMoney = 0;
      final expensesCollection = await getExpenses();
      final installmentsCollection = await getInstallments();
      final debtsCollection = await getDebts();
      final incomesCollection = await getIncomes();

      final expenses = await expensesCollection.where().findAll();
      final installments = await installmentsCollection.where().findAll();
      final debts = await debtsCollection.where().findAll();
      final incomes = await incomesCollection.where().findAll();

      if (expenses.isNotEmpty) {
        var sumExpenses = expenses
            .map((e) => e.amount)
            .reduce((value, element) => value! + element!);
        idleMoney -= sumExpenses!;
      }

      if (installments.isNotEmpty) {
        var sumInstallments = installments
            .map((e) => e.amount)
            .reduce((value, element) => value! + element!);
        idleMoney -= sumInstallments!;
      }

      if (debts.isNotEmpty) {
        var sumDebts = debts
            .map((e) => e.amount)
            .reduce((value, element) => value! + element!);
        idleMoney -= sumDebts!;
      }

      if (incomes.isNotEmpty) {
        var sumIncomes = incomes
            .map((e) => e.amount)
            .reduce((value, element) => value! + element!);
        idleMoney += sumIncomes!;
      }

      return idleMoney;
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
