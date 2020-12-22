import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/modals/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];
  String authToken;
  String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    try {
      final filterString =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final _productsUrl =
          'https://flutter-practice-shopapp-4b993-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
      final favoriteStatusUrl =
          "https://flutter-practice-shopapp-4b993-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken";
      final response = await http.get(_productsUrl);
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedItems = [];
      if (fetchedData == null) {
        return;
      }
      final favoriteResponse = await http.get(favoriteStatusUrl);
      final favoriteItemsData = json.decode(favoriteResponse.body) as Map<String, dynamic>;
      fetchedData.forEach((id, data) {
        bool isFavorite = false;
        if (favoriteItemsData != null) {
          if (favoriteItemsData.containsKey(id)) {
            isFavorite = favoriteItemsData[id]['isFavorite'];
          }
        }
        loadedItems.add(
          Product(
              id: id,
              title: data['title'],
              description: data['description'],
              price: data['price'],
              isFavorite: isFavorite,
              imageUrl: data['imageUrl']),
        );
      });

      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }


  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) async {
    try {
      final _productsUrl =
          "https://flutter-practice-shopapp-4b993-default-rtdb.firebaseio.com/products.json?auth=$authToken";
      final response = await http.post(
        _productsUrl,
        body: json.encode(
          {
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
            'creatorId': userId,
          },
        ),
      );
      final id = json.decode(response.body)['name'];
      final Product newProduct = Product(
        id: id,
        title: product.title,
        description: product.description,
        price: product.price,
        isFavorite: product.isFavorite,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateItem(Product product) async {
    final id = product.id;
    int index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      try {
        final productUrlForUpdating =
            "https://flutter-practice-shopapp-4b993-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
        await http.patch(
          productUrlForUpdating,
          body: json.encode(
            {
              "title": product.title,
              "description": product.description,
              "price": product.price,
              "imageUrl": product.imageUrl,
              "isFavorite": product.isFavorite,
            },
          ),
        );
        _items[index] = product;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://flutter-practice-shopapp-4b993-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
    final int indexOfProductToBeDeleted =
        _items.indexWhere((element) => element.id == id);
    Product productToBeDeleted = _items[indexOfProductToBeDeleted];
    _items.removeAt(indexOfProductToBeDeleted);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(indexOfProductToBeDeleted, productToBeDeleted);
      notifyListeners();
      throw HttpException("Couldn't delete product");
    }
    productToBeDeleted = null;
  }
}
