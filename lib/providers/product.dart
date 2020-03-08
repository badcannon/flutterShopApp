import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

// Implementing the ChangeNotifier so that we can listen to changes in the isFavorite or any other parameter /

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.description,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    var oldIsfav = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        "https://flutter-d0945.firebaseio.com/userFavs/$userId/$id.json?auth=$token";
    var response = await http
        .put(
      url,
      body: json.encode(isFavorite),
    )
        .catchError((_) {
      isFavorite = oldIsfav;
      notifyListeners();
    });
      if (response.statusCode >= 400) {
      isFavorite = oldIsfav;
      notifyListeners();
    }
  }
}
