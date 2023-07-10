import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products_provider.dart';

class EditAddProductScreen extends StatefulWidget {
  static const routeName = '/edit-add-product';
  const EditAddProductScreen({super.key});

  @override
  State<EditAddProductScreen> createState() => _EditAddProductScreenState();
}

class _EditAddProductScreenState extends State<EditAddProductScreen> {
  final _form = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  var _initState = true;
  var _isLoading = false;

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _newProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        String productId = ModalRoute.of(context)!.settings.arguments as String;
        if (productId != '') {
          _newProduct =
              Provider.of<ProductsProvider>(context).findById(productId);
          _initValues = {
            'title': _newProduct.title,
            'description': _newProduct.description,
            'price': _newProduct.price.toString(),
            'imageUrl': '',
          };
          _imageUrlController.text = _newProduct.imageUrl;
        }
      }
    }

    _initState = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_newProduct.id != '') {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_newProduct.id, _newProduct);
      } catch (error) {
        // ignore: prefer_void_to_null
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addItems(_newProduct);
      } catch (error) {
        // ignore: prefer_void_to_null
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // String productId = ModalRoute.of(context)!.settings.arguments as String;
    // var productData = Provider.of<ProductsProvider>(context);
    // var product = Provider.of<ProductsProvider>(context).findById(productId);

    // ignore: no_leading_underscores_for_local_identifiers

    return Scaffold(
      appBar: AppBar(
        title: ModalRoute.of(context)!.settings.arguments == null
            ? const Text('Add Product')
            : const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onSaved: (newValue) {
                        _newProduct = Product(
                          id: _newProduct.id,
                          title: newValue!,
                          description: _newProduct.description,
                          price: _newProduct.price,
                          imageUrl: _newProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) {
                        _newProduct = Product(
                          id: _newProduct.id,
                          title: _newProduct.title,
                          description: _newProduct.description,
                          price: double.parse(
                              newValue!), // convert string to double
                          imageUrl: _newProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      // textInputAction: TextInputAction.next,
                      onSaved: (newValue) {
                        _newProduct = Product(
                          id: _newProduct.id,
                          title: _newProduct.title,
                          description: newValue!,
                          price: _newProduct.price,
                          imageUrl: _newProduct.imageUrl,
                        );
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onSaved: (newValue) {
                        _newProduct = Product(
                          id: _newProduct.id,
                          title: _newProduct.title,
                          description: _newProduct.description,
                          price: _newProduct.price,
                          imageUrl: newValue!,
                        );
                      },
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                    ),
                    Container(
                      // height: 200,
                      // width: 100,
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        border: _imageUrlController.text.isEmpty
                            ? Border.all(
                                color: Colors.transparent,
                                width: 1,
                              )
                            : Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? const Text('')
                          : Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
