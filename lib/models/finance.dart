import 'package:hive/hive.dart';
part 'finance.g.dart';

@HiveType(typeId: 1)
class Finance extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  double amount; // positive = income, negative = expense

  @HiveField(2)
  String note;

  Finance({required this.date, required this.amount, required this.note});
}
