import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../widgets/main_drawer.dart";
import "../widgets/user_product_item.dart";
import "../providers/products_provider.dart";
import "../screens/edit_products_screen.dart";

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user/products";

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName
              );
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, idx) => Column(
            children: <Widget>[
              UserProductItem(
                productsData.items[idx].id,
                productsData.items[idx].name,
                productsData.items[idx].imageUrl,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
