import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-details";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments;
    final loadedProduct = Provider.of<Products>(context).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            Card(
                child: Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.cover,
            )),
            Container(
              child: Text(
                loadedProduct.title,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text("\$${loadedProduct.price}",
                style: Theme.of(context).textTheme.subtitle),
            SizedBox(
              height: 10,
            ),
            Text(loadedProduct.description,style: Theme.of(context).textTheme.subhead,)
          ],
        ),
      ),
    );
  }
}
