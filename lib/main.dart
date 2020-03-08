import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section8_app/screens/splash_screen.dart';
import './providers/auth.dart';
import 'package:section8_app/screens/orders_screen.dart';
import 'package:section8_app/screens/user_product_edit_screen.dart';
import './providers/products_provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './helpers/custom_page_transition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (bctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          // The proxy provider depends on the provider above and is used given to generic types here the products and auth
          // from the data was supposed to be taken ! we couldnt just use the provider.of() cuz it was from one provider to another !

          update: (ctx, authData, previousProducts) {
            return Products(
              authData.token,
              authData.userId,
              previousProducts == null ? [] : previousProducts.items,
            );
          },
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, authdata, previousOrders) => Orders(
            authdata.token,
            authdata.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authdata, child) => MaterialApp(
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.deepPurple,
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransition(),
              TargetPlatform.iOS: CustomPageTransition(),
            }),
          ),
          // home: authdata.auth ? ProductsOverviewScreen() : AuthScreen(),
          home: authdata.auth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: authdata.autoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductEditScreen.routeName: (ctx) => UserProductEditScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
