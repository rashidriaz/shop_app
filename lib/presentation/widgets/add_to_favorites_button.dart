import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/product.dart';


class AddToFavoritesButton extends StatefulWidget{
  Product loadedProduct;
  Auth authData;

  AddToFavoritesButton({@required this.loadedProduct, @required this.authData});
  @override
  _AddToFavoritesButtonState createState() => _AddToFavoritesButtonState();
}

class _AddToFavoritesButtonState extends State<AddToFavoritesButton>{


  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).secondaryHeaderColor),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 10, horizontal: widget.loadedProduct.isFavorite? 5: 20))),
      onPressed: () {
        setState(() {
          widget.loadedProduct.toggleFavoriteStatus(
              widget.authData.token, widget.authData.userId);
        });
      },
      icon: Icon(widget.loadedProduct.isFavorite
          ? Icons.favorite
          : Icons.favorite_border),
      label: Text(widget.loadedProduct.isFavorite
          ? "Remove from Favorites"
          : "Add to favorites"),
    );
  }

}