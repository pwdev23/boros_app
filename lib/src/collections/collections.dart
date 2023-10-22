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

@collection
class Installment {
  Id id = Isar.autoIncrement;

  String? title;
  double? amount;
  String? notes;
  DateTime? dueDate;
  DateTime? createdAt;
}

@collection
class Debt {
  Id id = Isar.autoIncrement;

  String? title;
  double? amount;
  String? notes;
  DateTime? dueDate;
  DateTime? createdAt;
}

@collection
class Income {
  Id id = Isar.autoIncrement;

  String? title;
  double? amount;
  DateTime? createdAt;
}
