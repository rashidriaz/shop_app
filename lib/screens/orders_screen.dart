import 'package:flutter/material.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const String routeName = "./OrdersScreen";

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    bool neverPlacedOrder = orders.orders.length < 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Orders",
        ),
      ),
      drawer: AppDrawer(),
      body: (neverPlacedOrder)
          ? Align(
              alignment: Alignment.center,
              child: Text(
                "Nothing to Show here!",
              ),
            )
          : ListView.builder(
              itemCount: orders.orders.length,
              itemBuilder: (context, index) =>
                  OrderScreenItem(orders.orders[index]),
            ),
    );
  }
}
