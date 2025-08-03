import 'package:flutter/material.dart';
import '../controller/follower_controller.dart';

class FollowersWidget extends StatefulWidget {
  const FollowersWidget({super.key});

  @override
  State<FollowersWidget> createState() => _FollowersWidgetState();
}

class _FollowersWidgetState extends State<FollowersWidget> {
  final FollowerController _controller = FollowerController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Explore Sellers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'See All',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Scrollable Seller List
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _controller.followers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final follower = _controller.followers[index];
                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        /// Profile Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            follower.imageAsset,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),

                        /// Overlapping Follow Button
                        Positioned(
                          bottom: -8,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _controller.toggleFollow(index);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: follower.isFollowing
                                  ? Colors.grey[400]
                                  : const Color(0xFFB7DF4B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              minimumSize: const Size(80, 28),
                              elevation: 2,
                            ),
                            child: Text(
                              follower.isFollowing ? 'Following ✓' : 'Follow',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16), // spacing for the overlap
                    Text(
                      follower.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
