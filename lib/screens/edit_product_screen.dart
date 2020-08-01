import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppping_app/providers/products_provider.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();

  final _imageURLController = TextEditingController();

  final _form = GlobalKey<FormState>();

  var _product = Product(
    id: null,
    title: '',
    description: '',
    price: 0.00,
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_updateImageUrl);

    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLFocusNode.dispose();
    _imageURLController.dispose();

    super.dispose();
  }

  var _isInit = true;
  var _showProgress = false;

  void showProgress(bool show) {
    setState(() {
      _showProgress = show;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _product = Provider.of<ProductsProvider>(
          context,
          listen: false,
        ).findById(productId);

        _initValues = {
          'title': _product.title,
          'description': _product.description,
          'price': _product.price.toString(),
          'imageUrl': _product.imageUrl,
        };
        _imageURLController.text = _initValues['imageUrl'];
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (_imageURLController.text.isEmpty ||
        !_imageURLController.text.startsWith('http') &&
            !_imageURLController.text.startsWith('https')) return;

    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();

    if (!isValid) return;

    _form.currentState.save();
    try {
      showProgress(true);
      if (_product.id == null) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_product);
      } else {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_product.id, _product);
      }
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occured!'),
                content: Text('Something went wrong.'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Ok'),
                  ),
                ],
              ));
    }

    showProgress(false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.satellite),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _showProgress
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _product = Product(
                            id: _product.id,
                            title: value,
                            description: _product.description,
                            price: _product.price,
                            imageUrl: _product.imageUrl,
                            isFavourite: false,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter title';
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                          hintText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _product = Product(
                            id: _product.id,
                            title: _product.title,
                            description: _product.description,
                            price: double.parse(value),
                            imageUrl: _product.imageUrl,
                            isFavourite: false,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter price';

                          if (double.tryParse(value) == null)
                            return 'Please enter valid number';

                          if (double.tryParse(value) <= 0)
                            return 'Please enter number greater than zero';

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Description',
                        ),
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _product = Product(
                            id: _product.id,
                            title: _product.title,
                            description: value,
                            price: _product.price,
                            imageUrl: _product.imageUrl,
                            isFavourite: false,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter description';

                          if (value.length < 10)
                            return 'Description should contain at least 10 characters';

                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageURLController.text.isEmpty
                                ? Text('Enter a Url')
                                : FittedBox(
                                    child: Image.network(
                                      _imageURLController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageURLController,
                              focusNode: _imageURLFocusNode,
                              onFieldSubmitted: (_) => _saveForm(),
                              onSaved: (value) {
                                _product = Product(
                                  id: _product.id,
                                  title: _product.title,
                                  description: _product.description,
                                  price: _product.price,
                                  imageUrl: value,
                                  isFavourite: false,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please enter image URL';

                                if (!value.startsWith('http') &&
                                    !value.startsWith('https'))
                                  return 'Please enter valid image URL';

                                return null;
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
