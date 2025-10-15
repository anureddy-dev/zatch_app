import 'package:flutter/material.dart';
import 'package:zatch_app/model/user_model.dart';
import 'package:zatch_app/view/sellers/seller_card.dart'; // Import the reusable card

/// A screen that displays all sellers in a responsive 2-column grid.
class SeeAllFollowersScreen extends StatelessWidget {
  final List<UserModel> followers;

  const SeeAllFollowersScreen({
    super.key,
    required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Sellers'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75,
        ),
        itemCount: followers.length,
        itemBuilder: (context, index) {
          final follower = followers[index];
          return SellerCard(user: follower);
        },
      ),
    );
  }
}
