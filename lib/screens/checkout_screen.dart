import 'package:ecart/models/cart_model.dart';
import 'package:ecart/models/product_model.dart';
import 'package:ecart/provider/cart_provider.dart';
import 'package:ecart/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<CartModel> list_of_product = [];
  bool isProductAddedToCart = false;

  @override
  Widget build(BuildContext context) {
    list_of_product = Provider.of<CartProvider>(context, listen: false).products;

    return Scaffold(
      bottomSheet: (list_of_product.length != 0) ? _buildBottomBar(Provider.of<CartProvider>(context, listen: false).getTotalPrice()) : SizedBox(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildCheckoutTitle(),
            SizedBox(height: 20),
            Expanded(
              child: _buildProductList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutTitle() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 10),
      child: const Text(
        'Checkout...',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
      ),
    );
  }

  Widget _buildProductList() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 80),
      child: ListView.builder(
        itemCount: list_of_product.length,
        itemBuilder: (ctx, index) {
          return _buildProductItem(index);
        },
      ),
    );
  }

  Widget _buildProductItem(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      height: 145,
      color: Colors.white,
      child: Row(
        children: [
          _buildProductImage(index),
          SizedBox(width: 15),
          Flexible(
            // Wrap the InkWell with Flexible
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/ProductDetail', arguments: list_of_product[index].product);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(),
                  Flexible(
                    // Wrap the Text with Flexible
                    child: Text(
                      list_of_product[index].product.name,
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  SizedBox(),
                  Text('size : ${list_of_product[index].size}', style: TextStyle(fontWeight: FontWeight.w500)),
                  Text('ratings : (${list_of_product[index].product.stars})'),
                  SizedBox(),
                  Flexible(
                    // Wrap the Text with Flexible
                    child: Text('Price : \$${list_of_product[index].TotalPrice}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(int index) {
    return Stack(
      children: [
        Image.network(list_of_product[index].product.image),
        Positioned(
          bottom: 5,
          right: 8,
          child: _buildItemControl(index),
        ),
      ],
    );
  }

  Widget _buildItemControl(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCircleContainerForAddingAndRemovingItems(index: index, isAdd: false),
        SizedBox(width: 7),
        Text('item : ${list_of_product[index].itemCount}'),
        SizedBox(width: 7),
        _buildCircleContainerForAddingAndRemovingItems(index: index, isAdd: true),
      ],
    );
  }

  Widget _buildCircleContainerForAddingAndRemovingItems({required int index, bool isAdd = false}) {
    int itemCount = list_of_product[index].itemCount;
    return InkWell(
      onTap: () {
        if (isAdd) {
          itemCount++;
        } else {
          itemCount--;
        }
        if (itemCount > 10) {
          return;
        }
        if (itemCount == 0) {
          print('index ${index}');
          Provider.of<CartProvider>(context, listen: false).removeProduct(list_of_product[index]);
          setState(() {});
          return;
        }
        Provider.of<CartProvider>(context, listen: false).products[index].itemCount = itemCount;

        setState(() {});
      },
      child: Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black45,
          border: Border.all(
            color: const Color(0xFFFFFFFF).withOpacity(0.2),
            width: 1.0,
          ),
        ),
        child: Center(
          child: isAdd ? const Icon(Icons.add, size: 14, color: Colors.white) : const Icon(Icons.remove, size: 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBottomBar(double totalPrice) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 4, // Spread radius
            blurRadius: 10, // Blur radius
            offset: Offset(0, 4), // Offset for bottom and right
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: \$${totalPrice.toStringAsFixed(2)}', // Display total price
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xffff8b8b)),
            onPressed: () {},
            child: Row(
              children: const [
                Icon(Icons.payment), // Cart icon
                SizedBox(width: 20),
                Text("Pay Now"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
