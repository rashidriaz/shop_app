import "package:flutter/material.dart";
import 'package:shop_app/presentation/screens/product_overview_screen/components/app_bar_actions.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../../widgets/app_drawer.dart';
import 'widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../../../modals/filter_options.dart';

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverViewScreen> {
  bool _showFavoritesOnly = false;
  bool _isInitState = true;
  bool _isLoading = false;

  Future<void> _refreshScreen(BuildContext context) async {
    try {
      await Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts(filterByUser: false);
    } catch (error) {
      print("error in overview _refresh method");
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInitState) {
      setState(() {
        _isLoading = true;
      });
      try {
        Provider.of<Products>(context)
            .fetchAndSetProducts(filterByUser: false)
            .then((_) => _isLoading = false);
      } catch (error) {
        print("error in overview did change dependency");
      }
    }
    _isInitState = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: appBarActions(
            context: context,
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            }),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshScreen(context),
              child: ProductsGrid(_showFavoritesOnly),
            ),
    );
  }
}
