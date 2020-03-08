import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';
import '../models/cart_item.dart';

class OrderItems extends StatefulWidget {
  final int index;
  final List<CartItem> products;
  OrderItems({
    @required this.index,
    @required this.products,
  });

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    var orders = Provider.of<Orders>(context);
    return Column(
      children: <Widget>[
        Card(
          child: Column(
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                height: _isExpanded
                    ? min(widget.products.length * 20.0 + 50, 100)
                    : 95,
                child: ListTile(
                  title: Text("\$${orders.orders[widget.index].amount}"),
                  subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                      .format(orders.orders[widget.index].dateTime)),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more),
                  ),
                ),
              ),
              if (_isExpanded)
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  child: Container(
                    height: min(widget.products.length * 20.0 + 100, 200),
                    child: ListView(
                      children: widget.products.map((items) {
                        return ListTile(
                          leading: Chip(label: Text("\$${items.price}")),
                          title: Text(
                            "${items.title}",
                            style: Theme.of(context).textTheme.title,
                          ),
                          subtitle: Text(
                            "x ${items.quantity}",
                            style: TextStyle(color: Colors.grey),
                          ),
                          // trailing: Text("X"),
                        );
                      }).toList(),
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
