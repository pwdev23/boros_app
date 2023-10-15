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
  double? monthlyPayment;
  String? notes;
  DateTime? dueDate;
}

@collection
class Debt {
  Id id = Isar.autoIncrement;

  String? title;
  double? amount;
  double? interestRate;
  double? minimumPayment;
  String? notes;
  DateTime? dueDate;
}

@collection
class Income {
  Id id = Isar.autoIncrement;

  String? title;
  double? amount;
  String? source;
  DateTime? createdAt;
  String? notes;
}
