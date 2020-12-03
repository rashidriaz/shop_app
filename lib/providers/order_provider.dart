import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';

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

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(
    List<CartItem> cartItems,
    double total,
  ) {
    if(total == 0)return;
     _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartItems,
        time: DateTime.now(),
      ),
    );
  }
}
