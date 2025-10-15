import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zatch_app/services/api_service.dart';
import '../model/live_session_res.dart';
import '../model/product_response.dart';
import '../view/cart_screen.dart';
import '../view/profile/profile_screen.dart';


class LiveStreamController extends ChangeNotifier {
  final Session? session;
  LiveStreamController({ this.session});

  bool isLiked = false;
  bool isSaved = false;

  List<Product> products = [];
  Product? displayedProduct;
  final ApiService _api = ApiService();


  /// Fetch product list from API
  Future<void> fetchProducts() async {
    products = await _api.getProducts();
    if (products.isNotEmpty) {
      displayedProduct = products.first;
    }
    notifyListeners();
  }

  void toggleLike(BuildContext context) {
    isLiked = !isLiked;
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isLiked ? "You liked this stream ❤️" : "Like removed"),
      ),
    );
  }

  void toggleSave(BuildContext context) {
    isSaved = !isSaved;
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSaved ? "Saved to your list ✅" : "Removed from saved ❌"),
      ),
    );
  }

  void share(BuildContext context) {
    final liveLink = "https://zatch.live/${session?.host?.id ?? ""}";
    Share.share("Watch ${session?.host?.username ?? ""}'s live stream here: $liveLink");
  }

  void addToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartScreen()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to cart 🛒")),
    );
  }

  void buyNow(BuildContext context, Product? product) {
    if (product == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Buy clicked 🛍️")),
    );
  }

  void zatchNow(BuildContext context, Product? product) {
    if (product == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Zatch clicked ⚡")),
    );
  }

  void openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen()),
    );
  }

}
