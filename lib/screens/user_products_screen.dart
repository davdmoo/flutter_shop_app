import "package:flutter/material.dart";
import 'package:flutter_complete_guide/providers/product.dart';
import "package:provider/provider.dart";

import "../widgets/main_drawer.dart";
import "../widgets/user_product_item.dart";
import "../providers/products_provider.dart";
import "../screens/edit_products_screen.dart";

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user/products";

  Future<void> _refreshProducts(BuildContext context) async {
    // to avoid unnecessary products rebuild, listen to false is added
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print("REBUILDING..");

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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<Products>(
            builder: (ctx, productsData, _) => Padding(
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
          ),
        ),
      ),
    );
  }
}
