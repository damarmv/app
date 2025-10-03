import 'package:hive/hive.dart';
part 'stock.g.dart';

@HiveType(typeId: 2)
class Stock extends HiveObject {
  @HiveField(0)
  String item;

  @HiveField(1)
  int quantity;

  Stock({required this.item, required this.quantity});
}
