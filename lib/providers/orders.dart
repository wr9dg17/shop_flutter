import 'package:flutter/material.dart';

import 'package:shop_flutter/models/cart_item.dart';
import 'package:shop_flutter/models/order_item.dart';

class Orders with ChangeNotifier {
  final List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  void addOrder(List<CartItem> products, double amount) {
    _items.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: amount,
        products: products,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
