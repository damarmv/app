import 'package:hive/hive.dart';
part 'production.g.dart';

@HiveType(typeId: 0)
class Production extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int eggs;

  Production({required this.date, required this.eggs});
}
