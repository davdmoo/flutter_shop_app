import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import "../providers/cart.dart" show Cart;
import "../widgets/cart_item.dart";

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$ ${cart.totalAmount}",
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.headline6.color,
                      )
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  TextButton(
                    child: const Text("ORDER NOW"),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, idx) => CartItem(
                cart.items.values.toList()[idx].id,
                cart.items.values.toList()[idx].price,
                cart.items.values.toList()[idx].quantity,
                cart.items.values.toList()[idx].name,
                cart.items.keys.toList()[idx],
              ),
            ),
          ),
        ],
      ),
    );
  }
}