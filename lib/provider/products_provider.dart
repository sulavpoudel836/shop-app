import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/provider/product.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  List<Product> _searchItems = [];

  bool isSearching = false;

  void toggleSearch() {
    isSearching = !isSearching;

    notifyListeners();
  }

  String authToken = '';
  String userId = '';

  ProductsProvider(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get searchItems {
    return [..._searchItems];
  }

  List<Product> get favourites {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  // Future<void> fetchAndSetProductsBySearch(String search) async {
  //   print('here');
  //   var url = Uri.parse(
  //       'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/products.json?orderBy="title"&equalTo="$search"');

  //   try {
  //     final response = await http.get(url);

  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;

  //     if (extractedData.isEmpty) {
  //       _items = [];
  //       return;
  //     }

  //     url = Uri.parse(
  //         'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/user-favourites/$userId.json');

  //     final favouriteResponse = await http.get(url);

  //     final favouriteData = json.decode(favouriteResponse.body);
  //     final List<Product> loadedProducts = [];
  //     if (extractedData.isEmpty) {
  //       _items = [];
  //       return;
  //     }

  //     // var prefs = await SharedPreferences.getInstance();
  //     // final productData = json.encode({
  //     //   'products': extractedData,
  //     //   'favourites': favouriteData,
  //     // });
  //     // prefs.setString('productData', productData);
  //     // final localProductData =
  //     //     json.decode(prefs.getString('productData')!) as Map<String, dynamic>;
  //     // print(localProductData);

  //     extractedData.forEach((productId, productData) {
  //       loadedProducts.add(Product(
  //         id: productId,
  //         title: productData['title'],
  //         description: productData['description'],
  //         price: productData['price'],
  //         imageUrl: productData['imageUrl'],
  //         isFavourite:
  //             favouriteData == null ? false : favouriteData[productId] ?? false,
  //       ));
  //     });
  //     // print(loadedProducts);
  //     _items = loadedProducts;

  //     print(_items.length);
  //     notifyListeners();
  //   } catch (error) {
  //     // print(error);
  //     rethrow;
  //   }
  // }

  Future<void> fetchAndSetProducts(
      [bool filterByUser = false, String search = ""]) async {
    String filterString = filterByUser
        ? 'auth=$authToken&orderBy="creatorId"&equalTo="$userId"'
        : '';

    var url = Uri.parse(
        'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/products.json?$filterString');

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      // final List<dynamic> allProducts = extractedData.values.toList();

      if (extractedData.isEmpty) {
        _items = [];
        _searchItems = [];
        return;
      }

      url = Uri.parse(
          'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/user-favourites/$userId.json');

      final favouriteResponse = await http.get(url);

      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      final List<Product> loadedSearchProducts = [];
      if (extractedData.isEmpty) {
        _items = [];
        _searchItems = [];
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

      final searchedData = {};
      extractedData.forEach((productId, productData) {
        if (productData['title']
            .toString()
            .toLowerCase()
            .contains(search.toLowerCase())) {
          searchedData[productId] = productData;
        }
      });

      searchedData.forEach((productId, productData) {
        loadedSearchProducts.add(Product(
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
      _searchItems = loadedSearchProducts;

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
