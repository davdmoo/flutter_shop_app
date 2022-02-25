import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import "../providers/orders.dart" show Orders;
import "../widgets/order_item.dart";
import "../widgets/main_drawer.dart";

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your orders"),
      ),
      drawer: MainDrawer(),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, idx) => OrderItem(ordersData.orders[idx]),
      ),
    );
  }
}