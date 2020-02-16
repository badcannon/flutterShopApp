import 'package:flutter/material.dart';

class CartIcon extends StatelessWidget {
  final Widget child;
  final String number;
  CartIcon(this.number, this.child);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned(
          right: 7,
          child: Container(
            child: Text(number),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.purple.withOpacity(0.8)),
            width: 15,
          ),
        )
      ],
    );
  }
}
