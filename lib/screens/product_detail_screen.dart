import 'package:ecart/models/cart_model.dart';
import 'package:ecart/provider/cart_provider.dart';
import 'package:ecart/provider/user_provider.dart';
import 'package:ecart/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = ""; // Track the selected size
  int selectedQuantity = 1; // Track the selected quantity
  List<ProductModel> list_of_product = [];
  bool isProductAddedToCart = false;

  void setListfromProvider() {
    list_of_product = Provider.of<ProductProvider>(context, listen: false).products;
  }

  @override
  Widget build(BuildContext context) {
    setListfromProvider();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildProductImage(),
              const SizedBox(height: 20),
              _buildProductName(),
              const SizedBox(height: 15),
              _buildProductDescription(),
              const SizedBox(height: 20),
              Text(
                (selectedSize != '')
                    ? 'Price: \$${widget.product.availableSizesAndPrices[selectedSize]}'
                    : 'Price : select size for price info', // Display the price
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),
              _buildAvailableSizes(),
              SizedBox(height: 25),
              _buildQuantitySelection(),
              SizedBox(height: 25),
              _buildSeeMoreLikeThis(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: (selectedSize != '') ? _buildBottomBar(selectedQuantity * widget.product.availableSizesAndPrices[selectedSize]!) : SizedBox(),
    );
  }

  // Method to build the product image
  Widget _buildProductImage() {
    return Stack(
      children: [
        Image.network(
          widget.product.image,
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 5,
          left: 5,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              color: Color(0x66ffffff),
              child: Icon(Icons.arrow_back_ios_new),
            ),
          ),
        )
      ],
    );
  }

  // Method to build the product name
  Widget _buildProductName() {
    return Text(
      widget.product.name,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Method to build the product description
  Widget _buildProductDescription() {
    return Text(
      widget.product.description,
      style: TextStyle(fontSize: 15),
    );
  }

  // Method to build available sizes selection
  Widget _buildAvailableSizes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Available Sizes:',
          style: TextStyle(fontSize:18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          children: _buildSizeButtons(),
        ),
      ],
    );
  }

  // Method to build size selection buttons
  List<Widget> _buildSizeButtons() {
    return widget.product.availableSizesAndPrices.keys.map((size) {
      return Padding(
        padding: EdgeInsets.only(right: 8),
        child: ElevatedButton(
          onPressed: () {
            isProductAddedToCart = false;
            selectedSize = size;

            setState(() {});
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              selectedSize == size ? Color(0xff6d8df7) : Color(0xffff8b8b),
            ),
          ),
          child: Text(size),
        ),
      );
    }).toList();
  }

  // Method to build quantity selection dropdown
  Widget _buildQuantitySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Select Quantity:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            SizedBox(width: 20),
            DropdownButton<int>(
              value: selectedQuantity,
              onChanged: (value) {
                setState(() {
                  selectedQuantity = value!;
                });
              },
              items: _buildQuantityDropdownItems(),
            ),
          ],
        ),
      ],
    );
  }

  // Method to build quantity dropdown items
  List<DropdownMenuItem<int>> _buildQuantityDropdownItems() {
    return List.generate(10, (index) {
      int quantity = index + 1;
      return DropdownMenuItem<int>(
        value: quantity,
        child: Text(quantity.toString()),
      );
    });
  }

  // Method to build the bottom bar
  Widget _buildBottomBar(int totalPrice) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isProductAddedToCart ? 'Added' : 'Total: \$${totalPrice.toStringAsFixed(2)}' , textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              if (isProductAddedToCart){
                Navigator.pop(context);
             }
              else {
                Provider.of<CartProvider>(context, listen: false)
                    .addProduct(CartModel(widget.product, selectedSize, widget.product.availableSizesAndPrices[selectedSize]!.toDouble(), selectedQuantity));
                isProductAddedToCart = true;
              }

              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xff6d8df7)),
            child: Row(
              children: [
                isProductAddedToCart ? Icon(Icons.done_all) : Icon(Icons.shopping_cart), // Cart icon
                SizedBox(width: 8),
                isProductAddedToCart ? Text('Back to home page') : Text("Add to Cart"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeeMoreLikeThis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'see more like this...',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        SizedBox(height: 15),
        _hotProducts(),
      ],
    );
  }

  Widget _hotProducts() {
    return Container(
      height: 200, // Set a fixed height to constrain the ListView
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list_of_product.length,
        itemBuilder: (BuildContext context, int index) {
          return _hotProductItem(index);
        },
      ),
    );
  }

  // Widget for each hot product item
  Widget _hotProductItem(int index) {
    final product = list_of_product[index];
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/ProductDetail', arguments: list_of_product[index]);
      },
      child: Column(
        children: [
          Container(
            width: 135,
            margin: const EdgeInsets.only(right: 10),
            child: Stack(
              children: [
                Image.network(product.image),
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    width: 100,
                    color: Color(0x55FeFeFe),
                    child: Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: Container(
                    color: Color(0x55FeFeFe),
                    child: Text(
                      '\$${product.availableSizesAndPrices[product.availableSizesAndPrices.keys.first]}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
