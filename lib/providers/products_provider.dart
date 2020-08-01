import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  String apiUrl = 'https://flutter-shop-877ad.firebaseio.com/';

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((product) => product.isFavourite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetproducts() async {
    try {
      final response = await http.get(apiUrl + 'products.json');
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      fetchedData.forEach((productId, productData) {
        loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavourite: productData['isFavourite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        apiUrl + 'products.json',
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavourite': false,
        }),
      );

      var newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        isFavourite: false,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    final index = _items.indexWhere((product) => product.id == productId);
    if (index < 0) return;

    try {
      await http.patch(
        apiUrl + 'products/$productId.json',
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
          'isFavourite': newProduct.isFavourite,
        }),
      );

      _items[index] = newProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String productId) async {
    final existingProductIndex =
        _items.indexWhere((product) => product.id == productId);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(apiUrl + 'products/$productId');

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw Exception('Deletion failed.');
    }
    existingProduct = null;
  }
}
