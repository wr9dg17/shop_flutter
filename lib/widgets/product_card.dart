import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_flutter/providers/product.dart';
import 'package:shop_flutter/providers/cart.dart';
import 'package:shop_flutter/screens/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.read<Cart>();
    final product = context.read<Product>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: Icon(product.isFavourite ? Icons.favorite : Icons.favorite_outline),
              onPressed: () async {
                scaffoldMessenger.hideCurrentSnackBar();
                try {
                  await product.toggleFavourite();
                } catch (err) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text(err.toString()))
                  );
                }
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              scaffoldMessenger.hideCurrentSnackBar();
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: const Text('Added item to cart'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                )
              );
            },
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.path, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
