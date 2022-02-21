import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/presentation/widgets/badge.dart';
import 'package:shop_app/providers/cart_provider.dart';
import '../../cart_screen.dart';

Widget addCartIcon(BuildContext context) {
  return Consumer<Cart>(
    builder: (_, cart, child) => cart.itemCount == 0
        ? child
        : Badge(
      color: Theme.of(context).secondaryHeaderColor,
      child: child,
      value: cart.itemCount.toString(),
    ),
    child: IconButton(
      icon: Icon(Icons.shopping_cart),
      onPressed: () {
        Navigator.of(context).pushNamed(CartScreen.routeName);
      },
    ),
  );
}