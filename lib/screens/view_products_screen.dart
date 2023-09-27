import 'package:ecart/firebase/product_service.dart';
import 'package:ecart/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../provider/product_provider.dart';

class ViewProductsScreen extends StatefulWidget {
  const ViewProductsScreen({Key? key}) : super(key: key);

  @override
  State<ViewProductsScreen> createState() => _ViewProductsScreenState();
}

class _ViewProductsScreenState extends State<ViewProductsScreen> {
  List<ProductModel> list_of_product = [];
  bool didUserSearch = false;
  TextEditingController search = TextEditingController();
  UserModel? user;
  void setListfromProvider() {
    list_of_product = Provider.of<ProductProvider>(context, listen: false).products;
  }

  Future<void> setDataToProviderAndList() async {
    Provider.of<ProductProvider>(context,listen: false).setProducts(await getProducts());
    print('Data fetched');
    setListfromProvider();
  }

  @override
  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context,listen: false).user;

    return FutureBuilder(
      future: setDataToProviderAndList(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _welcomeText(),
                  const SizedBox(height: 15),
                  searchBar(),
                  const SizedBox(height: 25),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          didUserSearch ? SizedBox() : _hotProducts(),
                          _discoverText(),
                          const SizedBox(height: 22),
                          _newProducts(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget for the "welcome" and user name text
  Widget _welcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            'welcome,',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 5),
          child: (user!=null)?(user!.name.isNotEmpty)?Text(
            '${user!.name}!',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ) : SizedBox() : SizedBox(),
        ),
      ],
    );
  }

  // Widget for the "Discover New Products..." text
  Widget _discoverText() {
    return didUserSearch
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Results : ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              InkWell(
                onTap: () {
                  setListfromProvider();
                  didUserSearch = false;
                  setState(() {});
                },
                child: Icon(Icons.arrow_back_ios_rounded),
              ),
            ],
          )
        : Text(
            'Discover New Products...',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          );
  }

  // Widget for the search bar
  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0x22393B63),
        borderRadius: BorderRadius.circular(30),
      ),
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: search,
              decoration: InputDecoration(
                hintText: 'Search Item',
                contentPadding: EdgeInsets.all(0),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              didUserSearch = true;
              list_of_product = await searchProduct(search.text);
              setState(() {});
            },
            child: Icon(Icons.search_rounded),
          ),
        ],
      ),
    );
  }

  // Widget for the list of hot products
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

  // Widget for the list of new products
  Widget _newProducts() {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _newProductItem(list_of_product[index]);
            },
            childCount: list_of_product.length,
          ),
        ),
      ],
    );
  }

  // Widget for each new product item
  Widget _newProductItem(ProductModel product) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/ProductDetail', arguments: product);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        height: 140,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Image.network(product.image),
                Positioned(
                  bottom: 8,
                  right: 5,
                  child: Text(
                    'Price : \$${product.availableSizesAndPrices[product.availableSizesAndPrices.keys.first]}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Name : ',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Text(
                            product.name,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(),
                    Row(
                      children: [
                        Text(
                          'ratings(${product.reviewCount}) : ',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Text('${product.stars} / 5'),
                        ),
                      ],
                    ),
                    SizedBox(),
                    const Text(
                      'Description : ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Flexible(
                      child: Text(
                        product.description,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
