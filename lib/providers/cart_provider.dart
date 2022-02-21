import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  int quantity;
  final double pricePerProduct;
  bool isSelected;

  CartItem(
      {@required this.id,
      @required this.title,
      this.quantity = 1,
      @required this.pricePerProduct,
      this.isSelected = false});

  bool compare(CartItem c1, CartItem c2) {
    return c1.id == c2.id;
  }

  void increaseQuantity() {
    quantity += 1;
  }

  void decreaseQuantity() {
    if (quantity == 0) return;
    quantity -= 1;
  }

  void changeSelectedStatus() {
    isSelected = !isSelected;
  }
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  int get itemCount {
    return _items.length;
  }

  List<CartItem> get items {
    return [..._items];
  }

  void addItem(
      {@required String productId,
      @required double price,
      @required String title}) {
    bool containsItem = false;
    int index = _items.indexWhere((element) {
      containsItem = element.id == productId;
      return containsItem;
    });
    if (containsItem) {
      CartItem item = _items[index];
      item.increaseQuantity();
      _items.removeAt(index);
      _items.insert(index, item);
    } else {
      _items.add(CartItem(id: productId, title: title, pricePerProduct: price));
    }
    notifyListeners();
  }

  void increaseQuantityOfTheItem({@required String id}) {
    bool containsItem = false;
    int index = _items.indexWhere((element) {
      containsItem = element.id == id;
      return containsItem;
    });
    if (containsItem) {
      CartItem item = _items[index];
      item.increaseQuantity();
      _items.removeAt(index);
      _items.insert(index, item);
      notifyListeners();
    }
  }

  void decreaseQuantityOfTheItem({@required String id}) {
    bool containsItem = false;
    int index = _items.indexWhere((element) {
      containsItem = element.id == id;
      return containsItem;
    });
    if (containsItem) {
      CartItem item = _items[index];
      if (item.quantity == 1) {
        _items.removeAt(index);
        notifyListeners();
        return;
      }
      item.decreaseQuantity();
      _items.removeAt(index);
      _items.insert(index, item);
      notifyListeners();
    }
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((element) {
      if (element.isSelected) {
        total += (element.pricePerProduct * element.quantity);
      }
    });
    return total;
  }

  void changeSelectedStatus(String id) {
    _items.forEach((element) {
      if (element.id == id) {
        element.changeSelectedStatus();
        notifyListeners();
      }
    });
  }

  CartItem findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void removeItem(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  List<CartItem> get selectedItems {
    List<CartItem> selectedList = [];
    _items.forEach((element) {
      if (element.isSelected) {
        selectedList.add(element);
      }
    });
    return selectedList;
  }

  void removeSelectedItems(){
    // Iterator<CartItem> iterator = _items.iterator;
    _items.removeWhere((element) => element.isSelected);
    notifyListeners();
  }
}
