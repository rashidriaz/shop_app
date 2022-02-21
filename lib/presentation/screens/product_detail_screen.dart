import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/presentation/widgets/add_to_favorites_button.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final id = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Hero(
                tag: id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "\$${loadedProduct.price}",
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            SizedBox(
              height: 7,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                loadedProduct.description,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                ),
                softWrap: true,
              ),
            ),
            SizedBox(
              height: 240,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                AddToFavoritesButton(
                    loadedProduct: loadedProduct, authData: authData),
                Spacer(),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    ),
                  ),
                  onPressed: () {
                    cart.addItem(
                        productId: loadedProduct.id,
                        price: loadedProduct.price,
                        title: loadedProduct.title);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    addSnackBarWithTheMessageAndUnDoOption(context, () {
                      cart.decreaseQuantityOfTheItem(id: loadedProduct.id);
                    });
                  },
                  icon: Icon(Icons.shopping_cart),
                  label: Text(loadedProduct.isFavorite
                      ? "Remove from Favorites"
                      : "Add to favorites"),
                ),
                Spacer(),
              ],
            )
          ],
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
