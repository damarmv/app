import 'package:hive/hive.dart';
part 'invoice.g.dart';

@HiveType(typeId: 3)
class Invoice extends HiveObject {
  @HiveField(0)
  String customer;

  @HiveField(1)
  String item;

  @HiveField(2)
  int qty;

  @HiveField(3)
  double price;

  @HiveField(4)
  String status; // pending / paid

  @HiveField(5)
  DateTime date;

  Invoice({required this.customer, required this.item, required this.qty, required this.price, required this.status, required this.date});
}
