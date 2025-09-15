import 'package:flutter/material.dart';
import 'package:zatch_app/model/product_model.dart';
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
    Product(
      name: "Club Fleece Mens Jacket",
      category: "Jackets",
      price: "₹56.97",
      imageUrl: "https://picsum.photos/id/1005/200/200",
      discount: "20%",
      soldCount: 120,
    ),
    Product(
      name: "Skate Jacket",
      category: "Streetwear",
      price: "₹150.97",
      imageUrl: "https://picsum.photos/id/1001/200/200",
      discount: "10%",
      soldCount: 80,
    ),
    Product(
      name: "Puffer Jacket",
      category: "Winter",
      price: "₹120.50",
      imageUrl: "https://picsum.photos/id/1011/200/200",
      discount: "15%",
      soldCount: 60,
    ),
    Product(
      name: "Oversized Hoodie",
      category: "Casual",
      price: "₹45.20",
      imageUrl: "https://picsum.photos/id/1012/200/200",
      discount: "5%",
      soldCount: 200,
    ),
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
    product.isWishlisted = !product.isWishlisted;
    notifyListeners();
  }

  void shareProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile link copied")),
    );
  }
}
