import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_flutter/providers/orders.dart';
import 'package:shop_flutter/widgets/order_item.dart';
import 'package:shop_flutter/widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const path = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = context.read<Orders>().items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, i) => OrderItem(order: orders[i])
      ),
    );
  }
}
