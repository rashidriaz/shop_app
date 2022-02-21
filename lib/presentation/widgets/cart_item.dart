import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../screens/product_detail_screen.dart';

class CartScreenItem extends StatelessWidget {
  final String id;

  CartScreenItem({@required this.id});

  BuildContext get context => context;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme
            .of(context)
            .errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(context: context,
            builder: (context) {
              return AlertDialog(title: Text('Are you Sure?'),
                content: Text("Do you want to remove this item from the cart?"),
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("No"),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("Yes"),
                  ),
                ],);
            });
      },
      onDismissed: (_) {
        cart.removeItem(id);
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: id,
          );
        },
        child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.165,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Card(
          child: Row(
            children: [
              checkBox(),
              Consumer<Products>(
                builder: (_, products, child) =>
                    Image.network(
                      products
                          .findById(id)
                          .imageUrl,
                      fit: BoxFit.fill,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.2,
                    ),
              ),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.05,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleAndDescription(),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${cart
                                .findById(id)
                                .pricePerProduct}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                fontFamily: "Arial",
                                color: Colors.black54),
                          ),
                          quantityWithIncreaseAndDecreaseButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),),
    );
  }

  Widget checkBox() {
    return Consumer<Cart>(
        builder: (_, cart, child) =>
            Container(
              // height: 10,
              // width: MediaQuery.of(context).size.width * 0.2,
                child: Align(
                  alignment: Alignment.center,
                  child: Checkbox(
                      value: cart
                          .findById(id)
                          .isSelected,
                      onChanged: (_) {
                        cart.changeSelectedStatus(id);
                      }),
                )));
  }

  Widget titleAndDescription() {
    return Consumer<Products>(
      builder: (_, products, child) =>
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                products
                    .findById(id)
                    .title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                    fontFamily: 'Arial'),
              ),
              Text(
                products
                    .findById(id)
                    .description,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                    fontFamily: 'Arial'),
              ),
            ],
          ),
    );
  }

  Widget quantityWithIncreaseAndDecreaseButton() {
    return Consumer<Cart>(
        builder: (_, cart, child) =>
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.remove_circle_rounded),
                  tooltip: 'Decrease Quantity By 1',
                  onPressed: () {
                    cart.decreaseQuantityOfTheItem(id: id);
                  },
                ),
                Text(
                  "${cart
                      .findById(id)
                      .quantity}",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontFamily: 'Arial'),
                ),
                IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.add_circle_rounded),
                  tooltip: 'Increase Quantity By 1',
                  onPressed: () {
                    cart.increaseQuantityOfTheItem(id: id);
                  },
                ),
              ],
            ));
  }
}
