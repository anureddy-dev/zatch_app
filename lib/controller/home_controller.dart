import '../model/product_model.dart';

class HomeController {
  final List<Product> products = [
    Product(
      name: "Men's Harrington Jacket",
      category: "Jackets",
      price: "\$148.00",
      imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/bPn6CQkCQq/3cebuus2_expires_30_days.png",
      discount: "56% OFF",
      soldCount: 1200,
    ),
    Product(
      name: "Max Cirro Men's Slides",
      category: "Footwear",
      price: "\$148.00",
      imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/bPn6CQkCQq/8n4ibxkl_expires_30_days.png",
      discount: "56% OFF",
      soldCount: 1200,
    ),
  ];

  String searchQuery = '';
  void updateSearchQuery(String query) {
    searchQuery = query;
  }
}