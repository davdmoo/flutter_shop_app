import "package:flutter/material.dart";

import "../widgets/products_grid.dart";
import "../providers/products_provider.dart";

class ProductsOverview extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop App"),
      ),
      body: ProductsGrid(),
    );
  }
}