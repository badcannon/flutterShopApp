import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
                size: 40,
              ),
              Spacer(
                flex: 1,
              ),
              // Icon(
              //   Icons.delete,
              //   color: Colors.white,
              //   size: 40,
              // ),
              // Text(
              //   "X1",
              //   style:
              //       TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              // ),
            ]),
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd)
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        //  Fix this up !
        // else
        //   Provider.of<Cart>(context, listen: false).removeSingleItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Are you sure?",style: Theme.of(context).textTheme.title,),
                content: Text("You are about to delete this item !"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text("Yes"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: Text("No"),
                  ),
                ],
              );
            });
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
