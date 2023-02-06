import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shop_flutter/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchProducts() async {
    try {
      final res = await http
          .get(Uri.parse('https://flutter-shop-4e718-default-rtdb.firebaseio.com/products.json'));
      if (json.decode(res.body) == null) return;

      final List<Product> loadedProducts = [];
      final decoded = json.decode(res.body) as Map<String, dynamic>;
      decoded.forEach((id, data) {
        loadedProducts.add(Product(
          id: id,
          title: data['title'],
          description: data['description'],
          price: data['price'],
          imageUrl: data['imageUrl'],
          isFavourite: data['isFavourite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final res = await http.post(
      Uri.parse('https://flutter-shop-4e718-default-rtdb.firebaseio.com/products.json'),
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavourite': product.isFavourite,
      }),
    );
    _items.add(Product(
      id: json.decode(res.body)['name'],
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _items.indexWhere((product) => product.id == id);
    if (index >= 0) {
      await http.patch(
        Uri.parse('https://flutter-shop-4e718-default-rtdb.firebaseio.com/products/$id.json'),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    int index = _items.indexWhere((product) => product.id == id);
    Product? product = _items[index];
    _items.removeWhere((product) => product.id == id);
    notifyListeners();

    final res = await http.delete(
      Uri.parse('https://flutter-shop-4e718-default-rtdb.firebaseio.com/products/$id.json'),
    );
    if (res.statusCode >= 400) {
      _items.insert(index, product);
      notifyListeners();
      throw const HttpException('Could not delete product');
    }
    product = null;
  }
}
