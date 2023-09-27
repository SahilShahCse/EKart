import 'package:ecart/models/product_model.dart';

class CartModel{

  String size;
  double price;
  ProductModel product;
  int itemCount;

  CartModel(this.product,this.size,this.price , this.itemCount);

  double get TotalPrice{
    return price*itemCount;
  }
}