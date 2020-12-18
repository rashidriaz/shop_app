import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) => CartScreenItem(
                id: cart.items[index].id,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total:",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                        color:
                            // ignore: deprecated_member_use
                            Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  OrderButton(cart),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
      builder: (_, orders, child) => FlatButton(
        color: Theme.of(context).primaryColor,
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
