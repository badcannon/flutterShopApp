import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section8_app/screens/user_product_edit_screen.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product-screen";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _init = true;
  var _isLoading = false;

  Product _editedProduct = new Product(
    id: null,
    title: '',
    price: 0.0,
    description: '',
    imageUrl: '',
  );

  var _intiValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_imageFocus);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _intiValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_imageFocus);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _imageFocus() {
    var urlPattern =
        r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    var result = new RegExp(urlPattern, caseSensitive: false)
        .firstMatch(_imageUrlController.text);
    if ((result == null)) {
      print("Hello ?!");
      return;
    }
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    var vald = _form.currentState.validate();
    if (!vald) {
      return;
    }
    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateItem(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = true;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        return showDialog(
            context: context,
            builder: (bctx) => AlertDialog(
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Okay"),
                      onPressed: () {
                        Navigator.of(context).popUntil(ModalRoute.withName(
                            UserProductEditScreen.routeName));
                      },
                    )
                  ],
                  content: Text("Looks like something went wrong :("),
                  title: Text("Something Went Wrong !"),
                ));
      }).then((_) {
        Navigator.of(context).pop();
      });
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var bodyContent = Padding(
      padding: EdgeInsets.all(15),
      child: Form(
        key: _form,
        child: ListView(children: <Widget>[
          TextFormField(
            initialValue: _intiValues['title'],
            decoration: InputDecoration(labelText: 'Title'),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (val) {
              FocusScope.of(context).requestFocus(_priceFocusNode);
            },
            validator: (val) {
              if (val.isEmpty) {
                return 'Please provide a Title';
              }
              return null;
            },
            onSaved: (val) {
              _editedProduct = new Product(
                id: _editedProduct.id,
                isFavorite: _editedProduct.isFavorite,
                title: val,
                price: _editedProduct.price,
                description: _editedProduct.description,
                imageUrl: _editedProduct.imageUrl,
              );
            },
          ),
          TextFormField(
            initialValue: _intiValues['price'],
            decoration: InputDecoration(labelText: 'Price'),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            focusNode: _priceFocusNode,
            onFieldSubmitted: (val) {
              FocusScope.of(context).requestFocus(_descriptionFocusNode);
            },
            onSaved: (val) {
              _editedProduct = new Product(
                id: _editedProduct.id,
                isFavorite: _editedProduct.isFavorite,
                title: _editedProduct.title,
                price: double.parse(val),
                description: _editedProduct.description,
                imageUrl: _editedProduct.imageUrl,
              );
            },
            validator: (val) {
              if (double.tryParse(val) == null) {
                return 'Enter a valid number ';
              }
              if (double.parse(val) <= 0) {
                return 'Enter a number greater than 0';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: _intiValues['description'],
            decoration: InputDecoration(labelText: 'Description'),
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            focusNode: _descriptionFocusNode,
            onSaved: (val) {
              _editedProduct = new Product(
                id: _editedProduct.id,
                isFavorite: _editedProduct.isFavorite,
                title: _editedProduct.title,
                price: _editedProduct.price,
                description: val,
                imageUrl: _editedProduct.imageUrl,
              );
            },
            validator: (val) {
              if (val.length < 10) {
                return 'Please enter a description that is longer than 10 characters ';
              } else if (val.isEmpty) {
                return 'Please enter a description';
              } else {
                return null;
              }
            },
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                child: _imageUrlController.text.isEmpty
                    ? Text("Enter a Image Url")
                    : Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                // margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Image Url'),
                  controller: _imageUrlController,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  focusNode: _imageUrlFocusNode,
                  onFieldSubmitted: (_) {
                    setState(() {
                      _saveForm();
                    });
                  },
                  validator: (val) {
                    var urlPattern =
                        r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
                    var result = new RegExp(urlPattern, caseSensitive: false)
                        .firstMatch(val);
                    if (!(result == null)) {
                      return null;
                    } else {
                      return "Please Enter a vaild Url ";
                    }
                  },
                  onSaved: (val) {
                    _editedProduct = new Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: val,
                    );
                  },
                ),
              )
            ],
          )
        ]),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Stack(
              children: <Widget>[
                bodyContent,
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            )
          : bodyContent,
    );
  }
}
