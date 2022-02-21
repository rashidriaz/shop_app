import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/modals/http_exception.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    bool oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        "https://flutter-practice-shopapp-4b993-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken";
    try {
      final response = await http.put(url,
          body: json.encode({
            "isFavorite": isFavorite,
          }));
      if (response.statusCode >= 400) _setFavoriteValue(oldStatus);
    } catch (error) {
      _setFavoriteValue(oldStatus);
    }
  }

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }
}
