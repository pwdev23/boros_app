import 'package:isar/isar.dart';

part 'collections.g.dart';

@collection
class Expense {
  Id id = Isar.autoIncrement;

  String? title;
  double? amount;
  String? category;
  String? notes;
  DateTime? createdAt;
}
