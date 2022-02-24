import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.name,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;

    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  void addItem (String productId, double price, String name) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (product) => CartItem(
          id: product.id,
          name: product.name,
          price: product.price,
          quantity: product.quantity + 1,
          )
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          name: name,
          price: price,
          quantity: 1,
          )
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);

    notifyListeners();
  }
}