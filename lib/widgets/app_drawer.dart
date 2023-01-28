import 'package:flutter/material.dart';

import 'package:shop_flutter/screens/products_screen.dart';
import 'package:shop_flutter/screens/orders_screen.dart';
import 'package:shop_flutter/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('MyShop'),
            automaticallyImplyLeading: false,
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ProductsScreen.path);
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.path);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.path);
            },
          )
        ],
      ),
    );
  }
}
