import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/products_provider.dart";
import "./product_item.dart";

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  
  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, idx) => ChangeNotifierProvider.value(
        // create: (c) => products[idx],
        value: products[idx], // .value method is preferrable since it's a grid view
        child: ProductItem(
        // products[idx].id,
        // products[idx].name,
        // products[idx].imageUrl,
        // products[idx].price,
        ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // define number of columns
        childAspectRatio: 3 / 2, // define height(3) to width(2) ratio
        crossAxisSpacing: 10, // define spacing between col
        mainAxisSpacing: 10, // define spacing between row
      ),
    );
  }
}