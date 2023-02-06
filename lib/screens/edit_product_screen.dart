import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_flutter/providers/product.dart';
import 'package:shop_flutter/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const path = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool isMounted = false;
  bool isLoading = false;
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initialValues = {};

  @override
  void didChangeDependencies() {
    if (!isMounted) {
      final productId = ModalRoute.of(context)?.settings.arguments;

      if (productId != null) {
        _editedProduct = context.read<Products>().findById(productId as String);
        _initialValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    isMounted = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    _form.currentState?.save();
    setState(() => isLoading = true);

    if (_editedProduct.id == '') {
      try {
        await context.read<Products>().addProduct(_editedProduct);
      } catch (err) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Somethong went wrong'),
            content: Text(err.toString()),
          ),
        );
      }
    } else {
      await context.read<Products>().updateProduct(_editedProduct.id, _editedProduct);
    }

    Navigator.of(context).pop();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage product'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initialValues['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: value!,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initialValues['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value!),
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initialValues['description'],
                        decoration: const InputDecoration(labelText: 'Description'),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: value!,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? const Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: 'Image url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onEditingComplete: () => setState(() {}),
                              onFieldSubmitted: (_) => _submitForm(),
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value!,
                                  isFavourite: _editedProduct.isFavourite,
                                );
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
