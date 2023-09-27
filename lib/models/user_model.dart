import 'package:ecart/models/product_model.dart';

class UserModel {
  String id;
  String name;
  String profileImg;
  List<ProductModel> cart;
  String address;
  String phoneNumber;
  String email;
  String password;

  UserModel({
    required this.id,
    required this.name,
    required this.profileImg,
    required this.cart,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  // Convert UserModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profileImg': profileImg,
      'cart': cart?.map((product) => product.toMap())?.toList(),
      'address': address,
      'phoneNumber': phoneNumber,
      'password' : password,
      'email' : email,
    };
  }

  // Create UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      profileImg: map['profileImg'],
      cart: List<ProductModel>.from(
        map['cart']?.map((productMap) => ProductModel.fromMap(productMap)),
      ),
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      password: map['password'],
      email:  map['email'],
    );
  }
}


