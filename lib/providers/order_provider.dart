import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';
import "package:http/http.dart" as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime time;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.time});
}

class Orders extends ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(
    List<CartItem> cartItems,
    double total,
  ) async {
    final timeStamp = DateTime.now();
    final url =
        "https://flutter-practice-shopapp-4b993-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.post(
      url,
      body: json.encode( 
        {
          "amount": total,
          "dateTime": timeStamp.toIso8601String(),
          "products": cartItems
              .map(
                (element) => {
                  "id": element.id,
                  "title": element.title,
                  "quantity": element.quantity,
                  "price": element.pricePerProduct,
                },
              )
              .toList(),
        },
      ),
    );
    if (total == 0) return;
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartItems,
        time: timeStamp,
      ),
    );
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        "https://flutter-practice-shopapp-4b993-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((id, data) {
      loadedOrders.add(OrderItem(
        id: id,
        amount: data['amount'],
        time: DateTime.parse(data['dateTime']),
        products: (data['products'] as List<dynamic>).map((item) {
          return CartItem(
              id: item['id'],
              title: item['title'],
              pricePerProduct: item['price'],
              quantity: item['quantity']);
        }).toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
