import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/presentation/widgets/nothing_to_show.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavoritesOnly;

  ProductsGrid(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    List<Product> products =
        showFavoritesOnly ? productsData.favoriteItems : productsData.items;
    return products.length == 0
        ? EmptyScreen()
        : GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: products.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
  }
}
