import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section8_app/providers/cart.dart';
import 'package:section8_app/widgets/drawer_items.dart';
import '../widgets/product_overview_grid.dart';
import '../widgets/cart_icon.dart';
import '../screens/cart_screen.dart';

enum FiltersOption {
  All,
  Favorites,
}

class ProductsOverviewScreen extends StatefulWidget {
  // Route name for the home page
  static const routeName = "/";

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var favsOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Icon(Icons.shopping_cart),
            SizedBox(
              width: 3,
            ),
            Text("My Shop")
          ],
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FiltersOption selectedValue) {
              setState(() {
                if (selectedValue == FiltersOption.Favorites) {
                  favsOnly = true;
                } else {
                  favsOnly = false;
                }
              });
            },
            itemBuilder: (bctx) {
              return [
                PopupMenuItem(
                  child: Text("Only Favorites"),
                  value: FiltersOption.Favorites,
                ),
                PopupMenuItem(
                  child: Text("All"),
                  value: FiltersOption.All,
                ),
              ];
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
            builder: (_, cart, child) => CartIcon(
              cart.itemNumber.toString(),
              child,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: DrawerItems(),  
      ),
      body: ProductOverviewGrid(favsOnly),
    );
  }
}
