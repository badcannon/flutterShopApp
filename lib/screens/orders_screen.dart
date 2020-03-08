import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/drawer_items.dart';
import '../widgets/order_items.dart' as ord;
import 'package:intl/intl.dart';

class OrderScreen extends StatelessWidget {
  static const String routeName = "/orders-screen";

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // var orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders",
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: Colors.white)),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => ord.OrderItems(
                    index: i,
                    products: orderData.orders[i].cartItems,
                  ),
                ),
              );
            }
          }
        },
      ),
      drawer: Drawer(
        child: DrawerItems(),
      ),
    );
  }
}
