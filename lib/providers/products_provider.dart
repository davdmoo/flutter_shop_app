import "dart:convert";

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import "./product.dart";
import "../models/http_exception.dart";

// mix-in
class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   name: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   name: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   name: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   name: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
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

  Future<void> fetchProducts() async {
    try {
      final url = Uri.parse("https://flutter-shop-app-ef36c-default-rtdb.asia-southeast1.firebasedatabase.app/products.json");
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> fetchedProducts = [];

      if (data == null) return;

      data.forEach((productId, productData) {
        fetchedProducts.add(Product(
          id: productId,
          name: productData["name"],
          description: productData["description"],
          price: productData["price"],
          imageUrl: productData["imageUrl"],
          isFavorite: productData["isFavorite"],
        ));
      });
      _items = fetchedProducts;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final url = Uri.parse("https://flutter-shop-app-ef36c-default-rtdb.asia-southeast1.firebasedatabase.app/products.json");
      final response = await http
      .post(
        url,
        body: json.encode({
          "name": product.name,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "isFavorite": product.isFavorite,
        })
      );
        // .then((response) {
      final newProduct = Product(
        id: json.decode(response.body)["name"],
        name: product.name,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);

      notifyListeners();
        // })
        // .catchError((error) {
          // throw error;
        // });
    } catch (error) {
      throw (error);
    }
    
  }

  Future<void> updateProduct(String id, Product productBody) async {
    final url = Uri.parse("https://flutter-shop-app-ef36c-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json");

    try {
      final prodIndex = _items.indexWhere((product) => product.id == id);

      if (prodIndex >= 0) {
        await http
        .patch(
          url,
          body: json.encode({
            "name": productBody.name,
            "description": productBody.description,
            "imageUrl": productBody.imageUrl,
            "price": productBody.price,
          })
        );

        _items[prodIndex] = productBody;

        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }  
  }

  // optimistic updating
  Future<void> deleteProduct(String id) async {
    final url = Uri.parse("https://flutter-shop-app-ef36c-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json");
    final productIndex = _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[productIndex]; // saved in cache
    _items.removeAt(productIndex);
    notifyListeners();
  
    final response = await http.delete(url);
    if(response.statusCode >= 400) {
      // this can be done since the product is first saved into a variable (existingProduct) / cached
      // rerolls deleting from the list
      _items.insert(productIndex, existingProduct);
      notifyListeners();

      throw HttpException("Something went wrong when deleting the product.");
    }

    // clears up the reference so dart can remove the product from the memory
    existingProduct = null;
  }
}