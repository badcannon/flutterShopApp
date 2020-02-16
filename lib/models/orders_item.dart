import '../models/cart_item.dart';
import 'package:flutter/foundation.dart';

class OrderItems {
  @required final String id;
  @required final String amount;
  @required final List<CartItem> cartItems;
  @required final DateTime dateTime;

  OrderItems({
    this.id,
    this.amount,
    this.cartItems,
    this.dateTime ,
  });
}
