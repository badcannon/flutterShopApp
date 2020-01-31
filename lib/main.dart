import 'package:flutter/material.dart';
import 'package:section8_app/screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.deepPurple
      ),
      routes: {
        ProductsOverviewScreen.routeName : (ctx) => ProductsOverviewScreen(),
      },
    );
  }
}
