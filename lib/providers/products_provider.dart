import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:section8_app/models/http_exception.dart';
import './product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
//  The List of items
  List<Product> _items = [];

  String tokenAuth;
  String userId;
  Products(this.tokenAuth, this.userId, this._items);

// Returns a copy of the item
  List<Product> get items {
      return [
      ..._items
    ]; //we are copying the list of items by seperating it using spread operator and then sending the new list
  }

// The above is done since widgets must be notified with the changes in the data hence we cannot allow widgets to update the item list insted we allow it using a method :
  Future<void> addProduct(Product product) async {
    final url =
        "https://flutter-d0945.firebaseio.com/products.json?auth=$tokenAuth";
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'isFavorite': product.isFavorite,
            'imageUrl': product.imageUrl,
            'creatorId': userId
          },
        ),
      );
      Product newProduct = new Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      // The below code will notify all the listners !
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  List<Product> get favitems {
    return _items.where((product) => product.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> updateItem(String id, Product product) async {
    final url =
        'https://flutter-d0945.firebaseio.com/products/$id.json?auth=$tokenAuth';
    try {
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'imageUrl': product.imageUrl,
            'description': product.description,
            'price': product.price,
          }));

      var index = _items.indexWhere((prod) {
        return prod.id == product.id;
      });
      _items[index] = product;
    } catch (error) {
      throw error;
    }
  }

  // Optimistic update :D

  Future<void> deleteItem(String id) async {
    final url =
        'https://flutter-d0945.firebaseio.com/products/$id.json?auth=$tokenAuth';
    final existingProdIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProdData = _items[existingProdIndex];
    _items.removeWhere((prod) => prod.id == id);
    var response = await http.delete(url);
    notifyListeners();
    if (response.statusCode >= 400) {
      _items.insert(existingProdIndex, existingProdData);
      notifyListeners();
      throw HTTPException("Deleting Failed !");
    }
    existingProdData = null;
  }

  // fetch the products from firebase :
  Future<void> fetchProducts([bool filterUser = false]) async {
    var filterString =
        filterUser ? 'orderBy="creatorId"&equalTo="$userId"' : "";
    var url =
        "https://flutter-d0945.firebaseio.com/products.json?auth=$tokenAuth&$filterString";
    try {
      var response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      url =
          "https://flutter-d0945.firebaseio.com/userFavs/$userId.json?auth=$tokenAuth";
      final userFavsResponse = await http.get(url);
      final userFavsResponseData = json.decode(userFavsResponse.body);
      List<Product> fetchedProducts = [];
      extractedData.forEach((prodId, prodData) {
        fetchedProducts.add(new Product(
          id: prodId,
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          title: prodData['title'],
          //  ?? is to check if its null automatically and if so then false will be subbed !
          isFavorite: userFavsResponseData == null
              ? false
              : userFavsResponseData[prodId] ?? false,
        ));
      });
      _items = fetchedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
