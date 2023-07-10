import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isFavourite = false,
    required this.price,
  });

  Future<void> toggleFavourite(
    String token,
    String userId,
  ) async {
    isFavourite = !isFavourite;
    notifyListeners();
    var url = Uri.parse(
        'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/user-favourites/$userId/$id.json?auth=$token');

    var response = await http.put(url,
        body: json.encode(
          isFavourite,
        ));
    if (response.statusCode >= 400) {
      isFavourite = !isFavourite;
      notifyListeners();
      throw const HttpException('Could not toggle favourite status');
    }
  }
}
