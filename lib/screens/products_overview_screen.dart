import 'package:flutter/material.dart';
import 'package:section8_app/widgets/products_overview_item.dart';
import '../widgets/product_overview_grid.dart';
import '../models/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Icon(Icons.shopping_cart ),
            SizedBox(width: 3,),
            Text("My Shop")
          ],
        ),
      ),
      body: ProductOverviewGrid(),
    );
  }
}
