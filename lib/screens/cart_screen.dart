import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_flutter/providers/cart.dart';
import 'package:shop_flutter/providers/orders.dart';
import 'package:shop_flutter/screens/orders_screen.dart';
import 'package:shop_flutter/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const path = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    final orders = context.read<Orders>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    child: const Text('Order now'),
                    onPressed: () {
                      orders.addOrder(cart.items, cart.totalAmount);
                      cart.clear();
                      Navigator.of(context).pushNamed(OrdersScreen.path);
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCount,
              itemBuilder: (ctx, i) => CartItem(
                id: cart.items[i].id,
                productId: cart.keys[i],
                title: cart.items[i].title,
                qty: cart.items[i].qty,
                price: cart.items[i].price,
              ),
            ),
          )
        ],
      ),
    );
  }
}
