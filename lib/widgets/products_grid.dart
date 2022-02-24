import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/products_provider.dart";
import "./product_item.dart";

class ProductsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, idx) => ProductItem(
        products[idx].id,
        products[idx].name,
        products[idx].imageUrl,
        products[idx].price,
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