import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';

class ProductEditItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String id;

  ProductEditItem({this.id, this.imageUrl, this.title});
  @override
  Widget build(BuildContext context) {
    final scaffoldOf = Scaffold.of(context);
    Widget cancleButton = FlatButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text("Cancle"),
    );
    Widget okButton = FlatButton(
      onPressed: () async {
        try {
          Navigator.of(context).pop();
          await Provider.of<Products>(context, listen: false).deleteItem(id);
          scaffoldOf.showSnackBar(new SnackBar(
            content: Text("Deleted successfully !! "),
            elevation: 5,
          ));
        } catch (error) {
          scaffoldOf.showSnackBar(new SnackBar(
            content: Text("Deleting Failed ! "),
            elevation: 5,
          ));
        }
      },
      child: Text("Ok"),
    );

    AlertDialog alert = AlertDialog(
      title: Text('Are you sure ?'),
      content: Text('You are about to delete it permanently '),
      actions: <Widget>[
        cancleButton,
        okButton,
      ],
    );

    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title),
          trailing: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName, arguments: id);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.yellow,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    return showDialog(
                      context: context,
                      builder: (btx) => alert,
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                )
              ],
            ),
            width: 100,
          ),
        ),
        Divider(),
      ],
    );
  }
}
