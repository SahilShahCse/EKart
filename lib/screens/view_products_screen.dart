
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
  List<ProductModel> searchResults = [];
  bool didUserSearch = false;
  TextEditingController search = TextEditingController();
  UserModel? user;

  void setListfromProvider() {
    list_of_product = Provider.of<ProductProvider>(context, listen: false).products;
  }

  Future<void> setDataToProviderAndList() async {
    if(Provider.of<ProductProvider>(context, listen: false).products!=null){
      setListfromProvider();
      return;
    }
    Provider.of<ProductProvider>(context, listen: false).setProducts(await getProducts());
    setListfromProvider();
  }

  void performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        didUserSearch = false;
        searchResults.clear();
      } else {
        didUserSearch = true;
        searchResults = list_of_product
            .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).user;
    if(list_of_product!=null){
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
                        didUserSearch?_getSearchProduct() : _newProducts(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
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
          child: (user != null)
              ? (user!.name.isNotEmpty)
                  ? Text(
                      '${user!.name}!',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    )
                  : SizedBox()
              : SizedBox(),
        ),
      ],
    );
  }

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
              performSearch(search.text);
            },
            child: Icon(Icons.search_rounded),
          ),
        ],
      ),
    );
  }

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

  Widget _hotProducts() {
    return FutureBuilder<List<ProductModel>>(
        future: getProducts(), // Replace getHotProducts with your hot products fetching function
        builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while waiting for data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            list_of_product = snapshot.data ?? []; // Update the list_of_product

            if (list_of_product.isEmpty) {
              return Text('No hot products found');
            }

            return Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: list_of_product.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _hotProductItem(index);
                  },
                ));
          }
        });
  }

  Widget _getSearchProduct() {
    if (didUserSearch) {
      if (searchResults.isNotEmpty) {
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
            itemCount: searchResults.length,
            itemBuilder: (BuildContext context, int index) {
              return _newProductItem(searchResults[index]);
            },
          );
      } else {
        return Center(child: Text('Item not found...'));
      }
    } else {
      // If no search is performed, show an empty container
      return SizedBox();
    }
  }

  Widget _newProducts() {
    return FutureBuilder<List<ProductModel>>(
      future: getProducts(), // Replace getNewProducts with your new products fetching function
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final newProducts = snapshot.data ?? [];

          if (newProducts.isEmpty) {
            return Text('No new products found');
          }

          return CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _newProductItem(newProducts[index]);
                  },
                  childCount: newProducts.length,
                ),
              ),
            ],
          );
        }
      },
    );
  }

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
