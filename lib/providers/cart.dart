import '../models/cart_item.dart';
import 'package:flutter/foundation.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> items = {};

  int get itemNumber {
    return items.length;
  }

  double get total {
    double total = 0.0;
    items.forEach((string, cart) {
      total += cart.price;
    });
    return total;
  }

  void addItem(
    String id,
    String title,
    double price,
  ) {
    if (items.containsKey(id)) {
      items.update(
          id,
          (cartItem) => CartItem(
              id: cartItem.id,
              price: cartItem.price + price,
              quantity: cartItem.quantity + 1,
              title: cartItem.title));
    } else {
      items.putIfAbsent(
          id,
          () => CartItem(
              id: DateTime.now().toString(),
              price: price,
              quantity: 1,
              title: title));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if(!items.containsKey(productId)){
      return;
    }
    if(items[productId].quantity == 1){
      items.remove(productId);
    }
    else{
      items.update(productId, (item){
         return CartItem(id: item.id, price: item.price, quantity: item.quantity -1,
         title: item.title);
      
      });
    }   
    notifyListeners();
  }
  void clear(){
    items.clear();
    notifyListeners();
  }
}
