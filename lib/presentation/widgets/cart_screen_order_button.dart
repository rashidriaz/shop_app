import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';

class OrderButton extends StatefulWidget {
  final Cart cart;

  const OrderButton(this.cart);

  @override
  _OrderButtonState createState() {
    return _OrderButtonState(cart);
  }
}

class _OrderButtonState extends State<OrderButton> {
  final Cart cart;

  _OrderButtonState(this.cart);

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<Orders>(
      builder: (_, orders, child) => TextButton(
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
        ),
        onPressed: (cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
          setState(() {
            _isLoading = true;
          });
          await orders.addOrder(cart.selectedItems, cart.totalAmount);
          setState(() {
            _isLoading = false;
          });
          cart.removeSelectedItems();
        },
        child: child,
      ),
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
        "ORDER NOW",
        style: TextStyle(
            color: cart.totalAmount <= 0 ? Colors.black54 : Colors.white),
      ),
    );
  }
}