import 'package:shop_flutter/models/cart_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.date,
  });
}
