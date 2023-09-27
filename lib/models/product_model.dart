class ProductModel {
  String id;
  String name;
  String image;
  String description;
  Map<String, int> availableSizesAndPrices;
  int likes;
  int reviewCount;
  double stars;
  bool availableInStock;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.availableSizesAndPrices,
    required this.likes,
    required this.reviewCount,
    required this.stars,
    required this.availableInStock,
  });

  // Convert ProductModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'availableSizesAndPrices': availableSizesAndPrices,
      'likes': likes,
      'reviewCount': reviewCount,
      'stars' : stars,
      'availableInStock': availableInStock,
    };
  }

  // Create ProductModel from a Map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      description: map['description'],
      availableSizesAndPrices: Map<String, int>.from(map['availableSizesAndPrices']),
      likes: map['likes'],
      reviewCount: map['reviewCount'],
      stars: map['stars'],
      availableInStock: map['availableInStock'],
    );
  }

}



