import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer_items.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';
import '../widgets/products_edit_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductEditScreen extends StatelessWidget {
  static const routeName = "/user-edit-screen";

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    AppBar appbars = AppBar(
      title: Text(
        "Edit",
        style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          },
          icon: Icon(Icons.add),
          color: Colors.white,
        )
      ],
    );

    return Scaffold(
      appBar: appbars,
      drawer: Drawer(
        child: DrawerItems(),
      ),
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.done
              ?  RefreshIndicator(
                  onRefresh: () {
                    return refreshProducts(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height -
                        appbars.preferredSize.height * 1,
                    child: Consumer<Products>(
                      builder: (bctx, product, child) {
                        return ListView.builder(
                          itemBuilder: (_, index) {
                            return ProductEditItem(
                              id: product.items[index].id,
                              title: product.items[index].title,
                              imageUrl: product.items[index].imageUrl,
                            );
                          },
                          itemCount: product.items.length,
                        );
                      },
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )
      ),
    );
  }
}
