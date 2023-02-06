import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shop_flutter/models/cart_item.dart';
import 'package:shop_flutter/models/order_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> fetchOrders() async {
    try {
      final res = await http
          .get(Uri.parse('https://flutter-shop-4e718-default-rtdb.firebaseio.com/orders.json'));
      if (json.decode(res.body) == null) return;

      final List<OrderItem> loadedOrders = [];
      final decoded = json.decode(res.body) as Map<String, dynamic>;
      decoded.forEach((id, data) {
        loadedOrders.add(OrderItem(
          id: id,
          amount: data['amount'],
          date: DateTime.parse(data['date']),
          products: (data['products'] as List<dynamic>)
              .map((item) => CartItem(
            id: item['id'],
            title: item['title'],
            qty: item['qty'],
            price: item['price'],
          ))
              .toList(),
        ));
      });
      _items = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> products, double amount) async {
    final dateStamp = DateTime.now();
    final res = await http.post(
      Uri.parse('https://flutter-shop-4e718-default-rtdb.firebaseio.com/orders'),
      body: json.encode({
        'amount': amount,
        'date': dateStamp.toIso8601String(),
        'products': products
            .map((product) => {
                  'id': product.id,
                  'title': product.title,
                  'qty': product.qty,
                  'price': product.price,
                })
            .toList(),
      }),
    );
    _items.insert(
      0,
      OrderItem(
        id: json.decode(res.body)['name'],
        amount: amount,
        products: products,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
