import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/user_product_screen/user_product_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: Text("Hello User"),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("Shop"),
          onTap: () => Navigator.of(context).pushReplacementNamed("/"),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text("Orders"),
          onTap: () =>
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Manage Products"),
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(UserProductScreen.routeName),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Log Out!"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed("/");
            Provider.of<Auth>(context, listen: false).logOut();
          },
        ),
      ],
    ));
  }
}
