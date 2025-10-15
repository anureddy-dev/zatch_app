import 'package:flutter/material.dart';
import 'package:zatch_app/model/product_response.dart';
import 'package:zatch_app/model/upcoming_live_model.dart';

class ProfileController extends ChangeNotifier {
  bool isFollowing = false;
  int selectedTab = 0;

  /// Buy Bits dummy images
  final List<String> buyBitsImages = [
    "https://picsum.photos/id/1018/400/300",
    "https://picsum.photos/id/1025/400/300",
    "https://picsum.photos/id/1035/400/300",
    "https://picsum.photos/id/1043/400/300",
  ];

  /// Shop products
  final List<Product> shopProducts = [

  ];

  /// Upcoming Lives
  final List<UpcomingLive> upcomingLives = [
    UpcomingLive(
      title: "Nike Sneaker Collection",
      category: "Fashion",
      imageUrl: "https://picsum.photos/id/1003/400/300",
      date: "Tomorrow • 7:30 PM",
    ),
    UpcomingLive(
      title: "Streetwear Launch",
      category: "Fashion",
      imageUrl: "https://picsum.photos/id/1014/400/300",
      date: "7th July • 7:30 PM",
    ),
  ];

  void toggleFollow() {
    isFollowing = !isFollowing;
    notifyListeners();
  }

  void selectTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  void toggleWishlist(Product product) {
   // product.isWishlisted = !product.isWishlisted;
    notifyListeners();
  }

  void shareProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile link copied")),
    );
  }
}
