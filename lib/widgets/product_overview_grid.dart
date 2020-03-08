import 'package:flutter/material.dart';
import '../widgets/products_overview_item.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductOverviewGrid extends StatelessWidget {
  final bool favsOnly;
  ProductOverviewGrid(this.favsOnly);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = favsOnly ? productsData.favitems : productsData.items;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // 3 to height and 2 to width !
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      itemBuilder: (_, index) {
        return Container(
          child: ChangeNotifierProvider.value(
            // create: (bctx) => products[index],
            value: products[index],
            child: ProductOverviewItem(
                // title: products[index].title,
                // imageUrl: products[index].imageUrl,
                // id: products[index].id,
                ),
          ),
        );
      },
      itemCount: products.length,
    );
  }
}

// diff b/w .value and not .value
// When using a gridview or a listview and then uing a provider then there will be a problem
// since the widget will be the same and the state or the data will be changed , so there for by using the .value constructor
// we bind the widget to the state or data there by reduing that anomali!
// The data generated from the provider is cleaned automatically by the changenotifer provider

// Each product object will now have a seperate provider , Here if we dont use the .value constructor then the widget will be reused
// and the state is changed , this will result in some strange errors ! , this whole thing happens due to the lazy loading !
//
