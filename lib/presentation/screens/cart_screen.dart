import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/presentation/widgets/cart_screen_order_button.dart';
import 'package:shop_app/presentation/widgets/empty_cart_screen.dart';
import 'package:shop_app/providers/cart_provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: cart.items.length == 0
          ? EmptyCartScreen()
          : Column(
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


