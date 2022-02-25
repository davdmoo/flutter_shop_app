import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/cart.dart";

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String name;

  CartItem(this.id, this.price, this.quantity, this.name, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Please Confirm"),
            content: const Text("Do you want to remove this item from the cart?"),
            elevation: 5,
            actions: <Widget>[
              TextButton(
                child: Text("No"),
                onPressed: () {
                  // this will close the dialog and forward the value
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  // ctx is from the builder function
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: FittedBox(
                  child: Text("\$ $price")
                ),
              ),
            ),
            title: Text(name),
            subtitle: Text("Total: \$ ${price * quantity}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}