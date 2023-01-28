import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_flutter/providers/products.dart';
import 'package:shop_flutter/providers/cart.dart';
import 'package:shop_flutter/screens/cart_screen.dart';
import 'package:shop_flutter/widgets/app_drawer.dart';
import 'package:shop_flutter/widgets/product_card.dart';
import 'package:shop_flutter/widgets/badge.dart';

enum ProductsFilterOptions {
  all,
  favourites,
}

class ProductsScreen extends StatefulWidget {
  static const path = '/products';

  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool showFavourites = false;

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Products>();
    final productsList = showFavourites ? products.favouriteItems : products.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              value: '${cart.itemsCount}',
              child: child as Widget,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.path);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (ProductsFilterOptions value) {
              setState(() {
                showFavourites = value == ProductsFilterOptions.favourites;
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: ProductsFilterOptions.all,
                child: Text('Show all'),
              ),
              const PopupMenuItem(
                value: ProductsFilterOptions.favourites,
                child: Text('Only favourites'),
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: productsList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) {
          return ChangeNotifierProvider.value(
            value: productsList[i],
            child: const ProductCard(),
          );
        },
      ),
    );
  }
}
