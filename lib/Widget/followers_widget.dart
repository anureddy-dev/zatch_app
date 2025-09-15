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
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Scrollable Seller List
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _controller.followers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final follower = _controller.followers[index];
                  return Column(
                    key: ValueKey(follower.id),
                    children: [
                      /// Profile Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          follower.imageAsset,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),

                      /// Follow Button (below image)
                      ElevatedButton(
                        onPressed: () async {
                          await _controller.toggleFollow(index);
                          setState(() {}); // 👈 rebuild only after toggle
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: follower.isFollowing
                              ? Colors.white
                              : const Color(0xFFB7DF4B),
                          shape: const StadiumBorder(),
                          side: const BorderSide(color: Color(0xFFB7DF4B), width: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          elevation: 0,
                        ),
                        child: Text(
                          follower.isFollowing ? 'Following ✓' : 'Follow',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// Name
                      Text(
                        follower.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  );
                }

            ),
          ),
        ],
      ),
    );
  }
}
