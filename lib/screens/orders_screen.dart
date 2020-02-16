import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/drawer_items.dart';
import '../widgets/order_items.dart' as ord;
import 'package:intl/intl.dart';



class OrderScreen extends StatelessWidget {
  static const String routeName = "/orders-screen";
  @override
  Widget build(BuildContext context) {
    var orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders",
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: Colors.white)),
      ),
      body: Container(
          child: ListView.builder(
        itemBuilder: (ctx, index) {
          return ord.OrderItems(
            index: index,
            products:orders.orders[index].cartItems,
          );
        },
        itemCount: orders.orders.length,
      )),
      drawer: Drawer(
        child: DrawerItems(),
      ),
    );
  }
}
