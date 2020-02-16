import 'package:flutter/material.dart';
import 'package:section8_app/screens/orders_screen.dart';
import '../screens/user_product_edit_screen.dart';
class DrawerItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.shopping_cart,
                size: 40,
                color: Theme.of(context).accentColor,
              ),
              Text(
                "My Shop",
                style: TextStyle(
                  fontSize: 40,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          color: Theme.of(context).primaryColor,
          width: double.infinity,
          height: 100,
        ),
        Container(
          color: Theme.of(context).primaryColorLight,
          child: ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
            leading: Icon(
              Icons.credit_card,
              size: 30,
              color: Theme.of(context).accentColor,
            ),
            title: Text("Orders",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).accentColor)),
          ),
        ),
        // Divider(thickness: 1.2,color: Theme.of(context).accentColor,),
         Container(
          color: Theme.of(context).primaryColorLight,
          child: ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            leading: Icon(
              Icons.add_shopping_cart,
              size: 30,
              color: Theme.of(context).accentColor,
            ),
            title: Text("Shop",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).accentColor)),
          ),
        ),
           Container(
          color: Theme.of(context).primaryColorLight,
          child: ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductEditScreen.routeName);
            },
            leading: Icon(
              Icons.edit_attributes,
              size: 30,
              color: Theme.of(context).accentColor,
            ),
            title: Text("Manage Products",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).accentColor)),
          ),
        )
      ],
    );
  }
}
