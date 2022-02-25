import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/product.dart";
import "../providers/products_provider.dart";

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    name: "",
    price: 0,
    description: "",
    imageUrl: "",
  );
  var _isInit = false;
  var _initValues = {
    "name": "",
    "price": "",
    "description": "",
    "imageUrl": "",
  };

  @override
  void initState() {
    super.initState();
    _isInit = true;

    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          "name": _editedProduct.name,
          "price": _editedProduct.price.toString(),
          "description": _editedProduct.description,
          "imageUrl": "",
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;
  }

  void _updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty || !_imageUrlController.text.startsWith("http") && !_imageUrlController.text.startsWith("https")) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();

    if (!isValid) return;

    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();

    // focus nodes and controllers have to be disposed after use to prevent memory leaks
    _imageUrlFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _initValues["name"],
                  decoration: InputDecoration(labelText: "Name"),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) return "Please input a name.";

                    return null;
                  },
                  // this below makes sure the next button on keyboard directs user
                  // to price input
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      name: value,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      description: _editedProduct.description,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues["price"],
                  decoration: InputDecoration(labelText: "Price"),
                  validator: (value) {
                    if (value.isEmpty) return "Please input a price.";
                    if (double.tryParse(value) == null)
                      return "Please input a valid number.";
                    if (double.parse(value) <= 0)
                      return "Please input a number higher than 0";

                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      name: _editedProduct.name,
                      price: double.parse(value),
                      imageUrl: _editedProduct.imageUrl,
                      description: _editedProduct.description,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues["description"],
                    decoration: InputDecoration(labelText: "Description"),
                    validator: (value) {
                      if (value.isEmpty) return "Please input a description.";
                      if (value.length < 20) return "Minimum character is 20";

                      return null;
                    },
                    maxLines: 3,
                    keyboardType:
                        TextInputType.multiline, // adds "new line" on keyboard
                    textInputAction: TextInputAction.newline,
                    focusNode: _descriptionFocusNode,
                    onSaved: (value) {
                      _editedProduct = Product(
                        id: _editedProduct.id,
                        name: _editedProduct.name,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        description: value,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text("Enter the URL")
                          : FittedBox(
                              child: Image.network(_imageUrlController.text,
                                  fit: BoxFit.cover),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        validator: (value) {
                          if (value.isEmpty)
                            return "Please input an image URL.";
                          if (!value.startsWith("http") &&
                              !value.startsWith("https")) {
                            return "Please input a valid URL.";
                          }

                          return null;
                        },
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) {
                          // onFieldSubmitted accepts a function with string arg
                          // so anonymous function is needed here
                          _saveForm();
                        },
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            name: _editedProduct.name,
                            price: _editedProduct.price,
                            imageUrl: value,
                            description: _editedProduct.description,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


  // Expanded(
  //   child: TextFormField(
  //     decoration: InputDecoration(labelText: 'Image URL'),
  //     keyboardType: TextInputType.url,
  //     textInputAction: TextInputAction.done,
  //     controller: _imageUrlController,
  //     onEditingComplete: () {
  //       setState(() {});
  //     },
  //   )
  // ),