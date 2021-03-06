import 'package:flutter/material.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import 'package:shop_app/widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "./UserProductsScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Product"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshScreen(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshScreen(context),
                    child: Consumer<Products>(
                      builder: (context, products, _) => Padding(
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
    }catch(error){
      print("Error in user Screen");
    }
  }
}
