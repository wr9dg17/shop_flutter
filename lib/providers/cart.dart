import 'package:flutter/material.dart';

import 'package:shop_flutter/models/cart_item.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<String> get keys {
    return [..._items.keys.toList()];
  }

  List<CartItem> get items {
    return [..._items.values.toList()];
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.qty;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (currentItem) => CartItem(
          id: currentItem.id,
          title: currentItem.title,
          qty: currentItem.qty + 1,
          price: currentItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          qty: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.qty > 1) {
        _items.update(
          productId,
          (currentItem) => CartItem(
            id: currentItem.id,
            title: currentItem.title,
            qty: currentItem.qty - 1,
            price: currentItem.price,
          ),
        );
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
