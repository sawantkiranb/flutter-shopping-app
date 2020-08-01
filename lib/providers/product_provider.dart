import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  Product product;
  String apiUrl = 'https://flutter-shop-877ad.firebaseio.com/';

  ProductProvider(this.product);

  Future<void> toggleFavouriteStatus() async {
    product.isFavourite = !product.isFavourite;
    notifyListeners();

    final response = await http.patch(
      apiUrl + 'products/${product.id}.json',
      body: json.encode({
        'isFavourite': product.isFavourite,
      }),
    );

    if (response.statusCode != 200) {
      product.isFavourite = !product.isFavourite;
      notifyListeners();
      throw Exception('Failed');
    }
  }
}
