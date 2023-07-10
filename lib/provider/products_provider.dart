import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/provider/product.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 900,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 1000,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 500,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 2000,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String? authToken;
  final String? userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favourites {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    String filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }

      url = Uri.parse(
          'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/user-favourites/$userId.json?auth=$authToken');

      final favouriteResponse = await http.get(url);

      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      if (extractedData.isEmpty) {
        return;
      }

      // var prefs = await SharedPreferences.getInstance();
      // final productData = json.encode({
      //   'products': extractedData,
      //   'favourites': favouriteData,
      // });
      // prefs.setString('productData', productData);
      // final localProductData =
      //     json.decode(prefs.getString('productData')!) as Map<String, dynamic>;
      // print(localProductData);

      extractedData.forEach((productId, productData) {
        loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavourite:
              favouriteData == null ? false : favouriteData[productId] ?? false,
        ));
      });
      // print(loadedProducts);
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  Future<void> addItems(Product newProduct) async {
    var url = Uri.parse(
        'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    try {
      var response = await http.post(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'creatorId': userId,
          },
        ),
      );

      final addThis = Product(
        id: json.decode(response.body)['name'],
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
      );
      
      _items.add(addThis);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteItems(String id) async {
    var url = Uri.parse(
        'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);

    var response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw const HttpException('error occured.');
    }
    existingProduct = null;
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    var url = Uri.parse(
        'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

    try {
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          }));
      final productIndex = _items.indexWhere((element) => element.id == id);
      if (productIndex >= 0) {
        _items[productIndex] = newProduct;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}
