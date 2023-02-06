import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shop_flutter/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  void _setFavouriteStatus(bool status) {
    isFavourite = status;
    notifyListeners();
  }

  Future<void> toggleFavourite() async {
    _setFavouriteStatus(!isFavourite);

    final res = await http.patch(
      Uri.parse('https://flutter-shop-4e718-default-rtdb.firebaseio.com/products/$id.json'),
      body: json.encode({
        'isFavourite': isFavourite,
      }),
    );

    if (res.statusCode >= 400) {
      _setFavouriteStatus(!isFavourite);
      throw HttpException('Could not change product favourite status');
    }
  }
}
