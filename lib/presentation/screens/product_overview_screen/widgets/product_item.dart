import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart_provider.dart';
import '../../product_detail_screen.dart';
import '../../../../providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,),
                    color: Theme.of(context).secondaryHeaderColor,
                    onPressed: () {
                      product.toggleFavoriteStatus(
                          authData.token, authData.userId);
                    },
                  )),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(
                  productId: product.id,
                  price: product.price,
                  title: product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              addSnackBarWithTheMessageAndUnDoOption(context, () {
                cart.decreaseQuantityOfTheItem(id: product.id);
              });
            },
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController addSnackBarWithTheMessageAndUnDoOption(
      BuildContext context, Function function) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Added Item to Cart",
        ),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: function,
        ),
      ),
    );
  }
}
