import "package:flutter/material.dart";

import "../screens/edit_products_screen.dart";

class UserProductItem extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;

  UserProductItem(this.id, this.name, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 96,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id,
                );
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}