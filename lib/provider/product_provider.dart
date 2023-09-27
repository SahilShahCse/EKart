import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];

  // Getter to get the list of products
  List<ProductModel> get products => _products;

  // Setter to set the list of products
  void setProducts(List<ProductModel> products) {
    _products = products;
    notifyListeners();
  }
}
