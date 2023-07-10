import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {
    // 'productId': CartItem(
    //   id: 'cartId',
    //   price: productPrice,
    //   quantity: cartItemQuantity,
    //   title: 'productTitle',
    // ),
  };

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void _updateItemQuantity(int val, String productId) {
    _items.update(
      productId,
      (value) => CartItem(
        id: value.id,
        price: value.price,
        quantity: value.quantity + val,
        title: value.title,
      ),
    );
  }

  void removeSingleItem(String productId) {
    if (_items.containsKey(productId) && _items[productId]!.quantity > 1) {
      _updateItemQuantity(-1, productId);
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void addCartItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _updateItemQuantity(1, productId);
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: productId,
            price: price,
            quantity: 1,
            title: title),
      );
    }

    notifyListeners();
  }
}
