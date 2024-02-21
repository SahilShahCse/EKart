import 'package:ecart/firebase/user_services.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  UserService userService = UserService();

  // Getter to get the list of products
  UserModel? get user => _user;

  // Setter to set the list of products
  void setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }



}
