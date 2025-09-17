import 'package:flutter/material.dart';
import 'package:zatch_app/controller/live_follower_controller.dart';
import 'package:zatch_app/model/user_profile_response.dart';
import 'package:zatch_app/view/live_view/live_stream_screen.dart';

class LiveFollowersWidget extends StatefulWidget {
  UserProfileResponse? userProfile;
  LiveFollowersWidget({super.key, this.userProfile});

  @override
  State<LiveFollowersWidget> createState() => _LiveFollowersWidgetState();
}

class _LiveFollowersWidgetState extends State<LiveFollowersWidget> {
  final LiveFollowerController controller = LiveFollowerController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Live From Followers",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                },
                child: const Text(
                  "See All",
                  style: TextStyle(color: Colors.blue),
                ),
              ),

            ],
          ),
        ),

        /// Horizontal Scroll
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.liveUsers.length,
            itemBuilder: (context, index) {
              final user = controller.liveUsers[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LiveStreamScreen(user: user,userProfile:widget.userProfile),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        /// Background Image
                        Container(
                          height: 220,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(user.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /// Live Tag
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "Live · 465",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        /// User Info Bottom
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage(user.image),
                              ),
                              const SizedBox(width: 8),
                              Expanded( // 👈 prevents overflow
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      overflow: TextOverflow.ellipsis, // 👈 adds "..."
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      user.category,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage(user.image),
                              ),
                              const SizedBox(width: 8),
                              Expanded( // 👈 prevents overflow
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      overflow: TextOverflow.ellipsis, // 👈 adds "..."
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      user.category,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              );
            }
                      ),
        ),
      ],
    );
  }
}
