
import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'presentation/screens/auth_screen/auth_screen.dart';
import 'presentation/screens/cart_screen.dart';
import 'presentation/screens/edit_product_screen.dart';
import 'presentation/screens/orders_screen.dart';
import 'presentation/screens/product_detail_screen.dart';
import 'presentation/screens/product_overview_screen/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/user_product_screen/user_product_screen.dart';
import 'helpers/constants.dart' as app_constants;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
          create: null,
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previousOrders) => Orders(auth.token,
              auth.userId, previousOrders == null ? [] : previousOrders.orders),
          create: null,
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'My Shop App',
          debugShowCheckedModeBanner: false,
          theme: app_constants.themeData,
          home: auth.isAuthenticated
              ? ProductsOverViewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapShot) =>
                      authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }




}
