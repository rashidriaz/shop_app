import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "./edit_product";

  @override
  State createState() {
    return _EditProductScreenState();
  }
}

class _EditProductScreenState extends State<EditProductScreen> {
  // ignore: slash_for_doc_comments
  /**
   * -----------------------------------------------------------------------
   *                      Class Attributes and handlers..
   * -----------------------------------------------------------------------
   */
  final _priceNodeFocus = FocusNode();
  final _descriptionNodeFocus = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageController = TextEditingController();
  bool _widgetIsBuiltForTheFirstTime = true;
  var _initialValuesOfAllTheFields = {
    "title": '',
    "description": '',
    "price": '',
    "imageUrl": ''
  };
  Product _editedProduct = Product(
    title: '',
    imageUrl: '',
    id: null,
    price: 0.0,
    description: '',
  );
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;

// ignore: slash_for_doc_comments
  /**
   * -----------------------------------------------------------------------
   *                          Overridden methods
   * -----------------------------------------------------------------------
   */
  @override
  // ignore: must_call_super
  void dispose() async {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceNodeFocus.dispose();
    _descriptionNodeFocus.dispose();
    _imageController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_widgetIsBuiltForTheFirstTime) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(id);
        _initialValuesOfAllTheFields = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          "imageUrl": '',
        };
        _imageController.text = _editedProduct.imageUrl;
      }
    }
    _widgetIsBuiltForTheFirstTime = false;
    super.didChangeDependencies();
  }

// ignore: slash_for_doc_comments
  /**
   * ------------------------------------------------------------------
   *                           Build Method
   * ------------------------------------------------------------------
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add/Edit Product"),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              }),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Title",
                        ),
                        initialValue: _initialValuesOfAllTheFields["title"],
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceNodeFocus);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Provide a value for the title.";
                          }
                          return null;
                        },
                        onSaved: (value) => _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Price",
                        ),
                        initialValue: _initialValuesOfAllTheFields["price"],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceNodeFocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionNodeFocus);
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Please Provide Some Value for the Price.";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          if (double.parse(value) <= 0) {
                            return "Price of the product must be greater than 0.";
                          }
                          return null;
                        },
                        onSaved: (value) => _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Description",
                        ),
                        initialValue:
                            _initialValuesOfAllTheFields["description"],
                        focusNode: _descriptionNodeFocus,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Provide some description for the product.";
                          } else if (value.length < 10) {
                            return "The description of the product must be of the more than 10 characters";
                          }
                          return null;
                        },
                        onSaved: (value) => _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageController.text.isEmpty
                                ? Text(
                                    "Enter a URL",
                                    textAlign: TextAlign.center,
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Image URL"),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageController,
                              focusNode: _imageUrlFocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) => _saveForm(),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Provide a URL fort the product image.";
                                }
                                if ((!value.startsWith("http") &&
                                        !value.startsWith("https")) ||
                                    !value.endsWith("png") &&
                                        !value.endsWith("jpg") &&
                                        !value.endsWith("jpeg")) {
                                  return "Please Enter a valid URL. e.g https://www.webpage.com/image/logo.png";
                                }
                                return null;
                              },
                              onSaved: (value) => _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value,
                                isFavorite: _editedProduct.isFavorite,
                              ),
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

  // ignore: slash_for_doc_comments
  /**
   * ----------------------------------------------------------------------------
   *                            User Defined methods
   * ---------------------------------------------------------------------------
   */
  Future<void> _saveForm() async {
    bool isValid = _form.currentState.validate();
    setState(() {
      _isLoading = true;
    });
    if (isValid) {
      _form.currentState.save();
      if (_editedProduct.id != null) {
        try {
          await Provider.of<Products>(context, listen: false)
              .updateItem(_editedProduct);
        } catch (error) {
          await showDialog<Null>(
              context: context,
              builder: (ctx) {
                return errorDialogue();
              });
        }
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (error) {
          await showDialog<Null>(
              context: context,
              builder: (ctx) {
                return errorDialogue();
              });
        }
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  void _updateImageUrl() {
    if (_imageUrlFocusNode.hasFocus) {
      String value = _imageController.text;
      if ((!value.startsWith("http") && !value.startsWith("https")) ||
          !value.endsWith("png") &&
              !value.endsWith("jpg") &&
              !value.endsWith("jpeg")) {
        return;
      }
      setState(() {});
    }
  }

  AlertDialog errorDialogue() {
    return AlertDialog(
      title: Text("An error occurred!!"),
      content: Text("Something went wrong!!"),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Okay"),
        ),
      ],
    );
  }
}
