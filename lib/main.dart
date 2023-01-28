import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_flutter/providers/products.dart';
import 'package:shop_flutter/providers/cart.dart';
import 'package:shop_flutter/providers/orders.dart';

import 'package:shop_flutter/screens/products_screen.dart';
import 'package:shop_flutter/screens/product_details_screen.dart';
import 'package:shop_flutter/screens/cart_screen.dart';
import 'package:shop_flutter/screens/orders_screen.dart';
import 'package:shop_flutter/screens/user_products_screen.dart';
import 'package:shop_flutter/screens/edit_product_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ListenableProvider(create: (ctx) => Products()),
        ListenableProvider(create: (ctx) => Cart()),
        ListenableProvider(create: (ctx) => Orders()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
            .copyWith(secondary: Colors.deepOrange),
      ),
      initialRoute: ProductsScreen.path,
      routes: {
        ProductsScreen.path: (cotext) => const ProductsScreen(),
        ProductDetailsScreen.path: (cotext) => const ProductDetailsScreen(),
        CartScreen.path: (context) => const CartScreen(),
        OrdersScreen.path: (context) => const OrdersScreen(),
        UserProductsScreen.path: (context) => const UserProductsScreen(),
        EditProductScreen.path: (context) => const EditProductScreen(),
      },
    );
  }
}
