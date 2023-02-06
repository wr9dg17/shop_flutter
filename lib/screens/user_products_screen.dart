import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_flutter/providers/products.dart';
import 'package:shop_flutter/screens/edit_product_screen.dart';
import 'package:shop_flutter/widgets/app_drawer.dart';
import 'package:shop_flutter/widgets/user_product_card.dart';

class UserProductsScreen extends StatelessWidget {
  static const path = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Products>().items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.path),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return context.read<Products>().fetchProducts();
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            itemCount: products.length,
            itemBuilder: (ctx, i) => UserProductCard(
              id: products[i].id,
              title: products[i].title,
              imageUrl: products[i].imageUrl,
            ),
            separatorBuilder: (ctx, i) => const Divider(),
          ),
        ),
      ),
    );
  }
}
