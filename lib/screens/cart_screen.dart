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
                  OrderButton(cart: cart, orders: orders)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
    required this.orders,
  }) : super(key: key);

  final Cart cart;
  final Orders orders;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    bool isLoading = false;

    return TextButton(
      onPressed: () async {
        if (widget.cart.totalAmount > 0) {
          setState(() => isLoading = true);
          await widget.orders.addOrder(widget.cart.items, widget.cart.totalAmount);
          widget.cart.clear();
          setState(() => isLoading = false);
          navigator.pushNamed(OrdersScreen.path);
        }
      },
      child: Text(isLoading ? 'Ordering...' : 'Order now'),
    );
  }
}
