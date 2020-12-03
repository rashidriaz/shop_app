import "package:flutter/material.dart";
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOption {
  All,
  Favorites,
}

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverViewScreen> {
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorites"),
                value: FilterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOption.All,
              ),
            ],
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            },
          ),
          addCartIcon(),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showFavoritesOnly),
    );
  }

  Widget addCartIcon(){
      return Consumer<Cart>(
        builder: (_, cart, child)=> cart.itemCount == 0? child : Badge(
          child: child,
          value: cart.itemCount.toString(),
        ),
        child: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed:(){
            Navigator.of(context).pushNamed(CartScreen.routeName);
          },
        ),
      );

  }
}
