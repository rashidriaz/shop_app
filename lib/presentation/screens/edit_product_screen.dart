import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "./edit_product";

  @override
  _EditProductScreenState createState() {
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        validator: titleValidator,
                        onSaved: (value) => _editedProduct.title = value,
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
                        validator: priceValidator,
                        onSaved: (value) =>
                            _editedProduct.price = double.parse(value),
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
                        validator: descriptionValidator,
                        onSaved: (value) => _editedProduct.description = value,
                      ),
                      if (_imageController.text.isNotEmpty)
                        Container(
                          height: 150,
                          width: 300,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          child: FittedBox(
                            child: Image.network(
                              _imageController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      TextFormField(
                          decoration: InputDecoration(labelText: "Image URL"),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageController,
                          focusNode: _imageUrlFocusNode,
                          onEditingComplete: () {
                            setState(() {});
                          },
                          onFieldSubmitted: (_) => _saveForm(),
                          validator: urlValidator,
                          onSaved: (value) => _editedProduct.imageUrl = value,
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  String titleValidator(value) {
    if (value.isEmpty) {
      return "Please Provide a value for the title.";
    }
    return null;
  }

  String priceValidator(value) {
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
  }

  String descriptionValidator(value) {
    if (value.isEmpty) {
      return "Please Provide some description for the product.";
    } else if (value.length < 10) {
      return "The description of the product must be of the more than 10 characters";
    }
    return null;
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
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Okay"),
        ),
      ],
    );
  }

  String urlValidator(value) {
    if (value.isEmpty) {
      return "Please Provide a URL fort the product image.";
    }
    if ((!value.startsWith("http") && !value.startsWith("https")) ||
        !value.endsWith("png") &&
            !value.endsWith("jpg") &&
            !value.endsWith("jpeg")) {
      return "Please Enter a valid URL. e.g https://www.webpage.com/image/logo.png";
    }
    return null;
  }
}
