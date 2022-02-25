import "package:flutter/material.dart";
import "package:provider/provider.dart";

import '../providers/product.dart';
import "../screens/product_detail_screen.dart";
import "../providers/cart.dart";

class ProductItem extends StatelessWidget {
  // final String id;
  // final String name;
  // final String imageUrl;
  // final double price;

  // ProductItem(this.id, this.name, this.imageUrl, this.price);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        header: Container(
          color: Colors.black38,
          child: Text(
            product.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetail.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              product.favoriteHandler();
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            "\$ ${product.price.toString()}",
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.name);

              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("Added item to cart!"),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).colorScheme.secondary,
          )
        ),
      ),
    );
  }
}