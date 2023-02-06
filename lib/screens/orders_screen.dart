import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_flutter/providers/orders.dart';
import 'package:shop_flutter/widgets/order_item.dart';
import 'package:shop_flutter/widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const path = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;

  Future _fetchOrdersFuture() {
    return context.read<Orders>().fetchOrders();
  }

  @override
  void initState() {
    _ordersFuture = _fetchOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, data, child) {
                return ListView.builder(
                  itemCount: data.items.length,
                  itemBuilder: (ctx, i) => OrderItem(order: data.items[i]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
