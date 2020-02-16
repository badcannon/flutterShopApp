import 'package:flutter/foundation.dart';
import '../models/orders_item.dart';
import '../models/cart_item.dart';

class Orders with ChangeNotifier {
  List<OrderItems> orders = [];


  void addOrders({String id, String totalAmount, List<CartItem> cartItems}) {
    orders.insert(
      0,
      OrderItems(
          amount: totalAmount,
          cartItems: cartItems,
          id: id,
          dateTime: DateTime.now()),
    );
    notifyListeners();
  }

}
