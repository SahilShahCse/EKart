import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

// Add a new product
Future<void> addProduct(ProductModel product) async {
  try {
    await FirebaseFirestore.instance.collection('products').add(product.toMap());
  } catch (e) {
    print('Error adding product: $e');
  }
}

// Get a list of products
Future<List<ProductModel>> getProducts() async {
  try {
    final querySnapshot = await FirebaseFirestore.instance.collection('products').get();
    return querySnapshot.docs.map((doc) => ProductModel.fromMap(doc.data())).toList();
  } catch (e) {
    print('Error getting products: $e');
    return [];
  }
}

// Search for products
Future<List<ProductModel>> searchProduct(String query) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .get();

    print('Query Results: ${querySnapshot.docs.length}');

    return querySnapshot.docs.map((doc) => ProductModel.fromMap(doc.data())).toList();
  } catch (e) {
    print('Error searching for products: $e');
    return [];
  }
}

