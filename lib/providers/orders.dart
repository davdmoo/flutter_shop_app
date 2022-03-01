import "dart:convert";

import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;

import "./cart.dart";

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse("https://flutter-shop-app-ef36c-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken");
    
    try {
      final response = await http.get(url);
      final List<OrderItem> fetchedOrders = [];
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;

      if(fetchedData == null) return;

      fetchedData.forEach((orderId, order) {
        fetchedOrders.add(OrderItem(
          id: orderId,
          amount: order["amount"],
          dateTime: DateTime.parse(order["dateTime"]),
          products: (order["products"] as List<dynamic>).map((el) => CartItem(
            id: el["id"],
            name: el["name"],
            price: el["price"],
            quantity: el["quantity"],
          )).toList(),
        ));
      });
      _orders = fetchedOrders.reversed.toList();

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse("https://flutter-shop-app-ef36c-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken");
    final timeStamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "amount": total,
          "dateTime": timeStamp.toIso8601String(),
          "products": cartProducts.map((item) => {
            "id": item.id,
            "name": item.name,
            "quantity": item.quantity,
            "price": item.price,
          }).toList(),
        }),
      );

      _orders.insert(0, OrderItem(
          id: json.decode(response.body)["name"],
          amount: total,
          dateTime: timeStamp,
          products: cartProducts,
        ),
      );

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}