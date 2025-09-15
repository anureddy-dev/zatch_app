import 'package:zatch_app/services/api_service.dart';

import '../model/product_response.dart';
import '../model/top_pick_model.dart';

class TopPickController {
  final ApiService _api = ApiService();

  List<Product> topPicks = [];

  /*List<TopPick> topPicks = [
    TopPick(
      "Men's Harrington Jacket",
      "1,200 sold this week",
      "assets/images/s1.png",
      price: 148.00,
      discountPercent: 56,
      videoAsset: "assets/watch_video.mp4",
      rating: 5.0,
    ),
    TopPick(
      "Max Cirro Men's Slides",
      "1,200 sold this week",
      "assets/images/s2.png",
      price: 148.00,
      discountPercent: 56,
      rating: 5.0,
    ),
    TopPick(
      "Max Cirro Jacket",
      "1,200 sold this week",
      "assets/images/s3.png",
      price: 148.00,
      discountPercent: 56,
      rating: 5.0,
    ),
  ];*/

  Future<void> fetchTopPicks() async {
    try {
      final products = await _api.getProducts();
      // You could add filtering logic here, e.g. only discounted/top items
      topPicks = products;
    } catch (e) {
      print("Error fetching top picks: $e");
      rethrow;
    }
  }
}
