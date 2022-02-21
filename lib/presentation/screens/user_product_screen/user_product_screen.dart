import 'package:flutter/material.dart';
import 'package:shop_app/presentation/widgets/nothing_to_show.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_drawer.dart';
import '../edit_product_screen.dart';
import 'widgets/user_product_item.dart';
import 'components/user_product_screen_app_bar.dart' as app_bar;

class UserProductScreen extends StatelessWidget {
  static const routeName = "./UserProductsScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: app_bar.userProductScreenAppBar(onPressedForActionButton: () {
        Navigator.of(context).pushNamed(EditProductScreen.routeName);
      }),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshScreen(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshScreen(context),
                child: Consumer<Products>(
                  builder: (context, products, _) => products.items.length == 0
                      ? EmptyScreen()
                      : Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: products.items.length,
                            itemBuilder: (_, index) => Column(
                              children: [
                                UserProductItem(
                                    products.items[index].title,
                                    products.items[index].imageUrl,
                                    products.items[index].id),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
      ),
    );
  }

  Future<void> _refreshScreen(BuildContext context) async {
    try {
      await Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts(filterByUser: true);
    } catch (error) {
      print("Error in user Screen");
    }
  }
}
