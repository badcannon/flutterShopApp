import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../models/orders_item.dart';
import '../models/cart_item.dart';
import 'package:http/http.dart' as http;

class Orders with ChangeNotifier {
  List<OrderItems> orders = [];

  String token;
  String userId;

  Orders(this.token,this.userId,this.orders);

  Future<void> fetchAndSetOrders() async {
    final url = 'https://flutter-d0945.firebaseio.com/orders/$userId.json?auth=$token';
    final response = await http.get(url);
    final List<OrderItems> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItems(
          id: orderId.toString(),
          amount: orderData["amount"],
           dateTime: DateTime.parse(orderData["dateTime"]),
           cartItems: (orderData["cartItems"] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
          // cartItems: null,
        ),
      );
    });
    orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrders({String totalAmount, List<CartItem> cartItems}) async {
    final dateTime = DateTime.now();
    final url = "https://flutter-d0945.firebaseio.com/orders/$userId.json?auth=$token";
    try {
      var response = await http.post(
        url,
        body: json.encode({
          'amount': totalAmount,
          'cartItems': cartItems.map((item) {
            return {
              'id': item.id,
              'price': item.price,
              'quantity': item.quantity,
              'title': item.title,
            };
          }).toList(),
          'dateTime': dateTime.toIso8601String(),
        }),
      );
      orders.insert(
        0,
        OrderItems(
          amount: totalAmount,
          cartItems: cartItems,
          id: json.decode(response.body)['name'],
          dateTime: dateTime,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
