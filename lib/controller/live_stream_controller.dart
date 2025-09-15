import 'package:flutter/material.dart';
import 'package:zatch_app/model/live_follower_model.dart';
import 'package:zatch_app/model/product_model.dart';
import 'package:zatch_app/view/profile/profile_screen.dart';


class LiveStreamController extends ChangeNotifier {
  final LiveFollowerModel user;

  LiveStreamController({required this.user});

  bool isSaved = false;
  bool isLiked = false;

  // Example products (replace with API or real list)
  final List<Product> products = [
    Product(
      name: "Modern light clothes",
      category: "Fashion",
      price: "₹ 212.99",
      imageUrl: "https://picsum.photos/200/300",
      discount: "10%",
      soldCount: 200,
    ),
    Product(
      name: "Wireless Headphones",
      category: "Electronics",
      price: "₹ 999.00",
      imageUrl: "https://picsum.photos/200/301",
      discount: "20%",
      soldCount: 540,
    ),
  ];

  /// Toggle like
  void toggleLike(BuildContext context) {
    isLiked = !isLiked;
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isLiked ? "You liked this stream ❤️" : "Like removed"),
      ),
    );
  }

  /// Toggle save
  void toggleSave(BuildContext context) {
    isSaved = !isSaved;
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSaved ? "Saved to your list ✅" : "Removed from saved ❌"),
      ),
    );
  }

  /// Share
  void share(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Shared!")),
    );
  }

  /// Cart
  void addToCart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to cart 🛒")),
    );
  }

  /// Buy
  void buyNow(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Buy button clicked 🛍️")),
    );
  }

  /// Zatch
  void zatchNow(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Zatch button clicked ⚡")),
    );
  }

  /// Navigate to profile
  void openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(person: {},),
      ),
    );
  }
}
