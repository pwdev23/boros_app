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
