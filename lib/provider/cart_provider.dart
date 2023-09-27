import 'dart:ffi';

import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _products = []; // Initialize with an empty list

  // Getter to get the list of products
  List<CartModel> get products => _products;

  void removeProduct(CartModel product){
    products.remove(product);
    notifyListeners();
  }

  void addProduct(CartModel product){
    products.add(product);
    print('Product added : ${product}');
    notifyListeners();
  }

  double getTotalPrice(){
    double total = 0;
    for(int i = 0 ; i < products.length ; i++){
      total += products[i].TotalPrice;
    }
    return total;
  }

  // Setter to set the list of products

}