import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  Product product;

  ProductProvider(this.product);

  void toggleFavouriteStatus() {
    product.isFavourite = !product.isFavourite;
    notifyListeners();
  }
}
