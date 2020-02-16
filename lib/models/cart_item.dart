import 'package:flutter/foundation.dart';


class CartItem {

  final String id;
  final String title;
  final double price;
  int quantity;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title
  });

}