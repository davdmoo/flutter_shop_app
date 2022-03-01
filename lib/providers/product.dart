import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool favoriteStatus) {
    isFavorite = favoriteStatus;
      notifyListeners();
  }

  Future<void> favoriteHandler(String authToken, String userId) async {
    final url = Uri.parse("https://flutter-shop-app-ef36c-default-rtdb.asia-southeast1.firebasedatabase.app/favorites/$userId/$id.json?auth=$authToken");
    final oldStatus = isFavorite;

    try {
      isFavorite = !isFavorite;
      notifyListeners();

      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );

      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (error) {
      _setFavoriteValue(oldStatus);

      throw (error);
    }
  }
}