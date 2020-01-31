import 'package:flutter/material.dart';
import '../widgets/products_overview_item.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductOverviewGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // 3 to height and 2 to width !
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      itemBuilder: (_, index) {
        return new Container(
          child: ProductOverviewItem(
            title: products[index].title,
            imageUrl: products[index].imageUrl,
            id: products[index].id,
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
