import "dart:convert";

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import "./product.dart";

// mix-in
class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      name: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      name: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      name: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      name: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    // if (_showFavoritesOnly) return _items.where((prod) => prod.isFavorite).toList();

    return [..._items]; 
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id)  {
    return _items.firstWhere((product) => product.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;

  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;

  //   notifyListeners();
  // }

  void addProduct(Product product) {
    final url = Uri.parse("https://flutter-shop-app-ef36c-default-rtdb.asia-southeast1.firebasedatabase.app/products.json");
    http.post(
      url,
      body: json.encode({
        "name": product.name,
        "description": product.description,
        "imageUrl": product.imageUrl,
        "price": product.price,
        "isFavorite": product.isFavorite,
      }),
    );
    
    final newProduct = Product(
      id: DateTime.now().toString(),
      name: product.name,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
    );

    _items.add(newProduct);

    notifyListeners();
  }

  void updateProduct(String id, Product productBody) {
    final prodIndex = _items.indexWhere((product) => product.id == id);

    if (prodIndex >= 0) {
      _items[prodIndex] = productBody;

      notifyListeners();
    }
    
  }

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);

    notifyListeners();
  }
}