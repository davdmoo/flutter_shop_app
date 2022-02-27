import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import "../providers/orders.dart" show Orders;
import "../widgets/order_item.dart";
import "../widgets/main_drawer.dart";

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _isLoading = true;

    Provider.of<Orders>(context, listen: false).fetchOrders()
      .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
  }
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your orders"),
      ),
      drawer: MainDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, idx) => OrderItem(ordersData.orders[idx]),
      ),
    );
  }
}